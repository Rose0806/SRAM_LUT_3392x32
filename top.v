`timescale 1ns/10ps
`define IS_POWER_OF_TWO(width) ((width & (width - 1)) == 0)
module top(
			/*INPUT*/
			clk, rst, data_in, data1, data2,
			/*OUTPUT*/
			out_valid,  
			en, 
			addr,
			out1, out2, out3, out4,
			addr1, addr2
			);

parameter width = 114; 
parameter width_minus_1 = width - 1; 
parameter height = 172; 

input clk, rst;
input [7:0] data_in;
input [31:0] data1, data2;
output reg out_valid;
output reg en;
output reg [$clog2(width*height)-1:0] addr;
output reg signed [7:0] out1, out2, out3, out4;
output [11 :0] addr1, addr2;

wire  [31:0] O0_R, O1_R, O2_R, O3_R;
wire  [31:0] O0_L, O1_L, O2_L, O3_L; 
wire  [31:0] O0_U, O1_U, O2_U, O3_U; 
wire  [31:0] O0_D, O1_D, O2_D, O3_D; 
reg SR_start, LUT_WE;

wire [11:0] O0_addr_R, O1_addr_R, O2_addr_R, O3_addr_R, O0_addr_L, O1_addr_L, O2_addr_L, O3_addr_L, O0_addr_U, O1_addr_U, O2_addr_U, O3_addr_U, O0_addr_D, O1_addr_D, O2_addr_D, O3_addr_D;

parameter IDLE = 0;
parameter STATE1 = 1;
parameter STATE2 = 2; 

reg [1:0] cur_state, next_state;
reg [7:0] wdata; 
reg [7:0] col_1 [0:4];
reg [7:0] col_2 [0:4];
reg [7:0] col_3 [0:4];
reg [7:0] col_4 [0:4];
wire [7:0] SRAM_0, SRAM_1, SRAM_2, SRAM_3;

wire signed [10:0] out1_R, out2_R, out3_R, out4_R;
wire signed [10:0] out1_L, out2_L, out3_L, out4_L;
wire signed [10:0] out1_U, out2_U, out3_U, out4_U;
wire signed [10:0] out1_D, out2_D, out3_D, out4_D;
wire signed [8:0] out1_buffer, out2_buffer, out3_buffer, out4_buffer; 
Rotational_Ensemble_calculator_Y_8_C my_REC_8(
			.out1_R(out1_R), .out2_R(out2_R), .out3_R(out3_R), .out4_R(out4_R), 
			.out1_L(out1_L), .out2_L(out2_L), .out3_L(out3_L), .out4_L(out4_L), 
			.out1_U(out1_U), .out2_U(out2_U), .out3_U(out3_U), .out4_U(out4_U), 
			.out1_D(out1_D), .out2_D(out2_D), .out3_D(out3_D), .out4_D(out4_D), 
			.out1_buffer(out1_buffer), .out2_buffer(out2_buffer), .out3_buffer(out3_buffer), .out4_buffer(out4_buffer)
			);
Direction_Calculator_Y_8 Right(
			.clk(clk), .rst(rst), .center(col_3[2]), .data1(col_4[2]), .data2(SRAM_2), .O0(O0_R), .O1(O1_R), .O2(O2_R), .O3(O3_R), 
			.O0_addr(O0_addr_R), .O1_addr(O1_addr_R), .O2_addr(O2_addr_R), .O3_addr(O3_addr_R),
			.out1(out1_R), .out2(out2_R), .out3(out3_R), .out4(out4_R)
			);
Direction_Calculator_Y_8 Left(
			.clk(clk), .rst(rst), .center(col_3[2]), .data1(col_2[2]), .data2(col_1[2]), .O0(O0_L), .O1(O1_L), .O2(O2_L), .O3(O3_L), 
			.O0_addr(O0_addr_L), .O1_addr(O1_addr_L), .O2_addr(O2_addr_L), .O3_addr(O3_addr_L),
			.out1(out1_L), .out2(out2_L), .out3(out3_L), .out4(out4_L)
			);
Direction_Calculator_Y_8 Up(
			.clk(clk), .rst(rst), .center(col_3[2]), .data1(col_3[1]), .data2(col_3[0]), .O0(O0_U), .O1(O1_U), .O2(O2_U), .O3(O3_U), 
			.O0_addr(O0_addr_U), .O1_addr(O1_addr_U), .O2_addr(O2_addr_U), .O3_addr(O3_addr_U),
			.out1(out1_U), .out2(out2_U), .out3(out3_U), .out4(out4_U)
			);
Direction_Calculator_Y_8 Down(
			.clk(clk), .rst(rst), .center(col_3[2]), .data1(col_3[3]), .data2(col_3[4]), .O0(O0_D), .O1(O1_D), .O2(O2_D), .O3(O3_D), 
			.O0_addr(O0_addr_D), .O1_addr(O1_addr_D), .O2_addr(O2_addr_D), .O3_addr(O3_addr_D),
			.out1(out1_D), .out2(out2_D), .out3(out3_D), .out4(out4_D)
			);

Line_Buf my_Line_Buf
(
	.clk(clk),
	.rst(rst),
	.en(en),
	.wdata(wdata),
	.out1(SRAM_0),
	.out2(SRAM_1),
	.out3(SRAM_2),
	.out4(SRAM_3)
);


