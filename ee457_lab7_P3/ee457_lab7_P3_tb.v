// File: ee457_lab7_P3_tb.v
// Written by Gandhi Puvvada, July 18, 2010, revised 10/18/2010
 
// This design supports SUB3, ADD4, ADD1, and MOV instructions
  
`timescale 1 ns / 100 ps

module ee457_lab7_P3_tb ;

reg Clk_tb, Rstb_tb;
integer  Clk_cnt, i; // i for the "for loop" in Instruction_Memory_Initialization
// instruction strings
wire [8*19:1] IF_InstrString, ID_InstrString, EX1_InstrString, EX2_InstrString,WB_InstrString;

integer fd;  

reg [8*19:1] outmsg_if_tb;
reg [8*19:1] outmsg_id_tb;
reg [8*19:1] outmsg_ex1_tb;
reg [8*19:1] outmsg_ex2_tb;
reg [8*19:1] outmsg_wb_tb;
  
localparam CLK_PERIOD = 20;

//---------- beginning of reverse assembly functions 
//---------- (By J Joshi and G. Puvvada based on similar functions in lab6)
function [8*6:1] get_regnumstring; 

  input [3:0] a;

	begin
		case(a)
		  4'b0000 : get_regnumstring = "  $0  ";
		  4'b0001 : get_regnumstring = "  $1  ";
		  4'b0010 : get_regnumstring = "  $2  ";
		  4'b0011 : get_regnumstring = "  $3  ";
		  4'b0100 : get_regnumstring = "  $4  ";
		  4'b0101 : get_regnumstring = "  $5  ";
		  4'b0110 : get_regnumstring = "  $6  ";
		  4'b0111 : get_regnumstring = "  $7  ";
		  4'b1000 : get_regnumstring = "  $8  ";
		  4'b1001 : get_regnumstring = "  $9  ";
		  4'b1010 : get_regnumstring = "  $10 ";
		  4'b1011 : get_regnumstring = "  $11 ";
		  4'b1100 : get_regnumstring = "  $12 ";
		  4'b1101 : get_regnumstring = "  $13 ";
		  4'b1110 : get_regnumstring = "  $14 ";
		  4'b1111 : get_regnumstring = "  $15 ";
			
		  default : get_regnumstring =  "  $NO ";
		endcase
	end 
	
endfunction // get_regnumstring
 //--
function [8*6:1] get_instrtype;

  input [3:0] instr_field;

	begin
		case(instr_field)
		  4'b0000 : get_instrtype = "NOP   ";
		  4'b0001 : get_instrtype = "ADD1  ";
		  4'b0010 : get_instrtype = "ADD4  ";
		  4'b0100 : get_instrtype = "SUB3  ";
		  4'b1000 : get_instrtype = "MOV   ";			
		  default : get_instrtype = "ERROR ";
		endcase

	end
endfunction // get_instrtype  
 //--
function [8*19:1] reverse_assemble;

  input [31:0] binary_instruction  ;
  reg [8*6:1] instruction_mnemonic;
  
	begin
	  if (binary_instruction[31:28]==4'b0000)
		if (binary_instruction[27:8]==20'hFFFFF)
			instruction_mnemonic = "BUBBLE";
		else
			instruction_mnemonic = "NOP   ";
	  else
			instruction_mnemonic = get_instrtype(binary_instruction[31:28]);
	  // end if		
	  reverse_assemble = {		instruction_mnemonic,
								get_regnumstring(binary_instruction[7:4]),
								get_regnumstring(binary_instruction[3:0])
							};
	end
endfunction // reverse_assemble  
 //--
function [8*19:1] reverse_assemble_TimeSpace;

  input [31:0] binary_instruction  ;
	begin
		reverse_assemble_TimeSpace
						 = {reverse_assemble(binary_instruction),
						  "|"}; // concatenate a pipe symbol to form column dividers
	end
endfunction // reverse_assemble_TimeSpace 

//---------- end of reverse assembly functions

//---------- beginning of code segment generating a TimeSpace Diagram ------------ 
//---------- (By J Joshi and G. Puvvada based on similar code segment in lab6)
initial
	begin
		fd = $fopen("TimeSpace.txt");
		$fwrite(fd,"=============|==================|==================|==================|==================|==================|\n");
		$fwrite(fd,"        CLK# |       IF         |       ID         |       EX1        |      EX2         |         WB       |\n");
		$fwrite(fd,"=============|==================|==================|==================|==================|==================|\n"); 		
		outmsg_if_tb 	       = "RESET             |";
		outmsg_id_tb 		   = "RESET             |";
		outmsg_ex1_tb 		   = "RESET             |";
		outmsg_ex2_tb 		   = "RESET             |";
		outmsg_wb_tb 		   = "RESET             |";
		// #500;		
		//$fclose(fd);	
	end  
  
 always @ (negedge Clk_tb)
	begin
		if( Rstb_tb != 1'b1) // during reset, print the default reset string: "RESET             |" 
			begin
				$fwrite(fd,"%d  |%s%s%s%s%s\n",Clk_cnt,outmsg_if_tb,outmsg_id_tb,outmsg_ex1_tb,outmsg_ex2_tb,outmsg_wb_tb);
				$fwrite(fd,"-------------|------------------|------------------|------------------|------------------|------------------|\n");
			end
		else 
			begin
				outmsg_if_tb = reverse_assemble_TimeSpace (UUT.IF_INSTR);
				outmsg_id_tb = reverse_assemble_TimeSpace (UUT.ID_INSTR);
				outmsg_ex1_tb = reverse_assemble_TimeSpace (UUT.EX1_INSTR);
				outmsg_ex2_tb = reverse_assemble_TimeSpace (UUT.EX2_INSTR);
				outmsg_wb_tb = reverse_assemble_TimeSpace (UUT.WB_INSTR);
				$fwrite(fd,"%d  |%s%s%s%s%s\n",Clk_cnt,outmsg_if_tb,outmsg_id_tb,outmsg_ex1_tb,outmsg_ex2_tb,outmsg_wb_tb);
				$fwrite(fd,"-------------|------------------|------------------|------------------|------------------|------------------|\n");
			end
			
	end
//---------- end of code segment generating the TimeSpace Diagram ------------
	
ee457_lab7_P3  UUT (.CLK(Clk_tb), .RSTB(Rstb_tb));  // UUT instantiation

assign IF_InstrString = reverse_assemble (UUT.IF_INSTR);
assign ID_InstrString = reverse_assemble (UUT.ID_INSTR);
assign EX1_InstrString = reverse_assemble (UUT.EX1_INSTR);
assign EX2_InstrString = reverse_assemble (UUT.EX2_INSTR);
assign WB_InstrString = reverse_assemble (UUT.WB_INSTR);
				 
initial
  begin  : CLK_GENERATOR
    Clk_tb = 0;
    forever
       begin
	      #(CLK_PERIOD/2) Clk_tb = ~Clk_tb;
       end 
  end

initial
  begin  : RESET_GENERATOR
    Rstb_tb = 0;
    #(2 * CLK_PERIOD) Rstb_tb = 1;
  end

initial Clk_cnt = 0;
always @ (posedge Clk_tb)  
  begin
    # (0.1 * CLK_PERIOD);
	Clk_cnt <= Clk_cnt + 1;
  end

// initial
  // begin  : CLK_COUNTER
    // Clk_cnt = 0;
	// # (0.6 * CLK_PERIOD); // wait until a little after the positive edge
    // forever
       // begin
	      // #(CLK_PERIOD) Clk_cnt <= Clk_cnt + 1;
       // end 
  // end

initial
  begin  : Instruction_Memory_Initialization
  // The comments below about stalling apply only to the design with separate EX1 and and separate EX2 stages.
  // When you later merge the EX1 and EX2 stages, a STALL occurs whenever an ADD1 arrives in EX12. At that time
  // WB also needs to be stalled. There will be no other stalls due to dependency once you merge EX1 and EX2!  
	UUT.INS_MEM.memory[0]  = 32'h40000012; //  SUB3 $1,$2    ($1) = 1\h  SKIP2
	UUT.INS_MEM.memory[1]  = 32'h20000002; //  ADD4 $0,$2    ($0) = 8\h  SKIP1
	UUT.INS_MEM.memory[2]  = 32'h10000012; //  ADD1 $1,$2    ($1) = 5\h  No skip
	UUT.INS_MEM.memory[3]  = 32'h10000021; //  ADD1 $2,$1    ($2) = 6\h  FORW1 from instruction in MEM(2) after stall
	UUT.INS_MEM.memory[4]  = 32'h100000A1; //  ADD1 $A,$1    ($A) = 6\h  Internal Forwarding after the above stall
	UUT.INS_MEM.memory[5]  = 32'h40000012; //  SUB3 $1,$2    ($1) = 3\h  FORW1 from instruction in MEM(3)
	UUT.INS_MEM.memory[6]  = 32'h10000021; //  ADD1 $2,$1    ($2) = 4\h  FORW1, PRIORITY from instruction in MEM(4)	
	UUT.INS_MEM.memory[7]  = 32'h20000022; //  ADD4 $2,$2    ($2) = 8\h  FORW2 from instruction in MEM(6)
	UUT.INS_MEM.memory[8]  = 32'h20000022; //  ADD4 $2,$2    ($2) = C\h  Same as the above instruction. No stall + FORW2
//  The following set of 3 instructions will check
//  No Stall + FORW1 + FORW2 simultaneously
//  Possible error again would be that they stall for a cycle
	UUT.INS_MEM.memory[9]  = 32'h10000015; //  ADD1 $1,$5    ($1) = 21\h
	UUT.INS_MEM.memory[10] = 32'h20000031; //  ADD4 $3,$1    ($3) = 25\h
	UUT.INS_MEM.memory[11] = 32'h40000041; //  SUB3 $4,$1    ($4) = 1E\h
//  The following set of 3 instructions will check
//  No stall + FORW1 with PRIORITY + FORW1 later with no PRIORITY in the next cycle
//  The donor nearest to that being forwarded should forward - in this case the 2nd 
//  SUB3 instruction should forward to the ADD1 instruction.
	UUT.INS_MEM.memory[12] = 32'h40000012; //  SUB3 $1,$2    ($1) = 9\h
	UUT.INS_MEM.memory[13] = 32'h10000041; //  ADD1 $4,$1    ($4) = A\h
	UUT.INS_MEM.memory[14] = 32'h20000051; //  ADD4 $5,$1    ($5) = D\h
	UUT.INS_MEM.memory[15] = 32'h00000000; //  NOP
//  The following set of 7 instructions will check
//  Forwarding erroneously from a NOP with matching destination register 
	UUT.INS_MEM.memory[16] = 32'h00000089; //  NOP (with $8 as dest. reg, $9 as source reg)
	UUT.INS_MEM.memory[17] = 32'h40000088; //  SUB3 $8,$8	 ($8) = 00FD\h
	UUT.INS_MEM.memory[18] = 32'h00000088; //  NOP ($8 as dest. reg, $8 as source reg)
	UUT.INS_MEM.memory[19] = 32'h10000088; //  ADD1 $8,$8	 ($8) = 00FE\h
	UUT.INS_MEM.memory[20] = 32'h00000088; //  NOP ($8 as dest. reg, $8 as source reg)
	UUT.INS_MEM.memory[21] = 32'h20000088; //  ADD4 $8,$8	 ($8) = 0102\h
	UUT.INS_MEM.memory[22] = 32'h00000088; //  NOP ($8 as dest. reg, $8 as source reg)
	UUT.INS_MEM.memory[23] = 32'h00000000; //  NOP	
//  The following set of 3 instructions will check
//  Interference of stall with forwarding
	UUT.INS_MEM.memory[24] = 32'h10000066; //  ADD1 $6,$6	 ($6) = 41\h
	UUT.INS_MEM.memory[25] = 32'h10000066; //  ADD1 $6,$6	 ($6) = 42\h
	UUT.INS_MEM.memory[26] = 32'h10000066; //  ADD1 $6,$6	 ($6) = 43\h
//  The following instructions test MOV instruction and its interaction with others (and also stalls)
	UUT.INS_MEM.memory[27] = 32'h80000096; //  MOV  $9,$6    ($9) = 43\h 
	// The above MOV, which is dependent on the previous ADD1 receives 43/h for $6 (when MOV is in EX2 stage)
	// and conveys it to the immediate next SUB3 in EX1 at the beginning of the clock
	UUT.INS_MEM.memory[28] = 32'h40000099; //  SUB3 $9,$9  ($9) = 40\h
	UUT.INS_MEM.memory[29] = 32'h10000099; //  ADD1 $9,$9  ($9) = 41\h
	UUT.INS_MEM.memory[30] = 32'h10000099; //  ADD1 $9,$9  ($9) = 42\h
	UUT.INS_MEM.memory[31] = 32'h10000099; //  ADD1 $9,$9  ($9) = 43\h
	// The above ADD1 (when it is in WB stage) forwards the value 43\h to the next MOV for $9,
	// when the next MOV is in EX2, the next MOV immediately forwards the same $43 to the
	// further next ADD1 for $10.
	UUT.INS_MEM.memory[32] = 32'h800000A9; //  MOV  $10,$9   ($10) = 43\h
	UUT.INS_MEM.memory[33] = 32'h100000BA; //  ADD1 $11,$10  ($11) = 44\h
	UUT.INS_MEM.memory[34] = 32'h800000CB; //  MOV $12,$11   ($12) = 44\h
	UUT.INS_MEM.memory[35] = 32'h000000CB; //  NOP (with $12 as destination and $11 as source)
	UUT.INS_MEM.memory[36] = 32'h400000DC; //  SUB3 $13,$12   ($13) = 41\h
//  Fill the rest of the memory with NOPs
	for (i = 37; i < 64; i = i+1)
		UUT.INS_MEM.memory[i] = 32'h00000000;		
  end

 initial
  begin  : Register_File_Initialization
	UUT.REG_FILE.reg_file[0]  = 16'b0000000000000001; // $0
	UUT.REG_FILE.reg_file[1]  = 16'b0000000000000010; // $1	
	UUT.REG_FILE.reg_file[2]  = 16'b0000000000000100; // $2	
	UUT.REG_FILE.reg_file[3]  = 16'b0000000000001000; // $3	
	UUT.REG_FILE.reg_file[4]  = 16'b0000000000010000; // $4	
	UUT.REG_FILE.reg_file[5]  = 16'b0000000000100000; // $5	
	UUT.REG_FILE.reg_file[6]  = 16'b0000000001000000; // $6	
	UUT.REG_FILE.reg_file[7]  = 16'b0000000010000000; // $7	
	UUT.REG_FILE.reg_file[8]  = 16'b0000000100000000; // $8
	UUT.REG_FILE.reg_file[9]  = 16'b0000001000000000; // $9	
	UUT.REG_FILE.reg_file[10] = 16'b0000010000000000; // $10	
	UUT.REG_FILE.reg_file[11] = 16'b0000100000000000; // $11	
	UUT.REG_FILE.reg_file[12] = 16'b0001000000000000; // $12	
	UUT.REG_FILE.reg_file[13] = 16'b0010000000000000; // $13	
	UUT.REG_FILE.reg_file[14] = 16'b1111111111111000; // $14	
	UUT.REG_FILE.reg_file[15] = 16'b1111111111111111; // $15		

  end

// Initial content of the register file (as per above initialization) is
// 0001 0002 0004 0008 0010 0020 0040 0080
// 0100 0200 0400 0800 1000 2000 fff8 ffff

// Final content of the register file, (if your design is correct) will be (after simulating for 1200ns)
// 0008 0009 000c 0025 000a 000d 0043 0080
// 0102 0043 0043 0044 0044 0041 fff8 ffff
endmodule  
