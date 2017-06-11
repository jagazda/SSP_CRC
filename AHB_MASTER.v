module AHB_MAST #(parameter [31:0] DATA_WIDTH = 32'd32,ADDR_WIDTH = 32'd32)(

    //GENERAL SIGNALS
    input wire HCLK,
    input wire RESET,                       // Active LOW
    //AMBA AHB SIGNALS
    //Signals from SLAVE
    input wire [DATA_WIDTH-1:0] HRDATA,     // DATA form Slave to master
    input wire HREADY,                      // When HIGH-transfer finished, LOW to extend transfer
    input wire HRESP,                       // Transfer status(HERE ALWAYS OKAY) : LOW- OKAY, HIGH-ERROR

    //CONF REGISTERs INPUTs
    input reg                       REGs_ready,
    input reg   [ADDR_WIDTH-1:0]    DADR,
    input reg   [ADDR_WIDTH-1:0]    CADR,
    input reg                       DLEN,
    input reg                       DBIT,   


    //MASTER OUT
    output reg [ADDR_WIDTH-1:0] HADDR,      // ADDR to slave, lasts for a single HCLK cycle
    output reg [DATA_WIDTH-1:0] HWDATA,     // DATA form Master to Slave
    output reg [2:0] HBURST,                // BURST type : single incr wrap
    output reg [2:0] HSIZE,                 // SIZE of transfer : byte, halfword or word - max 1024bits
    output reg [1:0] HTRANS,                // Transfer type:  IDLE,BUSY,NONSEQ,SEQ
    output reg HWRITE,                      // Transfer direction: HIGH-write, LOW-read
    output reg HMASTLOCK                    // HIGH when locked sequence
    
);
    //HTRANS TYPES
    localparam [1:0] IDLE       = 2'b00;
    localparam [1:0] BUSY       = 2'b01;    //Not used
    localparam [1:0] NONSEQ     = 2'b10;
    localparam [1:0] SEQ        = 2'b11;

    //HBURST TYPES
    localparam [2:0] SINGLE     = 3'b000;
    localparam [2:0] INCR       = 3'b001;

    // NOT USED 
    localparam [2:0] WRAP4      = 3'b010;  
    localparam [2:0] INCR4      = 3'b011;   
    localparam [2:0] WRAP8      = 3'b100;   
    localparam [2:0] INCR8      = 3'b101;   
    localparam [2:0] WRAP16     = 3'b110;   
    localparam [2:0] INCR16     = 3'b111;
    //

    //AHB SIZES
    localparam [2:0] BYTE       = 3'b000;   // 8bits
    localparam [2:0] HALFWORD   = 3'b001;   // 16bits
    localparam [2:0] WORD       = 3'b010;   // 32bits

    //Unused signals
    assign HMASTLOCK            = 1'b0  ;
    assign HRESP                = 1'b0  ;

    //Local REGs
    reg [ADDR_WIDTH-1:0]  NEXT_ADDR;
    reg [DATA_WIDTH-1:0]  NEXT_HWDATA;    
    reg [3:0]             STATE;
    reg [3:0]             NEXT_STATE;
    reg [2:0]             TMP_SIZE;     //
    reg [2:0]             TMP_BURST;    //
    reg [1:0]             NEXT_HTRANS;
    reg                   NEXT_HWRITE;

    //States
    localparam [3:0] IDLE_STATE     = 4'b0000;
    localparam [3:0] SINGLE_START   = 4'b0001;
    localparam [3:0] SINGLE_READY   = 4'b0010;
    localparam [3:0] SINGLE_STOP    = 4'b0100;
    localparam [3:0] ADDR_BURST     = 4'b1110;
    localparam [3:0] DATA_BURST     = 4'b1101;
 //   localparam [3:0] BUSY_BURST     = 4'b1011;
    localparam [3:0] READ_BURST     = 4'b0111;
    localparam [3:0] END_BURST      = 4'b1100;


