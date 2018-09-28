`timescale 1ns / 1ps

module fsm(
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

	output reg run_ind,//运行指示灯
	output reg admin_ind,//管理员模式灯
	output reg [1:0]good_ind,//商品选中灯
	output reg hold_ind,//机器被占用指示灯
	output reg drinktk_ind,//取饮料指示灯
	output reg charge_ind,//找零提示
	// output reg charge_val,//退给商户的币值
	output reg [3:0]sum,
	output reg [3:0]sum_frac,
	output reg [3:0]money3,
	output reg [3:0]money2,
	output reg [3:0]money1,
	output reg [3:0]money0,
	output reg [3:0]num1,
	output reg [3:0]num0,
	output reg [4:0]state
    );
	parameter s_off = 0, s_open = 1, confirm_goods1 = 2, confirm_goods2 = 3, goods1 = 4, goods2 = 5,
	buy1 = 6, buy2 = 7, get1 = 8, get2 = 9, temp_to_echo_remain = 10, echo_remain = 11, temp_to_charge = 12, charge = 13,
	temp_to_s_open1 = 14, temp_to_s_open2 = 15 ,test = 16, valid0 = 17, valid1 = 18, stop_goods1 = 19, stop_goods2 = 20;
	
	reg [4:0]next_state;
	reg [31:0]cnt, counter;
	reg activate;
	reg ok_act;

//时序逻辑部分
always@(posedge clk)
begin
	case(state)
		s_off:
		begin 
			counter <= 0;
			activate <= 1;
			money0 <= 5;
			money1 <= 2;
			money2 <= 0;
			money3 <= 5;
			num0 <= 2;
			num1 <= 12;
		end
		s_open:
		begin
			sum <= 0;
			sum_frac <= 0;
			counter <= 0;
			activate <= 1;
			counter <= 0;
			ok_act <= 1;
		end

		goods1:
		begin
			counter <= 0;
			if(coin_val == 2'b00)
				activate <= 1;
			else if(activate == 1)
			begin
				case(coin_val)
					2'b01:
					begin
						sum <= sum + 1;
						activate <= 0;
					end
					2'b10:
					begin
						sum <= sum + 10;
						activate <= 0;
					end
					default:activate <= 0;
				endcase // coin_val
			end
			else
				activate <= 0;
		end

		goods2:
		begin
			counter <= 0;
			if(coin_val == 2'b00)
				activate <= 1;
			else if(activate == 1)
			begin
				case(coin_val)
					2'b01:
					begin
						sum <= sum + 1;
						activate <= 0;
					end
					2'b10:
					begin
						sum <= sum + 10;
						activate <= 0;
					end
					default:activate <= 0;
				endcase // coin_val
			end
			else
				activate <= 0;
		end

		stop_goods1:
			counter <= counter + 1;
		stop_goods2:
			counter <= counter + 2;

		buy1:
		begin 
			sum <= money0==0 ? sum-money1 : sum-money1-1;
			sum_frac <= money0==0 ? 0 : 10 - money0;
			num0 <= num0 - 1;
			counter <= 0;
		end

		buy2:
		begin 
			sum <= money2==0 ? sum-money3 : sum-money3-1;
			sum_frac <= money2==0 ? 0 : 10 - money2;
			num1 <= num1 - 1;
			counter <= 0;
		end

		get1, get2:
			counter <= counter + 1;

		temp_to_echo_remain:
			counter <= 0;

		echo_remain:
			counter <= counter + 1;

		temp_to_charge:
			counter <= 0;

		temp_to_s_open1, temp_to_s_open2:
			counter <= counter + 1;

		charge:
			counter <= counter + 1;

		test:
			counter <= counter + 1;

		valid0:
		begin 
			if(add == 0)
				activate <= 1;
			else if(activate == 1 && add == 1)
			begin 
				num0 <= num0 + 1;
				activate <= 0;
			end
			else
				activate <= 0;
			if(ok_flag == 0)
				ok_act <= 1;
			else
				ok_act <= 0;
		end

		valid1:
		begin 
			if(add == 0)
				activate <= 1;
			else if(activate == 1 && add == 1)
			begin 
				num1 <= num1 + 1;
				activate <= 0;
			end
			else
				activate <= 0;
			if(ok_flag == 0)
				ok_act <= 1;
			else
				ok_act <= 0;
		end

	endcase // state

	if(reset == 0)//use cpu reset
		state <= s_off;
	else
		state <= next_state;
end


//组合逻辑部分
always@(*)
begin
	case(state)
		s_off:
		begin
			run_ind <= 0;
			hold_ind <= 0;
			drinktk_ind <= 0;
			good_ind <= 2'b00;
			charge_ind <= 0;
			admin_ind <= 0;
			if(op_start == 1)
				next_state <= s_open;
			else
				next_state <= s_off;
		end

		test:
		begin
			run_ind <= 1;
			hold_ind <= 0;
			drinktk_ind <= 0;
			good_ind <= 2'b00;
			charge_ind <= 0;
			admin_ind <= 0;
			if(op_start == 1)
				next_state <= s_open;
			else if(admin == 1)
			begin 
				if(counter == 5)	
					next_state <= valid0;
				else
					next_state <= test;
			end
			else
				next_state <= s_open;
		end


		valid0:
		begin 
			hold_ind <= 0;
			drinktk_ind <= 0;
			good_ind <= 2'b00;
			charge_ind <= 0;
			admin_ind <= 1;

			if(ok_act == 1 && ok_flag == 1)
				next_state <= valid1;
			else
				next_state <= valid0;
		end

		valid1:
		begin 
			hold_ind <= 0;
			drinktk_ind <= 0;
			good_ind <= 2'b00;
			charge_ind <= 0;
			admin_ind <= 1;

			if(ok_act == 1 && ok_flag == 1)
				next_state <= s_open;
			else
				next_state <= valid1;
		end

		s_open:
		begin
			run_ind <= 1;
			hold_ind <= 0;
			drinktk_ind <= 0;
			good_ind <= 2'b00;
			charge_ind <= 0;
			admin_ind <= 0;
			if(admin == 1)
				next_state <= test;
			else
			case(choice)
				2'b01:
				next_state <= confirm_goods1;
				2'b10:
				next_state <= confirm_goods2;
				default:
				next_state <= s_open;
			endcase // choice
		end

		confirm_goods1:
		begin
			run_ind <= 1;
			hold_ind <= 1;
			drinktk_ind <= 0;
			good_ind <= 2'b01;
			charge_ind <= 0;
			admin_ind <= 0;
			if(num0 == 0)
				next_state <= temp_to_s_open1;
			else if(cancel_flag == 1)
				next_state <= s_open;
			else if(confirm_flag == 1)
				next_state <= goods1;
			else
				next_state <= confirm_goods1;
		end

		goods1:
		begin
			run_ind <= 1;
			hold_ind <= 1;
			drinktk_ind <= 0;
			good_ind <= 2'b01;
			charge_ind <= 0;
			admin_ind <= 0;
			if(sum > money1 || (sum == money1 && sum_frac >= money0))
				next_state <= stop_goods1;
			else
				next_state <= goods1;
		end

		stop_goods1:
		begin
			run_ind <= 1;
			hold_ind <= 1;
			drinktk_ind <= 0;
			good_ind <= 2'b01;
			charge_ind <= 0;
			admin_ind <= 0;
			if(counter == 2)
				next_state <= buy1;
			else
				next_state <= stop_goods1;
		end

		confirm_goods2:
		begin
			run_ind <= 1;
			hold_ind <= 1;
			drinktk_ind <= 0;
			good_ind <= 2'b10;
			charge_ind <= 0;
			admin_ind <= 0;
			if(num1 == 0)
				next_state <= temp_to_s_open2;
			else if(cancel_flag == 1)
				next_state <= s_open;
			else if(confirm_flag == 1)
				next_state <= goods2;
			else
				next_state <= confirm_goods2;
		end

		goods2:
		begin
			run_ind <= 1;
			hold_ind <= 1;
			drinktk_ind <= 0;
			good_ind <= 2'b10;
			charge_ind <= 0;
			admin_ind <= 0;
			if(sum > money3 || (sum == money3 && sum_frac >= money2))
				next_state <= stop_goods2;
			else
				next_state <= goods2;
		end

		stop_goods2:
		begin
			run_ind <= 1;
			hold_ind <= 1;
			drinktk_ind <= 0;
			good_ind <= 2'b10;
			charge_ind <= 0;
			admin_ind <= 0;
			if(counter == 2)
				next_state <= buy2;
			else
				next_state <= stop_goods2;
		end

		temp_to_s_open1:
		begin 
			run_ind <= 1;
			hold_ind <= 1;
			drinktk_ind <= 0;
			good_ind <= 2'b01;
			charge_ind <= 0;
			admin_ind <= 0;
			if(counter == 4)
				next_state <= s_open;
			else
				next_state <= temp_to_s_open1;
		end

		temp_to_s_open2:
		begin 
			run_ind <= 1;
			hold_ind <= 1;
			drinktk_ind <= 0;
			good_ind <= 2'b10;
			charge_ind <= 0;
			admin_ind <= 0;
			if(counter == 4)
				next_state <= s_open;
			else
				next_state <= temp_to_s_open2;
		end

		buy1:
		begin
			run_ind <= 1;
			hold_ind <= 1;
			drinktk_ind <= 0;
			good_ind <= 2'b01;
			charge_ind <= 0;
			admin_ind <= 0;
			next_state <= get1;
		end

		buy2:
		begin
			run_ind <= 1;
			hold_ind <= 1;
			drinktk_ind <= 0;
			good_ind <= 2'b10;
			charge_ind <= 0;
			admin_ind <= 0;
			next_state <= get2;
		end

		get1:
		begin
			run_ind <= 1;
			hold_ind <= 1;
			drinktk_ind <= 1;
			good_ind <= 2'b01;
			charge_ind <= 0;
			admin_ind <= 0;
			if(counter == 10)
				next_state <= temp_to_echo_remain;
			else
				next_state <= get1;
		end

		get2:
		begin
			run_ind <= 1;
			hold_ind <= 1;
			drinktk_ind <= 1;
			good_ind <= 2'b10;
			charge_ind <= 0;
			admin_ind <= 0;
			if(counter == 10)
				next_state <= temp_to_echo_remain;
			else
				next_state <= get2;
		end

		temp_to_echo_remain:
		begin
			run_ind <= 1;
			hold_ind <= 1;
			drinktk_ind <= 0;
			good_ind <= 0;
			charge_ind <= 0;
			admin_ind <= 0;
			next_state <= echo_remain;
		end

		echo_remain:
		begin
			run_ind <= 1;
			hold_ind <= 1;
			drinktk_ind <= 0;
			good_ind <= 0;
			charge_ind <= 0;
			admin_ind <= 0;
			if(counter == 5)
				next_state <= temp_to_charge;
			else
				next_state <= echo_remain;
		end

		temp_to_charge:
		begin
			run_ind <= 1;
			hold_ind <= 1;
			drinktk_ind <= 0;
			good_ind <= 0;
			charge_ind <= 1;
			admin_ind <= 0;
			next_state <= charge;
		end

		charge:
		begin
			run_ind <= 1;
			hold_ind <= 1;
			drinktk_ind <= 0;
			good_ind <= 0;
			charge_ind <= 1;
			admin_ind <= 0;
			if(counter == 2)
				next_state <= s_open;
			else
				next_state <= charge;
		end


	endcase // state
end

// //将商品的个数和价格储存在RAM中
// always@(*)


endmodule // fsm
