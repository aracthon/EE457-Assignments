// EE457 RTL Exercises
// min_max_finder_part2_tb.v
// Written by Nasir Mohyuddin, Gandhi Puvvada 
// June 3, 2010, 
// Given an array of 16 unsigned 8-bit numbers, we need to find the maximum and the minimum number
 
 
`timescale 1 ns / 100 ps

module min_max_finder_part2_tb ;

wire [7:0] Max_tb;
wire [7:0] Min_tb;
reg Start_tb, Clk_tb, Reset_tb;
wire  Qi_tb, Ql_tb, Qcmx_tb, Qcmn_tb, Qd_tb;

reg [4*8:1] state_string, last_UUT_state_string; // 4 character state string for displaying state in text mode in the waveform

integer  Clk_cnt, file_results; // file_results is a logical name for the physical file output_results_part2.txt here.
reg [3:0] test_number = 0;
reg [127:0] M_tb;
wire [7:0] M_of_I; // a copy of the M[I] in the UUT

localparam CLK_PERIOD = 20;

min_max_finder_part2 UUT (Max_tb, Min_tb, Start_tb, Clk_tb, Reset_tb, 
				 Qi_tb, Ql_tb, Qcmx_tb, Qcmn_tb, Qd_tb);
				 
assign M_of_I = {UUT.M[UUT.I]}; // this is for displaying in waveform
				 
always @(*)
	begin
		case ({Qi_tb, Ql_tb, Qcmx_tb, Qcmn_tb, Qd_tb})
			5'b10000: state_string = "INI ";
			5'b01000: state_string = "LOAD";
			5'b00100: state_string = "CMx";
			5'b00010: state_string = "CMn";
			5'b00001: state_string = "DONE";
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
	file_results = $fopen("output_results_part2.txt", "w");
	test_number = 0;
	   M_tb = 128'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00; 
	   memory_initialization (M_tb);
      // these initalization before reset are not important
	   Start_tb = 0;		// except for avoiding red color
	
	wait (!Reset_tb);    // wait until reset is over
	@(posedge Clk_tb);   // wait for a clock
	$fdisplay (file_results, " ");
    $fdisplay (file_results, "File name: output_results_part2.txt");
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

    $fdisplay (file_results, "All tests concluded.");
	 $fclose (file_results);
	 $display ("\n All tests concluded. Inspect the text file output_results_part2.txt. \n Current Clock Count = %0d ", Clk_cnt);
	 
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