always @(posedge HCLK or negedge RESET) begin
    if (RESET == 1'b0) begin
        HADDR   <= {ADDR_WIDTH{1'b0}};
        HWDATA  <= {DATA_WIDTH{1'b0}};
        HBURST  <=  SINGLE;
        HSIZE   <=  HALFWORD;   // ??? or byte ?
        HWRITE  <=  1'b0;
        HTRANS  <=  IDLE; 
    end
    else begin
        STATE   <= NEXT_STATE;
        HADDR   <= NEXT_ADDR;
        HWDATA  <= NEXT_HWDATA;
        HBURST  <= TMP_BURST;
        HSIZE   <= TMP_SIZE;
        HWRITE  <= NEXT_HWRITE;
        HTRANS  <= NEXT_HTRANS;
    end
end


always @(*) begin
    
    case(STATE)
    IDLE_STATE: begin
        if(HREADY == 1'b1) begin
            if(TMP_BURST == SINGLE)begin
                NEXT_STATE  = SINGLE_START;
                NEXT_HTRANS = NONSEQ;
            end
            else  begin         //if(TMP_BURST == INCR)
                NEXT_STATE  = ADDR_BURST;
                NEXT_HTRANS = NONSEQ;
            end
        end
        else begin
            NEXT_STATE  = IDLE_STATE;
            NEXT_HTRANS = IDLE;
        end
        end

    SINGLE_START: begin
        if(HREADY == 1'b1) begin
            NEXT_STATE  = SINGLE_READY
            NEXT_HTRANS = IDLE;
        end
        else begin
            NEXT_STATE  = SINGLE_START;
            NEXT_HTRANS = NONSEQ;
        end
    end
        
    SINGLE_READY: begin
        if(HRESP == 1'b0) begin
            if(HREADY == 1'b1 ) begin
                NEXT_STATE = SINGLE_STOP;

            end 
            else begin
                NEXT_STATE = SINGLE_READY;
            end
        end 
        NEXT_HTRANS = IDLE;

    end

    SINGLE_STOP: begin
        NEXT_STATE  = IDLE_STATE;
        NEXT_HTRANS = IDLE;
    end

    ADDR_BURST: begin
    if(HREADY == 1'b1)
        if(HBURST == INCR) begin
            NEXT_STATE = DATA_BURST;
            NEXT_HTRANS = SEQ;
        end else begin
            if(NEXT_HWRITE == 1'b1) begin
            NEXT_STATE = END_BURST;
            NEXT_HTRANS = IDLE;
        end else begin
            NEXT_STATE = READ_BURST;
            NEXT_HTRANS = SEQ;
        end
    end
    else begin
        NEXT_STATE = ADDR_BURST;
        NEXT_HTRANS = NONSEQ;
    end
    end

    DATA_BURST:
    if(TMP_BURST == INCR) begin
        if(HREADY == 1'b1) begin
            if(NEXT_HWRITE == 1'b1) begin
                NEXT_STATE = ADDR_BURST;
                NEXT_HTRANS = SEQ;
            end else begin
                NEXT_STATE = READ_BURST;
                NEXT_HTRANS = SEQ;
                end
        end else begin
            NEXT_STATE = DATA_BURST;
            NEXT_HTRANS = SEQ;
        end
    end
    else begin
        NEXT_STATE = END_BURST;
        NEXT_HTRANS = IDLE;
    end


/// THIS READ is bad 
    READ_BURST:
        if(TMP_BURST == INCR) begin
            NEXT_STATE = ADDR_BURST;
            NEXT_HTRANS = SEQ;
        end else begin
            NEXT_STATE = DATA_BURST;
            NEXT_HTRANS = SEQ;
        end

    END_BURST: begin
        NEXT_STATE = IDLE_STATE;
        NEXT_HTRANS = IDLE;
    end    

    default: begin
        NEXT_STATE = IDLE_STATE;
        NEXT_HTRANS = IDLE;
    end
    endcase
end

always @(*) begin
    
    case()
end


endmodule