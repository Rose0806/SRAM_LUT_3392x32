// simplified
module Direction_Calculator_Y_8(
			/*INPUT*/
			clk, rst, center, data1, data2, O0, O1, O2, O3, 
			/*OUTPUT*/
			O0_addr, O1_addr, O2_addr, O3_addr,
			out1, out2, out3, out4
			);
input clk, rst;
input [7:0] center, data1, data2; //0~255
input [31:0] O0, O1, O2, O3; // total 16 number of (127~-127) = 128 bit
output reg [11:0] O0_addr, O1_addr, O2_addr, O3_addr;
output reg signed [10:0] out1, out2, out3, out4; 

wire [7:0] center_Normal = center-16;
wire [7:0] data1_Normal = data1-16;
wire [7:0] data2_Normal = data2-16;

wire [3:0] img_a1 = center_Normal[7:4]; //range: 0~15
wire [3:0] img_b1 = data1_Normal[7:4];
wire [3:0] img_c1 = data2_Normal[7:4];

wire [4:0] img_a2 = img_a1 + 1; //range: 1~16
wire [4:0] img_b2 = img_b1 + 1;
wire [4:0] img_c2 = img_c1 + 1;

wire [2:0] Lx = center[3:1];
wire [2:0] Ly = data1[3:1];
wire [2:0] Lz = data2[3:1];

//225 15 1
wire [11:0] addr_P000 = (((img_a1<<7) + (img_a1<<6)) + ((img_a1<<5) + img_a1)) + (((img_b1<<4) - img_b1) + img_c1);  
wire [11:0] addr_P001 = addr_P000 + 1;
wire [11:0] addr_P010 = addr_P000 + 15;
wire [11:0] addr_P011 = addr_P000 + 16;
wire [11:0] addr_P100 = addr_P000 + 225;
wire [11:0] addr_P101 = addr_P000 + 226;
wire [11:0] addr_P110 = addr_P000 + 240;
wire [11:0] addr_P111 = addr_P000 + 241;


reg signed [4:0] W0; //weight range (0~8), one more sign bit for next calculation (signed mult)
reg signed [3:0] W1, W2, W3; //weight range (0~8), one more sign bit for next calculation (signed mult)
reg [3:0] W0_; //0~8
reg [2:0] W1_, W2_, W3_; //0~8

always@(posedge clk, posedge rst) begin
	if(rst) begin
		W0 <= 0;
		W1 <= 0;
		W2 <= 0;
		W3 <= 0;
	end
	else begin
		W0 <= {1'b0, W0_};
		W1 <= {1'b0, W1_};
		W2 <= {1'b0, W2_};
		W3 <= {1'b0, W3_};
		out1  <= ($signed(O0[31:24])*W0 + $signed(O1[31:24])*W1) + ($signed(O2[31:24])*W2 + $signed(O3[31:24])*W3);
		out2  <= ($signed(O0[23:16])*W0 + $signed(O1[23:16])*W1) + ($signed(O2[23:16])*W2 + $signed(O3[23:16])*W3);
		out3  <= ($signed(O0[15:8])*W0 + $signed(O1[15:8])*W1) + ($signed(O2[15:8])*W2 + $signed(O3[15:8])*W3);
		out4  <= ($signed(O0[7:0])*W0 + $signed(O1[7:0])*W1) + ($signed(O2[7:0])*W2 + $signed(O3[7:0])*W3);		// W0+W1+W2+W3 = 16 => 7+4+1 = 12	
	end
end


always@(*) begin
	
	if(Lx > Ly) begin
		if(Ly > Lz) begin
			W0_ = 8 - Lx;
			W1_ = Lx - Ly;
			W2_ = Ly - Lz;
			W3_ = Lz;
			O0_addr = addr_P000;			
			O1_addr = addr_P100;
			O2_addr = addr_P110;
			O3_addr = addr_P111;		
		end
		else if(Lx > Lz) begin
			W0_ = 8 - Lx;
			W1_ = Lx - Lz;
			W2_ = Lz - Ly;
			W3_ = Ly;
			O0_addr = addr_P000;
			O1_addr = addr_P100;
			O2_addr = addr_P101;
			O3_addr = addr_P111;                          
		end
		else begin
			W0_ = 8 - Lz;
			W1_ = Lz - Lx;
			W2_ = Lx - Ly;
			W3_ = Ly;
			O0_addr = addr_P000;
			O1_addr = addr_P001;
			O2_addr = addr_P101;
			O3_addr = addr_P111;			                          
		end
	end
	else begin
		if(Lz > Ly) begin
			W0_ = 8 - Lz;
			W1_ = Lz - Ly;
			W2_ = Ly - Lx;
			W3_ = Lx;
			O0_addr = addr_P000;
			O1_addr = addr_P001;
			O2_addr = addr_P011;
			O3_addr = addr_P111;			
		end
		else if(Lz > Lx) begin
			W0_ = 8 - Ly;
			W1_ = Ly - Lz;
			W2_ = Lz - Lx;
			W3_ = Lx;
			O0_addr = addr_P000;
			O1_addr = addr_P010;
			O2_addr = addr_P011;
			O3_addr = addr_P111;                   
		end
		else begin
			W0_ = 8 - Ly;
			W1_ = Ly - Lx;
			W2_ = Lx - Lz;
			W3_ = Lz;
			O0_addr = addr_P000;
			O1_addr = addr_P010;
			O2_addr = addr_P110;
			O3_addr = addr_P111;			
		end
	end
end

endmodule
