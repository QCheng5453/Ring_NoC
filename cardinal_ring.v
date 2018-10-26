
`define PACKET_WIDTH 64
`define RESERVED_WIDTH 6
`define HOP_WIDTH 8
`define SOURCE_WIDTH 16
`define EVEN 1'b0
`define ODD 1'b1
`define CW 1'b0
`define CCW 1'b1
`define RESET_ACTIVE 1'b1
`define SO_RESET_VALUE 1'b0
`define RI_RESET_VALUE 1'b1
`define DATA_RESET_VALUE 0
`define PRI_CW_PE 1'b0
`define PRI_CCW_PE 1'b0
`define PRI_CW_CCW 1'b0
`define POLARITY_RESET_VALUE 1'b0
`define HANDSHAKING_ACTIVE 1'b1
`define DIR_CW 1'b0
`define DIR_CCW 1'b1
`define HOP_ZERO 1'b0
`define IDLE 1'b1
`define OCCUPIED 1'b0


module ring_router( clk, reset, polarity,
					cwsi, cwri, cwdi,
					cwso, cwro, cwdo,
					ccwsi, ccwri, ccwdi,
					ccwso, ccwro, ccwdo,
					pesi, peri, pedi,
					peso, pero, pedo);
input cwsi, cwro, ccwsi, ccwro, pesi, pero, clk, reset;
output reg cwri, cwso, ccwri, ccwso, peri, peso, polarity;
input [`PACKET_WIDTH-1:0] cwdi, ccwdi, pedi;
output reg [`PACKET_WIDTH-1:0] cwdo, ccwdo, pedo;
reg pe_priority, cw_priority, ccw_priority;
reg pe_vc, pe_dir;
reg cwi_even_status, cwi_odd_status, cwo_even_status, cwo_odd_status, ccwi_even_status, ccwi_odd_status, ccwo_even_status, ccwo_odd_status, pei_even_status, pei_odd_status, peo_even_status, peo_odd_status;
reg cw_valid, ccw_valid, pe_valid;
reg [`HOP_WIDTH-1:0] cw_hop_value, ccw_hop_value, pe_hop_value;
reg [`PACKET_WIDTH-1:0] cwdi_even, cwdi_odd, cwdo_even, cwdo_odd, ccwdi_even, ccwdi_odd, ccwdo_even, ccwdo_odd, pedi_even, pedi_odd, pedo_even, pedo_odd;

