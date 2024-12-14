module Line_Buf
(
    clk,
    rst,
    en,
    wdata,
    out1,
    out2,
    out3,
    out4
);

parameter input_size = 8;
parameter line_width = 114;
input clk;
input rst;
input en;
input [input_size-1:0] wdata;
output [input_size-1:0] out1;
output [input_size-1:0] out2;
output [input_size-1:0] out3;
output [input_size-1:0] out4;
reg [8:0] cur_waddr, cur_raddr;
wire [input_size*4-1:0] full_wdata;
wire [input_size*4-1:0] full_rdata;


assign out1 = full_rdata[input_size*4-1 : input_size*3];
assign out2 = full_rdata[input_size*3-1 : input_size*2];
assign out3 = full_rdata[input_size*2-1 : input_size*1];
assign out4 = full_rdata[input_size*1-1 : 0];

assign full_wdata = (en)?{out2, out3, out4, wdata}:32'b0;
reg [8:0] rst_addr;
wire [8:0] waddr = (en)?cur_waddr:rst_addr;

always@(posedge clk) begin
    if(rst) begin
        cur_waddr <= $unsigned(2'b00);
        cur_raddr <= $unsigned(2'b01);
        rst_addr <= 0;
    end        
    else begin
        if(en) begin
            cur_waddr <= (cur_waddr == line_width-$unsigned(2'b01))? 0 : cur_waddr+$unsigned(2'b01);
            cur_raddr <= (cur_raddr == line_width-$unsigned(2'b01))? 0 : cur_raddr+$unsigned(2'b01);            
        end
        else begin
            rst_addr <= rst_addr + 1;
        end
    end
end
//SRAM
wire [31:0] Woutput;
SRAM_DP_LINEBUF mySRAM_DP_LINEBUF(  
            //read        
            .DA(32'b0),
            .AA(cur_raddr),
            .CLKA(clk),
            .CENA(1'b0),
            .WENA(1'b1),
            .QA(full_rdata),
            .EMAA(3'b0),
            //write
            .DB(full_wdata),
            .AB(waddr),
            .CLKB(clk),
            .CENB(1'b0),
            .WENB(1'b0),
            .QB(Woutput),
            .EMAB(3'b0)
            );




// //SIMULATION
// reg [31:0] out_reg;
// reg [31:0] line_mem [0:line_width-1];
// assign full_rdata = out_reg;
// always@(posedge clk) begin
//     line_mem[waddr] <= full_wdata;     
//     out_reg <= line_mem[cur_raddr];
// end

endmodule

