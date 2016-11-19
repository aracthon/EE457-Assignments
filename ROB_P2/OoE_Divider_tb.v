// EE457 RTL Exercises
// File Name: OoE_Divider_tb.v 
// Written by Mingyu Chang; Instructed by Byeongju Cha and Gandhi Puvvada
// Create Date:10/01/2014
// Description: this testbench initialize the mem_dividend_divisor memory and print out the execution results.

`timescale 1 ns / 100 ps

module OoE_Divider_tb ;

reg Clk_tb, Reset_tb;

integer  Clk_cnt, file_results; // file_results is a logical name for the physical file OoE_output_results.txt here.
reg [511:0] M_dd;
reg Start_tb;
wire complete_tb;
reg [16*8:0] state_string;
localparam CLK_PERIOD = 20,
Initial  = 3'b001,
Execution = 3'b010,
Complete = 3'b100;

Out_of_Order_divider OoE_DIV (Clk_tb, Reset_tb, Start_tb, complete_tb);
				 
			
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
	file_results = $fopen("OoE_output_results.txt", "w");
	   M_dd = 512'h00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00_00; 
	   memory_initialization (M_dd);
	   Start_tb = 1'b0;
      // these initalization before reset are not important except for avoiding red color
	
	wait (!Reset_tb);    // wait until reset is over
	@(posedge Clk_tb);   // wait for a clock
	 M_dd = 512'h89_32_45_07_29_03_d3_42_62_51_15_10_82_16_a5_37_85_29_25_02_73_80_c5_46_d5_71_72_34_17_06_19_10_89_56_65_30_89_40_c5_64_fe_23_83_67_23_06_9a_6e_e1_b8_64_50_b1_97_90_08_5a_02_41_80_56_53_90_15;
	 run_test (M_dd); 
	 $fclose (file_results);
	 $display ("\n ","\n", " Don't be scared when you see many 'xxxxxxxxxxxxxxxx' in the waveform, it should be that case.\n They are added just for reference and debugging!\n Good Luck!");
     // $stop;	 
	end // STIMULUS
	

task memory_initialization; 
   input [511:0] M_local_tb;   // we could have avoided passing argument for this task as all parent variables are visible to the task.
	integer i, j;
	begin
		for (i=0; i<=31; i = i +1)
		    begin
				for (j=0; j<=15; j = j +1)
		         OoE_DIV.mem_dividend_divisor[i][j]  = M_local_tb[(i*16)+j];
			end 
	end
endtask

		
task run_test;
	input [511:0] M_32x16_sendout_tb; // we could have avoided passing argument for this task as all parent variables are visible to the task.                        
	integer Start_clock_count, Clocks_taken, p;
	begin
		// test begins
		@(posedge Clk_tb);
		#2;
		memory_initialization (M_32x16_sendout_tb);
		Start_tb = 1;	// After a little while provide START
		@(posedge Clk_tb); 
		#5;
		Start_tb = 0;
		Start_clock_count = Clk_cnt;
		wait (complete_tb);
		#5;
		Clocks_taken = Clk_cnt - Start_clock_count;
		if (complete_tb == 1'b1) 
		   begin
		   $fdisplay (file_results, "dividend                  divisor                  quotient                  remainder        clocks_of_single_div_complete      clocks_of_rob_graduation");
		    for (p=0;p<=31;p=p+1)
	     		begin
		           $fdisplay (file_results, "   %02h                        %02h                       %02h                        %02h                        %02h                                %02h", OoE_DIV.mem_dividend_divisor[p][15:8], OoE_DIV.mem_dividend_divisor[p][7:0], OoE_DIV.mem_quotient_remainder[p][15:8], OoE_DIV.mem_quotient_remainder[p][7:0], OoE_DIV.mem_clocks_of_single_div_completion[p], OoE_DIV.mem_clocks_of_rob_graduation[p]);
		        end
			end
		$fdisplay (file_results, "\n Clocks taken = %0d. \n", Clocks_taken);
		#4;

	end
endtask


  always @ (OoE_DIV.state) // a combinational process to report the state in text format in the waveform
	begin : report_state	
		case (OoE_DIV.state)
		// spaces distributed around the names of the state 
		// to make it an 8-character string
		Initial: 		state_string  =   "   Initial  ";
		Execution: 		state_string  =   "   Execution   ";
		Complete: 	state_string  =   "  Complete  ";
		default: 	state_string  =   " Unknown";

		endcase
	end



endmodule 