LUT myLUT
(
    .clk(clk),
	.rst(rst),
    .data1(data1), .data2(data2),
    .O0_addr_R(O0_addr_R), .O1_addr_R(O1_addr_R), .O2_addr_R(O2_addr_R), .O3_addr_R(O3_addr_R), 
	.O0_addr_L(O0_addr_L), .O1_addr_L(O1_addr_L), .O2_addr_L(O2_addr_L), .O3_addr_L(O3_addr_L), 
	.O0_addr_U(O0_addr_U), .O1_addr_U(O1_addr_U), .O2_addr_U(O2_addr_U), .O3_addr_U(O3_addr_U), 
	.O0_addr_D(O0_addr_D), .O1_addr_D(O1_addr_D), .O2_addr_D(O2_addr_D), .O3_addr_D(O3_addr_D), 	
    .addr1(addr1), .addr2(addr2), .SR_start(SR_start) , .LUT_WE(LUT_WE),
    .O0_R(O0_R), .O1_R(O1_R), .O2_R(O2_R), .O3_R(O3_R), 
	.O0_L(O0_L), .O1_L(O1_L), .O2_L(O2_L), .O3_L(O3_L), 
	.O0_U(O0_U), .O1_U(O1_U), .O2_U(O2_U), .O3_U(O3_U), 
	.O0_D(O0_D), .O1_D(O1_D), .O2_D(O2_D), .O3_D(O3_D)	
);


integer i;
always@(posedge clk) begin
		if(rst) begin
			for(i=0 ; i<=4 ; i=i+1)	begin
				col_1[i] <= 0;
				col_2[i] <= 0;
				col_3[i] <= 0;
				col_4[i] <= 0;
			end
			wdata <= 0;
			out1 <= 0;
			out2 <= 0;
			out3 <= 0;
			out4 <= 0;
		end
		else begin
			wdata <= data_in;
			col_4[0] <= SRAM_0;
			col_4[1] <= SRAM_1;
			col_4[2] <= SRAM_2;
			col_4[3] <= SRAM_3;
			col_4[4] <= wdata;
			for(i=0 ; i<=4 ; i=i+1)	begin
				col_1[i] <= col_2[i];
				col_2[i] <= col_3[i];
				col_3[i] <= col_4[i];
			end
			out1 <= $signed(out1_buffer[7:0]);
			out2 <= $signed(out2_buffer[7:0]);
			out3 <= $signed(out3_buffer[7:0]);
			out4 <= $signed(out4_buffer[7:0]);
		end
	end
	
reg [10:0] addr_base;
assign addr1 = {addr_base, 1'b0};
assign addr2 = {addr_base, 1'b1};

always@(posedge clk) begin
	if(rst) begin
		LUT_WE <= 0;
		SR_start <= 0;
		addr_base <= 0;
	end
	else begin
		if(addr_base >= 1689) begin
			LUT_WE <= 1;
			SR_start <= 1;
		end	
		else begin
			addr_base <= addr_base + 1;
		end	
	end
end

if (`IS_POWER_OF_TWO(width)) begin 
	always@(posedge clk) begin
		if(rst) addr <= {$clog2(width*height){1'b1}};
		else begin
			if(SR_start) addr <= addr + 1;
		end
	end

	wire [$clog2(width)-1:0] X = addr[$clog2(width)-1:0];
	wire [$clog2(height)-1:0] Y = addr[$clog2(width*height)-1:$clog2(width)];
	
	always@(*) begin
		case(cur_state)
		IDLE: next_state = STATE1;
		STATE1: begin
			if(X == 7 && Y == 4) next_state = STATE2;
			else next_state = STATE1;
		end
		STATE2: next_state = STATE2;
		default: next_state = IDLE;
		endcase
	end

	always@(posedge clk) begin
		if(rst) cur_state <= IDLE;
		else cur_state <= next_state;
	end

	always@(posedge clk) begin
		if(rst) begin	
			out_valid <= 0;
			en <= 0;
		end
		else begin		
			case(cur_state) 
			IDLE: out_valid <= 0;
			STATE1: begin
				out_valid <= 0;				
				if(X && !Y) en <= 1;
			end
			STATE2:	begin				
				if(X > 3 && X < 8) out_valid <= 0; 			
				else out_valid <= 1;
			end
			endcase
		end
	end
end 	
	
else begin
	reg [$clog2(width)-1:0] pixel_x;
	reg [$clog2(height)-1:0] pixel_y;
	wire [$clog2(width*height)-1:0] addr_buffer = (pixel_y*width) + pixel_x;

	always@(*) begin
		case(cur_state)
		IDLE: next_state = STATE1;
		STATE1: begin
			if(pixel_x == 8 && pixel_y == 4) next_state = STATE2;			
			else next_state = STATE1;
		end
		STATE2: next_state = STATE2;
		default: next_state = IDLE;
		endcase
	end

	always@(posedge clk) begin
		if(rst) cur_state <= IDLE;
		else cur_state <= next_state;
	end

	always@(posedge clk) begin
		if(rst) begin
			pixel_x <= 0;
			pixel_y <= 0;
			addr <= 0;
		end
		else begin
			if(SR_start) begin
				if(pixel_x >= width_minus_1) begin
					pixel_x <= 0;
					pixel_y <= pixel_y + 1;
				end
				else pixel_x <= pixel_x + 1;
			end			
			addr <= addr_buffer;
		end
	end

	always@(posedge clk) begin
		if(rst) begin	
			out_valid <= 0;
			en <= 0;
		end
		else begin		
			case(cur_state) 
			IDLE: out_valid <= 0;
			STATE1: begin
				out_valid <= 0;			
				if(pixel_x > 1) en <= 1;
			end
			STATE2:	begin		
				if(pixel_x > 4 && pixel_x < 9) out_valid <= 0;
			else out_valid <= 1;
			end
			endcase
		end
	end
end

endmodule


