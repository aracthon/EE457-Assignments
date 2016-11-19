// EE457 RTL Exercises
// min_max_finder_part3_M1_tb.v (improved)(Part 3 method 1 uses one comparison unit like part 2)
// Written by Gandhi Puvvada 
// June 4, 2010, 9/18/2012 
// Earlier to 9/18/2012, we used testbench which did not show difference between M1 and M2 (similarly between M3 and M4). We added 6 tests to show the difference.
// Given an array of 16 unsigned 8-bit numbers, we need to find the maximum and the minimum number
 
 
`timescale 1 ns / 100 ps

module min_max_finder_part3_M1_tb ;

wire [7:0] Max_tb;
wire [7:0] Min_tb;
reg Start_tb, Clk_tb, Reset_tb;
wire  Qi_tb, Ql_tb, Qcmx_tb, Qcmnf_tb, Qcmn_tb, Qcmxf_tb, Qd_tb;

reg [4*8:1] state_string, last_UUT_state_string; // 4 character state string for displaying state in text mode in the waveform

integer  Clk_cnt, file_results; // file_results is a logical name for the physical file output_results_part3_M1.txt here.
reg [3:0] test_number = 0;
reg [127:0] M_tb;
wire [7:0] M_of_I; // a copy of the M[I] in the UUT

localparam CLK_PERIOD = 20;

min_max_finder_part3_M1 UUT (Max_tb, Min_tb, Start_tb, Clk_tb, Reset_tb, 
				 Qi_tb, Ql_tb, Qcmx_tb, Qcmnf_tb, Qcmn_tb, Qcmxf_tb, Qd_tb);
				 
assign M_of_I = {UUT.M[UUT.I]}; // this is for displaying in waveform
				 
always @(*)
	begin
		case ({Qi_tb, Ql_tb, Qcmx_tb, Qcmnf_tb, Qcmn_tb, Qcmxf_tb, Qd_tb})
			7'b1000000: state_string = "INI ";
			7'b0100000: state_string = "LOAD";
			7'b0010000: state_string = "CMx";
			7'b0001000: state_string = "CMnF";
			7'b0000100: state_string = "CMn";
			7'b0000010: state_string = "CMxF";
			7'b0000001: state_string = "DONE";
		   default: state_string = "UNKN";
		endcase
	end

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
    Reset_tb = 1;
    #(2 * CLK_PERIOD) Reset_tb = 0;
  end

initial
  begin  : CLK_COUNTER
    Clk_cnt = 0;
	# (0.6 * CLK_PERIOD); // wait until a little after the positive edge
    forever
       begin
	      #(CLK_PERIOD) Clk_cnt <= Clk_cnt + 1;
       end 
  end

initial
  begin  : STIMULUS
	file_results = $fopen("output_results_part3_M1.txt", "w");
	test_number = 0;
	   M_tb = 128'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00; 
	   memory_initialization (M_tb);
      // these initalizations before reset are not important
	   Start_tb = 0;		// except for avoiding red color
	
	wait (!Reset_tb);    // wait until reset is over
	@(posedge Clk_tb);   // wait for a clock
	$fdisplay (file_results, " ");
    $fdisplay (file_results, "File name: output_results_part3_M1.txt");
	$fdisplay (file_results, " ");
	
// test #1 begin
	// Last character is the largest
    // You should find F5H as the Max and 02H as the Min
	 M_tb = 128'hF5_84_02_02_99_02_85_F4_F4_23_83_90_F4_64_9A_3B;
	 test_number = test_number + 1;
	 run_test (M_tb, test_number);

// test #1 end

// test #2 begin
	// Last character is the smallest. Lots of repeated numbers.
    // You should find B9H as the Max and 01H as the Min
	M_tb = 128'h01_B9_39_53_09_09_73_91_A9_A9_29_31_31_31_56_93; 
	test_number = test_number + 1;
	run_test (M_tb, test_number);
	
// test #2 end

// test #3 begin
	// Every number updates Max or Min
    // You should find DEH as the Max and 1EH as the Min
	M_tb = 128'h1E_DE_1F_DD_20_DC_21_CB_32_BA_43_A9_54_98_76_87; 
	test_number = test_number + 1;
	run_test (M_tb, test_number);

// test #3 end

// test #4 begin
   // The first two numbers update Max and Min and rest of the number are in the middle.
   // You should find FFH as the Max and 00H as the Min
	M_tb = 128'h85_09_39_53_20_68_73_91_62_38_29_59_60_38_00_FF; 
	test_number = test_number + 1;
	run_test (M_tb, test_number);

// test #4 end

// test #5 begin  
   // Array is pre-sorted in ascending order
   // You should find 82H as the Max and 73H as the Min
	M_tb = 128'h82_81_80_7F_7E_7D_7C_7B_7A_79_78_77_76_75_74_73; 
	test_number = test_number + 1;
	run_test (M_tb, test_number);

// test #5 end

// test #6 begin  
   // Array is pre-sorted in descending order
   // You should find 82H as the Max and 73H as the Min
	M_tb = 128'h73_74_75_76_77_78_79_7A_7B_7C_7D_7E_7F_80_81_82; 
	test_number = test_number + 1;
	run_test (M_tb, test_number);

// test #6 end

// test #7 begin  
   // array has two segments of (nearly) pre-sorted sections, first in ascending order and second in descending order
   // You should find 82H as the Max and 75H as the Min
	M_tb = 128'h79_75_76_76_77_78_79_7A_82_81_80_7F_7B_7C_7C_7B; 
	test_number = test_number + 1;
	run_test (M_tb, test_number);

// test #7 end

// test #8 begin  // array has two segments of (nearly) pre-sorted sections, first in descending order and second in ascending order
   // You should find 81H as the Max and 23H as the Min
	M_tb = 128'h23_81_80_7F_7E_7E_7C_7B_73_74_75_76_77_77_79_7A; 
	test_number = test_number + 1;
	run_test (M_tb, test_number);

// test #8 end


// test #9 begin  // array has more or less increasing 
// sequence of numbers with a few small dips, 
// which should be considered as minor dips 
// as in M2/M4 for better performance.
// This test should provide better performance for M2 and M4.
   // You should find A2H as the Max and 02H as the Min
	M_tb = 128'hA0_A2_92_80_82_72_60_62_52_40_42_32_20_22_12_02; 
	test_number = test_number + 1;
	run_test (M_tb, test_number);

// test #9 end

// test #10 begin  // array has more or less decreasing 
// sequence of numbers with a few small ups, 
// which should be considered as minor ups 
// as in M2/M4 for better performance.
// This test should provide better performance for M2 and M4.
   // You should find FEH as the Max and 5EH as the Min
	M_tb = 128'h5F_5E_6E_7F_7E_8E_9F_9E_AE_BF_BE_CE_DF_DE_EE_FE; 
	test_number = test_number + 1;
	run_test (M_tb, test_number);

// test #10 end

// test #11 begin  // array which goes up for a while and then goes 
// down for a while and so on with local minor ups and minor downs
// This test should provide better performance for M2 and M4.
   // You should find D1H as the Max and 21H as the Min
	M_tb = 128'h21_32_31_41_D1_C0_C1_B1_51_62_61_71_A1_90_91_81; 
	test_number = test_number + 1;
	run_test (M_tb, test_number);

// test #11 end

// test #12 begin  // array similar to test 11 above except that 
// the local minor ups and minor downs are removed.
// This test should provide same clocks for both M1 and M2 
// (similarly M3 and M4).
   // You should find F5H as the Max and 11H as the Min
	M_tb = 128'hF5_F1_11_21_31_E1_D1_C1_41_51_61_71_B1_A1_91_81;  
	test_number = test_number + 1;
	run_test (M_tb, test_number);

// test #12 end

// test #13 begin  // array similar to test 11 above except that 
// the local minor up will be followed by major up and 
// local minor down will be followed by major down.
// This test should provide better performance for M1 and M3.
   // You should find A6H as the Max and 46H as the Min
	M_tb = 128'h47_46_51_56_A0_A6_A1_96_62_61_66_71_90_91_86_81;  
	test_number = test_number + 1;
	run_test (M_tb, test_number);

// test #13 end

// test #14 begin  // array similar to test 13 above except that 
// the "up" is exactly equal to the current max and 
// the down is exactly equal to the current min.
// This test should provide equal performance for all 4 methods.
   // You should find A6H as the Max and 46H as the Min
	M_tb = 128'hA6_46_51_56_61_A6_A1_96_91_61_66_71_81_91_86_81;  
	test_number = test_number + 1;
	run_test (M_tb, test_number);

// test #14 end 


    $fdisplay (file_results, "All tests concluded.");
	 $fclose (file_results);
	 $display ("\n All tests concluded. Inspect the text file output_results_part3_M1.txt. \n Current Clock Count = %0d ", Clk_cnt);
	 
	 // $stop;  // break in simulation. Enter interactive simulation mode
	end // STIMULUS
	
/*
task memory_initialization; 
    input [127:0] M_local_tb;
	begin
		  UUT.M[0]  = M_local_tb[7:0]; // notice the "." (DOT) notation for hierarchical 
        UUT.M[1]  = M_local_tb[15:8]; // referencing of signals hidden in UUT
        UUT.M[2]  = M_local_tb[23:16];
        UUT.M[3]  = M_local_tb[31:24];
        UUT.M[4]  = M_local_tb[39:32];
        UUT.M[5]  = M_local_tb[47:40];
        UUT.M[6]  = M_local_tb[55:48];
        UUT.M[7]  = M_local_tb[63:56];
        UUT.M[8]  = M_local_tb[71:64];
        UUT.M[9]  = M_local_tb[79:72];
        UUT.M[10] = M_local_tb[87:80];
        UUT.M[11] = M_local_tb[95:88];
        UUT.M[12] = M_local_tb[103:96];
        UUT.M[13] = M_local_tb[111:104];
        UUT.M[14] = M_local_tb[119:112];
        UUT.M[15] = M_local_tb[127:120]; 
	end
endtask
*/	
/*		
task memory_initialization; 
    input [127:0] M_local_tb;
	integer i;
	begin
		for (i=0; i<=15; i = i +1)
		UUT.M[i]  = {M_local_tb[(i*8)+7],M_local_tb[(i*8)+6],M_local_tb[(i*8)+5],M_local_tb[(i*8)+4],
					 M_local_tb[(i*8)+3],M_local_tb[(i*8)+2],M_local_tb[(i*8)+1],M_local_tb[(i*8)+0]};
	end
endtask
*/
task memory_initialization; 
   input [127:0] M_local_tb;   // we could have avoided passing argument for this task as all parent variables are visible to the task.
	integer i, j;
	begin
		for (i=0; i<=15; i = i +1)
		    begin
				for (j=0; j<=7; j = j +1)
		         UUT.M[i][j]  = M_local_tb[(i*8)+j];
			end 
	end
endtask
		
task run_test;
	input [127:0] M_16x8_tb; // we could have avoided passing argument for this task as all parent variables are visible to the task.
	input [7:0] test_numb;   // we could have avoided passing argument for this task as all parent variables are visible to the task.
	integer Start_clock_count, Clocks_taken;
	begin
		// test begins
		@(posedge Clk_tb);
		#2;
		memory_initialization (M_16x8_tb);
		Start_tb = 1;	// After a little while provide START
		@(posedge Clk_tb); 
		#5;
		Start_tb = 0;	// After a little while remove START
		Start_clock_count = Clk_cnt;
		wait (Qd_tb);
		#5;
		Clocks_taken = Clk_cnt - Start_clock_count;
		if (Qd_tb == 1) 
		   begin
		    $fdisplay (file_results, "Test number  %d: Max: %d decimal = %h hex   and   Min: %d decimal = %h hex.", test_numb, Max_tb, Max_tb, Min_tb, Min_tb);
		    $display ("Test number %d: Max: %d decimal = %h hex   and   Min: %d decimal = %h hex", test_numb, Max_tb, Max_tb, Min_tb, Min_tb);
			$fdisplay (file_results, "    Design entered DONE state from  %s .", last_UUT_state_string);
			$display ("    Design entered DONE state from  %s .", last_UUT_state_string);
		   end
		$fdisplay (file_results, "           Clocks taken for this test = %0d. \n", Clocks_taken);
		$display ("           Clocks taken for this test = %0d. \n", Clocks_taken);
		#4;
		// test ends
	end
endtask

always @(negedge Clk_tb)
	if (UUT.Qd != 1) last_UUT_state_string <= state_string;


endmodule  
