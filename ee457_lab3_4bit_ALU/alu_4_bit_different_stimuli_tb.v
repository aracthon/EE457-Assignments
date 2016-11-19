// EE457 RTL Exercises
// 4-Bit ALU Lab
// alu_4_bit_different_stimuli_tb.v
// Written by Gandhi Puvvada 
// June 19, 2010, 

// There are several choices to fill-in the 8 rows in the table given in the lab manual.
// Students: Fill-in the A and B numbers you arrived at, in the 8 tests, simulate, 
// and confirm that your choices of A and B are right.

`timescale 1 ns / 100 ps

module alu_4_bit_different_stimuli_tb;

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
 integer A_signed_int, B_signed_int, R_signed_int;
 reg signed [3:0] A_signed, B_signed, R_signed;
 reg signed [4:0] A_5bit_signed, B_5bit_signed;
 reg [4:0] unsigned_correct_sum;
 reg signed [4:0] signed_correct_sum, signed_correct_difference;
 reg [58*8:1] comment_string_unsigned, comment_string_signed;
   begin
	   A_tb = A_value;
	   B_tb = B_value;
	   AINV_tb = AINV_value;	   
	   BNEG_tb = BNEG_value;
	   Opr_tb = Opr_value;
	   test_num = test_num + 1;
	   A_signed = A_value; B_signed = B_value;  // Please refer to 
	   A_signed_int = A_signed; B_signed_int = B_signed;
	   case (Opr_value)
			2	: if ((~AINV_value) && BNEG_value) Opr_string_tb = "SUB operation";
				  else if (!(AINV_value || BNEG_value) ) Opr_string_tb = "ADD operation";
				  else Opr_string_tb = "UNK operation"; // unknown operation
			default	: Opr_string_tb = "UNK operation"; // unknown operation for this test
		endcase
		#1 ; // wait for a little while for all delta_T delays to pass before reporting the results
		// output to console
		R_signed = RESULT_tb;
		R_signed_int = R_signed;
		
		A_5bit_signed = A_signed; B_5bit_signed = B_signed; 
		signed_correct_sum = A_5bit_signed + B_5bit_signed;
		signed_correct_difference = A_5bit_signed - B_5bit_signed;
		unsigned_correct_sum = ({1'b0,A_value} + {1'b0,B_value});
		
		if (BNEG_value) // if subtracting
		  begin
			if (A_value < B_value) 
				comment_string_unsigned = 	"  Unsigned difference is negative and is unrepresentable.";
										//	"012345678901234567890123456789012345678901234567890123456789"
			else 
				comment_string_unsigned = 	"  Unsigned difference is positive and is representable.  ";
										//	"012345678901234567890123456789012345678901234567890123456789"
			if 	(signed_correct_difference != R_signed_int)
				comment_string_signed = 	"  Signed difference does not fit in 4 bits.              ";
										//	"012345678901234567890123456789012345678901234567890123456789"
			else 
				comment_string_signed = 	"  Signed difference fits in 4 bits.                      ";
										//	"012345678901234567890123456789012345678901234567890123456789"
			end
		else // if adding
		  begin
			if ( ({1'b0,A_value} + {1'b0,B_value}) > 15) 
				comment_string_unsigned = 	"  Unsigned sum does not fit in 4 bits.                   ";
										//	"012345678901234567890123456789012345678901234567890123456789"
			else 
				comment_string_unsigned = 	"  Unsigned sum fits in 4 bits.                           ";
										//	"012345678901234567890123456789012345678901234567890123456789"
			if 	(signed_correct_sum != R_signed_int)
				comment_string_signed = 	"  Signed sum does not fit in 4 bits.                     ";
										//	"012345678901234567890123456789012345678901234567890123456789"
			else 
				comment_string_signed = 	"  Signed sum fits in 4 bits.                             ";
										//	"012345678901234567890123456789012345678901234567890123456789"
		  end
		
		$display ("Test # = %0d ", test_num);
		$display ("Inputs: \t \t A = %b \t B = %b \t R = %b \t %s", A_tb, B_tb, RESULT_tb, Opr_string_tb);
		$display ("As signed numbers, \t A = %0d \t B = %0d \t R = %0d \t OVERFLOW = %b ", A_signed_int, B_signed_int, R_signed_int, OVERFLOW_tb);
		$display ("%s",comment_string_signed);
		$display ("As unsigned numbers, \t A = %0d \t B = %0d \t R = %0d \t COUT = %b ", A_tb, B_tb, RESULT_tb, COUT_tb);
		$display ("%s",comment_string_unsigned);
		$display (" ");
	    // output to file
		$fdisplay (file_results,"Test # = %0d ", test_num);
		$fdisplay (file_results,"Inputs: \t \t A = %b \t B = %b \t R = %b \t %s", A_tb, B_tb, RESULT_tb, Opr_string_tb);
		$fdisplay (file_results,"As signed numbers, \t A = %0d \t B = %0d \t R = %0d \t OVERFLOW = %b ", A_signed_int, B_signed_int, R_signed_int, OVERFLOW_tb); 
		$fdisplay (file_results,"%s",comment_string_signed);
		$fdisplay (file_results,"As unsigned numbers, \t A = %0d \t B = %0d \t R = %0d \t COUT = %b ", A_tb, B_tb, RESULT_tb, COUT_tb);
		$fdisplay (file_results,"%s",comment_string_unsigned);
		$fdisplay (file_results," ");
		#19;  // wait for a total of 20 ns (1 + 19 = 20ns) before applying next set of stimulai to the combinational logic
	end
 endtask

initial
  begin  : STIMULUS
  file_results = $fopen("alu_add_subtract_overflow_results.txt", "w");
   test_num = 0;
   
		$display ("ALU add/subtract results");
		$display (" ");
		$fdisplay (file_results,"ALU add/subtract results");
		$fdisplay (file_results," ");

// test #1 begin
	TEST_ALU ( 3,  4, 0, 0, 2); // (A,B,AINV,BNEG,Opr)  ADD
// test #1 end

// test #2 begin
	TEST_ALU ( 7,  11, 0, 0, 2); // (A,B,AINV,BNEG,Opr)  ADD
// test #2 end

// test #3 begin
	TEST_ALU ( 4,  5, 0, 0, 2); // (A,B,AINV,BNEG,Opr)  ADD
// test #3 end

// test #4 begin
	TEST_ALU ( 9,  8, 0, 0, 2); // (A,B,AINV,BNEG,Opr)  ADD
// test #4 end

// test #5 begin
	TEST_ALU ( 4,  3, 0, 1, 2); // (A,B,AINV,BNEG,Opr)  SUB
// test #5 end

// test #6 begin
	TEST_ALU ( 4,  5, 0, 1, 2); // (A,B,AINV,BNEG,Opr)  SUB
// test #6 end

// test #7 begin
	TEST_ALU ( -5,  7, 0, 1, 2); // (A,B,AINV,BNEG,Opr)  SUB
// test #7 end

// test #8 begin
	TEST_ALU ( 7,  -2, 0, 1, 2); // (A,B,AINV,BNEG,Opr)  SUB
// test #8 end

		$display ("All tests concluded!");
		$fdisplay (file_results,"All tests concluded!");
		$fclose (file_results);
		
 end // STIMULUS


endmodule  // alu_4_bit_different_stimuli_tb

