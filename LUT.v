
module LUT
(   //input
    clk,
    rst,
    data1, data2,
    O0_addr_R, O1_addr_R, O2_addr_R, O3_addr_R, 
    O0_addr_L, O1_addr_L, O2_addr_L, O3_addr_L, 
    O0_addr_U, O1_addr_U, O2_addr_U, O3_addr_U, 
    O0_addr_D, O1_addr_D, O2_addr_D, O3_addr_D,
    addr1, addr2, SR_start, LUT_WE,
    //output    
    O0_R, O1_R, O2_R, O3_R, 
    O0_L, O1_L, O2_L, O3_L, 
    O0_U, O1_U, O2_U, O3_U, 
    O0_D, O1_D, O2_D, O3_D    
);


input clk, rst;
input [31:0] data1, data2;
input [11:0] O0_addr_R, O1_addr_R, O2_addr_R, O3_addr_R, O0_addr_L, O1_addr_L, O2_addr_L, O3_addr_L, O0_addr_U, O1_addr_U, O2_addr_U, O3_addr_U, O0_addr_D, O1_addr_D, O2_addr_D, O3_addr_D;
input [11:0] addr1, addr2;
output [31:0] O0_R, O1_R, O2_R, O3_R, O0_L, O1_L, O2_L, O3_L, O0_U, O1_U, O2_U, O3_U, O0_D, O1_D, O2_D, O3_D;
input SR_start, LUT_WE;

reg [31:0] data1_, data2_;
wire [11:0] addr1_R, addr2_R, addr3_R, addr4_R; 
assign addr1_R = (SR_start)? O0_addr_R : (addr1-4);
assign addr2_R = (SR_start)? O1_addr_R : (addr2-4);
assign addr3_R = (SR_start)? O2_addr_R : (addr1-4);
assign addr4_R = (SR_start)? O3_addr_R : (addr2-4);
always@(posedge clk) begin
	if(rst) begin
        data1_ <= 0;
        data2_ <= 0;
	end
	else begin
        data1_ <= data1;
        data2_ <= data2;
	end
end
SRAM_DP_test5 mySRAM_DP_LUT_R1(  
            //port1        
            .DA(data1_),
            .AA(addr1_R),
            .CLKA(clk),
            .CENA(1'b0),
            .WENA(LUT_WE),
            .QA(O0_R),
            .EMAA(3'b0),
            //port2
            .DB(data2_),
            .AB(addr2_R),
            .CLKB(clk),
            .CENB(1'b0),
            .WENB(LUT_WE),
            .QB(O1_R),
            .EMAB(3'b0)
            );
SRAM_DP_test5 mySRAM_DP_LUT_R2(  
            //port1        
            .DA(data1_),
            .AA(addr3_R),
            .CLKA(clk),
            .CENA(1'b0),
            .WENA(LUT_WE),
            .QA(O2_R),
            .EMAA(3'b0),
            //port2
            .DB(data2_),
            .AB(addr4_R),
            .CLKB(clk),
            .CENB(1'b0),
            .WENB(LUT_WE),
            .QB(O3_R),
            .EMAB(3'b0)
            );
wire [11:0] addr1_L, addr2_L, addr3_L, addr4_L; 
assign addr1_L = (SR_start)? O0_addr_L : addr1-4;
assign addr2_L = (SR_start)? O1_addr_L : addr2-4;
assign addr3_L = (SR_start)? O2_addr_L : addr1-4;
assign addr4_L = (SR_start)? O3_addr_L : addr2-4;

SRAM_DP_test5 mySRAM_DP_LUT_L1(  
            //port1        
            .DA(data1_),
            .AA(addr1_L),
            .CLKA(clk),
            .CENA(1'b0),
            .WENA(LUT_WE),
            .QA(O0_L),
            .EMAA(3'b0),
            //port2
            .DB(data2_),
            .AB(addr2_L),
            .CLKB(clk),
            .CENB(1'b0),
            .WENB(LUT_WE),
            .QB(O1_L),
            .EMAB(3'b0)
            );
SRAM_DP_test5 mySRAM_DP_LUT_L2(  
            //port1        
            .DA(data1_),
            .AA(addr3_L),
            .CLKA(clk),
            .CENA(1'b0),
            .WENA(LUT_WE),
            .QA(O2_L),
            .EMAA(3'b0),
            //port2
            .DB(data2_),
            .AB(addr4_L),
            .CLKB(clk),
            .CENB(1'b0),
            .WENB(LUT_WE),
            .QB(O3_L),
            .EMAB(3'b0)
            );
wire [11:0] addr1_U, addr2_U, addr3_U, addr4_U; 
assign addr1_U = (SR_start)? O0_addr_U : addr1-4;
assign addr2_U = (SR_start)? O1_addr_U : addr2-4;
assign addr3_U = (SR_start)? O2_addr_U : addr1-4;
assign addr4_U = (SR_start)? O3_addr_U : addr2-4;

SRAM_DP_test5 mySRAM_DP_LUT_U1(  
            //port1        
            .DA(data1_),
            .AA(addr1_U),
            .CLKA(clk),
            .CENA(1'b0),
            .WENA(LUT_WE),
            .QA(O0_U),
            .EMAA(3'b0),
            //port2
            .DB(data2_),
            .AB(addr2_U),
            .CLKB(clk),
            .CENB(1'b0),
            .WENB(LUT_WE),
            .QB(O1_U),
            .EMAB(3'b0)
            );
SRAM_DP_test5 mySRAM_DP_LUT_U2(  
            //port1        
            .DA(data1_),
            .AA(addr3_U),
            .CLKA(clk),
            .CENA(1'b0),
            .WENA(LUT_WE),
            .QA(O2_U),
            .EMAA(3'b0),
            //port2
            .DB(data2_),
            .AB(addr4_U),
            .CLKB(clk),
            .CENB(1'b0),
            .WENB(LUT_WE),
            .QB(O3_U),
            .EMAB(3'b0)
            );
wire [11:0] addr1_D, addr2_D, addr3_D, addr4_D; 
assign addr1_D = (SR_start)? O0_addr_D : addr1-4;
assign addr2_D = (SR_start)? O1_addr_D : addr2-4;
assign addr3_D = (SR_start)? O2_addr_D : addr1-4;
assign addr4_D = (SR_start)? O3_addr_D : addr2-4;

SRAM_DP_test5 mySRAM_DP_LUT_D1(  
            //port1        
            .DA(data1_),
            .AA(addr1_D),
            .CLKA(clk),
            .CENA(1'b0),
            .WENA(LUT_WE),
            .QA(O0_D),
            .EMAA(3'b0),
            //port2
            .DB(data2_),
            .AB(addr2_D),
            .CLKB(clk),
            .CENB(1'b0),
            .WENB(LUT_WE),
            .QB(O1_D),
            .EMAB(3'b0)
            );
SRAM_DP_test5 mySRAM_DP_LUT_D2(  
            //port1        
            .DA(data1_),
            .AA(addr3_D),
            .CLKA(clk),
            .CENA(1'b0),
            .WENA(LUT_WE),
            .QA(O2_D),
            .EMAA(3'b0),
            //port2
            .DB(data2_),
            .AB(addr4_D),
            .CLKB(clk),
            .CENB(1'b0),
            .WENB(LUT_WE),
            .QB(O3_D),
            .EMAB(3'b0)
            );



endmodule

