// ---------------------------------------------------------------------------------
//  Module: merge_sort_P2
//  File name:  merge_sort_P2.v (based on copy_array_to_array_imp2.v)
// 	Design by:  Gandhi Puvvada Dec 2015 
//  Verilog coding by: Urvashi Dhoot <dhoot@usc.edu> and Pezhman Mamdouh <mamdouh@usc.edu> 
//	Minor improvement of code on 1/24/2016 by Gandhi 
//  Date: 1/7/2016, 1/24/2016

//  Description: Merging two 4-element arrays P[I] and Q[J],presorted in ascending order 
//				 into an 8-element array R[K] in ascending order
//
//				 Coding note:
//				 Array declaration is different here compared to min_max_finder_part1.v
//
//				 In the min-max lab, the M[I] array was declared in the UUT (Unit 
//				 Under Test) using the statement reg [7:0] M [0:15];
//				 And the testbench min_max_finder_part1_tb.v initializes the content 
//				 of this array by using the heirarchical refering method (UUT.M[I]).
//				 In the UUT, we can write statements such as Max <= M[I]; 
//				 because the array M[I] is declared in the UUT.
//				  
//				 In this lab the arrays, P[I], Q[J], and R[K], are declared in the testbench. 
//				 The UUT manipulates (initializes and increments) the indecies I, J, and K 
//				 and conveys them to the testbench.
//				 The testbench returns P[I] and Q[J], under the signal names Ps_of_I and Qs_of_J.
//				 The testbench receives from the UUT the following and writes into R[K] 
// 				 the data provided to it by the UUT:
// 				 Rs_of_K, K, and the desire to write Rs_of_K_Write
//				 So Rs_of_K_Write signal is produced combinationally. The combinational OFL
//				 downstream of the state memory Flip-Flops is coded thoughtfully using 
//				 an assign statement, and not a clocked RTL statement.
//				 So, in this code, we cannot write RTL statements such as R[K] <= P[I];
//				 because the arrays P[I], Q[J], and R[K] are not declared in the UUT.
//				 
// 				 The min-max lab practice is suitable if the arrays such as the register file
//				 are part of the UUT namely the CPU.
//				 The practice shown here is suitable for coding pieces of hardware such as
//				 a memory controller, because the memory is outside the memory controller.
//				 More on this in higher courses!
// ---------------------------------------------------------------------------------

`timescale 1 ns / 100 ps

module merge_sort_P2 (Reset, Clk, Start, Ack, Ps_of_I, Qs_of_J, Rs_of_K, Rs_of_K_Write, I, J, K);
					 

// The testbench or the TOP design has the memory arrays.
// The pointers I, J, and K are maintained and updated here in the sub-design.

//inputs and outputs declaration
input Reset, Clk;
input Start, Ack;
input [7:0] Ps_of_I,Qs_of_J; // Ps_of_I stands for P[I]; similarly Qs_of_J stands for Q[J]
output Rs_of_K_Write;
output reg [3:0] I, J; //I and J are counters for memory indexing
output reg [3:0] K; //K counter for the final array
output reg [7:0] Rs_of_K;
// reg and wire declaration
reg [4:0] state;

// State machine states
localparam
 INI   = 5'b00001,
 CMST =  5'b00010,
 RP   =  5'b00100,
 RQ  =   5'b01000,
 DONE  = 5'b10000,
 UNKN=   5'bxxxxx;

 localparam 
 Imax  = 4'b0011, Jmax = 4'b0011,Kmax = 4'b0111; // 
 
// OFL 
// ** TODO #1 **  Actually there is nothing to do here, 
// except you read the following OFL code and comments closely.
// ======
// beginning of  the OFL
// Note: Here we have deviated from our RTL coding style and created a combinational OFL
assign Rs_of_K_Write = ( (state == CMST) || (state == RP) || (state == RQ) );
// Note that we should not, by mistake, be generating the above signal, Rs_of_K_Write, 
// in the clocked procedural block below. If we do so, we will have a clock delay 
// in activating (and inactivating) Rs_of_K_Write. One of our goals is to make this point, 
// hence we have coded the design with memories in the top/test bench.  

always @(*) // Note that we are combinationally conveying the data from P[I] or Q[J] 
		    // to the testbench to deposit it as R[K]
	begin
			Rs_of_K=Ps_of_I; // default assignment to avoid latches
		//if( (state==RP) || (state==CMST && Ps_of_I<Qs_of_J) )
		//	Rs_of_K=Ps_of_I;
		if( (state==RQ) || (state==CMST && Ps_of_I>=Qs_of_J) )
			Rs_of_K=Qs_of_J;
	end	
// end of  the OFL
// ======
	
//start of state machine
always @(posedge Clk, posedge Reset) //asynchronous active_high Reset
 begin  
	   if (Reset) 
	       begin
	           I <= 4'bXXXX;
	           J <= 4'bXXXX;
			   K <= 4'bXXXX;
			   state <= INI;
	       end
       else // under positive edge of the clock
         begin
            case (state) // state and data transfers
                 INI:
					begin
                        if(Start) 
							begin
								state <= CMST;
							end
					   	I <= 4'b0000;
						J <= 4'b0000;
						K <= 4'b0000;
					end
                       
                CMST:      	// ** TODO #2 **  complete State transitions and RTL operations            
                    begin  	// Please see the "assign Rs_of_K_Write = ..." line in the OFL
							// and also see the combinational always (*) block above in the OFL
						// State transitions in the CU
						if (I == 3 && (Ps_of_I[I] < Qs_of_J[J])) begin
							state <= RQ;
						end
						else if (J == 3 && (Ps_of_I[I] >= Qs_of_J[J])) begin
							state <= RP;
						end
						else begin
							state <= CMST;
						end
						
						// RTL operations in the DPU
						
						if (Ps_of_I[I] < Qs_of_J[J]) begin
							Rs_of_K[K] <= Ps_of_I[I];
							I <= I + 1;
							K <= K + 1;
						end
						else begin
							Rs_of_K[K] <= Qs_of_J[J];
							J <= J + 1;
							K <= K + 1;					
						end
					end
				
				RQ:      	// ** TODO #3 **  complete State transitions and RTL operations 
					begin
						// State transitions in the CU
						if (K == 7) begin
							state <= DONE;
						end
						else begin
							state <= RQ;
						end

						// RTL operations in the DPU	
						Rs_of_K[K] <= Qs_of_J[J];
						J <= J + 1;
						K <= K + 1;
					end
					
				RP:      	// ** TODO #4 **  complete State transitions and RTL operations 
					begin
						// State transitions in the CU
						if (K == 7) begin
							state <= DONE;
						end
						else begin
							state <= RP;
						end
						
						// RTL operations in the DPU	
						Rs_of_K[K] <= Ps_of_I[I];
						I <= I + 1;
						K <= K + 1;
					end
                                                  
                DONE:
                    begin
                        if(Ack)
							state <= INI;
                    end
				default: 
                    begin
                         state <= UNKN;    
                    end
            endcase
         end   
 end 
              
endmodule