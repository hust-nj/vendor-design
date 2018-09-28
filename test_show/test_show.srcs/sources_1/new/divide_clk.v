`timescale 1ns / 1ps

module divide_clk
	#(parameter delay = 10000)
	(
	input clk,
	output reg div_clk
    );

parameter delay1 = delay / 2;
reg [31:0]cnt = 0;

always @(posedge clk)
begin
	if(cnt >= delay1 - 1)
	begin
		div_clk <= ~div_clk;
		cnt <= 0;
	end
	else
		cnt <= cnt + 1;
end

endmodule
