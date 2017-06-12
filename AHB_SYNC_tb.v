module AHB_SYNC_tb ;

	//INPUTs REGs
	 reg 						HCLK;
	 reg  						req;
	 reg 				[6-1:0]	DADR;
	 reg 				[6-1:0]	CADR;
	 reg 						DLEN;
	 reg 						DBIT;	

	//OUTPUTs
	 wire						ack;
	 wire 						REGs_ready;
	 wire 				[6-1:0]	DADR_O;
	 wire 				[6-1:0]	CADR_O;
	 wire 						DLEN_O;
	 wire 						DBIT_O;


	 AHB_SYNC U0 (
	 	.HCLK 			(HCLK),
	 	.req 			(req),
	 	.DADR 			(DADR),
	 	.CADR 			(CADR),
	 	.DLEN 			(DLEN),
	 	.DBIT 			(DBIT),
	 	.ack 			(ack),
	 	.REGs_ready 	(REGs_ready),
	 	.DADR_O 		(DADR_O),
	 	.CADR_O			(CADR_O),
	 	.DLEN_O 		(DLEN_O),
	 	.DBIT_O 		(DBIT_O)
	 	);

	 initial begin
	 	HCLK = 1'b0;
	 	req = 1'b0;
	 	DADR = 1'b0;
	 	CADR = 1'b0;
	 	DLEN = 1'b0;
	 	DBIT = 1'b0;
	 //	ack = 0;
	 //	REGs_ready = 0 ;
	 //	DADR_O = 0;
	 //	CADR_O = 0;
	 //	DLEN_O = 0;
	 //	DBIT_O = 0;
	 end

	 	
	always 
			#5 HCLK = !HCLK;

	initial begin
		$dumpfile ("AHB_SYNC.vcd");
		$dumpvars;
	end

initial begin
	
	#5 	DADR = 6'b001101;
		CADR = 6'b011111;
		DLEN = 1'b1;
		DBIT = 1'b1;

	#20 req = 1'b1;
	#30 req = 1'b0;
	#20
	#5 	DADR = 6'b111111;
		CADR = 6'b011000;
		DLEN = 1'b0;
		DBIT = 1'b0;

	#20 req = 1'b1;
	#30 req = 1'b0;

 	#100 $finish;
	end





endmodule
