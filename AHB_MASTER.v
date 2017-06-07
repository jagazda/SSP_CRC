module AHB_MAST #(parameter [31:0] DATA_WIDTH = 32'd32,ADDR_WIDTH = 32'd32)(

    //GENERAL SIGNALS
    input wire HCLK,
    input wire RESET,
    //AMBA AHB SIGNALS
    //Signals from SLAVE
    input wire [DATA_WIDTH-1:0] HRDATA,
    input wire HREADY,
    input wire HRESP,

    //MASTER OUT
    output reg [ADDR_WIDTH-1:0] HADDR,
    output reg [DATA_WIDTH-1:0] HWDATA,
    output reg [2:0] HBURST,
    output reg [2:0] HSIZE,
    output reg [1:0] HTRANS,
    output reg HWRITE,
    output reg HMASTLOCK,
    output reg HSEL,
    
);
    //HTRANS TYPES
    localparam IDLE     = 2'b00;
    localparam BUSY     = 2'b01;
    localparam NONSEQ   = 2'b10;
    localparam SEQ      = 2'b11;

    //HBURST TYPES
    localparam SINGLE   = 3'b000;
    localparam INCR     = 3'b001;
    localparam WRAP4    = 3'b010;
    localparam INCR4    = 3'b011;
    localparam WRAP8    = 3'b100;
    localparam INCR8    = 3'b101;
    localparam WRAP16   = 3'b110;
    localparam INCR16   = 3'b111;




