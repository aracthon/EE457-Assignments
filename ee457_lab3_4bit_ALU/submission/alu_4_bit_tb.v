// EE457 RTL Exercises
// 4-Bit ALU Lab
// 4-Bit_alu_lab_3_tb.v
// Written by Nasir Mohyuddin, Gandhi Puvvada 
// June 17, 2010, 

 
`timescale 1 ns / 100 ps

module alu_4_bit_tb;

reg [3:0] A_tb, B_tb;
reg  AINV_tb, BNEG_tb;
reg  [1:0] Opr_tb;
wire [3:0] RESULT_tb;
wire OVERFLOW_tb, ZERO_tb, COUT_tb;

integer test_num;
integer file_results; // file_results is a logical name for the physical file alu_output_results.txt here.

// module alu_4_bit (A, B, AINV, BNEG, Opr, RESULT, OVERFLOW, ZERO, COUT);
alu_4_bit alu_4 (A_tb, B_tb, AINV_tb, BNEG_tb, Opr_tb,  // CIN_tb, LESS_tb,
                 RESULT_tb, OVERFLOW_tb, ZERO_tb, COUT_tb);
                 
task TEST_ALU;
 input [3:0] A_value, B_value;
 input AINV_value, BNEG_value;
 input [1:0] Opr_value;
 reg [16*8:1] Opr_string_tb;
   begin
	   A_tb = A_value;
	   B_tb = B_value;
	   AINV_tb = AINV_value;	   
	   BNEG_tb = BNEG_value;
	   Opr_tb = Opr_value;
	   test_num = test_num + 1;
	   case (Opr_value)
	        0	: if (AINV_value && BNEG_value) Opr_string_tb = "NOR operation";
				  else if (!(AINV_value || BNEG_value) ) Opr_string_tb = "AND operation";
				  else Opr_string_tb = "UNK operation"; // unknown operation
			1	: if (AINV_value && BNEG_value) Opr_string_tb = "NAND operation";
				  else if (!(AINV_value || BNEG_value) ) Opr_string_tb = " OR operation";
				  else Opr_string_tb = "UNK operation"; // unknown operation
			2	: if ((~AINV_value) && BNEG_value) Opr_string_tb = "SUB operation";
				  else if (!(AINV_value || BNEG_value) ) Opr_string_tb = "ADD operation";
				  else Opr_string_tb = "UNK operation"; // unknown operation
			3	: if ((~AINV_value) && BNEG_value) Opr_string_tb = "SLT operation";
				  else Opr_string_tb = "UNK operation"; // unknown operation
		endcase
		#1 ; // wait for a little while for all delta_T delays to pass before reporting the results
		// output to console
		$display ("Test # = %0d ", test_num);
		$display ("Inputs:   A = %b and  B = %b AINV = %b BNEG = %b", A_tb, B_tb, AINV_tb, BNEG_tb);
		$display ("Opr = %h  %s  RESULT = %b  ", Opr_tb, Opr_string_tb, RESULT_tb);
		$display ("                COUT = %b  OVERFLOW = %b ZERO = %b ", COUT_tb, OVERFLOW_tb, ZERO_tb); 
		$display (" ");
	    // output to file
		$fdisplay (file_results,"Test # = %0d ", test_num);
		$fdisplay (file_results,"Inputs:   A = %b and  B = %b AINV = %b BNEG = %b", A_tb, B_tb, AINV_tb, BNEG_tb);
		$fdisplay (file_results,"Opr = %h  %s  RESULT = %b  ", Opr_tb, Opr_string_tb, RESULT_tb);
		$fdisplay (file_results,"                COUT = %b  OVERFLOW = %b ZERO = %b ", COUT_tb, OVERFLOW_tb, ZERO_tb); 
		$fdisplay (file_results," ");
		#19;  // wait for a total of 20 ns (1 + 19 = 20ns) before applying next set of stimulai to the combinational logic
	end
 endtask

initial
  begin  : STIMULUS
  file_results = $fopen("alu_output_results.txt", "w");
   test_num = 0;
// test #1 begin
	TEST_ALU (11, 7, 0, 0, 0); // (A,B,AINV,BNEG,Opr)  AND
// test #1 end

// test #2 begin
	TEST_ALU (11, 7, 0, 0, 1); // (A,B,AINV,BNEG,Opr)  OR
// test #2 end

// test #3 begin
	TEST_ALU (11, 7, 0, 0, 2); // (A,B,AINV,BNEG,Opr)  ADD
// test #3 end

// test #4 begin
	TEST_ALU (11, 7, 0, 1, 2); // (A,B,AINV,BNEG,Opr)  SUB
// test #4 end

// test #5 begin
	TEST_ALU (11, 7, 0, 1, 3); // (A,B,AINV,BNEG,Opr)  SLT
// test #5 end

// test #6 begin
	TEST_ALU (4, 7, 0, 1, 3); // (A,B,AINV,BNEG,Opr)  SLT
// test #6 end

// test #7 begin
	TEST_ALU (7, 4, 0, 1, 3); // (A,B,AINV,BNEG,Opr)  SLT
// test #7 end

// test #8 begin
	TEST_ALU (11, 12, 0, 1, 3); // (A,B,AINV,BNEG,Opr)  SLT
// test #8 end

// test #9 begin
	TEST_ALU (11, 10, 0, 1, 3); // (A,B,AINV,BNEG,Opr)  SLT
// test #9 end

// test #10 begin
	TEST_ALU (11, 7, 1, 1, 0); // (A,B,AINV,BNEG,Opr)  NOR
// test #10 end


		$display ("All tests concluded!");
		$fdisplay (file_results,"All tests concluded!");
		$fclose (file_results);
		
 end // STIMULUS


endmodule  // alu_4_bit_tb

