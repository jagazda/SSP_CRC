module AHB_MAST #(parameter [31:0] DATA_WIDTH = 32'd32,ADDR_WIDTH = 32'd32)(

    //GENERAL SIGNALS
    input wire HCLK,
    input wire RESET,
    //AMBA AHB SIGNALS
    input wire [DATA_WIDTH-1:0] HRDATA,
    input wire HREADY,
    input wire HRESP,
    output reg [ADDR_WIDTH-1:0] HADDR,
    output reg [DATA_WIDTH-1:0] HWDATA,
    output reg [2:0] HBURST,
    output reg [2:0] HSIZE,
    output reg [1:0] HTRANS,
    output reg HWRITE,
    output reg HMASTLOCK,
    output reg HSEL,
    
);

    