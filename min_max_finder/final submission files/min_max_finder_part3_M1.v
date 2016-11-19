// EE457 RTL Exercises
// min_max_finder_part3_M1.v (Part 3 method 1 uses one comparison unit like part 2)
// Written by Gandhi Puvvada
// June 4, 2010, 
// Given an array of 16 unsigned 8-bit numbers, we need to find the maximum and the minimum number
 

`timescale 1 ns / 100 ps

module min_max_finder_part3_M1 (Max, Min, Start, Clk, Reset, 
				           Qi, Ql, Qcmx, Qcmnf, Qcmn, Qcmxf, Qd);

input Start, Clk, Reset;
output [7:0] Max, Min;
output Qi, Ql, Qcmx, Qcmnf, Qcmn, Qcmxf, Qd;

reg [7:0] M [0:15]; 

reg [6:0] state;
reg [7:0] Max;
reg [7:0] Min;
reg [3:0] I;

localparam 
INI  = 	7'b0000001, // "Initial" state
LOAD = 	7'b0000010, // "Load Max and Min with 1st Element" state
CMx = 	7'b0000100, // "Compare each number with Max and Update Max if needed" state
CMnF = 	7'b0001000, // "Compare with Min. for the first time after a sequence of comparisons in the CMx" state
CMn = 	7'b0010000, // "Compare each number with Min and Update Min if needed" state
CMxF = 	7'b0100000, // "Comparing with Max. for the first time after a sequence of comparisons in the CMn" state
DONE = 	7'b1000000; // "Done finding Min and Max" state
         
         
assign {Qd, Qcmxf, Qcmn, Qcmnf, Qcmx, Ql, Qi} = state;  

always @(posedge Clk, posedge Reset) 

  begin  : CU_n_DU
    if (Reset)
       begin
         state <= INI;
         I <= 4'b0000;   // to avoid recirculating mux controlled by Reset 
	      Max <= 8'bxxxxxxxx;
	      Min <= 8'bxxxxxxxx;
	    end
    else
       begin
           case (state)
	        INI	: 
	          begin
		         // state transitions in the control unit
		         if (Start)
		           state <= LOAD;
		         // RTL operations in the Data Path            	              
		        I <= 0;
	          end
	        LOAD	:
	          begin
		           // RTL operations in the Data Path  
		           Max <= M[I]; // Load M[I] into Max
		           Min <= M[I]; // Load M[I] into Min
		           I <= I + 1;  // Increment I
		           // state transitions in the control unit
		           state <= CMx; // Transit unconditionally to the CMx state         
 	          end
	        
	        CMx :
	          begin 
			   // RTL operations in the Data Path   		                  
					if ( Max <= M[I] )
					begin
						Max <= M[I];
						I <= I + 1;
					end
					
			   // state transitions in the control unit
			   		if ( Max <= M[I]  && I != 4'b1111)
						state = CMx;
					else if ( Max <= M[I] && I == 4'b1111 )
						state = DONE;
					else
						state = CMnF;
				
			   end
			  
	        CMnF :
	          begin // 
				// RTL operations in the Data Path 
				I <= I + 1;
				if ( Min > M[I] )
				begin
					Min <= M[I];
				end
				// state transitions in the control unit 
				if ( I == 4'b1111 )
					state = DONE;
				else
					state = CMn;
			  end

	        CMn :
	          begin // 
				// RTL operations in the Data Path   		                  
				if ( Min >= M[I] )
				begin
					Min <= M[I];
					I <= I + 1;
				end
					
			    // state transitions in the control unit
		   		if ( Min >= M[I]  && I != 4'b1111)
					state = CMn;
				else if ( Min >= M[I] && I == 4'b1111 )
					state = DONE;
				else
					state = CMxF;
				end
	        CMxF : 
	          begin // 
				// RTL operations in the Data Path 
				I <= I + 1;
				if ( Max < M[I] )
				begin
					Max <= M[I];
				end
				// state transitions in the control unit 
				if ( I == 4'b1111 )
					state = DONE;
				else
					state = CMx;
			  end

	        DONE	:
	          begin  
		         // state transitions in the control unit
		           state <= INI; // Transit to INI state unconditionally
		       end    
      endcase
    end 
  end 
endmodule  