reg flag_cwo_even, flag_ccwo_even, flag_peo_even, flag_cwo_odd, flag_ccwo_odd, flag_peo_odd;
//output connection
always @(*) begin
	if (polarity == `EVEN) begin
	    //cw
		if(cwro == `HANDSHAKING_ACTIVE) begin
			if(cwo_even_status == `OCCUPIED) begin
				flag_cwo_even = 1'b1;
				cwdo = cwdo_even;
				cwso = `HANDSHAKING_ACTIVE;
			end
			else begin
			flag_cwo_even = 1'b0;
			cwso = ~`HANDSHAKING_ACTIVE;
			end
		end
		else begin
			flag_cwo_even = 1'b0;
			cwso = ~`HANDSHAKING_ACTIVE;
		end

		//ccw
		if(ccwro == `HANDSHAKING_ACTIVE) begin
			if(ccwo_even_status == `OCCUPIED) begin
				flag_ccwo_even = 1'b1;
				ccwdo = ccwdo_even;
				ccwso = `HANDSHAKING_ACTIVE;
			end
			else begin
				flag_ccwo_even = 1'b0;
				ccwso = ~`HANDSHAKING_ACTIVE;
			end
		end
		else begin
			flag_ccwo_even = 1'b0;
			ccwso = ~`HANDSHAKING_ACTIVE;
		end

		//pe
		if(pero == `HANDSHAKING_ACTIVE) begin
			if(peo_even_status == `OCCUPIED) begin
				flag_peo_even = 1'b1;
				pedo = pedo_even;
				peso = `HANDSHAKING_ACTIVE;
			end
			else begin
				flag_peo_even = 1'b0;
				peso = ~`HANDSHAKING_ACTIVE;
			end
		end
		else begin
			flag_peo_even = 1'b0;
			peso = ~`HANDSHAKING_ACTIVE;
		end

	end


	else begin//Odd polarity
	    //cw
		if(cwro == `HANDSHAKING_ACTIVE) begin
			if(cwo_odd_status == `OCCUPIED) begin
				flag_cwo_odd = 1'b1;
				cwdo = cwdo_odd;
				cwso = `HANDSHAKING_ACTIVE;
			end
			else begin
			flag_cwo_odd = 1'b0;
			cwso = ~`HANDSHAKING_ACTIVE;
			end
		end
		else begin
			flag_cwo_odd = 1'b0;
			cwso = ~`HANDSHAKING_ACTIVE;
		end

		//ccw
		if(ccwro == `HANDSHAKING_ACTIVE) begin
			if(ccwo_odd_status == `OCCUPIED) begin
				flag_ccwo_odd = 1'b1;
				ccwdo = ccwdo_odd;
				ccwso = `HANDSHAKING_ACTIVE;
			end
			else begin
				flag_ccwo_odd = 1'b0;
				ccwso = ~`HANDSHAKING_ACTIVE;

			end
		end
		else begin
			flag_ccwo_odd = 1'b0;
			ccwso = ~`HANDSHAKING_ACTIVE;
		end

		//pe
		if(pero == `HANDSHAKING_ACTIVE) begin
			if(peo_odd_status == `OCCUPIED) begin
				flag_peo_odd = 1'b1;
				pedo = pedo_odd;
				peso = `HANDSHAKING_ACTIVE;
			end
			else begin
				flag_peo_odd = 1'b0;
				peso = ~`HANDSHAKING_ACTIVE;
			end
		end
		else begin
			flag_peo_odd = 1'b0;
			peso = ~`HANDSHAKING_ACTIVE;
		end

	end
end




always @(posedge clk) begin
	if(reset == `RESET_ACTIVE) begin
		// so reset
//		cwso = `SO_RESET_VALUE;
//		ccwso = `SO_RESET_VALUE;
//		peso = `SO_RESET_VALUE;
		// ri reset
		cwri <= `RI_RESET_VALUE;
		ccwri <= `RI_RESET_VALUE;
		peri <= `RI_RESET_VALUE;
		// priority reset
		cw_priority <= `PRI_CW_PE;
		ccw_priority <= `PRI_CCW_PE;
		pe_priority <= `PRI_CW_CCW;
		// data reset
