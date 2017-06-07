module AHB_MAST #(parameter [31:0] DATA_WIDTH = 32'd32,ADDR_WIDTH = 32'd32)(

    //GENERAL SIGNALS
    input wire HCLK,
    input wire RESET,                       // Active LOW
    //AMBA AHB SIGNALS
    //Signals from SLAVE
    input wire [DATA_WIDTH-1:0] HRDATA,     // DATA form Slave to master
    input wire HREADY,                      // When HIGH-transfer finished, LOW to extend transfer
    input wire HRESP,                       // Transfer status : LOW- OKAY, HIGH-ERROR

    //MASTER OUT
    output reg [ADDR_WIDTH-1:0] HADDR,      // ADDR to slave
    output reg [DATA_WIDTH-1:0] HWDATA,     // DATA form Master to Slave
    output reg [2:0] HBURST,                // BURST type : single incr wrap
    output reg [2:0] HSIZE,                 // SIZE of transfer : byte, halfword or word - max 1024bits
    output reg [1:0] HTRANS,                // Transfer type:  IDLE,BUSY,NONSEQ,SEQ
    output reg HWRITE,                      // Transfer direction: HIGH-write, LOW-read
    output reg HMASTLOCK,                   // HIGH when locked sequence
    output reg HSEL,                        // Unnecessary, here only one slave
    
);
    //HTRANS TYPES
    localparam IDLE             = 2'b00;
    localparam BUSY             = 2'b01;
    localparam NONSEQ           = 2'b10;
    localparam SEQ              = 2'b11;

    //HBURST TYPES
    localparam [2:0] SINGLE     = 3'b000;
    localparam [2:0] INCR       = 3'b001;
    localparam [2:0] WRAP4      = 3'b010;
    localparam [2:0] INCR4      = 3'b011;
    localparam [2:0] WRAP8      = 3'b100;
    localparam [2:0] INCR8      = 3'b101;
    localparam [2:0] WRAP16     = 3'b110;
    localparam [2:0] INCR16     = 3'b111;

    //AHB SIZES
    localparam [2:0] BYTE       = 3'b000;   // 8bits
    localparam [2:0] HALFWORD   = 3'b001;   // 16bits
    localparam [2:0] WORD       = 3'b010;   // 32bits



