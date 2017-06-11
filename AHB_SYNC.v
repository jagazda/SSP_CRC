module AHB_SYNC #(parameter [31:0] DATA_WIDTH = 16'd16,ADDR_WIDTH = 6)
(
	//INPUTs REGs
	input wire 						HCLK,
	input reg  						req,
	input reg 	[ADDR_WIDTH-1:0]	DADR,
	input reg 	[ADDR_WIDTH-1:0]	CADR,
	input reg 						DLEN,
	input reg 						DBIT,	

	//OUTPUTs
	output reg 						ack
	output reg 						REGs_ready,
	output reg 	[ADDR_WIDTH-1:0]	DADR_O,
	output reg 	[ADDR_WIDTH-1:0]	CADR_O,
	output reg 						DLEN_O,
	output reg 						DBIT_O
);
	
	reg  		Latch1OUT;
	reg 		Latch2IN;
	reg 		Latch2OUT;
	reg 		Latch3IN;



	always @(posedge HCLK) begin
		Latch1OUT = req;
		Latch2IN = Latch1OUT;
		Latch2OUT = Latch2IN;
		Latch3IN = Latch2OUT;
		REGs_ready = Latch3IN;
	end

	if(Latch2OUT && !REGs_ready) begin
		DADR_O = DADR;
		CADR_O = CADR;
		DLEN_O = DLEN;
		DBIT_O = DBIT;
		ack = 1'b1;
	end else begin
		ack = 1'b0;
	end



endmodule
