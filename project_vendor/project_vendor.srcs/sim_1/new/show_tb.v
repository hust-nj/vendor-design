`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/04 04:39:06
// Design Name: 
// Module Name: show_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module show_tb();
	parameter s_off = 0, s_open = 1, confirm_goods1 = 2, confirm_goods2 = 3, goods1 = 4, goods2 = 5,
	buy1 = 6, buy2 = 7, get1 = 8, get2 = 9, temp_to_echo_remain = 10, echo_remain = 11, temp_to_charge = 12, charge = 13,
	temp_to_s_open1 = 14, temp_to_s_open2 = 15, test = 16, valid0 = 17, valid1 = 18;

	reg [4:0]state;
	reg clk;
	reg [3:0]num1, num0, money3, money2, money1, money0, sum, sum_frac;
	reg [7:0]seg, an;
	
	initial
	begin 
		clk = ~clk;
		forever #10 clk = ~clk;
	end

	initial
	begin 
		state <= s_open;
		num1 <= 0;
		num0 <= 0;
		money3 <= 0;
		money2 <= 0;
		money1 <= 0;
		money0 <= 0;
		sum <= 0;
		sum_frac <= 0;
	end

	show show7seg(state, clk, num1, num0, money3, money2, money1, money0, sum, sum_frac, seg, an);
endmodule
