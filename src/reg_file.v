module reg_file (
	input             clk,
	input             reg_write,  // Write Enable
	input      [4:0]  rs1,        // Source Register 1 Address
	input      [4:0]  rs2,        // Source Register 2 Address
	input      [4:0]  rd,         // Destination Register Address
	input      [31:0] write_data, // Data to write
	output     [31:0] read_data1, // Data from rs1
	output     [31:0] read_data2  // Data from rs2
);
	reg [31:0] rf [31:0]; // 32 registers of 32 bits

	// Initialize registers to zero (optional but good for simulation)
	integer i;
	initial begin
		for (i = 0; i < 32; i = i + 1) begin
			rf[i] = 32'b0;
		end
	end

	// Synchronous Write: Only write on the rising edge of the clock
	// RISC-V Rule: x0 is hardwired to 0 and cannot be changed.
	always @(posedge clk) begin
		if (reg_write && rd != 5'b0) begin
			rf[rd] <= write_data;
		end
	end

	// Asynchronous Read: Outputs change immediately when rs1/rs2 change
	// Register x0 always returns 0
	assign read_data1 = (rs1 == 5'b0) ? 32'b0 : rf[rs1];
	assign read_data2 = (rs2 == 5'b0) ? 32'b0 : rf[rs2];

endmodule
