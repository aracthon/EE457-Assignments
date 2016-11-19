// -------------------------------------------------------------------------------------
//  Module: merge_sort_P2_tb
//  File name:  merge_sort_P2_tb.v (based on copy_array_to_array_imp2_tb.v designed by Ananth Rampura Sheshagiri Rao , Gandhi Puvvada) 
//  Verilog coding by: Pezhman Mamdouh <mamdouh@usc.edu> 
//  Date: 1/7/2016, 1/25/2016
// -------------------------------------------------------------------------------------


`timescale 1 ns / 100 ps

module merge_sort_P2_tb; // notice empty port list

reg Reset, Clk;
reg Start, Ack;
wire [7:0] Ps_of_I;
wire [7:0] Qs_of_J; 
wire [7:0] Rs_of_K;

wire Rs_of_K_Write;
wire [3:0] I, J;
wire [3:0] K;

reg [7:0] Ps_of_I_array [3:0] , Qs_of_J_array [3:0];
reg [7:0] Rs_of_K_array [7:0];

// The above Ps_of_I_array and Qs_of_J_array are the active arrays. 
// One of the four pairs of test arrays below is copied into the above pair, one at a time.
reg [7:0] Ps_of_I_array1 [3:0], Ps_of_I_array2 [3:0], Ps_of_I_array3 [3:0], Ps_of_I_array4 [3:0], Ps_of_I_array5 [3:0];
reg [7:0] Qs_of_J_array1 [3:0], Qs_of_J_array2 [3:0], Qs_of_J_array3 [3:0], Qs_of_J_array4 [3:0], Qs_of_J_array5 [3:0];

parameter CLK_PERIOD = 10;

localparam
 INI   = 5'b00001,
 CMST =  5'b00010,
 RP   =  5'b00100,
 RQ  =   5'b01000,
 DONE  = 5'b10000,
 UNKN=   5'bxxxxx;
 
reg [4*8:1] state_string;

integer  Clk_cnt, Start_clock_count, Clocks_taken;

integer output_file; // file designator for output_results_P2.txt file
reg [3:0] KK; // Index into P, Q, and R arrays for console display and file output
localparam KK_max  = 4'b0111;
reg [32*8:1] msg_string; // a maximum of 32 characters can be stored in this msg_string
 
task display_P_Q_R_arrays;
  begin
//	$display("\n\t#\tP\tQ\tR\n"); // display the heading row as  	#	P	Q	R with leading and trailing new lines (\n)
	$display("\n\t #\t  P\t  Q\t  R\n"); // display the heading row as  	#	P	Q	R with leading and trailing new lines (\n)
//	$fdisplay(output_file, "\n\t#\tP\tQ\tR\n");
	$fdisplay(output_file, "\n\t #\t  P\t  Q\t  R\n");
	
	
	for (KK=0; KK<=KK_max; KK=KK+1) // for all the rows in the matrices
		begin // for each row (there are p items in a row)
			msg_string = "\n";
			$sformat(msg_string, "%s\t%d", msg_string, KK); 	// Print the index II_JJ in the msg_string
			if(KK<4)
			begin
				$sformat(msg_string, "%s\t%d", msg_string, Ps_of_I_array[KK]); 	// gather P[I] in the msg_string in decimal
				$sformat(msg_string, "%s\t%d", msg_string, Qs_of_J_array[KK]);	// gather Q[J] in the msg_string in decimal
				$sformat(msg_string, "%s\t%d", msg_string, Rs_of_K_array[KK]);
			end
			else
			begin
				$sformat(msg_string, "%s\t\t\t%d", msg_string, Rs_of_K_array[KK]);		// gather R[K] in the msg_string in decimal
			end	
			$display("%s", msg_string);
			$fwrite(output_file, "%s\n", msg_string);
		end	
	$display ("\n Clocks_taken = %d . \n", Clocks_taken);
	$fdisplay (output_file, "\n Clocks_taken = %d . \n", Clocks_taken);
  end
endtask 

// Instantiating core RTL block in the testbench

merge_sort_P2 UUT (Reset, Clk, Start, Ack, Ps_of_I, Qs_of_J, Rs_of_K, Rs_of_K_Write, I, J, K);

initial 
   begin
	output_file = $fopen ("output_results_P2.txt", "w"); // create the file "output_results_P2.txt" and open it for writing
   end
   
initial 
   begin 
      Reset <= 1;
      Start <= 0;
      Ack   <= 0;
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
      Reset <= ~Reset; // going out of Reset  
	  
	  $display("\n MERGE SORT P2\n");
	  $fdisplay(output_file, "\n MERGE SORT P2\n");	  
	  
	  // Test #1:
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #1: \n");
	  $fdisplay(output_file, "\n Test #1: \n");
	  simulate_with_given_array (
					{Ps_of_I_array1[3],
					 Qs_of_J_array1[3],
					 Ps_of_I_array1[2],
					 Qs_of_J_array1[2],
					 Ps_of_I_array1[1],
					 Qs_of_J_array1[1],
					 Ps_of_I_array1[0],
					 Qs_of_J_array1[0]}
					);

	// Test #2: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #2: \n");
	  $fdisplay(output_file, "\n Test #2: \n");
	  simulate_with_given_array (
					{Ps_of_I_array2[3],
					 Qs_of_J_array2[3],
					 Ps_of_I_array2[2],
					 Qs_of_J_array2[2],
					 Ps_of_I_array2[1],
					 Qs_of_J_array2[1],
					 Ps_of_I_array2[0],
					 Qs_of_J_array2[0]}
					);
	  
	// Test #3: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #3: \n");
	  $fdisplay(output_file, "\n Test #3: \n");
	  simulate_with_given_array (
					{Ps_of_I_array3[3],
					 Qs_of_J_array3[3],
					 Ps_of_I_array3[2],
					 Qs_of_J_array3[2],
					 Ps_of_I_array3[1],
					 Qs_of_J_array3[1],
					 Ps_of_I_array3[0],
					 Qs_of_J_array3[0]}
					);
	  
	// Test #4: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #4: \n");
	  $fdisplay(output_file, "\n Test #4: \n");
	  simulate_with_given_array (
					{Ps_of_I_array4[3],
					 Qs_of_J_array4[3],
					 Ps_of_I_array4[2],
					 Qs_of_J_array4[2],
					 Ps_of_I_array4[1],
					 Qs_of_J_array4[1],
					 Ps_of_I_array4[0],
					 Qs_of_J_array4[0]}
					);

	// Test #5: 
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  $display("\n Test #5: \n");
	  $fdisplay(output_file, "\n Test #5: \n");
	  simulate_with_given_array (
					{Ps_of_I_array5[3],
					 Qs_of_J_array5[3],
					 Ps_of_I_array5[2],
					 Qs_of_J_array5[2],
					 Ps_of_I_array5[1],
					 Qs_of_J_array5[1],
					 Ps_of_I_array5[0],
					 Qs_of_J_array5[0]}
					);

					
	$display("\n All tests completed. \n");
	$fdisplay(output_file, "\n All tests completed. \n");
	$fclose(output_file);				
	end
	
task simulate_with_given_array;
 input [63:0] passed_on_array_bits;
 begin
 
	Ps_of_I_array [0] = passed_on_array_bits [ 7: 0];
	Qs_of_J_array [0] = passed_on_array_bits [15: 8];
	Ps_of_I_array [1] = passed_on_array_bits [23:16];
	Qs_of_J_array [1] = passed_on_array_bits [31:24];
	Ps_of_I_array [2] = passed_on_array_bits [39:32];
	Qs_of_J_array [2] = passed_on_array_bits [47:40];
	Ps_of_I_array [3] = passed_on_array_bits [55:48];
	Qs_of_J_array [3] = passed_on_array_bits [63:56];

	Start <= 0;
      Ack   <= 0;
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
      Start <= 1;
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
      Start <= 0;	
	  Start_clock_count = Clk_cnt;
	  // wait until the UUT reaches DONE state and then send Ack
	  @(posedge UUT.state[4]);  // DONE  state is given the one-hot code 5'b10000 
	  #(CLK_PERIOD/5);

	  Clocks_taken = Clk_cnt - Start_clock_count;
	  display_P_Q_R_arrays; // call the task to display the contents
	  Ack <= 1;
	  @(posedge Clk); #(CLK_PERIOD/5); // After waiting for a clock (and a little)
	  Ack <= 0;
   end
endtask

initial 
   begin
    // Initializing Ps_of_I, Qs_of_J with some test values
      
	  // 1  -- simultaneous I==3 and J==3 situation
      Ps_of_I_array1[0] <= 10;
      Qs_of_J_array1[0] 	<= 13;
      Ps_of_I_array1[1] <= 11;    
      Qs_of_J_array1[1] 	<= 14; 
      Ps_of_I_array1[2] <= 12;
      Qs_of_J_array1[2] 	<= 15;
      Ps_of_I_array1[3] <= 17;
      Qs_of_J_array1[3] 	<= 16;
	  
	  // 2  -- All P's before any Q's
	  Ps_of_I_array2[0] <= 20;
      Qs_of_J_array2[0] 	<= 24;
      Ps_of_I_array2[1] <= 21;
      Qs_of_J_array2[1] 	<= 25;
      Ps_of_I_array2[2] <= 22;
      Qs_of_J_array2[2] 	<= 26;
      Ps_of_I_array2[3] <= 23;
      Qs_of_J_array2[3] 	<= 27;

	  // 3  -- P's and Q's take turns
	  Ps_of_I_array3[0] <= 30;
      Qs_of_J_array3[0] 	<= 31;
      Ps_of_I_array3[1] <= 32;
      Qs_of_J_array3[1] 	<= 33;
      Ps_of_I_array3[2] <= 34;
      Qs_of_J_array3[2] 	<= 35;
      Ps_of_I_array3[3] <= 36;
      Qs_of_J_array3[3] 	<= 37;

	  // 4  -- All 8 data are identical
	  Ps_of_I_array4[0] <= 44;
      Qs_of_J_array4[0] 	<= 44;
      Ps_of_I_array4[1] <= 44;
      Qs_of_J_array4[1] 	<= 44;
      Ps_of_I_array4[2] <= 44;
      Qs_of_J_array4[2] 	<= 44;
      Ps_of_I_array4[3] <= 44;
      Qs_of_J_array4[3] 	<= 44;

	  // 5  -- All 4 data in P are identical; All 4 data in Q are identical but different from P
	  Ps_of_I_array5[0] <= 50;
      Qs_of_J_array5[0] 	<= 55;
      Ps_of_I_array5[1] <= 50;
      Qs_of_J_array5[1] 	<= 55;
      Ps_of_I_array5[2] <= 50;
      Qs_of_J_array5[2] 	<= 55;
      Ps_of_I_array5[3] <= 50;
      Qs_of_J_array5[3] 	<= 55;
	  
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
  
assign #1 Ps_of_I = Ps_of_I_array[I];
assign #1 Qs_of_J = Qs_of_J_array[J];


// Capturing data from RTL into memory
always @ (posedge Clk) 
        begin
		if (Rs_of_K_Write == 1)
		begin
           Rs_of_K_array[K] <= Rs_of_K;
		end
		end 

always @(*)
  case (UUT.state) // UUT.state works here only in presynthesis simulation

	INI   :		state_string = "INI ";
	CMST  :		state_string = "CMST";
	RQ  :		state_string = " RQ ";
	RP  :		state_string = " RP ";
	DONE  :		state_string = "DONE";
	default  : 	state_string = "unkn";
  endcase
  
endmodule