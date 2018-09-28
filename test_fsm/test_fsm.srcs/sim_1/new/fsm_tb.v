`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/04 04:38:39
// Design Name: 
// Module Name: fsm_tb
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


module fsm_tb();

	reg reset;//电路总清零信号，reset == off不工作
	reg op_start = 0;//op_start == 1表示客户开始操作时的启动信号
	reg clk = 0;//系统同步时钟
	reg [1:0]choice = 0;//选择信号
	reg [1:0]coin_val = 0;//识别出来的币值：01为1r，10为10r
	reg cancel_flag = 0;//取消信号
	reg confirm_flag = 0;//确定信号
	reg admin = 0; //长按5秒进入管理员模式
	reg add = 0; //加一
	reg ok_flag = 0; //确认

	wire run_ind;//运行指示灯
	wire admin_ind;//管理员模式灯
	wire [1:0]good_ind;//商品选中灯
	wire hold_ind;//机器被占用指示灯
	wire drinktk_ind;//取饮料指示灯
	wire charge_ind;//找零提示
	// wire charge_val;//退给商户的币值
	wire [3:0]sum;
	wire [3:0]sum_frac;
	wire [3:0]money3;
	wire [3:0]money2;
	wire [3:0]money1;
	wire [3:0]money0;
	wire [3:0]num1;
	wire [3:0]num0;
	wire [4:0]state;

	initial forever #10 clk = ~clk;

	initial
	begin
		reset <= 0;
		#20
		reset <= 1;
		#100

		op_start <= 1;
		#20
		op_start <= 0;
		#100

		choice <= 2'b01;
		#20
		choice <= 0;
		#100//选择商品1

		cancel_flag <= 1;
		#20
		cancel_flag <= 0;
		#100//取消购买

		choice <= 2'b10;
		#20
		choice <= 0;
		#100//选择商品2

		confirm_flag <= 1;
		#20
		confirm_flag <= 0;
		#100//确认购买

		coin_val <= 2'b10;
		#20
		coin_val <= 2'b00;
		#700//至此成功购买商品2

		choice <= 2'b01;
		#20
		choice <= 0;
		#100//选择商品1

		confirm_flag <= 1;
		#20
		confirm_flag <= 0;
		#100//确认购买

		coin_val <= 2'b01;
		#20
		coin_val <= 2'b00;
		#100

		coin_val <= 2'b01;
		#20
		coin_val <= 2'b00;
		#100

		coin_val <= 2'b01;
		#20
		coin_val <= 2'b00;
		#700//至此成功购买商品1

		choice <= 2'b01;
		#20
		choice <= 0;
		#100//选择商品1

		confirm_flag <= 1;
		#20
		confirm_flag <= 0;
		#100

		coin_val <= 2'b10;
		#20
		coin_val <= 2'b00;
		#700//至此成功购买商品1

		choice <= 2'b01;
		#20
		choice <= 0;
		#700

		admin <= 1;
		#20
		admin <= 0;
		#100//按键时间过短，未进入管理员模式

		admin <= 1;
		#140
		admin <= 0;
		#100//按键时间足够，进入管理员模式

		add <= 1;
		#20
		add <= 0;
		#100

		add <= 1;
		#40
		add <= 0;
		#100

		ok_flag <= 1;
		#20
		ok_flag <= 0;
		#100//加2确认

		add <= 1;
		#20
		add <= 0;
		#100

		ok_flag <= 1;
		#20
		ok_flag <= 0;
		#100//加1确认

		choice <= 2'b01;
		#20
		choice <= 2'b00;
		#100//可继续购买商品1

		confirm_flag <= 1;
		#20
		confirm_flag <= 0;
		#100

		coin_val <= 2'b10;
		#20
		coin_val <= 2'b00;


	end

	fsm fsm_sim(reset, op_start, clk, choice, coin_val, cancel_flag,
		confirm_flag, admin, add, ok_flag, run_ind, admin_ind, good_ind, 
		hold_ind, drinktk_ind, charge_ind, sum, sum_frac, money3, money2,
		money1, money0, num1, num0, state);

endmodule
