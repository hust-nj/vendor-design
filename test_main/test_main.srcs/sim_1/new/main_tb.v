`timescale 1ns / 1ps

module main_tb();
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
	wire [7:0]an;//数码管选信号
	wire [7:0]seg;//数码管显示驱动信号

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

	main main_sim(reset, op_start, clk, choice, coin_val, cancel_flag,
		confirm_flag, admin, add, ok_flag, run_ind, admin_ind, good_ind, 
		hold_ind, drinktk_ind, charge_ind, an, seg);


endmodule