// EE457 RTL Exercises
// File Name: Solution_OoE_Divider.v 
// Written by Mingyu Chang; Instructed by Byeongju Cha and Gandhi Puvvada
// Create Date:10/17/2014
// Refined Date:03/15/2015
// Implementation improvement and exercise assignment -- Sanmukh Kuppannagari 4/12/2015
// Description: This is an out of order execution, in order completion divider. 
//              read dividends and divisors from memory mem_dividend_divisor, execute, 
//              then write quotients and remainders to memory mem_quotient_remainder.

`timescale 1 ns / 100 ps

module Out_of_Order_divider (clk, rst,start, memory_write_complete);
input clk, rst, start;
output memory_write_complete;

//signals related to memory
reg [15:0] mem_dividend_divisor [0:31];// dividend-divisor pairs to be calculated initialized by testbench
reg [15:0] mem_quotient_remainder [0:31];//quotient-remainder pairs calculated. 
reg [7:0] mem_clocks_of_single_div_completion [0:31];//the clock number at which the division execution is complete, this is for displaying purpose. 
reg [7:0] mem_clocks_of_rob_graduation [0:31];//the clock number at which the rob entry is graduated, this is for displaying purpose. 
reg [4:0] mem_dd_pointer, mem_qr_pointer; //pointers. we read from mem_dividend_divisor, write into mem_quotient_remainder. 
reg memory_read_complete;
wire memory_write_complete; 

//signals related to single divider
reg [3:0] ack_from_OoE_div, start_from_OoE_div;//output to single dividers
wire [2:0] single_div_states [0:3]; //input from single dividers
wire [7:0] dividend_of_OoE_div;//output to single dividers
wire [7:0] divisor_of_OoE_div;//output to single dividers
wire [7:0] quotient_of_OoE_div [0:3];//input from single dividers
wire [7:0] remainder_of_OoE_div [0:3];//input from single dividers
wire no_divider_available; 

//signals related to rob 
wire [2:0] rob_tag_from_OoE_div;//attaching rob tag when assigning a task to single divider. output to single dividers
wire [2:0] rob_tag_to_OoE_div [0:3];//returning rob tag from single divider.
reg [3:0] rob_wp, rob_rp;
reg [15:0] rob_qr [0:7];//quotient and remainder array
reg [7:0] rob_ready;//ready bit array
reg [7:0] clocks_of_single_div_completion_internal [0:7];//storing the clock number at which the division execution is complete
wire [3:0] rob_depth;
wire rob_full;


wire stall;
reg [7:0] clock_counter;//keep counting clocks, this is for displaying purpose.
integer i,j,k;
reg found_signal_for_dispatch, found_signal_for_issue_1, found_signal_for_issue_2;//found signals are used in "for" loop to realize priority.
//Note: 'disable' could be used to exist the 'for' loop in Verilog, yet it is not synthesizable in Xilinx.


reg [2:0] state;
localparam

//states of OoE divider
Initial  = 3'b001,
Execution = 3'b010,
Complete = 3'b100,


//states of single divider
Qi = 3'b001,
Qc = 3'b010,
Qd = 3'b100;


// instantiation of single divider module
single_divider divider0 (.Xin(dividend_of_OoE_div), .Yin(divisor_of_OoE_div), .Start(start_from_OoE_div[0]),.Ack(ack_from_OoE_div[0]),.Clk(clk),.Reset(rst),.Quotient(quotient_of_OoE_div[0]), .Remainder(remainder_of_OoE_div[0]), .tag_in(rob_tag_from_OoE_div), .tag_out(rob_tag_to_OoE_div[0]), .state(single_div_states[0]));
single_divider divider1 (.Xin(dividend_of_OoE_div), .Yin(divisor_of_OoE_div), .Start(start_from_OoE_div[1]),.Ack(ack_from_OoE_div[1]),.Clk(clk),.Reset(rst),.Quotient(quotient_of_OoE_div[1]), .Remainder(remainder_of_OoE_div[1]), .tag_in(rob_tag_from_OoE_div), .tag_out(rob_tag_to_OoE_div[1]), .state(single_div_states[1]));
single_divider divider2 (.Xin(dividend_of_OoE_div), .Yin(divisor_of_OoE_div), .Start(start_from_OoE_div[2]),.Ack(ack_from_OoE_div[2]),.Clk(clk),.Reset(rst),.Quotient(quotient_of_OoE_div[2]), .Remainder(remainder_of_OoE_div[2]), .tag_in(rob_tag_from_OoE_div), .tag_out(rob_tag_to_OoE_div[2]), .state(single_div_states[2]));
single_divider divider3 (.Xin(dividend_of_OoE_div), .Yin(divisor_of_OoE_div), .Start(start_from_OoE_div[3]),.Ack(ack_from_OoE_div[3]),.Clk(clk),.Reset(rst),.Quotient(quotient_of_OoE_div[3]), .Remainder(remainder_of_OoE_div[3]), .tag_in(rob_tag_from_OoE_div), .tag_out(rob_tag_to_OoE_div[3]), .state(single_div_states[3]));


assign rob_depth = rob_wp - rob_rp;
assign rob_full = (rob_depth==4'b1000); 
//Task #1: Fill in the condition when no divider is available.
//Hint: In part 1 we looked at the next divider to be assigned and checked whether it was available or not. However in this part we check whether ANY
//divider is available or not.
assign no_divider_available = (single_div_states[0]!=Qi)&&(single_div_states[1]!=Qi)&&(single_div_states[2]!=Qi)&&(single_div_states[3]!=Qi);
//Task #2: Fill in the stall condition
//Hint: In part 1, we stalled when no divider was available, is it enough in this part 2?
//What else needs to be added?
assign stall = rob_full || no_divider_available;
assign memory_write_complete = (state == Complete);

//The following wires are assigned the dividend divisor pairs and rob tag. This goes as input to the current divider to be assigned in the instantiation of single divider module 
assign	dividend_of_OoE_div = mem_dividend_divisor[mem_dd_pointer][15:8];//assign dividend from memory to single divider
assign	divisor_of_OoE_div  = mem_dividend_divisor[mem_dd_pointer][7:0];//assign divisor from memory to single divider
assign	rob_tag_from_OoE_div = rob_wp[2:0];//the lower 3 bits of rob write pointer are used as rob tag.


always @(posedge clk, posedge rst)
begin
if (rst) 
     begin
	     state <= Initial;
	     mem_dd_pointer <= 5'bxxxxx; // to avoid recirculating mux controlled by Reset
         mem_qr_pointer <= 5'bxxxxx;
         rob_wp <= 4'bxxxx;
         rob_rp <= 4'bxxxx;
         rob_ready <= 8'hxx;
	     memory_read_complete <= 1'bx;
		 clock_counter <= 16'hxx;
     end
else
  begin	
 
    case(state)
      Initial:
        begin
	     mem_dd_pointer <= 5'b00000;
         mem_qr_pointer <= 5'b00000;
         rob_wp <= 4'b0000;
         rob_rp <= 4'b0000;
         rob_ready <= 8'h00;
	     memory_read_complete <= 1'b0;
	     if (start)
	     state <= Execution;
		 clock_counter <= 16'h01;
	    end   
	  	   
      Execution:	   
		begin   
		clock_counter <= clock_counter + 1; 
//dispatch unit. assigning the division task to an available single divider   
//----------------------------------------------------------------------------------------
//Task #3: Fill the if condition.
//Hint: The contents of the if block means that a dividend divisor pair from the memory is read and a new rob entry is allocated.
//Under what conditions will you read a dividend divisor pair and assign it to a single divider.
		if ( !stall )
            begin 			 
				rob_wp <= rob_wp + 1;// increment rob write_pointer.
				mem_dd_pointer <= mem_dd_pointer + 1;//increment memory read pointer.
				if (mem_dd_pointer == 5'b11111)
					memory_read_complete <= 1'b1; //if this is the last entry, set memory_read_complete so that dispatching stops.
     		end
			
//----------------------------------------------------------------------------------------				
//rob graduation. if the top-most rob array is ready, write rob-stored information to the memories pointed by mem_qr_pointer. 
	    if (rob_ready[rob_rp[2:0]] == 1'b1)
          begin		
          //Task #4: Fill in the next two lines
          //Hint: In the next three lines, rob entry corresponding to top is stored in memory and the rob entry's ready bit is reset.
          //Can you use your excellent reverse engineering skills and figure out what the tag bits are? :)
			mem_quotient_remainder[mem_qr_pointer][15:8] <= rob_qr[rob_rp[2:0]][15:8];
            mem_quotient_remainder[mem_qr_pointer][7:0] <= rob_qr[rob_rp[2:0]][7:0];
            rob_ready[rob_rp[2:0]] <= 1'b0;// reset its ready bit 
			
			mem_clocks_of_rob_graduation[mem_qr_pointer] <= clock_counter;
			mem_clocks_of_single_div_completion[mem_qr_pointer] <= clocks_of_single_div_completion_internal[rob_rp[2:0]];
			rob_rp <= rob_rp + 1;  // increment rob read_pointer.
			mem_qr_pointer <= mem_qr_pointer + 1;// increment the memory write pointer.
			if (mem_qr_pointer == 5'b11111)
				 state <= Complete;//if it is the last item, goes to complete state.                	        
		  end
//----------------------------------------------------------------------------------------			  
//issue unit.	if any single divider is ready, return the quotient and remainder along with the rob tag assigned to it.
//NOTE: please understand this for loop below properly
//Here, we are finding the first single divider whose state is done, so that we could mark it ready for collection.
//To do so, we use a for loop and iterate through each and every single divider. If we find a single divider, we 
//assert the signal "found_signal_for_issue_1", so that we do not enter the if statement.
//Since we check from 0 and increment towards 3, the priority condition that the smaller-index divider has the higher priority is met
//Maybe there is a better way??
	     found_signal_for_issue_1 = 1'b0;     
	     for (k=0;k<=3;k=k+1)
          begin
              if ((single_div_states[k]== Qd)&&(found_signal_for_issue_1==1'b0))
                 begin
                    rob_qr[rob_tag_to_OoE_div[k]][15:8] <= quotient_of_OoE_div[k];			   
			        rob_qr[rob_tag_to_OoE_div[k]][7:0] <= remainder_of_OoE_div[k];
					clocks_of_single_div_completion_internal[rob_tag_to_OoE_div[k]] <= clock_counter;
			        found_signal_for_issue_1 = 1'b1;// the smaller-index divider has the higher priority.
					rob_ready[rob_tag_to_OoE_div[k]] <= 1'b1;//set the rob_ready as indicated by the tag
			     end
		  end	
	   end
	
      Complete:
	    begin
	    state <= Initial;
	    end
    endcase	
		
   end	      
end



// we separate the following block from the clocked block above, because we do not want infer any registers for signals like 'start' and 'ack'.

always@(*)

begin
//dispatch unit. ----------------------------------------------------------------------------------------	
		found_signal_for_dispatch = 1'b0;
		start_from_OoE_div = 4'b0000; //reset start signal for all the dividers.
        if ((stall == 1'b0)&&(memory_read_complete == 1'b0)&&(state == Execution))
            begin 
	            for (i=0;i<=3;i=i+1) 
					 begin
						  if ((single_div_states[i] == Qi)&&(found_signal_for_dispatch==1'b0))
								begin
									start_from_OoE_div[i] = 1'b1;//set that divider to start, noticed that this "start" signals only last for one clock.
									found_signal_for_dispatch = 1'b1;	// the smaller-index divider has the higher priority.	
								end
					 end 
            end	
//issue unit.----------------------------------------------------------------------------------------				
            //Task #5: Here we want to find the next single divider which is in done state so that it could be acknowledged .
            //Remember the for loop before,implement something like that. Or if you want a better design in mind, implement that.			
			//Make sure the priority condition is satisfied.
			//We have written a sample pseudo code for you
				

			found_signal_for_issue_2 = 1'b0; 
			ack_from_OoE_div = 4'b0000;
			for (i=0;i<=3;i=i+1) begin
				if ((single_div_states[i] == Qd)&&(found_signal_for_issue_2==1'b0)) begin
					found_signal_for_issue_2 = 1'b1;
					ack_from_OoE_div[i] = 1'b1;
				end
			end
			
			
end

endmodule