//		cwdo = `DATA_RESET_VALUE;
//		ccwdo = `DATA_RESET_VALUE;
//		pedo = `DATA_RESET_VALUE;
		cwdi_even <= `DATA_RESET_VALUE;
		cwdi_odd <= `DATA_RESET_VALUE;
		cwdo_even <= `DATA_RESET_VALUE;
		cwdo_odd <= `DATA_RESET_VALUE;
		ccwdi_even <= `DATA_RESET_VALUE;
		ccwdi_odd <= `DATA_RESET_VALUE;
		ccwdo_even <= `DATA_RESET_VALUE;
		ccwdo_odd <= `DATA_RESET_VALUE;
		pedi_even <= `DATA_RESET_VALUE;
		pedi_odd <= `DATA_RESET_VALUE;
		pedo_even <= `DATA_RESET_VALUE;
		pedo_odd <= `DATA_RESET_VALUE;
		// polarity reset
		polarity = `POLARITY_RESET_VALUE;
		// register validation reset
		cw_valid <= ~`HANDSHAKING_ACTIVE;
		ccw_valid <= ~`HANDSHAKING_ACTIVE;
		pe_valid <= ~`HANDSHAKING_ACTIVE;
		{cwi_even_status, cwi_odd_status, cwo_even_status, cwo_odd_status, ccwi_even_status, ccwi_odd_status, ccwo_even_status, ccwo_odd_status, pei_even_status, pei_odd_status, peo_even_status, peo_odd_status} <= 12'hfff;
	end
	else begin
		polarity = ~polarity;
		// cw_valid = ~`HANDSHAKING_ACTIVE;
		// ccw_valid = ~`HANDSHAKING_ACTIVE;
		// pe_valid = ~`HANDSHAKING_ACTIVE;
		// even
		if(polarity == `EVEN) begin
			// input buffers
			if(cwsi == `HANDSHAKING_ACTIVE) begin
				if(cwi_odd_status == `IDLE) begin
					cwdi_odd <= cwdi;
					//cw_hop_value <= cwdi[`PACKET_WIDTH-9:`PACKET_WIDTH-16];
					cwi_odd_status <= `OCCUPIED;
				end
			end
			if(ccwsi == `HANDSHAKING_ACTIVE) begin
				if(ccwi_odd_status == `IDLE) begin
					ccwdi_odd <= ccwdi;
					//ccw_hop_value <= ccwdi[`PACKET_WIDTH-9:`PACKET_WIDTH-16];
					ccwi_odd_status <= `OCCUPIED;
				end
			end
			if(pesi == `HANDSHAKING_ACTIVE) begin
				if(pei_odd_status == `IDLE) begin
					pedi_odd <= pedi;
					//pe_vc <= pedi[`PACKET_WIDTH-1];
					//pe_dir <= pedi[`PACKET_WIDTH-2];
					//pe_hop_value <= pedi[`PACKET_WIDTH-9:`PACKET_WIDTH-16];
					pei_odd_status <= `OCCUPIED;
				end
			end
			cwri <= cwi_odd_status;
			ccwri <= ccwi_odd_status;
			peri <= pei_odd_status;
			//inner connections
			// cw out
			if(cwo_even_status == `IDLE) begin
				if(cwi_even_status == `OCCUPIED && cwdi_even[`PACKET_WIDTH-16] != `HOP_ZERO) begin
					if(pei_even_status == `OCCUPIED && pedi_even[`PACKET_WIDTH-2] == `DIR_CW ) begin
						// contention ocurrs
						if(cw_priority == `PRI_CW_PE) begin
//						  	cwdo_even <= cwdi_even;
							cwdo_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= cwdi_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
							cwdo_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= cwdi_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
							cwdo_even[`PACKET_WIDTH-17:0] <= cwdi_even[`PACKET_WIDTH-17:0];
							cwi_even_status <= `IDLE;
//							cwo_even_status <= `OCCUPIED;
						end
						else begin
//							cwdo_even <= pedi_even;
							cwdo_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= pedi_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
							cwdo_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= pedi_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
							cwdo_even[`PACKET_WIDTH-17:0] <= pedi_even[`PACKET_WIDTH-17:0];
							pei_even_status <= `IDLE;
//							cwo_even_status <= `OCCUPIED;
						end
						cw_priority <= ~cw_priority;
					end
					else begin
//						cwdo_even <= cwdi_even;
						cwdo_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= cwdi_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
						cwdo_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= cwdi_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
						cwdo_even[`PACKET_WIDTH-17:0] <= cwdi_even[`PACKET_WIDTH-17:0];
						cwi_even_status <= `IDLE;
//						cwo_even_status <= `OCCUPIED;
					end
					cwo_even_status <= `OCCUPIED;
				end
				else if(pei_even_status == `OCCUPIED && pedi_even[`PACKET_WIDTH-2] == `DIR_CW) begin
//					cwdo_even <= pedi_even;
					cwdo_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= pedi_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
					cwdo_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= pedi_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
					cwdo_even[`PACKET_WIDTH-17:0] <= pedi_even[`PACKET_WIDTH-17:0];
					pei_even_status <= `IDLE;
					cwo_even_status <= `OCCUPIED;
				end
			end

			// ccw out
			if(ccwo_even_status == `IDLE) begin
				if(ccwi_even_status == `OCCUPIED && ccwdi_even[`PACKET_WIDTH-16] != `HOP_ZERO) begin
					if(pei_even_status == `OCCUPIED && pedi_even[`PACKET_WIDTH-2] == `DIR_CCW ) begin
						// contention ocurrs
						if(ccw_priority == `PRI_CCW_PE) begin
//						  	ccwdo_even <= ccwdi_even;
							ccwdo_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= ccwdi_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
							ccwdo_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= ccwdi_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
							ccwdo_even[`PACKET_WIDTH-17:0] <= ccwdi_even[`PACKET_WIDTH-17:0];
							ccwi_even_status <= `IDLE;
//							ccwo_even_status <= `OCCUPIED;
						end
						else begin
//							ccwdo_even <= pedi_even;
							ccwdo_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= pedi_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
							ccwdo_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= pedi_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
							ccwdo_even[`PACKET_WIDTH-17:0] <= pedi_even[`PACKET_WIDTH-17:0];
							pei_even_status <= `IDLE;
//							ccwo_even_status <= `OCCUPIED;
						end
						ccw_priority <= ~ccw_priority;
					end
					else begin
//						ccwdo_even <= ccwdi_even;
						ccwdo_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= ccwdi_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
						ccwdo_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= ccwdi_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
						ccwdo_even[`PACKET_WIDTH-17:0] <= ccwdi_even[`PACKET_WIDTH-17:0];
						ccwi_even_status <= `IDLE;
//						ccwo_even_status <= `OCCUPIED;
					end
					ccwo_even_status <= `OCCUPIED;
				end
				else if(pei_even_status == `OCCUPIED && pedi_even[`PACKET_WIDTH-2] == `DIR_CCW) begin
//					ccwdo_even <= pedi_even;
					ccwdo_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= pedi_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
					ccwdo_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= pedi_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
					ccwdo_even[`PACKET_WIDTH-17:0] <= pedi_even[`PACKET_WIDTH-17:0];
					pei_even_status <= `IDLE;
					ccwo_even_status <= `OCCUPIED;
				end
			end

			// pe out
			if(peo_even_status == `IDLE) begin
				if(cwi_even_status == `OCCUPIED && cwdi_even[`PACKET_WIDTH-16] == `HOP_ZERO) begin
					if(ccwi_even_status == `OCCUPIED && ccwdi_even[`PACKET_WIDTH-16] == `HOP_ZERO) begin
						// contention ocurrs
						if(pe_priority == `PRI_CW_CCW) begin
//						  	pedo_even <= cwdi_even;
							pedo_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= cwdi_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
							pedo_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= cwdi_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
							pedo_even[`PACKET_WIDTH-17:0] <= cwdi_even[`PACKET_WIDTH-17:0];
							cwi_even_status <= `IDLE;
						end
						else begin
//							pedo_even <= ccwdi_even;
							pedo_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= ccwdi_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
							pedo_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= ccwdi_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
							pedo_even[`PACKET_WIDTH-17:0] <= ccwdi_even[`PACKET_WIDTH-17:0];
							ccwi_even_status <= `IDLE;
						end
						pe_priority <= ~pe_priority;
					end
					// cw valid, ccw invalid
					else begin
//						pedo_even <= cwdi_even;
						pedo_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= cwdi_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
						pedo_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= cwdi_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
						pedo_even[`PACKET_WIDTH-17:0] <= cwdi_even[`PACKET_WIDTH-17:0];
						cwi_even_status <= `IDLE;
					end
					peo_even_status <= `OCCUPIED;
				end
				// cw invalid, ccw valid
				else if(ccwi_even_status == `OCCUPIED && ccwdi_even[`PACKET_WIDTH-16] == `HOP_ZERO) begin
//					pedo_even <= ccwdi_even;
					ccwi_even_status <= `IDLE;
					peo_even_status <= `OCCUPIED;
					pedo_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= ccwdi_even[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
					pedo_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= ccwdi_even[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
					pedo_even[`PACKET_WIDTH-17:0] <= ccwdi_even[`PACKET_WIDTH-17:0];
				end
			end

			//output flag
			if (flag_cwo_odd) begin
//				cwso <= `HANDSHAKING_ACTIVE;
				cwo_odd_status <= `IDLE;
			end
//			else begin
//				cwso <= ~`HANDSHAKING_ACTIVE;
//			end

			if (flag_ccwo_odd) begin
//				ccwso <= `HANDSHAKING_ACTIVE;
				ccwo_odd_status <= `IDLE;
			end
//			else begin
//				ccwso <= ~`HANDSHAKING_ACTIVE;
//			end

			if (flag_peo_odd) begin
//				peso <= `HANDSHAKING_ACTIVE;
				peo_odd_status <= `IDLE;
			end
//			else begin
//				peso <= ~`HANDSHAKING_ACTIVE;
//			end


		end
		// odd
		else begin
			// input buffers
			if(cwsi == `HANDSHAKING_ACTIVE) begin
				if(cwi_even_status == `IDLE) begin
					cwdi_even <= cwdi;
					//cw_hop_value <= cwdi[`PACKET_WIDTH-9:`PACKET_WIDTH-16];
					cwi_even_status <= `OCCUPIED;
				end
			end
			if(ccwsi == `HANDSHAKING_ACTIVE) begin
				if(ccwi_even_status == `IDLE) begin
					ccwdi_even <= ccwdi;
					//ccw_hop_value <= ccwdi[`PACKET_WIDTH-9:`PACKET_WIDTH-16];
					ccwi_even_status <= `OCCUPIED;
				end
			end
			if(pesi == `HANDSHAKING_ACTIVE) begin
				if(pei_even_status == `IDLE) begin
					pedi_even <= pedi;
					//pe_vc <= pedi[`PACKET_WIDTH-1];
					//pe_dir <= pedi[`PACKET_WIDTH-2];
					//pe_hop_value <= pedi[`PACKET_WIDTH-9:`PACKET_WIDTH-16];
					pei_even_status <= `OCCUPIED;
				end
			end
			cwri <= cwi_even_status;
			ccwri <= ccwi_even_status;
			peri <= pei_even_status;


			//inner connections
			// cw out
			if(cwo_odd_status == `IDLE) begin
				if(cwi_odd_status == `OCCUPIED && cwdi_odd[`PACKET_WIDTH-16] != `HOP_ZERO) begin
					if(pei_odd_status == `OCCUPIED && pedi_odd[`PACKET_WIDTH-2] == `DIR_CW ) begin
						// contention ocurrs
						if(cw_priority == `PRI_CW_PE) begin
//						  	cwdo_odd <= cwdi_odd;
							cwdo_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= cwdi_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
							cwdo_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= cwdi_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
							cwdo_odd[`PACKET_WIDTH-17:0] <= cwdi_odd[`PACKET_WIDTH-17:0];
							cwi_odd_status <= `IDLE;
//							cwo_odd_status <= `OCCUPIED;
						end
						else begin
//							cwdo_odd <= pedi_odd;
							cwdo_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= pedi_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
							cwdo_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= pedi_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
							cwdo_odd[`PACKET_WIDTH-17:0] <= pedi_odd[`PACKET_WIDTH-17:0];
							pei_odd_status <= `IDLE;
//							cwo_odd_status <= `OCCUPIED;
						end
						cw_priority <= ~cw_priority;
					end
					else begin
//						cwdo_odd <= cwdi_odd;
						cwdo_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= cwdi_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
						cwdo_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= cwdi_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
						cwdo_odd[`PACKET_WIDTH-17:0] <= cwdi_odd[`PACKET_WIDTH-17:0];
						cwi_odd_status <= `IDLE;
//						cwo_odd_status <= `OCCUPIED;
					end
					cwo_odd_status <= `OCCUPIED;
				end
				else if(pei_odd_status == `OCCUPIED && pedi_odd[`PACKET_WIDTH-2] == `DIR_CW) begin
//					cwdo_odd <= pedi_odd;
					cwdo_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= pedi_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
					cwdo_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= pedi_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
					cwdo_odd[`PACKET_WIDTH-17:0] <= pedi_odd[`PACKET_WIDTH-17:0];
					pei_odd_status <= `IDLE;
					cwo_odd_status <= `OCCUPIED;
				end
			end

			// ccw out
			if(ccwo_odd_status == `IDLE) begin
				if(ccwi_odd_status == `OCCUPIED && ccwdi_odd[`PACKET_WIDTH-16] != `HOP_ZERO) begin
					if(pei_odd_status == `OCCUPIED && pedi_odd[`PACKET_WIDTH-2] == `DIR_CCW ) begin
						// contention ocurrs
						if(ccw_priority == `PRI_CCW_PE) begin
//						  	ccwdo_odd <= ccwdi_odd;
							ccwdo_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= ccwdi_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
							ccwdo_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= ccwdi_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
							ccwdo_odd[`PACKET_WIDTH-17:0] <= ccwdi_odd[`PACKET_WIDTH-17:0];
							ccwi_odd_status <= `IDLE;
//							ccwo_odd_status <= `OCCUPIED;
						end
						else begin
//							ccwdo_odd <= pedi_odd;
							ccwdo_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= pedi_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
							ccwdo_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= pedi_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
							ccwdo_odd[`PACKET_WIDTH-17:0] <= pedi_odd[`PACKET_WIDTH-17:0];
							pei_odd_status <= `IDLE;
//							ccwo_odd_status <= `OCCUPIED;
						end
						ccw_priority <= ~ccw_priority;
					end
					else begin
//						ccwdo_odd <= ccwdi_odd;
						ccwdo_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= ccwdi_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
						ccwdo_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= ccwdi_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
						ccwdo_odd[`PACKET_WIDTH-17:0] <= ccwdi_odd[`PACKET_WIDTH-17:0];
						ccwi_odd_status <= `IDLE;
//						ccwo_odd_status <= `OCCUPIED;
					end
					ccwo_odd_status <= `OCCUPIED;
				end
				else if(pei_odd_status == `OCCUPIED && pedi_odd[`PACKET_WIDTH-2] == `DIR_CCW) begin
//					ccwdo_odd <= pedi_odd;
					ccwdo_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= pedi_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
					ccwdo_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= pedi_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
					ccwdo_odd[`PACKET_WIDTH-17:0] <= pedi_odd[`PACKET_WIDTH-17:0];
					pei_odd_status <= `IDLE;
					ccwo_odd_status <= `OCCUPIED;
				end
			end

			// pe out
			if(peo_odd_status == `IDLE) begin
				if(cwi_odd_status == `OCCUPIED && cwdi_odd[`PACKET_WIDTH-16] == `HOP_ZERO) begin
					if(ccwi_odd_status == `OCCUPIED && ccwdi_odd[`PACKET_WIDTH-16] == `HOP_ZERO) begin
						// contention ocurrs
						if(pe_priority == `PRI_CW_CCW) begin
//						  	pedo_odd <= cwdi_odd;
							pedo_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= cwdi_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
							pedo_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= cwdi_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
							pedo_odd[`PACKET_WIDTH-17:0] <= cwdi_odd[`PACKET_WIDTH-17:0];
							cwi_odd_status <= `IDLE;
						end
						else begin
//							pedo_odd <= ccwdi_odd;
							pedo_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= ccwdi_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
							pedo_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= ccwdi_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
							pedo_odd[`PACKET_WIDTH-17:0] <= ccwdi_odd[`PACKET_WIDTH-17:0];
							ccwi_odd_status <= `IDLE;
						end
						pe_priority <= ~pe_priority;
					end
					// cw valid, ccw invalid
					else begin
//						pedo_odd <= cwdi_odd;
						pedo_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= cwdi_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
						pedo_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= cwdi_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
						pedo_odd[`PACKET_WIDTH-17:0] <= cwdi_odd[`PACKET_WIDTH-17:0];
						cwi_odd_status <= `IDLE;
					end
					peo_odd_status <= `OCCUPIED;
				end
				// cw invalid, ccw valid
				else if(ccwi_odd_status == `OCCUPIED && ccwdi_odd[`PACKET_WIDTH-16] == `HOP_ZERO) begin
//					pedo_odd <= ccwdi_odd;
					ccwi_odd_status <= `IDLE;
					peo_odd_status <= `OCCUPIED;
					pedo_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8] <= ccwdi_odd[`PACKET_WIDTH-1:`PACKET_WIDTH-8];
					pedo_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16] <= ccwdi_odd[`PACKET_WIDTH-9:`PACKET_WIDTH-16]>>1'b1;
					pedo_odd[`PACKET_WIDTH-17:0] <= ccwdi_odd[`PACKET_WIDTH-17:0];
				end
			end
//          out flag
			if (flag_cwo_even) begin
//				cwso <= `HANDSHAKING_ACTIVE;
				cwo_even_status <= `IDLE;
			end
//			else begin
//				cwso <= ~`HANDSHAKING_ACTIVE;
//			end

			if (flag_ccwo_even) begin
//				ccwso <= `HANDSHAKING_ACTIVE;
				ccwo_even_status <= `IDLE;
			end
//			else begin
//				ccwso <= ~`HANDSHAKING_ACTIVE;
//			end

			if (flag_peo_even) begin
//				peso <= `HANDSHAKING_ACTIVE;
				peo_even_status <= `IDLE;
			end
//			else begin
//				peso <= ~`HANDSHAKING_ACTIVE;
//			end


		end
	end
end
endmodule

module cardinal_ring(	clk, reset,
						pesi0, peri0, pedi0, peso0, pero0, pedo0, polarity0,
						pesi1, peri1, pedi1, peso1, pero1, pedo1, polarity1,
						pesi2, peri2, pedi2, peso2, pero2, pedo2, polarity2,
						pesi3, peri3, pedi3, peso3, pero3, pedo3, polarity3
);
input clk, reset;
input pesi0, pero0, pesi1, pero1, pesi2, pero2, pesi3, pero3;
input [`PACKET_WIDTH-1:0] pedi0, pedi1, pedi2, pedi3;
output peri0, peso0, peri1, peso1, peri2, peso2, peri3, peso3;
output [`PACKET_WIDTH-1:0] pedo0, pedo1, pedo2, pedo3;
output wire polarity0, polarity1, polarity2, polarity3;
wire cwsi0, cwsi1, cwsi2, cwsi3, cwri0, cwri1, cwri2, cwri3, ccwsi0, ccwsi1, ccwsi2, ccwsi3, ccwri0, ccwri1, ccwri2, ccwri3;
wire [`PACKET_WIDTH-1:0] cwdi0, cwdi1, cwdi2, cwdi3, ccwdi0, ccwdi1, ccwdi2, ccwdi3;

ring_router rr0(clk, reset, polarity0, cwsi0, cwri0, cwdi0, cwsi1, cwri1, cwdi1, ccwsi0, ccwri0, ccwdi0, ccwsi3, ccwri3, ccwdi3, pesi0, peri0, pedi0, peso0, pero0, pedo0);
ring_router rr1(clk, reset, polarity1, cwsi1, cwri1, cwdi1, cwsi2, cwri2, cwdi2, ccwsi1, ccwri1, ccwdi1, ccwsi0, ccwri0, ccwdi0, pesi1, peri1, pedi1, peso1, pero1, pedo1);
ring_router rr2(clk, reset, polarity2, cwsi2, cwri2, cwdi2, cwsi3, cwri3, cwdi3, ccwsi2, ccwri2, ccwdi2, ccwsi1, ccwri1, ccwdi1, pesi2, peri2, pedi2, peso2, pero2, pedo2);
ring_router rr3(clk, reset, polarity3, cwsi3, cwri3, cwdi3, cwsi0, cwri0, cwdi0, ccwsi3, ccwri3, ccwdi3, ccwsi2, ccwri2, ccwdi2, pesi3, peri3, pedi3, peso3, pero3, pedo3);

endmodule // four_nodes_ring
