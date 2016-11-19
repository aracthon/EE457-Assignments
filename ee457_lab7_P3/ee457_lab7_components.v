// File: ee457_lab7_components.v
// Written by Jyoti Sachdeva, Gandhi Puvvada, July 18, 2010
 
// This design supports SUB3, ADD4, ADD1, and MOV instructions.
// It also supports carrying the complete 32-bit instruction through
// the pipeline to support reverse assembly and forming the Time-Space diagram.
//-------------------------
`timescale 1 ns / 100 ps
module pc (en,clk,rstb,pco);
input en,clk,rstb;
output reg [7:0] pco;
always @ (posedge clk, negedge rstb)
if (rstb == 1'b0)
begin
    pco <= 0;
end 
else if (en)
begin
    pco <= pco + 1;
end
endmodule
//-------------------------
`timescale 1 ns / 100 ps
module ins_mem(a,d_out);
input [5:0]a;
output [31:0]d_out;
reg [31:0] memory [0:63];
assign d_out = memory[a];
endmodule
//-------------------------
`timescale 1 ns / 100 ps
module pipe_if_id_P1(rstb,clk,en,id_za,id_ya,id_xa,id_ra,run,instr_in,instr_out);
    input rstb,clk,en;
    input [31:0]instr_in;  output reg [31:0]instr_out;
    output reg [3:0] id_za,id_ya,id_xa,id_ra;
    output reg run;
    always @(posedge clk, negedge rstb)
	  begin
		if (rstb == 1'b0)
		  begin
			id_za<= 4'b0000;
			id_ya<= 4'b0000;
			id_xa<= 4'b0000;
			id_ra<= 4'b0000;
			run<= 0;
			instr_out <= 32'h00000000;
		  end
		else if (en)
		  begin
		   id_xa <= instr_in[3:0];
		   id_ya <= instr_in[7:4];
		   id_za <= instr_in[11:8];
		   id_ra <= instr_in[15:12] ;
		   run <= instr_in[31]; //  1 = ADD; 0 = NOP
		   instr_out <= instr_in;
		  end 
	  end
endmodule
//-------------------------
`timescale 1 ns / 100 ps
module pipe_if_id_P3(rstb,clk,en,id_xa,id_ra,add1,add4,sub3,mov,instr_in,instr_out);
    input rstb,clk,en;
    input [31:0]instr_in; output reg [31:0]instr_out;
    output reg [3:0] id_xa,id_ra;
    output reg add1,add4,sub3,mov;
    always @(posedge clk, negedge rstb)
    if (rstb == 1'b0)
    begin
        id_xa<= 4'b0000;
        id_ra<= 4'b0000;
        add1<= 0;add4<= 0;sub3<= 0;mov<= 0;
		instr_out <= 32'h00000000;
    end
    else if (en)
    begin
       id_xa <= instr_in[3:0];
       id_ra <= instr_in[7:4] ;
       add1 <= instr_in[28]; //  instr_in[28] = 1 => ADD1;
       add4 <= instr_in[29]; //  instr_in[29] = 1 => ADD4;
       sub3 <= instr_in[30]; //  instr_in[30] = 1 => SUB3;
	   mov  <= instr_in[31]; //  instr_in[31] = 1 => MOV;
	   instr_out <= {instr_in[31:28],20'h00000,instr_in[7:0]};
    end  
endmodule
//-------------------------
`timescale 1 ns / 100 ps
module register_file (r1a,r2a,r3a,wa,wd,reg_write,r1d,r2d,r3d,clk);
    input clk,reg_write;
	input [3:0]r1a,r2a,r3a,wa;
	input [15:0] wd;
    output[15:0] r1d,r2d,r3d;
    
    reg [15:0] reg_file [0:15] ;
    
	assign r1d = reg_file[r1a];
    assign r2d = reg_file[r2a];
    assign r3d = reg_file[r3a];
		
    always @(negedge clk)
    begin
        if (reg_write)
        begin
           reg_file[wa] <= wd;
        end
    end
// This register file writes in the middle of the clock
// (i.e. on the negative edges of the SYS_CLK) so that
// the internal forwarding becomes automatic.
endmodule
//-------------------------
`timescale 1 ns / 100 ps
module pipe_reg2(rstb,clk,en,
vec16_in1,vec16_in2,vec16_in3,vec16_out1,vec16_out2,vec16_out3,
vec4_in1,vec4_in2,vec4_out1,vec4_out2,
bit_in1,bit_in2,bit_in3,bit_in4,bit_in5,bit_in6,bit_out1,bit_out2,bit_out3,bit_out4,bit_out5,bit_out6,instr_in,instr_out);

input rstb,clk,en;
input [15:0] vec16_in1,vec16_in2,vec16_in3;
input [3:0] vec4_in1,vec4_in2;
input bit_in1,bit_in2,bit_in3,bit_in4,bit_in5,bit_in6;
output reg  [15:0] vec16_out1,vec16_out2,vec16_out3;
output reg [3:0] vec4_out1,vec4_out2;
output reg bit_out1,bit_out2,bit_out3,bit_out4,bit_out5,bit_out6;
input [31:0]instr_in; output reg [31:0]instr_out;

always @ (posedge clk, negedge rstb)
 begin
    if (rstb == 1'b0)
	  begin
		vec16_out1 <= 16'h0000;
		vec16_out2 <= 16'h0000;
		vec16_out3 <= 16'h0000;
		vec4_out1 <= 4'b0000; 
		vec4_out2 <= 4'b0000; 
		bit_out1 <= 1'b0;
		bit_out2 <= 1'b0;
		bit_out3 <= 1'b0;
		bit_out4 <= 1'b0;
		bit_out5 <= 1'b0;
		bit_out6 <= 1'b0;
		instr_out <= 32'h00000000;
      end
    else if (en)
	  begin
		vec16_out1 <= vec16_in1;
		vec16_out2 <= vec16_in2;
		vec16_out3 <= vec16_in3;
		vec4_out1 <= vec4_in1;
		vec4_out2 <= vec4_in2;
		bit_out1 <= bit_in1;
		bit_out2 <= bit_in2;
		bit_out3 <= bit_in3;
		bit_out4 <= bit_in4;
		bit_out5 <= bit_in5;	
		bit_out6 <= bit_in6;
		instr_out <= instr_in;		
	  end
 end
endmodule
//-------------------------
`timescale 1 ns / 100 ps
module comp_station_P1(ex2_ra,ex1_ra,id_za,id_ya,id_xa,zmex2,ymex2,xmex2,zmex1,ymex1,xmex1);
input [3:0] ex2_ra,ex1_ra,id_za,id_ya,id_xa ;
output reg  zmex2,ymex2,xmex2,zmex1,ymex1,xmex1;

always @(ex2_ra,ex1_ra,id_za,id_ya,id_xa) 
	begin: combinational_block
		// default assignments
		zmex2 <= 1'b0;
		ymex2 <= 1'b0;
		xmex2 <= 1'b0;
		zmex1 <= 1'b0;
		ymex1 <= 1'b0;
		xmex1 <= 1'b0;
		// conditional over-riding of the default assignments
		if (ex2_ra == id_za)	zmex2 <= 1'b1;
		if (ex1_ra == id_za)	zmex1 <= 1'b1;
		if (ex2_ra == id_ya)	ymex2 <= 1'b1;
		if (ex1_ra == id_ya)	ymex1 <= 1'b1;
		if (ex2_ra == id_xa)	xmex2 <= 1'b1;
		if (ex1_ra == id_xa)	xmex1 <= 1'b1;
	end
endmodule
//-------------------------
`timescale 1 ns / 100 ps
module comp_station_P3(ex2_ra,ex1_ra,id_xa,xmex2,xmex1);
input [3:0] ex2_ra,ex1_ra,id_xa ;
output reg  xmex2,xmex1;

always @(ex2_ra,ex1_ra,id_xa) 
	begin: combinational_block
		// default assignments
		xmex2 <= 1'b0;
		xmex1 <= 1'b0;
		// conditional over-riding of the default assignments
		if (ex2_ra == id_xa)	xmex2 <= 1'b1;
		if (ex1_ra == id_xa)	xmex1 <= 1'b1;
	end
endmodule
//-------------------------



        
    
    
    
    






