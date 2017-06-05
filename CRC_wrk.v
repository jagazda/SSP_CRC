module CRC_wrk #(parameter [31:0] DATA_WIDTH = 32'd32)(

    input wire                  CLK,
    input reg  [DATA_WIDTH-1:0] DATA_IN,
    input reg                   DADR,
    input reg                   DLEN,  
    input reg                   CADR,
    input reg                   DBIT,
    input reg                   ,    

 //-------------OUTPUTS-------------------  
    output reg                  STAT,
    output reg [DATA_WIDTH-1:0] DATA_OUT,
    output wire                 icrc,

    
);

    localparam [15:0] IBM_poly      =   16'b1000000000000101 ;
    localparam [15:0] Prof_poly     =   16'b0001110111001111 ;
    reg        [2:0]  Result                                 ;