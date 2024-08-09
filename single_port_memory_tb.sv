//Single Port Memory tb 

module memory_tb;

parameter WIDTH=8;
parameter DEPTH=16;
parameter ADDR_WIDTH=$clog2(DEPTH);

reg clk;
reg reset;
reg valid;
reg wr_rd_en;
reg [ADDR_WIDTH-1:0] addr;
reg [WIDTH-1:0] wdata;

wire [WIDTH-1:0] rdata;
wire ready;

memory #(.WIDTH(WIDTH), .DEPTH(DEPTH)) dut_mem 
		(.clk(clk),
		.reset(reset),
		.valid(valid),
		.wr_rd_en(wr_rd_en),
		.addr(addr),
		.wdata(wdata),
		.rdata(rdata),
		.ready(ready)
		);

// Clock generation
initial begin
	clk = 1'b1;
	forever #5 clk=~clk;
end

// Stimulus
initial begin
	reset = 1;
	rst();
	@(posedge clk);
  	reset = 0;
	@(posedge clk);
	write_data_into_memory();
	read_data_from_memory();
	$finish();
end

// Reset task
task rst();
	clk = 0;
	addr = 0;
	wdata = 0;
	wr_rd_en = 0;
	valid = 0;
endtask

// Write task
task write_data_into_memory();
	for (int i=0;i<DEPTH;i++) begin
		@(posedge clk);
		addr = i;
		wdata = $urandom;
		wr_rd_en = 1;
		valid = 1;
		wait(ready==1);
	end
endtask 

// Read task
task read_data_from_memory();
	for(int i=0;i<DEPTH;i++) begin
		@(posedge clk);
		addr = i;
		wr_rd_en = 0;
		valid =1;
		wait(ready==1);
	end
endtask

initial begin
	$monitor("%0t wr_rd_en=%0d | addr=%0h, wdata=%0h, rdata=%0h", $time, wr_rd_en,addr,wdata,rdata);
end

// To generate waveforms in the simulator
initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
end

endmodule : memory_tb