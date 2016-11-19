// -------------------------------------------------------------------------------------
//  Module: merge_sort_P4_tb
//  File name:  merge_sort_P4_tb.v (based on copy_array_to_array_imp2_tb.v designed by Ananth Rampura Sheshagiri Rao , Gandhi Puvvada) 
//  Verilog coding by: Pezhman Mamdouh <mamdouh@usc.edu> 
//  Additional tests to cover all states and a StateSequence_P4.txt are added by: Bo Zhang and Kalpana Singla on 2/9/2016 
//  StateSequence_P4 Coding improvement by Gandhi on 2/15/2016
//  Date: 1/7/2016, 1/25/2016, 2/9/2016, 2/15/2016

// -------------------------------------------------------------------------------------

`timescale 1 ns / 10 ps

module merge_sort_P4_tb; // notice empty port list

reg Reset, Clk;
reg Start, Ack;
wire [7:0] As_of_I;
wire [7:0] Bs_of_J; 
wire [7:0] Cs_of_K;
wire [7:0] Ms_of_L;

wire [3:0] I, J, K, L;

reg [7:0] As_of_I_array [3:0] , Bs_of_J_array [3:0], Cs_of_K_array [3:0];
reg [7:0] Ms_of_L_array [11:0];

// The above As_of_I_array, Bs_of_J_array, and Cs_of_K_array are the active array. 
// One of the four arrays below is copied into the above arrays, one at a time.

reg [7:0] As_of_I_array1 [3:0], As_of_I_array2 [3:0], As_of_I_array3 [3:0], As_of_I_array4 [3:0], As_of_I_array5 [3:0];
reg [7:0] Bs_of_J_array1 [3:0], Bs_of_J_array2 [3:0], Bs_of_J_array3 [3:0], Bs_of_J_array4 [3:0], Bs_of_J_array5 [3:0];
reg [7:0] Cs_of_K_array1 [3:0], Cs_of_K_array2 [3:0], Cs_of_K_array3 [3:0], Cs_of_K_array4 [3:0], Cs_of_K_array5 [3:0];

reg [7:0] As_of_I_array6 [3:0], As_of_I_array7 [3:0], As_of_I_array8 [3:0], As_of_I_array9 [3:0], As_of_I_array10 [3:0];
reg [7:0] Bs_of_J_array6 [3:0], Bs_of_J_array7 [3:0], Bs_of_J_array8 [3:0], Bs_of_J_array9 [3:0], Bs_of_J_array10 [3:0];
reg [7:0] Cs_of_K_array6 [3:0], Cs_of_K_array7 [3:0], Cs_of_K_array8 [3:0], Cs_of_K_array9 [3:0], Cs_of_K_array10 [3:0];

reg [7:0] As_of_I_array11 [3:0], As_of_I_array12 [3:0], As_of_I_array13 [3:0], As_of_I_array14 [3:0], As_of_I_array15 [3:0];
reg [7:0] Bs_of_J_array11 [3:0], Bs_of_J_array12 [3:0], Bs_of_J_array13 [3:0], Bs_of_J_array14 [3:0], Bs_of_J_array15 [3:0];
reg [7:0] Cs_of_K_array11 [3:0], Cs_of_K_array12 [3:0], Cs_of_K_array13 [3:0], Cs_of_K_array14 [3:0], Cs_of_K_array15 [3:0];

reg [7:0] As_of_I_array16 [3:0], As_of_I_array17 [3:0], As_of_I_array18 [3:0], As_of_I_array19 [3:0], As_of_I_array20 [3:0];
reg [7:0] Bs_of_J_array16 [3:0], Bs_of_J_array17 [3:0], Bs_of_J_array18 [3:0], Bs_of_J_array19 [3:0], Bs_of_J_array20 [3:0];
reg [7:0] Cs_of_K_array16 [3:0], Cs_of_K_array17 [3:0], Cs_of_K_array18 [3:0], Cs_of_K_array19 [3:0], Cs_of_K_array20 [3:0];

parameter CLK_PERIOD = 10;

localparam
  INI   = 11'b00000000001,
  CAB 	= 11'b00000000010,
  CACS1 = 11'b00000000100,
  CBCS1 = 11'b00000001000,
  CBCS2 = 11'b00000010000,
  CABS2 = 11'b00000100000,
  CACS2 = 11'b00001000000,
  RA	= 11'b00010000000,
  RB	= 11'b00100000000,
  RC	= 11'b01000000000,
  DONE  = 11'b10000000000,
  UNKN  = 11'bXXXXXXXXXXX;
 
reg [6*8:1] state_string = " INI  ";
reg [4:0] testcase_number = 1;

integer  Clk_cnt, Start_clock_count, Clocks_taken;

integer output_file,output_file1; // file designator for output_results_P4.txt file
reg [3:0] KK; // Index into A,B,C, and M arrays for console display and file output
localparam KK_max  = 4'b1011;
reg [32*8:1] msg_string; // a maximum of 32 characters can be stored in this msg_string
 
task display_A_B_C_M_arrays;
  begin
//	$display("\n\t#\tA\tB\tC\tM\n");
	$display("\t #\t  A\t  B\t  C\t  M\n");
	$fdisplay(output_file, "\t #\t  A\t  B\t  C\t  M\n");
	
	for (KK=0; KK<=KK_max; KK=KK+1) // for all the rows in the matrices
		begin // for each row (there are p items in a row)
			msg_string = "\n";
			$sformat(msg_string, "%s\t%d", msg_string, KK); 	// Print the index II_JJ in the msg_string
			if(KK<4)
			begin
				$sformat(msg_string, "%s\t%d", msg_string, As_of_I_array[KK]); 	// gather A[I] in the msg_string in decimal
				$sformat(msg_string, "%s\t%d", msg_string, Bs_of_J_array[KK]);	// gather B[J] in the msg_string in decimal
				$sformat(msg_string, "%s\t%d", msg_string, Cs_of_K_array[KK]);  // gather C[K] in the msg_string in decimal
				$sformat(msg_string, "%s\t%d", msg_string, Ms_of_L_array[KK]);	// gather M[L] in the msg_string in decimal	
			end
			else
			begin
				$sformat(msg_string, "%s\t\t\t\t%d", msg_string, Ms_of_L_array[KK]);		// gather M[L] in the msg_string in decimal	
			end	
			$display("%s", msg_string);
			$fwrite(output_file, "%s\n", msg_string);
		end	
	$display ("\n Test #%d   Clocks_taken = %d . \n", testcase_number, Clocks_taken);
	$fdisplay (output_file, "\n Test #%d   Clocks_taken = %d . \n", testcase_number, Clocks_taken);
  end
endtask 

// Instantiating core RTL block in the testbench

merge_sort_P4 UUT (Reset, Clk, Start, Ack, As_of_I, Bs_of_J, Cs_of_K, Ms_of_L, Ms_of_L_Write, I, J, K, L);

initial 
   begin
	output_file = $fopen ("output_results_P4.txt", "w"); // create the file "output_results_P4.txt" and open it for writing
   end
   
initial 
   begin 
      Reset <= 1;
      Start <= 0;
      Ack   <= 0;
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
      Reset <= ~Reset; // going out of Reset  
	  
	  $display("\n MERGE SORT P4\n");
	  $fdisplay(output_file, "\n MERGE SORT P4\n");	  
	  
	  // Test #1: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #1: \n");
	  $fdisplay(output_file, "\n Test #1: \n");
	  simulate_with_given_array (
					{As_of_I_array1[3],
					 Bs_of_J_array1[3],
					 Cs_of_K_array1[3],
					 As_of_I_array1[2],
					 Bs_of_J_array1[2],
					 Cs_of_K_array1[2],
					 As_of_I_array1[1],
					 Bs_of_J_array1[1],
					 Cs_of_K_array1[1],
					 As_of_I_array1[0],
					 Bs_of_J_array1[0],
					 Cs_of_K_array1[0]}
					);

	// Test #2: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #2: \n");
	  $fdisplay(output_file, "\n Test #2: \n");
	  simulate_with_given_array (
					{As_of_I_array2[3],
					 Bs_of_J_array2[3],
					 Cs_of_K_array2[3],
					 As_of_I_array2[2],
					 Bs_of_J_array2[2],
					 Cs_of_K_array2[2],
					 As_of_I_array2[1],
					 Bs_of_J_array2[1],
					 Cs_of_K_array2[1],
					 As_of_I_array2[0],
					 Bs_of_J_array2[0],
					 Cs_of_K_array2[0]}
					);
	  
	// Test #3: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #3: \n");
	  $fdisplay(output_file, "\n Test #3: \n");
	  simulate_with_given_array (
					{As_of_I_array3[3],
					 Bs_of_J_array3[3],
					 Cs_of_K_array3[3],
					 As_of_I_array3[2],
					 Bs_of_J_array3[2],
					 Cs_of_K_array3[2],
					 As_of_I_array3[1],
					 Bs_of_J_array3[1],
					 Cs_of_K_array3[1],
					 As_of_I_array3[0],
					 Bs_of_J_array3[0],
					 Cs_of_K_array3[0]}
					);
	  
	// Test #4: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #4: \n");
	  $fdisplay(output_file, "\n Test #4: \n");
	  simulate_with_given_array (
					{As_of_I_array4[3],
					 Bs_of_J_array4[3],
					 Cs_of_K_array4[3],
					 As_of_I_array4[2],
					 Bs_of_J_array4[2],
					 Cs_of_K_array4[2],
					 As_of_I_array4[1],
					 Bs_of_J_array4[1],
					 Cs_of_K_array4[1],
					 As_of_I_array4[0],
					 Bs_of_J_array4[0],
					 Cs_of_K_array4[0]}
					);
	  
	// Test #5: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #5: \n");
	  $fdisplay(output_file, "\n Test #5: \n");
	  simulate_with_given_array (
					{As_of_I_array5[3],
					 Bs_of_J_array5[3],
					 Cs_of_K_array5[3],
					 As_of_I_array5[2],
					 Bs_of_J_array5[2],
					 Cs_of_K_array5[2],
					 As_of_I_array5[1],
					 Bs_of_J_array5[1],
					 Cs_of_K_array5[1],
					 As_of_I_array5[0],
					 Bs_of_J_array5[0],
					 Cs_of_K_array5[0]}
					);
	
	// Test #6: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #6: \n");
	  $fdisplay(output_file, "\n Test #6: \n");
	  simulate_with_given_array (
					{As_of_I_array6[3],
					 Bs_of_J_array6[3],
					 Cs_of_K_array6[3],
					 As_of_I_array6[2],
					 Bs_of_J_array6[2],
					 Cs_of_K_array6[2],
					 As_of_I_array6[1],
					 Bs_of_J_array6[1],
					 Cs_of_K_array6[1],
					 As_of_I_array6[0],
					 Bs_of_J_array6[0],
					 Cs_of_K_array6[0]}
					);
				
	// Test #7: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #7: \n");
	  $fdisplay(output_file, "\n Test #7: \n");
	  simulate_with_given_array (
					{As_of_I_array7[3],
					 Bs_of_J_array7[3],
					 Cs_of_K_array7[3],
					 As_of_I_array7[2],
					 Bs_of_J_array7[2],
					 Cs_of_K_array7[2],
					 As_of_I_array7[1],
					 Bs_of_J_array7[1],
					 Cs_of_K_array7[1],
					 As_of_I_array7[0],
					 Bs_of_J_array7[0],
					 Cs_of_K_array7[0]}
					);
					
	// Test #8: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #8: \n");
	  $fdisplay(output_file, "\n Test #8: \n");
	  simulate_with_given_array (
					{As_of_I_array8[3],
					 Bs_of_J_array8[3],
					 Cs_of_K_array8[3],
					 As_of_I_array8[2],
					 Bs_of_J_array8[2],
					 Cs_of_K_array8[2],
					 As_of_I_array8[1],
					 Bs_of_J_array8[1],
					 Cs_of_K_array8[1],
					 As_of_I_array8[0],
					 Bs_of_J_array8[0],
					 Cs_of_K_array8[0]}
					);
	
	// Test #9: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #9: \n");
	  $fdisplay(output_file, "\n Test #9: \n");
	  simulate_with_given_array (
					{As_of_I_array9[3],
					 Bs_of_J_array9[3],
					 Cs_of_K_array9[3],
					 As_of_I_array9[2],
					 Bs_of_J_array9[2],
					 Cs_of_K_array9[2],
					 As_of_I_array9[1],
					 Bs_of_J_array9[1],
					 Cs_of_K_array9[1],
					 As_of_I_array9[0],
					 Bs_of_J_array9[0],
					 Cs_of_K_array9[0]}
					);
	
	// Test #10: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #10: \n");
	  $fdisplay(output_file, "\n Test #10: \n");
	  simulate_with_given_array (
					{As_of_I_array10[3],
					 Bs_of_J_array10[3],
					 Cs_of_K_array10[3],
					 As_of_I_array10[2],
					 Bs_of_J_array10[2],
					 Cs_of_K_array10[2],
					 As_of_I_array10[1],
					 Bs_of_J_array10[1],
					 Cs_of_K_array10[1],
					 As_of_I_array10[0],
					 Bs_of_J_array10[0],
					 Cs_of_K_array10[0]}
					);
	
	// Test #11: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #11: \n");
	  $fdisplay(output_file, "\n Test #11: \n");
	  simulate_with_given_array (
					{As_of_I_array11[3],
					 Bs_of_J_array11[3],
					 Cs_of_K_array11[3],
					 As_of_I_array11[2],
					 Bs_of_J_array11[2],
					 Cs_of_K_array11[2],
					 As_of_I_array11[1],
					 Bs_of_J_array11[1],
					 Cs_of_K_array11[1],
					 As_of_I_array11[0],
					 Bs_of_J_array11[0],
					 Cs_of_K_array11[0]}
					);
	
	// Test #12: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #12: \n");
	  $fdisplay(output_file, "\n Test #12: \n");
	  simulate_with_given_array (
					{As_of_I_array12[3],
					 Bs_of_J_array12[3],
					 Cs_of_K_array12[3],
					 As_of_I_array12[2],
					 Bs_of_J_array12[2],
					 Cs_of_K_array12[2],
					 As_of_I_array12[1],
					 Bs_of_J_array12[1],
					 Cs_of_K_array12[1],
					 As_of_I_array12[0],
					 Bs_of_J_array12[0],
					 Cs_of_K_array12[0]}
					);
	
	// Test #13: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #13: \n");
	  $fdisplay(output_file, "\n Test #13: \n");
	  simulate_with_given_array (
					{As_of_I_array13[3],
					 Bs_of_J_array13[3],
					 Cs_of_K_array13[3],
					 As_of_I_array13[2],
					 Bs_of_J_array13[2],
					 Cs_of_K_array13[2],
					 As_of_I_array13[1],
					 Bs_of_J_array13[1],
					 Cs_of_K_array13[1],
					 As_of_I_array13[0],
					 Bs_of_J_array13[0],
					 Cs_of_K_array13[0]}
					);
	
	// Test #14: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #14: \n");
	  $fdisplay(output_file, "\n Test #14: \n");
	  simulate_with_given_array (
					{As_of_I_array14[3],
					 Bs_of_J_array14[3],
					 Cs_of_K_array14[3],
					 As_of_I_array14[2],
					 Bs_of_J_array14[2],
					 Cs_of_K_array14[2],
					 As_of_I_array14[1],
					 Bs_of_J_array14[1],
					 Cs_of_K_array14[1],
					 As_of_I_array14[0],
					 Bs_of_J_array14[0],
					 Cs_of_K_array14[0]}
					);
	// Test #15: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #15: \n");
	  $fdisplay(output_file, "\n Test #15: \n");
	  simulate_with_given_array (
					{As_of_I_array15[3],
					 Bs_of_J_array15[3],
					 Cs_of_K_array15[3],
					 As_of_I_array15[2],
					 Bs_of_J_array15[2],
					 Cs_of_K_array15[2],
					 As_of_I_array15[1],
					 Bs_of_J_array15[1],
					 Cs_of_K_array15[1],
					 As_of_I_array15[0],
					 Bs_of_J_array15[0],
					 Cs_of_K_array15[0]}
					);
	
	// Test #16: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #16: \n");
	  $fdisplay(output_file, "\n Test #16: \n");
	  simulate_with_given_array (
					{As_of_I_array16[3],
					 Bs_of_J_array16[3],
					 Cs_of_K_array16[3],
					 As_of_I_array16[2],
					 Bs_of_J_array16[2],
					 Cs_of_K_array16[2],
					 As_of_I_array16[1],
					 Bs_of_J_array16[1],
					 Cs_of_K_array16[1],
					 As_of_I_array16[0],
					 Bs_of_J_array16[0],
					 Cs_of_K_array16[0]}
					);
					
	// Test #17: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #17: \n");
	  $fdisplay(output_file, "\n Test #17: \n");
	  simulate_with_given_array (
					{As_of_I_array17[3],
					 Bs_of_J_array17[3],
					 Cs_of_K_array17[3],
					 As_of_I_array17[2],
					 Bs_of_J_array17[2],
					 Cs_of_K_array17[2],
					 As_of_I_array17[1],
					 Bs_of_J_array17[1],
					 Cs_of_K_array17[1],
					 As_of_I_array17[0],
					 Bs_of_J_array17[0],
					 Cs_of_K_array17[0]}
					);
	
	// Test #18: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #18: \n");
	  $fdisplay(output_file, "\n Test #18: \n");
	  simulate_with_given_array (
					{As_of_I_array18[3],
					 Bs_of_J_array18[3],
					 Cs_of_K_array18[3],
					 As_of_I_array18[2],
					 Bs_of_J_array18[2],
					 Cs_of_K_array18[2],
					 As_of_I_array18[1],
					 Bs_of_J_array18[1],
					 Cs_of_K_array18[1],
					 As_of_I_array18[0],
					 Bs_of_J_array18[0],
					 Cs_of_K_array18[0]}
					);
					
	// Test #19: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #19: \n");
	  $fdisplay(output_file, "\n Test #19: \n");
	  simulate_with_given_array (
					{As_of_I_array19[3],
					 Bs_of_J_array19[3],
					 Cs_of_K_array19[3],
					 As_of_I_array19[2],
					 Bs_of_J_array19[2],
					 Cs_of_K_array19[2],
					 As_of_I_array19[1],
					 Bs_of_J_array19[1],
					 Cs_of_K_array19[1],
					 As_of_I_array19[0],
					 Bs_of_J_array19[0],
					 Cs_of_K_array19[0]}
					);
	
	// Test #20: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #20: \n");
	  $fdisplay(output_file, "\n Test #20: \n");
	  simulate_with_given_array (
					{As_of_I_array20[3],
					 Bs_of_J_array20[3],
					 Cs_of_K_array20[3],
					 As_of_I_array20[2],
					 Bs_of_J_array20[2],
					 Cs_of_K_array20[2],
					 As_of_I_array20[1],
					 Bs_of_J_array20[1],
					 Cs_of_K_array20[1],
					 As_of_I_array20[0],
					 Bs_of_J_array20[0],
					 Cs_of_K_array20[0]}
					);
	
					
	$display("\n All tests completed. \n");
	$fdisplay(output_file, "\n All tests completed. \n");
	$fclose(output_file);	
	$fclose(output_file1);
	end
	
task simulate_with_given_array;
 input [95:0] passed_on_array_bits;
 begin
 
	As_of_I_array [0] = passed_on_array_bits [23:16];
	Bs_of_J_array [0] = passed_on_array_bits [15: 8];
	Cs_of_K_array [0] = passed_on_array_bits [ 7: 0];
	
	As_of_I_array [1] = passed_on_array_bits [47:40];
	Bs_of_J_array [1] = passed_on_array_bits [39:32];
	Cs_of_K_array [1] = passed_on_array_bits [31:24];
	
	As_of_I_array [2] = passed_on_array_bits [71:64];
	Bs_of_J_array [2] = passed_on_array_bits [63:56];
	Cs_of_K_array [2] = passed_on_array_bits [55:48];
	
	As_of_I_array [3] = passed_on_array_bits [95:88];
	Bs_of_J_array [3] = passed_on_array_bits [87:80];
	Cs_of_K_array [3] = passed_on_array_bits [79:72];

	  Start <= 0;
      Ack   <= 0;
	  
	  output_file1 = $fopen("StateSequence_P4.txt");
	  $fwrite(output_file1, "Test Case %2d\n", testcase_number);
	  $fwrite(output_file1,"========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|\n");
	  $fwrite(output_file1," START  |    1   |    2   |    3   |    4   |    5   |    6   |    7   |    8   |    9   |   10   |   11   |   12   |   13   |   14   |   15   |   16   |   17   |   18   |   19   |   END  |\n");
	  $fwrite(output_file1,"========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|\n");
	  
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
      Start <= 1;
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
      Start <= 0;	
	  Start_clock_count = Clk_cnt;
	  $fwrite(output_file1, "  INI   |");
	  // wait until the UUT reaches DONE state and then send Ack
	  while(!UUT.state[10])
		begin
			@(posedge Clk);
			$fwrite(output_file1, " %s |", state_string); 			
			#(CLK_PERIOD/10); // this makes us check a little after the posedge of the clock so that we get to know the DONE state at the beginning of the clock when DONE is entered
			// Note: There is a delta-T delay caused in passing the DONE state signal from UUT.state[10] to testbench. 
			// Without the above delay, we would do one extra iteration of the while loop and we were reporting, one extra clock in the clocks taken. 
		end
	  //@(posedge UUT.state[10]);  // DONE  state is given the one-hot code 11'b10000000000 
	  // The above line was used in the place of the while loop before we created the Timse
	  #(CLK_PERIOD/5); 
	  Clocks_taken = Clk_cnt - Start_clock_count;
	  $fwrite(output_file1, " %s |", state_string); // To write out the DONE state in the output_file1("StateSequence_P4.txt")
	  $fwrite(output_file1, "\n");
	  $fwrite(output_file1,"========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|========|\n");
	  $fwrite(output_file1, "Clocks taken %2d\n\n",Clocks_taken);

	  display_A_B_C_M_arrays; // call the task to display the contents
	  Ack <= 1;
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  Ack <= 0;
	  testcase_number = testcase_number + 1;
	  Clocks_taken = 32'bX;
   end
endtask

initial 
   begin
    // Initializing arrays with some test values
      
	  // 1  
		As_of_I_array1 [0] = 0;
		Bs_of_J_array1 [0] = 	8;
		Cs_of_K_array1 [0] = 		4;
		
		As_of_I_array1 [1] = 1;
		Bs_of_J_array1 [1] = 	9;
		Cs_of_K_array1 [1] = 		5;
		
		As_of_I_array1 [2] = 2;
		Bs_of_J_array1 [2] = 	10;
		Cs_of_K_array1 [2] = 		6;
		
		As_of_I_array1 [3] = 13;
		Bs_of_J_array1 [3] = 	11;
		Cs_of_K_array1 [3] = 		12;
	  
	  // 2
		As_of_I_array2 [0] = 8;
		Bs_of_J_array2 [0] = 	3;
		Cs_of_K_array2 [0] = 		0;
		
		As_of_I_array2 [1] = 9;
		Bs_of_J_array2 [1] = 	4;
		Cs_of_K_array2 [1] = 		1;
		
		As_of_I_array2 [2] = 10;
		Bs_of_J_array2 [2] = 	5;
		Cs_of_K_array2 [2] = 		2;
		
		As_of_I_array2 [3] = 11;
		Bs_of_J_array2 [3] = 	7;
		Cs_of_K_array2 [3] = 		6;

	  // 3
		As_of_I_array3 [0] = 0;
		Bs_of_J_array3 [0] = 	8;
		Cs_of_K_array3 [0] = 		4;
		
		As_of_I_array3 [1] = 1;
		Bs_of_J_array3 [1] = 	9;
		Cs_of_K_array3 [1] = 		5;
		
		As_of_I_array3 [2] = 2;
		Bs_of_J_array3 [2] = 	10;
		Cs_of_K_array3 [2] = 		6;
		
		As_of_I_array3 [3] = 3;
		Bs_of_J_array3 [3] = 	11;
		Cs_of_K_array3 [3] = 		7;

	  // 4
		As_of_I_array4 [0] = 1;
		Bs_of_J_array4 [0] = 	2;
		Cs_of_K_array4 [0] = 		3;
		
		As_of_I_array4 [1] = 4;
		Bs_of_J_array4 [1] = 	5;
		Cs_of_K_array4 [1] = 		6;
		
		As_of_I_array4 [2] = 7;
		Bs_of_J_array4 [2] = 	8;
		Cs_of_K_array4 [2] = 		9;
		
		As_of_I_array4 [3] = 10;
		Bs_of_J_array4 [3] = 	11;
		Cs_of_K_array4 [3] = 		12;

	  // 5  -- All 12 data are identical
		As_of_I_array5 [0] = 99;
		Bs_of_J_array5 [0] = 	99;
		Cs_of_K_array5 [0] = 		99;
		
		As_of_I_array5 [1] = 99;
		Bs_of_J_array5 [1] = 	99;
		Cs_of_K_array5 [1] = 		99;
		
		As_of_I_array5 [2] = 99;
		Bs_of_J_array5 [2] = 	99;
		Cs_of_K_array5 [2] = 		99;
		
		As_of_I_array5 [3] = 99;
		Bs_of_J_array5 [3] = 	99;
		Cs_of_K_array5 [3] = 		99;
	
	// 6
		As_of_I_array6 [0] = 0;
		Bs_of_J_array6 [0] = 	1;
		Cs_of_K_array6 [0] = 		0;
		
		As_of_I_array6 [1] = 2;
		Bs_of_J_array6 [1] = 	1;
		Cs_of_K_array6 [1] = 		2;
		
		As_of_I_array6 [2] = 3;
		Bs_of_J_array6 [2] = 	1;
		Cs_of_K_array6 [2] = 		3;
		
		As_of_I_array6 [3] = 4;
		Bs_of_J_array6 [3] = 	3;
		Cs_of_K_array6 [3] = 		4;
		
	// 7
		As_of_I_array7 [0] = 1;
		Bs_of_J_array7 [0] = 	2;
		Cs_of_K_array7 [0] = 		0;
		
		As_of_I_array7 [1] = 2;
		Bs_of_J_array7 [1] = 	3;
		Cs_of_K_array7 [1] = 		0;
		
		As_of_I_array7 [2] = 3;
		Bs_of_J_array7 [2] = 	4;
		Cs_of_K_array7 [2] = 		0;
		
		As_of_I_array7 [3] = 4;
		Bs_of_J_array7 [3] = 	5;
		Cs_of_K_array7 [3] = 		2;
		
	// 8
		As_of_I_array8 [0] = 0;
		Bs_of_J_array8 [0] = 	2;
		Cs_of_K_array8 [0] = 		1;
		
		As_of_I_array8 [1] = 0;
		Bs_of_J_array8 [1] = 	4;
		Cs_of_K_array8 [1] = 		3;
		
		As_of_I_array8 [2] = 0;
		Bs_of_J_array8 [2] = 	5;
		Cs_of_K_array8 [2] = 		3;
		
		As_of_I_array8 [3] = 1;
		Bs_of_J_array8 [3] = 	5;
		Cs_of_K_array8 [3] = 		5;
	
    // 9
		As_of_I_array9 [0] = 0;
		Bs_of_J_array9 [0] = 	1;
		Cs_of_K_array9 [0] = 		2;
		
		As_of_I_array9 [1] = 0;
		Bs_of_J_array9 [1] = 	1;
		Cs_of_K_array9 [1] = 		4;
		
		As_of_I_array9 [2] = 0;
		Bs_of_J_array9 [2] = 	1;
		Cs_of_K_array9 [2] = 		5;
		
		As_of_I_array9 [3] = 0;
		Bs_of_J_array9 [3] = 	3;
		Cs_of_K_array9 [3] = 		6;	
		
	// 10
		As_of_I_array10 [0] = 1;
		Bs_of_J_array10 [0] = 	2;
		Cs_of_K_array10 [0] = 		0;
		
		As_of_I_array10 [1] = 1;
		Bs_of_J_array10 [1] = 	2;
		Cs_of_K_array10 [1] = 		0;
		
		As_of_I_array10 [2] = 1;
		Bs_of_J_array10 [2] = 	2;
		Cs_of_K_array10 [2] = 		0;
		
		As_of_I_array10 [3] = 3;
		Bs_of_J_array10 [3] = 	3;
		Cs_of_K_array10 [3] = 		4;
		
	// 11
		As_of_I_array11 [0] = 1;
		Bs_of_J_array11 [0] = 	4;
		Cs_of_K_array11 [0] = 		0;
		
		As_of_I_array11 [1] = 1;
		Bs_of_J_array11 [1] = 	5;
		Cs_of_K_array11 [1] = 		0;
		
		As_of_I_array11 [2] = 1;
		Bs_of_J_array11 [2] = 	6;
		Cs_of_K_array11 [2] = 		0;
		
		As_of_I_array11 [3] = 3;
		Bs_of_J_array11 [3] = 	7;
		Cs_of_K_array11 [3] = 		2;
	
	// 12
		As_of_I_array12 [0] = 1;
		Bs_of_J_array12 [0] = 	0;
		Cs_of_K_array12 [0] = 		1;
		
		As_of_I_array12 [1] = 2;
		Bs_of_J_array12 [1] = 	2;
		Cs_of_K_array12 [1] = 		2;
		
		As_of_I_array12 [2] = 3;
		Bs_of_J_array12 [2] = 	3;
		Cs_of_K_array12 [2] = 		3;
		
		As_of_I_array12 [3] = 4;
		Bs_of_J_array12 [3] = 	5;
		Cs_of_K_array12 [3] = 		4;
	
	// 13
		As_of_I_array13 [0] = 1;
		Bs_of_J_array13 [0] = 	3;
		Cs_of_K_array13 [0] = 		0;
		
		As_of_I_array13 [1] = 1;
		Bs_of_J_array13 [1] = 	4;
		Cs_of_K_array13 [1] = 		0;
		
		As_of_I_array13 [2] = 1;
		Bs_of_J_array13 [2] = 	5;
		Cs_of_K_array13 [2] = 		0;
		
		As_of_I_array13 [3] = 3;
		Bs_of_J_array13 [3] = 	6;
		Cs_of_K_array13 [3] = 		2;
		
	// 14
		As_of_I_array14 [0] = 1;
		Bs_of_J_array14 [0] = 	2;
		Cs_of_K_array14 [0] = 		0;
		
		As_of_I_array14 [1] = 3;
		Bs_of_J_array14 [1] = 	2;
		Cs_of_K_array14 [1] = 		0;
		
		As_of_I_array14 [2] = 3;
		Bs_of_J_array14 [2] = 	2;
		Cs_of_K_array14 [2] = 		0;
		
		As_of_I_array14 [3] = 4;
		Bs_of_J_array14 [3] = 	4;
		Cs_of_K_array14 [3] = 		0;
		
	// 15
		As_of_I_array15 [0] = 2;
		Bs_of_J_array15 [0] = 	1;
		Cs_of_K_array15 [0] = 		0;
		
		As_of_I_array15 [1] = 2;
		Bs_of_J_array15 [1] = 	1;
		Cs_of_K_array15 [1] = 		0;
		
		As_of_I_array15 [2] = 2;
		Bs_of_J_array15 [2] = 	1;
		Cs_of_K_array15 [2] = 		0;
		
		As_of_I_array15 [3] = 2;
		Bs_of_J_array15 [3] = 	3;
		Cs_of_K_array15 [3] = 		0;
		
	// 16
		As_of_I_array16 [0] = 2;
		Bs_of_J_array16 [0] = 	1;
		Cs_of_K_array16 [0] = 		0;
		
		As_of_I_array16 [1] = 2;
		Bs_of_J_array16 [1] = 	1;
		Cs_of_K_array16 [1] = 		0;
		
		As_of_I_array16 [2] = 2;
		Bs_of_J_array16 [2] = 	1;
		Cs_of_K_array16 [2] = 		0;
		
		As_of_I_array16 [3] = 4;
		Bs_of_J_array16 [3] = 	3;
		Cs_of_K_array16 [3] = 		0;
	
	// 17
		As_of_I_array17 [0] = 2;
		Bs_of_J_array17 [0] = 	0;
		Cs_of_K_array17 [0] = 		1;
	
		As_of_I_array17 [1] = 3;
		Bs_of_J_array17 [1] = 	0;
		Cs_of_K_array17 [1] = 		3;
		
		As_of_I_array17 [2] = 3;
		Bs_of_J_array17 [2] = 	0;
		Cs_of_K_array17 [2] = 		4;
		
		As_of_I_array17 [3] = 4;
		Bs_of_J_array17 [3] = 	0;
		Cs_of_K_array17 [3] = 		5;
		
	// 18
		As_of_I_array18 [0] = 2;
		Bs_of_J_array18 [0] = 	0;
		Cs_of_K_array18 [0] = 		1;
	
		As_of_I_array18 [1] = 4;
		Bs_of_J_array18 [1] = 	0;
		Cs_of_K_array18 [1] = 		1;
		
		As_of_I_array18 [2] = 5;
		Bs_of_J_array18 [2] = 	0;
		Cs_of_K_array18 [2] = 		1;
		
		As_of_I_array18 [3] = 6;
		Bs_of_J_array18 [3] = 	0;
		Cs_of_K_array18 [3] = 		4;
	
	// 19
		As_of_I_array19 [0] = 1;
		Bs_of_J_array19 [0] = 	0;
		Cs_of_K_array19 [0] = 		2;
		
		As_of_I_array19 [1] = 1;
		Bs_of_J_array19 [1] = 	0;
		Cs_of_K_array19 [1] = 		3;
	
		As_of_I_array19 [2] = 1;
		Bs_of_J_array19 [2] = 	0;
		Cs_of_K_array19 [2] = 		4;
		
		As_of_I_array19 [3] = 1;
		Bs_of_J_array19 [3] = 	0;
		Cs_of_K_array19 [3] = 		5;
		
	// 20
		As_of_I_array20 [0] = 1;
		Bs_of_J_array20 [0] = 	0;
		Cs_of_K_array20 [0] = 		2;
		
		As_of_I_array20 [1] = 1;
		Bs_of_J_array20 [1] = 	0;
		Cs_of_K_array20 [1] = 		2;
		
		As_of_I_array20 [2] = 1;
		Bs_of_J_array20 [2] = 	0;
		Cs_of_K_array20 [2] = 		2;
		
		As_of_I_array20 [3] = 3;
		Bs_of_J_array20 [3] = 	0;
		Cs_of_K_array20 [3] = 		4;
	
   end

// generating Clk of 10 ns period
	initial begin: clock_generator
		Clk = 0;
		forever begin
			#(CLK_PERIOD/2) Clk = ~Clk; 
		end
	end


initial
  begin  : CLK_COUNTER
	Clk_cnt = 0;
	#(CLK_PERIOD * 0.6); // wait until a little after the positive edge
	forever
	  begin
		#(CLK_PERIOD) Clk_cnt <= Clk_cnt + 1;
	  end 
  end
  
assign #1 As_of_I = As_of_I_array[I];
assign #1 Bs_of_J = Bs_of_J_array[J];
assign #1 Cs_of_K = Cs_of_K_array[K];

// Capturing data from RTL into memory
always @ (posedge Clk) 
        begin
		if (Ms_of_L_Write == 1)
		begin
           Ms_of_L_array[L] <= Ms_of_L;
		end
		end 

always @(*)
	case (UUT.state) // UUT.state works here only in presynthesis simulation  
			INI		:		state_string = " INI  ";
			CAB  	:		state_string = " CAB  ";
			CACS1  	:		state_string = " CACS1";
			CBCS1	:		state_string = " CBCS1";
			CBCS2  	:		state_string = " CBCS2";
			CACS2  	:		state_string = " CACS2";
			CABS2  	:		state_string = " CABS2";
			RA		:		state_string = "  RA  ";
			RB  	:		state_string = "  RB  ";
			RC  	:		state_string = "  RC  ";
			DONE  	:		state_string = " DONE ";
			default : 		state_string = " unkn ";
	endcase
endmodule