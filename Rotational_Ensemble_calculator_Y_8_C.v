module Rotational_Ensemble_calculator_Y_8_C(
			/*INPUT*/
			out1_R, out2_R, out3_R, out4_R,
            out1_L, out2_L, out3_L, out4_L,
            out1_U, out2_U, out3_U, out4_U,
            out1_D, out2_D, out3_D, out4_D,
			/*OUTPUT*/
			out1_buffer,out2_buffer, out3_buffer, out4_buffer
			);

input signed [10:0] out1_R, out2_R, out3_R, out4_R;
input signed [10:0] out1_L, out2_L, out3_L, out4_L;
input signed [10:0] out1_U, out2_U, out3_U, out4_U;
input signed [10:0] out1_D, out2_D, out3_D, out4_D;
output signed [8:0] out1_buffer,out2_buffer, out3_buffer, out4_buffer;

wire signed [12:0] out1_1 = (out1_R + out4_L) + (out2_U + out3_D);
wire signed [8:0] out1_1_ = $signed({1'b0,out1_1[10:3]}) + $signed({7'b0,out1_1[2]}); //round
wire signed [8:0] out1_buffer = (out1_1[12])? 16 : (out1_1 >= 1752)? 235 : (out1_1_+16) ; //219*8=1752

wire signed [12:0] out2_1 = (out2_R + out3_L) + (out4_U + out1_D);
wire signed [8:0] out2_1_ = $signed({1'b0,out2_1[10:3]}) + $signed({7'b0,out2_1[2]}); 
wire signed [8:0] out2_buffer = (out2_1[12])? 16 : (out2_1 >= 1752)? 235 : (out2_1_+16) ;

wire signed [12:0] out3_1 = (out3_R + out2_L) + (out1_U + out4_D);
wire signed [8:0] out3_1_ = $signed({1'b0,out3_1[10:3]}) + $signed({7'b0,out3_1[2]}); 
wire signed [8:0] out3_buffer = (out3_1[12])? 16 : (out3_1 >= 1752)? 235 : (out3_1_+16) ;

wire signed [12:0] out4_1 = (out4_R + out1_L) + (out3_U + out2_D);
wire signed [8:0] out4_1_ = $signed({1'b0,out4_1[10:3]}) + $signed({7'b0,out4_1[2]}); 
wire signed [8:0] out4_buffer = (out4_1[12])? 16 : (out4_1 >= 1752)? 235 : (out4_1_+16) ;


endmodule
