// File: ee457_lab7_P3_RTL_Coding_Style.v 
// This is basically a re-writing of the earlier file "ee457_lab7_P3.v" in RTL coding style
// Written by Gandhi Puvvada, Oct 12, 2010, Nov 21, 2010
// Here, we want to reduce unnecessary hierarchy. So we are not using the 
// components defined in ee457_lab7_components.v. Instead we are coding them inline. 
// Also, we could avoid coding the mux select lines separately, comparator outputs separately.
// These can be implicitly defined in the if..else.. statements.
// The code is short, easy to understand and maintain.
// This is the recommended style.

// This design supports SUB3, ADD4, ADD1, and MOV instructions.

`timescale 1 ns / 100 ps

module ee457_lab7_P3 (CLK,RSTB);
input CLK,RSTB;


// signals -- listed stagewise
// Signals such as PC_OUT were wires in ee457_lab7_P3.v.
// Here they are changed to "reg".

// IF stage signals
reg [7:0] PC_OUT;
reg [31:0] memory [0:63]; // instruction memory 64x32
wire [31:0] IF_INSTR_combinational;
reg [31:0] IF_INSTR;

// ID stage signals
// reg ID_XMEX1, ID_XMEX2; // Outputs of the comparison station in ID-stage. 
// The above line is commented out and the above two signals are declared 
// with in the named procedural block, "Main_Clocked_Block" later to show how to curtail visibility of local signals.

// Notice that we declared below two signals: a wire signal called STALL_combinational and a reg signal called STALL.
// We explained later why we have declared these two signals. 
reg STALL; // STALL_B, the opposite of STALL, is neither explicitly declared, nor produced explicitly. 
wire STALL_combinational; // Declared as wire, as we intend to produce it using a continuous assign statement (outside the procedural block). 
reg ID_MOV,ID_SUB3,ID_ADD4,ID_ADD1; // We did not declare ID_MOV_OUT,ID_SUB3_OUT,ID_ADD4_OUT,ID_ADD1_OUT as it is considered as "too much detailing".
reg [3:0] ID_XA,ID_RA; // 4-bit source register and write register IDs
reg [15:0] reg_file [0:15] ; // register file 16x16
reg [15:0] ID_XD; // Data at ID_XA
reg [31:0] ID_INSTR;

// EX1 stage signals
reg EX1_MOV,EX1_SUB3,EX1_ADD4,EX1_ADD1,EX1_XMEX1,EX1_XMEX2; 
wire PRIORITY_combinational; // This is used in a question in your lab.
reg PRIORITY,FORW1,SKIP1; // intermediate signals in EX1
reg [3:0] EX1_RA; // 4-bit write register ID
reg [15:0] EX1_XD,EX1_PRIO_XD,EX1_ADDER_IN,EX1_ADDER_OUT;
reg [31:0] EX1_INSTR;

// EX2 stage signals
reg EX2_MOV,EX2_SUB3,EX2_ADD4,EX2_ADD1,EX2_XMEX1; // These are registered signals (and or not intermediate signals).
reg FORW2,SKIP2; // intermediate signals in EX2
reg [3:0] EX2_RA; // 4-bit write register ID
reg [15:0] EX2_XD,EX2_ADDER_IN,EX2_ADDER_OUT,EX2_XD_OUT;
reg [31:0] EX2_INSTR;

// WB stage signals
reg WB_WRITE;
reg WB_SKIP2;
reg [3:0] WB_RA; // 4-bit write register ID
reg [15:0] WB_EX2_ADDER_OUT, WB_EX2_ADDER_IN;
reg [31:0] WB_INSTR;



assign IF_INSTR_combinational = memory[PC_OUT[5:0]]; // instruction is read from the instruction memory;
// The IF_INSTR_combinational is produced because Modelsim displays the IF_INSTR produced 
// by the blocking assignment in the clocked-always block 1-clock late in the waveform.

// usage of blocking and non-blocking assignments
// It is important to note where to use blocking assignments and where to use non-blocking
// assignments in coding in RTL style.
// Simple Golden Rule is that all registers should be updated/assigned using non-blocking
// assignments. However intermediate signals (note the word "intermediate") in the upstream 
// combinational logic (note the word "upstream") shall be assigned using blocking assignment
// because (i) you do not want to infer a register for these intermediate signals and
// (ii) you want these intermediate signals (or variables) to be updated immediately without
// any delta-T delay as you produced these with the intent of immediately consuming them.
// The STALL signal is one such signal here. We could avoid producing FORW1, FORW2, SKIP1 and SKIP2,
// explicitly and write long RHS (right-hand side) expressions. But we produced them for clarity 
// and they are produced using blocking assignments.
// The 16-bit data in EX2 stage goes through several intermediate steps:
// 		(i) 	Forwarding mux, X2_Mux
//		(ii)	Adder ADD4
//		(iii)	Skip mux, R2_Mux
// Please note that all the intermediate values of the 16-bit data are assigned using blocking assignments.

// Also notice that several signals in the declarative area starting from PC_OUT are changed from the 
// previous "wire" type (in structural coding in earlier part) to "reg" type now. 
// Previously they were outputs of register-components instantiated and they were driven continuously  
// by the instantiated components. Hence they were wires. 
// Now they are generated in an "always procedural block". Hence they are declared as "reg".

assign STALL_combinational = 	(ID_XA == EX1_RA) // if the ID stage instruction's source register matches with the EX1 stage instruction's destination register
								& // and further
								(ID_SUB3 | ID_ADD1) // if the instruction in ID is a kind of instruction who will insist on receiving help at the beginning of the clock in EX1 itself when he reaches EX1
								& // and further
								(EX1_ADD4 | EX1_ADD1) // if the instruction in EX1 is a kind of instruction who will can't help at the beginning of the clock when he is in EX2 as he is still producing his result
								; // then we need to stall the dependent instruction in ID stage.
								
// At the beginning of the "else // referring to else if posedge CLK" portion of the "clocked always procedural block"
// we produced STALL using blocking assignments and used it immediately to stall the PC and IF/ID registers.
// However, in the ModelSim waveform display, the STALL signal is displayed "after" the clock-edge at
// which it is supposed to take action, leading to possible confusion to a new reader (a novice) of 
// modelsim waveforms for designs expressed in Verilog.
// One can produce STALL_combinational as shown above and use it in place of the STALL below to stall the pipeline.
// Notice that the STALL_combinational waveform is easier to understand.
// Also notice the STALL (produced through blocked assignment) is initially unknown as it is not 
// initialized (and it is not necessary to initialize it) under reset (under "if (RSTB == 1'b0)").
// My recommendation: It is best not to display (in waveform) signals assigned using blocked assignments in a clocked always block.

assign PRIORITY_combinational = EX1_XMEX1 & (EX2_SUB3 | EX2_MOV); // This is used in a question in your lab.


//--------------------------------------------------
always @(negedge CLK) // due to writing at negative edge, internal forwarding became automatic!
  begin : RegFile_Block
	if (WB_WRITE)
	begin
	   reg_file[WB_RA] <= WB_RD;
	end
  end
//--------------------------------------------------
always @(posedge CLK, negedge RSTB)

  begin : Main_Clocked_Block 	// Name the sequential block as in this example. Any name (an unique identifier) may be chosen.
								// Once you name a block as shown above, you can declare variables visible to this block only.
								// This is inline with the "variables declaration with in a process in VHDL". Those variables
								// are visible only inside that process.
 reg ID_XMEX1, ID_XMEX2; // Outputs of the comparison station in ID stage.
						 // These are intermediate signals in the ID-stage combinational logic.
						 // Intermediate signals generated inside a sequential procedural block are best declared in the block itself
						 // as shown here, so that they are not accessed by mistake from outside. Because if they are accessed from 
						 // outside this clocked procedural block, they will be treated as "registered" outputs (registered on the clock-edge)
						 // and the behavior would be different from what we would expect from our schematic-entry experience.
						 // Notice that we produced STALL_combinational outside this procedure and we used the expression "(ID_XA == EX1_RA)" correctly.
						 // We should not use the ID_XMEX1 intermediate variable generated here and we prevented such mistake by declaring ID_XMEX1 locally here.
						 // You may ask, how come then you used EX1_XMEX1, etc. generated here in producing PRIORITY_combinational outside!
						 // Well, since EX1_XMEX1, etc. are registered signals and are not intermediate signals, there will not be any change
						 // in the way they behave inside this procedural block or outside. This is important to understand.
  
	if (RSTB == 1'b0)
	
	  begin
	  
		// IF stage
		PC_OUT <= 8'h00;
		
		// ID Stage
		// Notice: ID_XD is not a physical register. So do not initalize it (no need to write "ID_XD <= 16'hXXXX;")
		//          and later do not assign to it using a non-blocking assignment.	
		// 			Similarly ID_XMEX1, ID_XMEX2, and STALL are not physical registers.	So no initialization for these also.	
		ID_XA <= 4'hX; 
		ID_RA <= 4'hX;
		ID_INSTR <= 32'h00000000; // we could put 32'hXXXXXXXX but, we want to report a NOP in TimeSpace.txt
		ID_MOV  <= 1'b0;
		ID_SUB3 <= 1'b0; 
		ID_ADD4 <= 1'b0; 
		ID_ADD1 <= 1'b0; 
		// please notice that the control signals (ID_MOV, etc.) are inactivated to make sure
		// that a BUBBLE occupies the stage during reset. When control signals
		// are turned to zero, data can be don't care. See "EX1_XD <= 16'hXXXX;" below.
		
		// EX1 Stage
		EX1_XD <= 16'hXXXX;
		EX1_RA <= 4'hX;
		EX1_INSTR <= 32'h00000000; // we could put 32'hXXXXXXXX but, we want to report a NOP in TimeSpace.txt
		EX1_MOV  <= 1'b0;
		EX1_SUB3 <= 1'b0; 
		EX1_ADD4 <= 1'b0; 
		EX1_ADD1 <= 1'b0; 
		EX1_XMEX1 <= 1'bX;
		EX1_XMEX2 <= 1'bX;
		
		// EX2 Stage
		EX2_XD <= 16'hXXXX;
		EX2_RA <= 4'hX;
		EX2_INSTR <= 32'h00000000; // we could put 32'hXXXXXXXX but, we want to report a NOP in TimeSpace.txt
		EX2_MOV  <= 1'b0;
		EX2_SUB3 <= 1'b0; 
		EX2_ADD4 <= 1'b0; 
		EX2_ADD1 <= 1'b0; 
		EX2_XMEX1 <= 1'bX;

		// WB Stage
		WB_RD <= 16'hXXXX;
		WB_INSTR <= 32'h00000000; // we could put 32'hXXXXXXXX but, we want to report a NOP in TimeSpace.txt
		WB_RA <= 4'hX;
		WB_WRITE <= 1'b0; // to see that a BUBBLE occupies the WB stage initially

	  end	
	  
	else // else if posedge CLK
	
	  begin
		// Please notice that we are producing the STALL signal
		// as an intermediate variable using blocking assignment
		// in the beginning of the else part of the statement, as
		// it is needed as an enable for the PC counter and the IF/ID stage register.
		
		// To produce STALL in ID stage, first we need to produce the outputs, ID_XMEX1 and ID_XMEX2, 
		// of the compare-station in ID stage using blocking assignments
		ID_XMEX1 = (ID_XA == EX1_RA);
		ID_XMEX2 = (ID_XA == EX2_RA); // This line can be shifted down (a little above the line producing EX1_XMEX2)
		STALL	 = 	(ID_XMEX1) // if the ID stage instruction's source register matches with the EX1 stage instruction's destination register
					& // and further
					(ID_SUB3 | ID_ADD1) // if the instruction in ID is a kind of instruction who will insist on receiving help at the beginning of the clock in EX1 itself when he reaches EX1
					& // and further
					(EX1_ADD4 | EX1_ADD1) // if the instruction in EX1 is a kind of instruction who will can't help at the beginning of the clock when he is in EX2 as he is still producing his result
					; // then we need to stall the dependent instruction in ID stage.
					// notice that we used the blocking assignment operator "=", and not the non-blocking assignment operator "<="
				
		if (~STALL) // if STALL is *not* true, the PC and the IF/ID registers may be updated.
		// Can we replace the above line with "if (~STALL_combinational)" ? YES!
		// But then, the STALL and the STALL_combinational, are quite different in the waveform.
		// True, but that is an artifact of RTL coding in HDL and the associated waveform display.
		// Please make sure you understand this point completely.
			begin

			// PC
			
				PC_OUT <= PC_OUT + 1;

			// IF stage logic and IF_ID stage register
				// IF stage logic
				IF_INSTR = memory[PC_OUT[5:0]]; // instruction is read from the instruction memory using blocking assignment
				// IF_ID stage register
				ID_XA <= IF_INSTR[3:0]; 
				ID_RA <= IF_INSTR[7:4];
				ID_MOV  <= IF_INSTR[31];
				ID_SUB3 <= IF_INSTR[30]; 
				ID_ADD4 <= IF_INSTR[29]; 
				ID_ADD1 <= IF_INSTR[28]; 
				ID_INSTR <= IF_INSTR; // carry the instruction for reverse assembling and displaying in Time-Space diagram
			end

		// The rest of the three stage registers ID/EX1, EX1/EX2, and EX2/WB are not controlled by the STALL signal.

		// ID stage logic and ID_EX1 stage register
			// ID stage logic
			ID_XD = reg_file[ID_XA]; // register content is read from the register file using blocking assignment
			// Note that the following line is commented out and is written at the beginning (just upstream of the STALL logic). 
			// ID_XMEX1 = (ID_XA == EX1_RA); // comparator in ID stage, notice the blocking assignment				
			// ID/EX1 stage register
			EX1_XD <= ID_XD;
			EX1_RA <= ID_RA;
			// We did not produce first ID_MOV_OUT,ID_SUB3_OUT,ID_ADD4_OUT,ID_ADD1_OUT as it is considered too much detailing!
			// ID_MOV_OUT = (~STALL) & ID_MOV;
			// EX1_MOV <=  ID_MOV_OUT; 
			// Instead of the above two lines, we have the following line.
			EX1_MOV <=  (~STALL) & ID_MOV;
			EX1_SUB3 <= (~STALL) & ID_SUB3; 
			EX1_ADD4 <= (~STALL) & ID_ADD4;
			EX1_ADD1 <= (~STALL) & ID_ADD1;
			EX1_XMEX1 <= ID_XMEX1;
			EX1_XMEX2 <= ID_XMEX2;
			if (STALL)
				EX1_INSTR <= {24'h0FFFFF,ID_INSTR[7:0]}; // carry a bubble into EX1 for reverse assembling and displaying in Time-Space diagram
				// Notice that, if the EX1_INSTR[31:8] is loaded with 24'h0FFFFF, the reverse assembler reports a "BUBBLE" (to distinguish from a NOP)
			else
				EX1_INSTR <= ID_INSTR; // carry the instruction for reverse assembling and displaying in Time-Space diagram

		// ************* Read and understand the important note below *********************
		
		// Notice that we coded EX2 stage logic first and then the EX1 stage logic.
		// There is an important observation to make. Since a MOV instruction in EX2 can help a dependent instruction in EX1, 
		// and probably the MOV instruction in EX2 itself is dependent on the instruction in WB, it is necessary for the
		// MOV instruction to receive help from WB first before it helps the instruction in EX1.
		// Hence, by coding the EX2 logic first, we are making sure that what we are forwarding to EX1 is already updated 
		// in the current clock.
		
		// So, are you saying that if no MOV instruction in EX2 is dependent on the instruction in WB, then we can code 
		// the EX2 logic after EX1 logic, and can still expect the MOV in EX2 to help the dependent instruction in EX1?
		// What about SUB3 in EX2 trying to help a dependent instruction in EX1? Does this require any ordering of 
		// coding of one stage logic before coding another stage logic? Is it really necessary to code one stage logic  
		// completely and then start coding the next stage logic or is it done just to improve readability?
		// May we consider all registers together constituting one big state memory (we call it SM when we discuss state
		// machines) and all combinational logics upstream of these registers (feeding data/control bits into these registers)
		// as one big next-state logic (NSL)? If so, may we code all the NSL first and then the SM next? Further may we 
		// recommend that care should be taken in ordering the statements in coding the NSL (of course using blocking assignments) 
		// to see that we do *not* consume a variable before producing it? In other words, we are saying that we need to first  
		// produce X2_Mux output (in EX2 stage logic) before forwarding it to the priority mux in EX1 stage. Similarly, we need
		// to first produce the priority mux output before sending it to the X1_mux (and code X1_mux output before sending it to 
		// SUB3, and so on). 
		// Then, what about coding the EX1/EX2 stage register before coding the X2_mux? Are we in a "catch-22" situation? 
		// It looks like a "catch-22" situation because, to code EX1/EX2 stage register, we need first the SKIP1 mux output,
		// which in-turn is dependent on X1_Mux output and so on. Fortunately that is not the case. All physical registers
		// (such as EX1/EX2 stage register) are coded (and should be coded) using non-blocking assignment. They all get updated 
		// together in one stroke after a delta-T after the clock edge. Before the clock-edge, the NSL produces and keeps ready
		// the data and/or the control bits need to go into these registers.
		
		// Conclusions (fill-in the blanks): 
		// Code __________ (SM/NSL) first and then __________ (SM/NSL).
		// Order of coding statements with-in the NSL: 
		// You are basically coding combinational logic. 
		// So, _____________ (produce/consume) an intermediate variable and then _____________ (produce/consume) it! 
		// Not the other way around!
		// Order of coding statements with-in the SM: 
		// Since state memory registers are (and should be) coded using ____________________________ (blocking/non-blocking) assignments, 
		// it ______________ (does / does not) matter in which order they are coded among themselves.
		// In a right-shift register, say QA is the left-most bit, QB is the middle bit, and QC is the right-most bit.
		// The following three statements ____________________________________________________________________________________________ 
		// (can be written in any order / should be written in the order shown below).
		// QA <= Serial_In;
		// QB <= QA;
		// QC <= QB;
		
		// ************* Read and understand the important note above *********************
		
		
		// EX2 stage logic and EX2_WB stage register
			// EX2 stage logic
			FORW2 = EX2_XMEX1 & (EX2_ADD4 | EX2_MOV) & WB_WRITE;
			if (FORW2)
				EX2_ADDER_IN = WB_RD;
			else
				EX2_ADDER_IN = EX2_XD;
			EX2_ADDER_OUT = EX2_ADDER_IN + (+4); // Add 4
			SKIP2 = ~(EX2_ADD1 | EX2_ADD4);
			if (SKIP2)
				EX2_XD_OUT = EX2_ADDER_IN;
			else			
				EX2_XD_OUT = EX2_ADDER_OUT;
			// EX2_WB stage register
			// WB_RD <= EX2_XD_OUT;
			// WB_RA <= EX2_RA;
			// WB_WRITE <= EX2_MOV | EX2_SUB3 | EX2_ADD4 | EX2_ADD1;	
			// WB_INSTR <= EX2_INSTR; // carry the instruction for reverse assembling and displaying in Time-Space diagram

			WB_EX2_ADDER_OUT <= EX2_ADDER_OUT;
			WB_EX2_ADDER_IN <= EX2_ADDER_IN;
			WB_SKIP2 <= SKIP2;
			WB_RA <= EX2_RA;
			WB_WRITE <= EX2_MOV | EX2_SUB3 | EX2_ADD4 | EX2_ADD1;	
			WB_INSTR <= EX2_INSTR;

		// EX1 stage logic and EX1_EX2 stage register
			// EX1 stage logic
			PRIORITY = EX1_XMEX1 & (EX2_SUB3 | EX2_MOV); // Note the blocking assignment operator "="
			FORW1 =  ((EX1_XMEX1 & (EX2_SUB3 | EX2_MOV)) | (EX1_XMEX2 & WB_WRITE) ); // Note the blocking assignment operator "="
			EX1_PRIO_XD = PRIORITY ? EX2_ADDER_IN : WB_RD;  // to support MOV instruction, it is EX2_ADDER_IN (and not EX2_XD)
			if (FORW1 == 1)
				EX1_ADDER_IN = EX1_PRIO_XD; // notice the blocking assignment
			else
				EX1_ADDER_IN = EX1_XD; // notice the blocking assignment
			EX1_ADDER_OUT = EX1_ADDER_IN + (-3); // Subtract 3 // notice the blocking assignment
			SKIP1 = (~(EX1_SUB3 | EX1_ADD1)); // notice the blocking assignment
			if (SKIP1 == 1)
				EX2_XD <= EX1_ADDER_IN; // notice the non-blocking assignment
			else
				EX2_XD <= EX1_ADDER_OUT; // notice the non-blocking assignment
				
			EX2_MOV <=  EX1_MOV;
			EX2_SUB3 <= EX1_SUB3; 
			EX2_ADD4 <= EX1_ADD4;
			EX2_ADD1 <= EX1_ADD1;
			EX2_RA   <= EX1_RA;
			EX2_XMEX1 <= EX1_XMEX1;
			EX2_INSTR <= EX1_INSTR; // carry the instruction for reverse assembling and displaying in Time-Space diagram

			
		// WB stage logic 
			// There isn't any logic here.
			// Not even a mux! 
			// In the 5-stage MIPS CPU, we have a mux controlled by Mem_to_Reg.
			if (WB_SKIP2) begin
				WB_RD <= WB_EX2_ADDER_IN;
			end
			else begin
				WB_RD <= WB_EX2_ADDER_OUT;
			end

	  end
  
  end

//--------------------------------------------------
endmodule