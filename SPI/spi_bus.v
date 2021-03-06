module spi_bus (
	input CLK12M,
	output SDI,
	output CSB,
	output CLK

);

	
	///Its perfect spi for all spi slaves that ignore every other transaction!!!
	reg clkReg = 1;
	reg csbReg = 1;
	reg data = 0;
	reg [7:0] transaction = 0;
	reg test = 0;
	reg [7:0] dataWrite = 8'b10101110;
	reg [7:0] counter = 0;
	always @(posedge CLK12M) begin
		if(transaction % 2 == 0) begin
			clkReg <= ~clkReg;
			if(transaction == 0) begin
				csbReg <= 0;
				transaction <= transaction + 1;
			end
			else if(transaction < 18) begin
				csbReg <= 0;
				data <= dataWrite[7- (transaction/2 - 1)];
				transaction <= transaction + 1;
			end
			else if (transaction < 37) begin
				csbReg <= 1;
				transaction <= transaction + 1;
			end
			else begin
				transaction <= 0;
			end
		end
		else begin
			clkReg <= ~clkReg;
			transaction <= transaction + 1;
		end
	end
	


	assign CSB = csbReg;
	assign CLK = clkReg;
	assign SDI = data;
endmodule