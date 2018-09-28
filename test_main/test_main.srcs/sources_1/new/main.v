`timescale 1ns / 1ps

module main(
	input reset,//电路总清零信号，reset == off不工作
	input op_start,//op_start == 1表示客户开始操作时的启动信号
	input clk,//系统同步时钟
	input [1:0]choice,//选择信号
	input [1:0]coin_val,//识别出来的币值：01为1r，10为10r
	input cancel_flag,//取消信号
	input confirm_flag,//确定信号
	input admin, //长按5秒进入管理员模式
	input add, //加一
	input ok_flag, //确认

	output run_ind,//运行指示灯
	output admin_ind,//管理员模式灯
	output [1:0]good_ind,//商品选中灯
	output hold_ind,//机器被占用指示灯
	output drinktk_ind,//取饮料指示灯
	output charge_ind,//找零提示
	// output reg charge_val,//退给商户的币值
	output [7:0]an,//数码管选信号
	output [7:0]seg//数码管驱动信号
    );

	wire [3:0]num[1:0];
	wire [3:0]money[3:0];
	wire [3:0]sum;
	wire [3:0]sum_frac;
	wire [4:0]state;

	fsm fsm_inst(reset, op_start, clk, choice, coin_val, cancel_flag, confirm_flag, admin, add, ok_flag, 
		run_ind, admin_ind, good_ind, hold_ind, drinktk_ind, charge_ind,
		sum, sum_frac, money[3], money[2], money[1], money[0], num[1], num[0], state);
	
//结构描述调用子层模块
//七段数码管显示部分
	show seg_show(.state(state), .clk(clk), .num1(num[1]), .num0(num[0]),
		.money3(money[3]), .money2(money[2]), .money1(money[1]), .money0(money[0]),
		.sum(sum), .sum_frac(sum_frac), .seg(seg), .an(an));
endmodule
