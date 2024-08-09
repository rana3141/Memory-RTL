// Simple single port memory

module memory#(parameter WIDTH=8,DEPTH=16,ADDR_WIDTH=$clog2(DEPTH))(
			input clk, 
			input reset, 
			input wr_rd_en, 
			input valid, 
			input [ADDR_WIDTH-1:0] addr, 
			input [WIDTH-1:0] wdata, 
			output reg [WIDTH-1:0] rdata,
			output reg ready_o);

// Declare memory
reg [WIDTH-1:0] mem [DEPTH-1:0];

always @(posedge clk) begin
	if (reset) begin
		ready_o <= 0;
		rdata <= 0;
		for(int i=0;i<DEPTH;i++) begin
			mem[i] = 0;
		end
	end
	else begin
		if (valid==1) begin 			//handshaking 
			ready_o <= 1;
			if (wr_rd_en) begin
				mem[addr] = wdata;		//write data
			end
			else begin
				rdata <= mem[addr];		//read data
			end
		end
	end
end

endmodule : memory