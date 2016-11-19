// 	A Verilog module for a simple divider
// 	Written by Gandhi Puvvada  Date: 7/17/98, 2/15/2008, 10/13/08
//  rob tag is added for OoE divider Date:10/01/2014
//  revised on 03/15/2015: "state" signal as output
//  File name:  Single_div.v
module single_divider (Xin, Yin, Start, Ack, Clk, Reset, 
				       Quotient, Remainder, tag_in, tag_out, state);

input [7:0] Xin, Yin;
input [2:0] tag_in;
input Start, Ack, Clk, Reset;
output [2:0] state;
output [7:0] Quotient, Remainder;
output [2:0] tag_out;

reg [7:0] Quotient;  // Remainder is a wire by default
reg [7:0] X, Y;
reg [2:0] state;
reg [2:0] tag_out;

localparam
INITIAL = 3'b001,
COMPUTE	= 3'b010,
DONE_S	= 3'b100;


always @(posedge Clk, posedge Reset) 

  begin  : CU_n_DU
    if (Reset)
       begin
        	state <= INITIAL;
	      X <= 8'hXX;        // to avoid recirculating mux controlled by Reset
	      Y <= 8'hXX;	   // to avoid recirculating mux controlled by Reset 
	      Quotient <= 8'hXX; // to avoid recirculating mux controlled by Reset
       end
    else
       begin
         (* full_case, parallel_case *)
         case (state)
	        INITIAL	: 
	          begin
		         // state transitions in the control unit
		         if (Start)
		           state <= COMPUTE;
		         // RTL operations in the Data Path 
		           X <= Xin;
		           Y <= Yin;
		           Quotient <= 0;
				   tag_out <= tag_in;
	          end
	        COMPUTE	:
	          begin
		         // state transitions in the control unit
		         if (X < Y)
		           state <= DONE_S;
		         // RTL operations in the Data Path 
		         if (!(X < Y))
		           begin
		             X <= X - Y;
		             Quotient <= Quotient + 1;
		           end
 	          end
	        DONE_S	:
	          begin  
		         // state transitions in the control unit
		         if (Ack)
		           state <= INITIAL;
		         // RTL operations in the Data Path 
		         // In DONE_S state, there are no RTL operations in the Data Path 
	          end    
      endcase
    end 
  end
 
assign Remainder = X;
assign Done = (state == DONE_S) ;

endmodule  // divider

