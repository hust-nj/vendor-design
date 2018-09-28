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
	temp_to_s_open1 = 14, temp_to_s_open2 = 15, test = 16, valid0 = 17, valid1 = 18, stop_goods1 = 19, stop_goods2 = 20;

	reg [4:0]state;
	reg clk = 0;
	reg [3:0]num1, num0, money3, money2, money1, money0, sum, sum_frac;
	wire [7:0]seg, an;
	
	initial
		forever #10 clk = ~clk;

	initial
	begin 
		state <= s_off;//不显示
		num1 <= 0;
		num0 <= 0;
		money3 <= 0;
		money2 <= 0;
		money1 <= 0;
		money0 <= 0;
		sum <= 0;
		sum_frac <= 0;

		#200
		state <= s_open;//显示hello

		#200
		state <= confirm_goods1;
		num0 <= 2;
		money1 <= 2;
		money0 <= 5;

		#300
		state <= confirm_goods2;
		num1 <= 12;
		money3 <= 5;
		money2 <= 0;

		#300
		state <= temp_to_s_open1;
		num0 <= 2;
		money1 <= 2;//表示商品1价格的整数部分
		money0 <= 5;//表示商品1价格的小数部分

		#500
		state <= temp_to_s_open2;
		num1 <= 12;
		money3 <= 5;//表示商品2价格的整数部分
		money2 <= 0;//表示商品2价格的小数部分

		#500
		state <= goods1;
		sum <= 11;
		sum_frac <= 5;
		money1 <= 2;//表示商品1价格的整数部分
		money0 <= 5;//表示商品1价格的小数部分

		#300
		state <= goods2;
		sum <= 11;
		sum_frac <= 5;//投入的币值
		money3 <= 5;
		money2 <= 0;

		#300
		state <= get1;//出货等待

		#300
		state <= echo_remain;
		sum <= 7;
		sum_frac <= 5;//显示剩余币值（整数部分.小数部分）

		#300
		state <= valid0;
		num0 <= 13;//商品1的数量

		#300
		state <= valid1;
		num1 <= 1;//商品2的数量

	end



	show show7seg(state, clk, num1, num0, money3, money2, money1, money0, sum, sum_frac, seg, an);
endmodule
