module alu(
	input  [31:0] a,
	input  [31:0] b,
	input  [4:0]  shamt,       // Shift amount (only 5 bits needed for 32-bit words)
	input  [3:0]  alu_control,
	output reg [31:0] result,
	output        zero
);
	assign zero = (result == 0);

	// In RISC-V, shift amounts are typically taken from the 5 lower bits of 'b' 
	// or an immediate value. I'll use b[4:0] directly inside the case for simplicity.

	always @(*) begin
		case (alu_control)
			4'b0000: result = a + b;                      // ADD
			4'b1000: result = a - b;                      // SUB
			4'b0001: result = a << b[4:0];                // SLL (Shift Left Logical)
			4'b0010: result = ($signed(a) < $signed(b)) ? 32'b1 : 32'b0; // SLT (Set Less Than)
			4'b0011: result = (a < b) ? 32'b1 : 32'b0;    // SLTU (Set Less Than Unsigned)
			4'b0100: result = a ^ b;                      // XOR
			4'b0101: result = a >> b[4:0];                // SRL (Shift Right Logical)
			4'b1101: result = $signed(a) >>> b[4:0];      // SRA (Shift Right Arithmetic)
			4'b0110: result = a | b;                      // OR
			4'b0111: result = a & b;                      // AND
			default: result = 32'b0;
		endcase
	end

endmodule
