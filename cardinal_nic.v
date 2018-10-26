`define PACKET_WIDTH 64
`define NIC_ADDR_WIDTH 2
`define EVEN 1'b0
`define ODD 1'b1
`define FULL 1'b1 //valid data
`define EMPTY 1'b0 //invalid data


module cardinal_nic(clk, reset,
					addr, d_in, d_out,
					nicEn, nicWrEn,
					net_so, net_ro, net_do,
					net_si,net_ri, net_di,
					net_polarity );

input clk, reset, nicEn, nicWrEn, net_ro, net_polarity, net_si;
input [0: `NIC_ADDR_WIDTH-1] addr;
input [0: `PACKET_WIDTH-1] d_in, net_di;
output reg net_so, net_ri;
output reg [0:`PACKET_WIDTH-1] net_do, d_out;
reg [0:`PACKET_WIDTH-1] output_buffer, input_buffer;
reg output_buffer_status, input_buffer_status;

//reg [0:1] addr_1,addr_2;

//reg processor_read_flag;
//reg processor_read_flag_2;
//reg [0:1] addr_last;

always @(posedge clk) begin
	if (reset) begin
		output_buffer <= 64'h0;
		input_buffer  <= 64'h0;
		d_out <= 64'h0;
		net_so <= 1'b0;
//		net_do <= 64'h0;
//		processor_read_flag <= 1'b0;
		output_buffer_status <= `EMPTY;
		input_buffer_status  <= `EMPTY;
	end
	else begin

		//write input_buffer -router handshake
		if (net_si) begin
			if (input_buffer_status == `EMPTY) begin
				input_buffer <= net_di;
				input_buffer_status <= `FULL;
			end
		end

		// send output buffer data to router -router handshake
		if (net_ro == 1'b1) begin
			if ( output_buffer[0] == net_polarity) begin
				if (output_buffer_status == `FULL) begin
					net_so <= 1'b1;
//					net_do <= output_buffer;
					output_buffer_status <= `EMPTY;
				end
			end
			else begin
				net_so <= 1'b0;
			end
		end
		else begin
			net_so <= 1'b0;
		end


		//processor read & output_buffer write -processor hanshake
		if (nicEn) begin
			if (nicWrEn) begin 	//write output_buffer,don't need to check buffer status here,because cpu will read output_buffer_status at last clk.
				if (output_buffer_status == `EMPTY) begin //check again in case of error
					output_buffer <= d_in;
					output_buffer_status <= `FULL;
//					processor_read_flag <= 1'b0;
//					processor_read_flag_2 <= processor_read_flag;
				end
			end

			else begin //processor read operation flag, when nicWrEn is low
//-----------------------------------------------
//				processor_read_flag <= 1'b1;
//				processor_read_flag_2 <= processor_read_flag;
//				if (addr == 2'b00) begin //after processor get the input_buffer data, it's empty again
//					input_buffer_status <= `EMPTY;
//---------------------------------------------------
				case(addr)
				2'b00:begin
						d_out <= input_buffer;
						input_buffer_status <= `EMPTY; end
				2'b01: begin
						d_out[`PACKET_WIDTH-1] <= input_buffer_status;
						d_out[0:`PACKET_WIDTH-2]<=63'h0; end
				2'b10: begin
						d_out <= output_buffer; end
				2'b11: begin
						d_out[`PACKET_WIDTH-1]  <=  output_buffer_status;
						d_out[0:`PACKET_WIDTH-2] <= 63'h0; end
				endcase

			end
		end
//		else begin
//			processor_read_flag <= 1'b0;
//			processor_read_flag_2 <= processor_read_flag;
//		end
	end

//	processor_read_flag_2 <= processor_read_flag;
//	addr_1 <= addr;
//	addr_2 <= addr_1;
end

always @(*) begin
//read request from processor

//net ri
	net_ri = ~input_buffer_status;

//net_do
	net_do = output_buffer;

end


endmodule
