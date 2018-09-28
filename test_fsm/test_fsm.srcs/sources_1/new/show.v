`timescale 1ns / 1ps

module show(
	input [4:0]state,
	input clk,
	// input reg[3:0]num[1:0],
	input [3:0]num1,
	input [3:0]num0,
	// input reg[2:0]money[3:0],
	input [3:0]money3,
	input [3:0]money2,
	input [3:0]money1,
	input [3:0]money0,
	input [3:0]sum,
	input [3:0]sum_frac,
	output reg [7:0]seg,
	output reg [7:0]an 
    );
parameter s_off = 0, s_open = 1, confirm_goods1 = 2, confirm_goods2 = 3, goods1 = 4, goods2 = 5,
buy1 = 6, buy2 = 7, get1 = 8, get2 = 9, temp_to_echo_remain = 10, echo_remain = 11, temp_to_charge = 12, charge = 13,
temp_to_s_open1 = 14, temp_to_s_open2 = 15, test = 16, valid0 = 17, valid1 = 18, stop_goods1 = 19, stop_goods2 = 20;
parameter div = 10;
parameter delay = 10000;
reg [3:0]dig;
reg [2:0]pos;
reg point;
reg off;
reg [31:0]counter;
reg [4:0]cnt;
wire [7:0]seg_num;
wire [7:0]an_num;
wire div_clk;

divide_clk #(.delay(delay)) inst(clk, div_clk);

always@(posedge div_clk)
case(state)
	s_off:
	begin
		seg <= 8'b11111111;
		an <= 8'b11111111;
	end
	
	s_open, test:
		case(cnt)
			0:
			begin
				cnt <= 1;
				an <= 8'b01111111;
				seg <= 8'b10001001;
			end//H
			1:
			begin
				cnt <= 2;
				an <= 8'b10111111;
				seg <= 8'b10000110;
			end//E
			2:
			begin
				cnt <= 3;
				an <= 8'b11011111;
				seg <= 8'b11000111;
			end//L
			3:
			begin
				cnt <= 4;
				an <= 8'b11101111;
				seg <= 8'b11000111;
			end//L
			4:
			begin
				cnt <= 0;
				an <= 8'b11110111;
				seg <= 8'b11000000;
			end//O
			default:cnt <= 0;
		endcase // cnt

	temp_to_s_open1:
	if(counter == 100_000_000 / delay / 2)
		counter <= 0;
	else if(counter <= 100_000_000 / delay / 4)
	begin
		counter <= counter + 1;
		seg <= 8'b11111111;
		an <= 8'b11111111;
	end
	else
	begin
		seg <= seg_num;
		an <= an_num;//接入端口
		counter <= counter + 1;
		case(cnt)
			0:
			begin 
				cnt <= 1;
				dig <= money0;
				point <= 0;
				off <= 0;
				pos <= 0;
			end
			1:
			begin 
				cnt <= 2;
				dig <= money1;
				point <= 1;
				off <= 0;
				pos <= 1;
			end // 打印售价
			2:
			begin 
				cnt <= 3;
				dig <= num0%10;
				point <= 0;
				off <= 0;
				pos <= 4;
			end // 打印数量个位
			3:
			begin 
				cnt <= 0;
				dig <= num0/10;
				point <= 0;
				off <= ~|(num0/10);
				pos <= 5;
			end // 打印数量十位
			default:cnt <= 0;
		endcase // cnt
	end

	confirm_goods1:
	begin
		seg <= seg_num;
		an <= an_num;//接入端口
		counter <= 0;
		case(cnt)
			0:
			begin 
				cnt <= 1;
				dig <= money0;
				point <= 0;
				off <= 0;
				pos <= 0;
			end
			1:
			begin 
				cnt <= 2;
				dig <= money1;
				point <= 1;
				off <= 0;
				pos <= 1;
			end // 打印售价
			2:
			begin 
				cnt <= 3;
				dig <= num0%10;
				point <= 0;
				off <= 0;
				pos <= 4;
			end // 打印数量个位
			3:
			begin 
				cnt <= 0;
				dig <= num0/10;
				point <= 0;
				off <= ~|(num0/10);
				pos <= 5;
			end // 打印数量十位
			default:cnt <= 0;
		endcase // cnt
	end

	temp_to_s_open2:
	if(counter == 100_000_000 / delay / 2)
		counter <= 0;
	else if(counter <= 100_000_000 / delay / 4)
	begin
		counter <= counter + 1;
		seg <= 8'b11111111;
		an <= 8'b11111111;
	end
	else
	begin
		seg <= seg_num;
		an <= an_num;//接入输出端口
		counter <= counter + 1;
		case(cnt)
			0:
			begin 
				cnt <= 1;
				dig <= money2;
				point <= 0;
				off <= 0;
				pos <= 0;
			end
			1:
			begin 
				cnt <= 2;
				dig <= money3;
				point <= 1;
				off <= 0;
				pos <= 1;
			end // 打印售价
			2:
			begin 
				cnt <= 3;
				dig <= num1%10;
				point <= 0;
				off <= 0;
				pos <= 4;
			end // 打印数量个位
			3:
			begin 
				cnt <= 0;
				dig <= num1/10;
				point <= 0;
				off <= ~|(num1/10);
				pos <= 5;
			end // 打印数量十位
			default:cnt <= 0;
		endcase // cnt
	end



	confirm_goods2:
	begin
		seg <= seg_num;
		an <= an_num;//接入输出端口
		counter <= 0;
		case(cnt)
			0:
			begin 
				cnt <= 1;
				dig <= money2;
				point <= 0;
				off <= 0;
				pos <= 0;
			end
			1:
			begin 
				cnt <= 2;
				dig <= money3;
				point <= 1;
				off <= 0;
				pos <= 1;
			end // 打印售价
			2:
			begin 
				cnt <= 3;
				dig <= num1%10;
				point <= 0;
				off <= 0;
				pos <= 4;
			end // 打印数量个位
			3:
			begin 
				cnt <= 0;
				dig <= num1/10;
				point <= 0;
				off <= ~|(num1/10);
				pos <= 5;
			end // 打印数量十位
			default:cnt <= 0;
		endcase // cnt
	end

	goods1, stop_goods1:
	begin 
		seg <= seg_num;
		an <= an_num;
		case(cnt)
			0:
			begin 
				cnt <= 1;
				dig <= sum/10;
				point <= 0;
				off <= ~|(sum/10);
				pos <= 6;
			end
			1:
			begin 
				cnt <= 2;
				dig <= sum%10;
				point <= 1;
				off <= 0;
				pos <= 5;
			end
			2:
			begin 
				cnt <= 3;
				dig <= sum_frac;
				point <= 0;
				off <= 0;
				pos <= 4;
			end
			3:
			begin 
				cnt <= 4;
				dig <= money0;
				point <= 0;
				off <= 0;
				pos <= 0;
			end
			4:
			begin 
				cnt <= 0;
				dig <= money1;
				point <= 1;
				off <= 0;
				pos <= 1;
			end
			default:cnt <= 0;
		endcase // cnt
	end

	goods2, stop_goods2:
	begin 
		seg <= seg_num;
		an <= an_num;
		case(cnt)
			0:
			begin 
				cnt <= 1;
				dig <= sum/10;
				point <= 0;
				off <= ~|(sum/10);
				pos <= 6;
			end
			1:
			begin 
				cnt <= 2;
				dig <= sum%10;
				point <= 1;
				off <= 0;
				pos <= 5;
			end
			2:
			begin 
				cnt <= 3;
				dig <= sum_frac;
				point <= 0;
				off <= 0;
				pos <= 4;
			end
			3:
			begin 
				cnt <= 4;
				dig <= money2;
				point <= 0;
				off <= 0;
				pos <= 0;
			end
			4:
			begin 
				cnt <= 0;
				dig <= money3;
				point <= 1;
				off <= 0;
				pos <= 1;
			end
			default:cnt<=0;
		endcase // cnt
	end

	get1, get2: // 实现转圈等待效果
	begin 
		case(cnt)
			0:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 1;
				end
				seg <= 8'b11111110;
				an  <= 8'b11111110;
			end
			1:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 2;
				end
				seg <= 8'b11111101;
				an  <= 8'b11111110;
			end
			2:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 3;
				end
				seg <= 8'b11111011;
				an  <= 8'b11111110;
			end
			3:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 4;
				end
				seg <= 8'b11110111;
				an  <= 8'b11111110;
			end
			4:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 5;
				end
				seg <= 8'b11110111;
				an  <= 8'b11111101;
			end
			5:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 6;
				end
				seg <= 8'b11110111;
				an  <= 8'b11111011;
			end
			6:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 7;
				end
				seg <= 8'b11110111;
				an  <= 8'b11110111;
			end
			7:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 8;
				end
				seg <= 8'b11110111;
				an  <= 8'b11101111;
			end
			8:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 9;
				end
				seg <= 8'b11110111;
				an  <= 8'b11011111;
			end
			9:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 10;
				end
				seg <= 8'b11110111;
				an  <= 8'b10111111;
			end
			10:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 11;
				end
				seg <= 8'b11110111;
				an  <= 8'b01111111;
			end
			11:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 12;
				end
				seg <= 8'b11101111;
				an  <= 8'b01111111;
			end
			12:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 13;
				end
				seg <= 8'b11011111;
				an  <= 8'b01111111;
			end
			13:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 14;
				end
				seg <= 8'b11111110;
				an  <= 8'b01111111;
			end
			14:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 15;
				end
				seg <= 8'b11111110;
				an  <= 8'b10111111;
			end
			15:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 16;
				end
				seg <= 8'b11111110;
				an  <= 8'b11011111;
			end
			16:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 17;
				end
				seg <= 8'b11111110;
				an  <= 8'b11101111;
			end
			17:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 18;
				end
				seg <= 8'b11111110;
				an  <= 8'b11110111;
			end
			18:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 19;
				end
				seg <= 8'b11111110;
				an  <= 8'b11111011;
			end
			19:
			begin 
				if(counter != 100_000_000 / delay / div)
					counter <= counter + 1;
				else
				begin 
					counter <= 0;
					cnt <= 0;
				end
				seg <= 8'b11111110;
				an  <= 8'b11111101;
			end
			default:
			begin 
				cnt <= 0;
				counter <= 0;
			end
		endcase // cnt
	end

	echo_remain:
	begin 
		seg <= seg_num;
		an <= an_num;
		case(cnt)
			0:
			begin 
				cnt <= 1;
				dig <= sum/10;
				point <= 0;
				off <= ~|(sum/10);
				pos <= 6;
			end
			1:
			begin 
				cnt <= 2;
				dig <= sum%10;
				point <= 1;
				off <= 0;
				pos <= 5;
			end
			2:
			begin 
				cnt <= 0;
				dig <= sum_frac;
				point <= 0;
				off <= 0;
				pos <= 4;
			end
			default:
			begin 
				off <= 1;
				cnt <= 0;
			end
		endcase // cnt
	end

	valid0:
	begin 
		seg <= seg_num;
		an <= an_num;
		case(cnt)
			0:
			begin 
				cnt <= 1;
				dig <= 1;
				point <= 0;
				off <= 0;
				pos <= 7;
			end
			1:
			begin 
				cnt <= 2;
				dig <= num0 / 10;
				point <= 0;
				off <= ~|(num0/10);
				pos <= 1;
			end
			2:
			begin 
				cnt <= 0;
				dig <= num0 % 10;
				point <= 0;
				off <= 0;
				pos <= 0;
			end
			default:cnt <= 0;
		endcase // cnt
	end

	valid1:
	begin 
		seg <= seg_num;
		an <= an_num;
		case(cnt)
			0:
			begin 
				cnt <= 1;
				dig <= 2;
				point <= 0;
				off <= 0;
				pos <= 7;
			end
			1:
			begin 
				cnt <= 2;
				dig <= num1 / 10;
				point <= 0;
				off <= ~|(num1/10);
				pos <= 1;
			end
			2:
			begin 
				cnt <= 0;
				dig <= num1 % 10;
				point <= 0;
				off <= 0;
				pos <= 0;
			end
			default:cnt <= 0;
		endcase // cnt
	end

	default:
	begin
		seg <= 8'b11111111;
		an <= 8'b11111111;
		counter <= 0;
	end
endcase // state

display_num show_num(.dig(dig), .pos(pos), .point(point), 
	.off(off), .seg(seg_num), .an(an_num));

endmodule
