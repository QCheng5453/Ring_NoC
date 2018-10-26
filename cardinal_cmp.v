 `include "./design/cardinal_nic.v"
 `include "./design/cardinal_ring.v"

`define WORD 32
`define HALF_WORD 16
`define DOUBLE_WORD 64
`define INSTR_WIDTH 32
`define WORD_ADDRESS 5
`define WW_WIDTH    2
`define TYPE_R 1'b0
`define TYPE_M 1'b1
`define IMEM_SIZE 8
`define DMEM_SIZE 8
`define RF_SIZE 32
`define ENABLED 1'b1
`define DISENABLED 1'b0
`define RF_RESET_VALUE 64'h0000_0000_0000_0000
`define OP_VAND     32'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXX1
`define OP_VOR      32'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XX1X
`define OP_VXOR     32'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_X1XX
`define OP_VNOT     32'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_1XXX
`define OP_VMOV     32'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXX1_XXXX
`define OP_VADD     32'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XX1X_XXXX
`define OP_VSUB     32'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_X1XX_XXXX
`define OP_VMULEU   32'bXXXX_XXXX_XXXX_XXXX_XXXX_XXXX_1XXX_XXXX
`define OP_VMULOU   32'bXXXX_XXXX_XXXX_XXXX_XXXX_XXX1_XXXX_XXXX
`define OP_VSLL     32'bXXXX_XXXX_XXXX_XXXX_XXXX_XX1X_XXXX_XXXX
`define OP_VSRL     32'bXXXX_XXXX_XXXX_XXXX_XXXX_X1XX_XXXX_XXXX
`define OP_VSRA     32'bXXXX_XXXX_XXXX_XXXX_XXXX_1XXX_XXXX_XXXX
`define OP_VRTTH    32'bXXXX_XXXX_XXXX_XXXX_XXX1_XXXX_XXXX_XXXX
`define OP_VDIV     32'bXXXX_XXXX_XXXX_XXXX_XX1X_XXXX_XXXX_XXXX
`define OP_VMOD     32'bXXXX_XXXX_XXXX_XXXX_X1XX_XXXX_XXXX_XXXX
`define OP_VSQEU    32'bXXXX_XXXX_XXXX_XXXX_1XXX_XXXX_XXXX_XXXX
`define OP_VSQOU    32'bXXXX_XXXX_XXXX_XXX1_XXXX_XXXX_XXXX_XXXX
`define OP_VSQRT    32'bXXXX_XXXX_XXXX_XX1X_XXXX_XXXX_XXXX_XXXX
`define OP_VLD      32'bXXXX_XXXX_XXXX_X1XX_XXXX_XXXX_XXXX_XXXX
`define OP_VSD      32'bXXXX_XXXX_XXXX_1XXX_XXXX_XXXX_XXXX_XXXX
`define OP_VBEZ     32'bXXXX_XXXX_XXX1_XXXX_XXXX_XXXX_XXXX_XXXX
`define OP_VBNEZ    32'bXXXX_XXXX_XX1X_XXXX_XXXX_XXXX_XXXX_XXXX
`define OP_VNOP     32'bXXXX_XXXX_X1XX_XXXX_XXXX_XXXX_XXXX_XXXX

`define VAND     32'b0000_0000_0000_0000_0000_0000_0000_0001
`define VOR      32'b0000_0000_0000_0000_0000_0000_0000_0010
`define VXOR     32'b0000_0000_0000_0000_0000_0000_0000_0100
`define VNOT     32'b0000_0000_0000_0000_0000_0000_0000_1000
`define VMOV     32'b0000_0000_0000_0000_0000_0000_0001_0000
`define VADD     32'b0000_0000_0000_0000_0000_0000_0010_0000
`define VSUB     32'b0000_0000_0000_0000_0000_0000_0100_0000
`define VMULEU   32'b0000_0000_0000_0000_0000_0000_1000_0000
`define VMULOU   32'b0000_0000_0000_0000_0000_0001_0000_0000
`define VSLL     32'b0000_0000_0000_0000_0000_0010_0000_0000
`define VSRL     32'b0000_0000_0000_0000_0000_0100_0000_0000
`define VSRA     32'b0000_0000_0000_0000_0000_1000_0000_0000
`define VRTTH    32'b0000_0000_0000_0000_0001_0000_0000_0000
`define VDIV     32'b0000_0000_0000_0000_0010_0000_0000_0000
`define VMOD     32'b0000_0000_0000_0000_0100_0000_0000_0000
`define VSQEU    32'b0000_0000_0000_0000_1000_0000_0000_0000
`define VSQOU    32'b0000_0000_0000_0001_0000_0000_0000_0000
`define VSQRT    32'b0000_0000_0000_0010_0000_0000_0000_0000
`define VLD      32'b0000_0000_0000_0100_0000_0000_0000_0000
`define VSD      32'b0000_0000_0000_1000_0000_0000_0000_0000
`define VBEZ     32'b0000_0000_0001_0000_0000_0000_0000_0000
`define VBNEZ    32'b0000_0000_0010_0000_0000_0000_0000_0000
`define VNOP     32'b0000_0000_0100_0000_0000_0000_0000_0000

//`include "/usr/local/synopsys/2011.09/dw/sim_ver"

module program_counter (input clk, reset, write_en,
                        input [0:`WORD-1] pc_in,
                        output reg [0:`WORD-1] pc_out);
always @(posedge clk) begin
    if (reset) begin
        pc_out <= 32'h0000_0000;
    end
    else begin
        // for branch control
        if (write_en) begin
            pc_out <= pc_in;
        end
        else begin
            pc_out <= pc_out + 4;
        end
    end
end
endmodule //program_counter

module instruction_decoder (input [0:`INSTR_WIDTH-1] instruction,
                            output reg instruction_type,
                            output reg [0:`WW_WIDTH-1] operand_width,
                            output reg [0:`WORD-1] operation);
always @ ( * ) begin
    operand_width = instruction[`INSTR_WIDTH-8:`INSTR_WIDTH-7];
    instruction_type = `TYPE_R;
    case (instruction[0:5])
        6'b101010: begin
            case (instruction[`INSTR_WIDTH-6:`INSTR_WIDTH-1])
                6'b000001: operation = `VAND;
                6'b000010: operation = `VOR;
                6'b000011: operation = `VXOR;
                6'b000100: operation = `VNOT;
                6'b000101: operation = `VMOV;
                6'b000110: operation = `VADD;
                6'b000111: operation = `VSUB;
                6'b001000: operation = `VMULEU;
                6'b001001: operation = `VMULOU;
                6'b001010: operation = `VSLL;
                6'b001011: operation = `VSRL;
                6'b001100: operation = `VSRA;
                6'b001101: operation = `VRTTH;
                6'b001110: operation = `VDIV;
                6'b001111: operation = `VMOD;
                6'b010000: operation = `VSQEU;
                6'b010001: operation = `VSQOU;
                6'b010010: operation = `VSQRT;
            endcase
        end
        6'b100000: begin
            instruction_type = `TYPE_M;
            operation = `VLD;
        end
        6'b100001: begin
            instruction_type = `TYPE_M;
            operation = `VSD;
        end
        6'b100010: operation = `VBEZ;
        6'b100011: operation = `VBNEZ;
        6'b111100: operation = `VNOP;
        6'b000000: operation = `VNOP;
    endcase
end
endmodule // instruction_decoder

module register_file (  input clk, reset, write_en,
                        input [0:`WORD_ADDRESS-1] ra_address, rb_address, rd_address,
                        input [0:`DOUBLE_WORD-1] rd_data,
                        output reg [0:`DOUBLE_WORD-1] ra_data, rb_data);
reg [0:`DOUBLE_WORD-1] regfile0;
reg [0:`DOUBLE_WORD-1] regfile1;
reg [0:`DOUBLE_WORD-1] regfile2;
reg [0:`DOUBLE_WORD-1] regfile3;
reg [0:`DOUBLE_WORD-1] regfile4;
reg [0:`DOUBLE_WORD-1] regfile5;
reg [0:`DOUBLE_WORD-1] regfile6;
reg [0:`DOUBLE_WORD-1] regfile7;
reg [0:`DOUBLE_WORD-1] regfile8;
reg [0:`DOUBLE_WORD-1] regfile9;
reg [0:`DOUBLE_WORD-1] regfile10;
reg [0:`DOUBLE_WORD-1] regfile11;
reg [0:`DOUBLE_WORD-1] regfile12;
reg [0:`DOUBLE_WORD-1] regfile13;
reg [0:`DOUBLE_WORD-1] regfile14;
reg [0:`DOUBLE_WORD-1] regfile15;
reg [0:`DOUBLE_WORD-1] regfile16;
reg [0:`DOUBLE_WORD-1] regfile17;
reg [0:`DOUBLE_WORD-1] regfile18;
reg [0:`DOUBLE_WORD-1] regfile19;
reg [0:`DOUBLE_WORD-1] regfile20;
reg [0:`DOUBLE_WORD-1] regfile21;
reg [0:`DOUBLE_WORD-1] regfile22;
reg [0:`DOUBLE_WORD-1] regfile23;
reg [0:`DOUBLE_WORD-1] regfile24;
reg [0:`DOUBLE_WORD-1] regfile25;
reg [0:`DOUBLE_WORD-1] regfile26;
reg [0:`DOUBLE_WORD-1] regfile27;
reg [0:`DOUBLE_WORD-1] regfile28;
reg [0:`DOUBLE_WORD-1] regfile29;
reg [0:`DOUBLE_WORD-1] regfile30;
reg [0:`DOUBLE_WORD-1] regfile31;
// reading logic
always @ ( * ) begin
    regfile0 = `RF_RESET_VALUE;
    case (ra_address)
        0  : ra_data = regfile0;
        1  : ra_data = regfile1;
        2  : ra_data = regfile2;
        3  : ra_data = regfile3;
        4  : ra_data = regfile4;
        5  : ra_data = regfile5;
        6  : ra_data = regfile6;
        7  : ra_data = regfile7;
        8  : ra_data = regfile8;
        9  : ra_data = regfile9;
        10 : ra_data = regfile10;
        11 : ra_data = regfile11;
        12 : ra_data = regfile12;
        13 : ra_data = regfile13;
        14 : ra_data = regfile14;
        15 : ra_data = regfile15;
        16 : ra_data = regfile16;
        17 : ra_data = regfile17;
        18 : ra_data = regfile18;
        19 : ra_data = regfile19;
        20 : ra_data = regfile20;
        21 : ra_data = regfile21;
        22 : ra_data = regfile22;
        23 : ra_data = regfile23;
        24 : ra_data = regfile24;
        25 : ra_data = regfile25;
        26 : ra_data = regfile26;
        27 : ra_data = regfile27;
        28 : ra_data = regfile28;
        29 : ra_data = regfile29;
        30 : ra_data = regfile30;
        31 : ra_data = regfile31;
    endcase
    case (rb_address)
        0  : rb_data = regfile0;
        1  : rb_data = regfile1;
        2  : rb_data = regfile2;
        3  : rb_data = regfile3;
        4  : rb_data = regfile4;
        5  : rb_data = regfile5;
        6  : rb_data = regfile6;
        7  : rb_data = regfile7;
        8  : rb_data = regfile8;
        9  : rb_data = regfile9;
        10 : rb_data = regfile10;
        11 : rb_data = regfile11;
        12 : rb_data = regfile12;
        13 : rb_data = regfile13;
        14 : rb_data = regfile14;
        15 : rb_data = regfile15;
        16 : rb_data = regfile16;
        17 : rb_data = regfile17;
        18 : rb_data = regfile18;
        19 : rb_data = regfile19;
        20 : rb_data = regfile20;
        21 : rb_data = regfile21;
        22 : rb_data = regfile22;
        23 : rb_data = regfile23;
        24 : rb_data = regfile24;
        25 : rb_data = regfile25;
        26 : rb_data = regfile26;
        27 : rb_data = regfile27;
        28 : rb_data = regfile28;
        29 : rb_data = regfile29;
        30 : rb_data = regfile30;
        31 : rb_data = regfile31;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        // use counter may be not good for synthesis
        regfile0 = `RF_RESET_VALUE;
        regfile1 = `RF_RESET_VALUE;
        regfile2 = `RF_RESET_VALUE;
        regfile3 = `RF_RESET_VALUE;
        regfile4 = `RF_RESET_VALUE;
        regfile5 = `RF_RESET_VALUE;
        regfile6 = `RF_RESET_VALUE;
        regfile7 = `RF_RESET_VALUE;
        regfile8 = `RF_RESET_VALUE;
        regfile9 = `RF_RESET_VALUE;
        regfile10 = `RF_RESET_VALUE;
        regfile11 = `RF_RESET_VALUE;
        regfile12 = `RF_RESET_VALUE;
        regfile13 = `RF_RESET_VALUE;
        regfile14 = `RF_RESET_VALUE;
        regfile15 = `RF_RESET_VALUE;
        regfile16 = `RF_RESET_VALUE;
        regfile17 = `RF_RESET_VALUE;
        regfile18 = `RF_RESET_VALUE;
        regfile19 = `RF_RESET_VALUE;
        regfile20 = `RF_RESET_VALUE;
        regfile21 = `RF_RESET_VALUE;
        regfile22 = `RF_RESET_VALUE;
        regfile23 = `RF_RESET_VALUE;
        regfile24 = `RF_RESET_VALUE;
        regfile25 = `RF_RESET_VALUE;
        regfile26 = `RF_RESET_VALUE;
        regfile27 = `RF_RESET_VALUE;
        regfile28 = `RF_RESET_VALUE;
        regfile29 = `RF_RESET_VALUE;
        regfile30 = `RF_RESET_VALUE;
        regfile31 = `RF_RESET_VALUE;
    end
    else begin
        if (write_en) begin
            case (rd_address)
                1  :  regfile1 = rd_data;
                2  :  regfile2 = rd_data;
                3  :  regfile3 = rd_data;
                4  :  regfile4 = rd_data;
                5  :  regfile5 = rd_data;
                6  :  regfile6 = rd_data;
                7  :  regfile7 = rd_data;
                8  :  regfile8 = rd_data;
                9  :  regfile9 = rd_data;
                10 : regfile10 = rd_data;
                11 : regfile11 = rd_data;
                12 : regfile12 = rd_data;
                13 : regfile13 = rd_data;
                14 : regfile14 = rd_data;
                15 : regfile15 = rd_data;
                16 : regfile16 = rd_data;
                17 : regfile17 = rd_data;
                18 : regfile18 = rd_data;
                19 : regfile19 = rd_data;
                20 : regfile20 = rd_data;
                21 : regfile21 = rd_data;
                22 : regfile22 = rd_data;
                23 : regfile23 = rd_data;
                24 : regfile24 = rd_data;
                25 : regfile25 = rd_data;
                26 : regfile26 = rd_data;
                27 : regfile27 = rd_data;
                28 : regfile28 = rd_data;
                29 : regfile29 = rd_data;
                30 : regfile30 = rd_data;
                31 : regfile31 = rd_data;
            endcase
        end
    end
end
endmodule // register_file

module hazard_detector (input clk, reset,
                        input [0:`INSTR_WIDTH-1] instr,
                        output reg rd_ra_1, rd_rb_1, rd_ra_2, rd_rb_2);
reg [0:4] rd_1, rd_2;
always @ (posedge clk) begin
    if (reset) begin
        rd_ra_1 <= 0;
        rd_rb_1 <= 0;
        rd_ra_2 <= 0;
        rd_rb_2 <= 0;
    end
    else begin
        rd_1 <= instr[6:10];
        rd_2 <= rd_1;
        if (instr[11:15] == rd_1) rd_ra_1 <= 1;
        else rd_ra_1 <= 0;
        if (instr[16:20] == rd_1) rd_rb_1 <= 1;
        else rd_rb_1 <= 0;
        if (instr[11:15] == rd_2) rd_ra_2 <= 1;
        else rd_ra_2 <= 0;
        if (instr[16:20] == rd_2) rd_rb_2 <= 1;
        else rd_rb_2 <= 0;
    end
end
endmodule // hazard_detector

//alu & sfu
//alu & sfu
module alu (    input [0:`DOUBLE_WORD-1] ra, rb,
                input [0:`WW_WIDTH-1] operand_width,
                input [0:`WORD-1] control,
                output reg [0:`DOUBLE_WORD-1] result);

wire [0:63] result_8_sqr,result_16_sqr, result_32_sqr, result_64_sqr,
			result_8_quo,result_16_quo, result_32_quo, result_64_quo,
			result_8_rem,result_16_rem, result_32_rem, result_64_rem
			;//SFU signals

	
			
always @ (*) begin

casex(control)
    `OP_VAND:begin //bit and
        result = ra & rb;
    end
    `OP_VOR:begin // bit or
        result = ra | rb;
    end
    `OP_VXOR:begin //bit xor
        result = ra ^ rb;
    end
    `OP_VNOT:begin //bit not
        result = ~ra;
    end
    `OP_VMOV:begin //rd <= ra
        result = ra;
    end
    `OP_VADD:begin //add operation and 4 type op width
        if (operand_width == 2'b00) begin //size = 8
            result[0:7]   = ra[0:7]   + rb[0:7];
            result[8:15]  = ra[8:15]  + rb[8:15];
            result[16:23] = ra[16:23] + rb[16:23];
            result[24:31] = ra[24:31] + rb[24:31];
            result[32:39] = ra[32:39] + rb[32:39];
            result[40:47] = ra[40:47] + rb[40:47];
            result[48:55] = ra[48:55] + rb[48:55];
            result[56:63] = ra[56:63] + rb[56:63];
        end
        else if (operand_width == 2'b01) begin // size = 16
            result[0:15]  = ra[0:15]  + rb[0:15];
            result[16:31] = ra[16:31] + rb[16:31];
            result[32:47] = ra[32:47] + rb[32:47];
            result[48:63] = ra[48:63] + rb[48:63];
        end
        else if (operand_width == 2'b10) begin // size = 32
            result[0:31]  = ra[0:31] + rb[0:31];
            result[32:63] = ra[32:63] + rb[32:63];
        end
        else if  (operand_width == 2'b11) begin // size = 64
            result[0:63] = ra[0:63] + rb[0:63];
        end
    end
    `OP_VSUB:begin//substract operation and 4 type op width
        if (operand_width == 2'b00) begin //size = 8
            result[0:7]   = ra[0:7]   - rb[0:7];
            result[8:15]  = ra[8:15]  - rb[8:15];
            result[16:23] = ra[16:23] - rb[16:23];
            result[24:31] = ra[24:31] - rb[24:31];
            result[32:39] = ra[32:39] - rb[32:39];
            result[40:47] = ra[40:47] - rb[40:47];
            result[48:55] = ra[48:55] - rb[48:55];
            result[56:63] = ra[56:63] - rb[56:63];
        end
        else if (operand_width == 2'b01) begin // size = 16
            result[0:15]  = ra[0:15]  - rb[0:15];
            result[16:31] = ra[16:31] - rb[16:31];
            result[32:47] = ra[32:47] - rb[32:47];
            result[48:63] = ra[48:63] - rb[48:63];
        end
        else if (operand_width == 2'b10) begin // size = 32
            result[0:31] = ra[0:31] - rb[0:31];
            result[32:63] = ra[32:63] - rb[32:63];
        end
        else if  (operand_width == 2'b11) begin // size = 64
            result[0:63] = ra[0:63] - rb[0:63];
        end
    end
    `OP_VMULEU:begin //even_mul operation and 4 type op width
        if (operand_width == 2'b00) begin //size = 8
            result[0:15]  = ra[0:7]   * rb[0:7];
            result[16:31] = ra[16:23] * rb[16:23];
            result[32:47] = ra[32:39] * rb[32:39];
            result[48:63] = ra[48:55] * rb[48:55];
        end
        else if (operand_width == 2'b01) begin //size = 16
            result[0:31]  = ra[0:15]  * rb[0:15];
            result[32:63] = ra[32:47] * rb[32:47];
        end
        else if (operand_width == 2'b10) begin //size = 32
            result[0:63] = ra[0:31] * rb[0:31];
        end
    end
    `OP_VMULOU:begin //odd_mul operation and 4 type op width
        if (operand_width == 2'b00) begin //size = 8
            result[0:15]  = ra[8:15]  * rb[8:15];
            result[16:31] = ra[24:31] * rb[24:31];
            result[32:47] = ra[40:47] * rb[40:47];
            result[48:63] = ra[56:63] * rb[56:63];
        end
        else if (operand_width == 2'b01) begin //size = 16
            result[0:31]  = ra[16:31] * rb[16:31];
            result[32:63] = ra[48:63] * rb[48:63];
        end
        else if (operand_width == 2'b10) begin //size = 32
            result[0:63] = ra[32:63] * rb[32:63];
        end
    end
    `OP_VSLL:begin //shift left 4 op width
        if (operand_width == 2'b00) begin //size = 8
             result[0:7]   = ra[0:7]   << rb[5:7];
             result[8:15]  = ra[8:15]  << rb[13:15];
             result[16:23] = ra[16:23] << rb[21:23];
             result[24:31] = ra[24:31] << rb[29:31];
             result[32:39] = ra[32:39] << rb[37:39];
             result[40:47] = ra[40:47] << rb[45:47];
             result[48:55] = ra[48:55] << rb[53:55];
             result[56:63] = ra[56:63] << rb[61:63];
            end
        else if (operand_width == 2'b01) begin // size = 16
             result[0:15]  = ra[0:15]  << rb[12:15];
             result[16:31] = ra[16:31] << rb[28:31];
             result[32:47] = ra[32:47] << rb[44:47];
             result[48:63] = ra[48:63] << rb[60:63];
        end
        else if (operand_width == 2'b10) begin // size = 32
             result[0:31]  = ra[0:31]  << rb[27:31];
             result[32:63] = ra[32:63] << rb[59:63];
        end
        else if  (operand_width == 2'b11) begin // size = 64
             result[0:63] = ra[0:63] << rb[58:63];
        end
    end
    `OP_VSRL:begin //shift right 4 op width
        if (operand_width == 2'b00) begin //size = 8
            result[0:7]   = ra[0:7]   >> rb[5:7];
            result[8:15]  = ra[8:15]  >> rb[13:15];
            result[16:23] = ra[16:23] >> rb[21:23];
            result[24:31] = ra[24:31] >> rb[29:31];
            result[32:39] = ra[32:39] >> rb[37:39];
            result[40:47] = ra[40:47] >> rb[45:47];
            result[48:55] = ra[48:55] >> rb[53:55];
            result[56:63] = ra[56:63] >> rb[61:63];
        end
        else if (operand_width == 2'b01) begin // size = 16
            result[0:15]  = ra[0:15]  >> rb[12:15];
            result[16:31] = ra[16:31] >> rb[28:31];
            result[32:47] = ra[32:47] >> rb[44:47];
            result[48:63] = ra[48:63] >> rb[60:63];
        end
        else if (operand_width == 2'b10) begin // size = 32
            result[0:31]  = ra[0:31]  >> rb[27:31];
            result[32:63] = ra[32:63] >> rb[59:63];
        end
        else if  (operand_width == 2'b11) begin // size = 64
            result[0:63] = ra[0:63] >> rb[58:63];
        end
    end
    `OP_VSRA:  begin // shift rifht 4 op width signed
        if (operand_width == 2'b00) begin //size = 8
            result[0:7]   = $signed(ra[0:7])   >>> rb[5:7];
            result[8:15]  = $signed(ra[8:15] ) >>> rb[13:15];
            result[16:23] = $signed(ra[16:23]) >>> rb[21:23];
            result[24:31] = $signed(ra[24:31]) >>> rb[29:31];
            result[32:39] = $signed(ra[32:39]) >>> rb[37:39];
            result[40:47] = $signed(ra[40:47]) >>> rb[45:47];
            result[48:55] = $signed(ra[48:55]) >>> rb[53:55];
            result[56:63] = $signed(ra[56:63]) >>> rb[61:63];
        end
        else if (operand_width == 2'b01) begin // size = 16
            result[0:15]  = $signed(ra[0:15] ) >>> rb[12:15];
            result[16:31] = $signed(ra[16:31]) >>> rb[28:31];
            result[32:47] = $signed(ra[32:47]) >>> rb[44:47];
            result[48:63] = $signed(ra[48:63]) >>> rb[60:63];
        end
        else if (operand_width == 2'b10) begin // size = 32
            result[0:31]  = $signed(ra[0:31] ) >>> rb[27:31];
            result[32:63] = $signed(ra[32:63]) >>> rb[59:63];
        end
        else if  (operand_width == 2'b11) begin // size = 64
            result[0:63] = $signed(ra[0:63]) >>> rb[58:63];
        end
    end
    `OP_VRTTH:begin //half rotate
        if (operand_width == 2'b00) begin //size = 8
            result[0:7]   = {ra[4:7]  ,ra[0:3]};
            result[8:15]  = {ra[12:15],ra[8:11]};
            result[16:23] = {ra[20:23],ra[16:19]};
            result[24:31] = {ra[28:31],ra[24:27]};
            result[32:39] = {ra[36:39],ra[32:35]};
            result[40:47] = {ra[44:47],ra[40:43]};
            result[48:55] = {ra[52:55],ra[48:51]};
            result[56:63] = {ra[60:63],ra[56:59]};
        end
        else if (operand_width == 2'b01) begin // size = 16
            result[0:15]  = {ra[8:15] ,ra[0:7]};
            result[16:31] = {ra[24:31],ra[16:23]};
            result[32:47] = {ra[40:47],ra[32:39]};
            result[48:63] = {ra[56:63],ra[48:55]};
        end
        else if (operand_width == 2'b10) begin // size = 32
            result[0:31]  = {ra[16:31],ra[0:15]};
            result[32:63] = {ra[48:63],ra[32:47]};
        end
        else if  (operand_width == 2'b11) begin // size = 64
            result[0:63] = {ra[32:63],ra[0:31]};
            end

    end
    `OP_VDIV: begin //integer unsigned div Quotient
        if (operand_width == 2'b00) begin //size = 8
            result = result_8_quo;
        end
        else if (operand_width == 2'b01) begin //size = 16
            result = result_16_quo;
        end
        else if (operand_width == 2'b10) begin //size = 32
            result = result_32_quo;
        end
        else if (operand_width == 2'b11) begin //size = 64
            result = result_64_quo;
        end
    end
    `OP_VMOD: begin //integer unsigned div remainder
        if (operand_width == 2'b00) begin //size = 8
            result = result_8_rem;
            end
        else if (operand_width == 2'b01) begin //size = 16
            result = result_16_rem;
            end
        else if (operand_width == 2'b10) begin //size = 32
            result = result_32_rem;
        end
        else if (operand_width == 2'b11) begin //size = 64
            result = result_64_rem;
        end
    end
    `OP_VSQEU: begin //squar left half bits Even
        if (operand_width == 2'b00) begin //size = 8
            result[0:15]  = ra[0:7]    ** 2;
            result[16:31] = ra[16:23]  ** 2;
            result[32:47] = ra[32:39]  ** 2;
            result[48:63] = ra[48:55]  ** 2;
        end
        else if (operand_width == 2'b01) begin //size = 16
            result[0:31]  = ra[0:15]   ** 2;
            result[32:63] = ra[32:47]  ** 2;
        end
        else if (operand_width == 2'b10) begin //size = 32
            result[0:63] = ra[0:31]    ** 2;
        end

    end
    `OP_VSQOU:begin//squar right half bits Odd
        if (operand_width == 2'b00) begin //size = 8
            result[0:15]  = ra[8:15]  ** 2;
            result[16:31] = ra[24:31] ** 2;
            result[32:47] = ra[40:47] ** 2;
            result[48:63] = ra[56:63] ** 2;
        end
        else if (operand_width == 2'b01) begin //size = 16
            result[0:31]  = ra[16:31] ** 2;
            result[32:63] = ra[48:63] ** 2;
        end
        else if (operand_width == 2'b10) begin //size = 32
            result[0:63] = ra[32:63]  ** 2;
        end
    end

    `OP_VSQRT:begin
        if (operand_width == 2'b00) begin //size = 8
            result = result_8_sqr;
        end
        else if (operand_width == 2'b01) begin //size = 16
            result = result_16_sqr;
        end
        else if (operand_width == 2'b10) begin //size = 32
            result = result_32_sqr;
        end
        else if (operand_width == 2'b11) begin //size = 64
            result = result_64_sqr;
        end

    end
/*
    `OP_VLD: begin

    end
    `OP_VSD: begin

    end
    `OP_VBEZ:begin

    end
    `OP_VBNEZ: begin

    end
    `OP_VNOP: begin

    end
*/

endcase
end

sqr_8  x1 (ra,result_8_sqr);
sqr_16 x2 (ra,result_16_sqr);
sqr_32 x3 (ra,result_32_sqr);
sqr_64 x4 (ra,result_64_sqr);
div_8  x5 (ra, rb, result_8_quo,  result_8_rem);
div_16 x6 (ra, rb, result_16_quo, result_16_rem);
div_32 x7 (ra, rb, result_32_quo, result_32_rem);
div_64 x8 (ra, rb, result_64_quo, result_64_rem);

endmodule
// alu end

//sfu-----------------------
//square
module sqr_8(ra, result_8_sqr); 

	input  [0:63] ra;
	output [0:63] result_8_sqr;
	
	parameter width = 8;
	`include "./include/DW_sqrt_function.inc"
	
	assign result_8_sqr[0:7]   = DWF_sqrt_uns ( ra[0:7]  );
	assign result_8_sqr[8:15]  = DWF_sqrt_uns ( ra[8:15] );
	assign result_8_sqr[16:23] = DWF_sqrt_uns ( ra[16:23]);
	assign result_8_sqr[24:31] = DWF_sqrt_uns ( ra[24:31]);
	assign result_8_sqr[32:39] = DWF_sqrt_uns ( ra[32:39]);
	assign result_8_sqr[40:47] = DWF_sqrt_uns ( ra[40:47]);
	assign result_8_sqr[48:55] = DWF_sqrt_uns ( ra[48:55]);
	assign result_8_sqr[56:63] = DWF_sqrt_uns ( ra[56:63]);

endmodule
//------------------------
module sqr_16 (ra, result_16_sqr); 

	input  [0:63] ra;
	output [0:63] result_16_sqr;

	parameter width = 16;
	`include "./include/DW_sqrt_function.inc"

	assign result_16_sqr[0:15]  = DWF_sqrt_uns (ra[0:15]);
	assign result_16_sqr[16:31] = DWF_sqrt_uns (ra[16:31]);
	assign result_16_sqr[32:47] = DWF_sqrt_uns (ra[32:47]);
	assign result_16_sqr[48:63] = DWF_sqrt_uns (ra[48:63]);

endmodule
//----------------------------
module sqr_32 (ra, result_32_sqr); 

	input  [0:63] ra;
	output [0:63] result_32_sqr;
	
	parameter width = 32;
	`include "./include/DW_sqrt_function.inc"
	
	assign result_32_sqr[0:31]  = DWF_sqrt_uns (ra[0:31]);
	assign result_32_sqr[32:63] = DWF_sqrt_uns (ra[32:63]);

endmodule
//--------------------------------
module sqr_64 (ra, result_64_sqr); 

	input  [0:63] ra;
	output [0:63] result_64_sqr;
	
	parameter width = 64;
	`include "./include/DW_sqrt_function.inc"
	
	assign result_64_sqr[0:63] = DWF_sqrt_uns (ra[0:63]);

endmodule
//------------------------------------
//div
module div_8 (ra, rb, result_8_quo, result_8_rem );

	input  [0:63] ra, rb;
	output [0:63] result_8_quo, result_8_rem;
	
	parameter a_width = 8;
	parameter b_width = 8;
	`include "./include/DW_div_function.inc"
	
	assign result_8_quo[0:7] = DWF_div_uns(ra[0:7], rb[0:7]);
	assign result_8_rem[0:7] = DWF_rem_uns(ra[0:7], rb[0:7]);
	
	assign result_8_quo[8:15] = DWF_div_uns(ra[8:15], rb[8:15]);
	assign result_8_rem[8:15] = DWF_rem_uns(ra[8:15], rb[8:15]);
	
	assign result_8_quo[16:23] = DWF_div_uns(ra[16:23], rb[16:23]);
	assign result_8_rem[16:23] = DWF_rem_uns(ra[16:23], rb[16:23]);
	
	assign result_8_quo[24:31] = DWF_div_uns(ra[24:31], rb[24:31]);
	assign result_8_rem[24:31] = DWF_rem_uns(ra[24:31], rb[24:31]);
	
	assign result_8_quo[32:39] = DWF_div_uns(ra[32:39], rb[32:39]);
	assign result_8_rem[32:39] = DWF_rem_uns(ra[32:39], rb[32:39]);
	
	assign result_8_quo[40:47] = DWF_div_uns(ra[40:47], rb[40:47]);
	assign result_8_rem[40:47] = DWF_rem_uns(ra[40:47], rb[40:47]);
	
	assign result_8_quo[48:55] = DWF_div_uns(ra[48:55], rb[48:55]);
	assign result_8_rem[48:55] = DWF_rem_uns(ra[48:55], rb[48:55]);
	
	assign result_8_quo[56:63] = DWF_div_uns(ra[56:63], rb[56:63]);
	assign result_8_rem[56:63] = DWF_rem_uns(ra[56:63], rb[56:63]);
	
	
endmodule
//-------------------------
module div_16 (ra, rb, result_16_quo, result_16_rem );

	input  [0:63] ra, rb;
	output [0:63] result_16_quo, result_16_rem;
	
	parameter a_width = 16;
	parameter b_width = 16;
	`include "./include/DW_div_function.inc"
	
	assign result_16_quo[0:15] = DWF_div_uns(ra[0:15], rb[0:15]);
	assign result_16_rem[0:15] = DWF_rem_uns(ra[0:15], rb[0:15]);
	
	assign result_16_quo[16:31] = DWF_div_uns(ra[16:31], rb[16:31]);
	assign result_16_rem[16:31] = DWF_rem_uns(ra[16:31], rb[16:31]);
	
	assign result_16_quo[32:47] = DWF_div_uns(ra[32:47], rb[32:47]);
	assign result_16_rem[32:47] = DWF_rem_uns(ra[32:47], rb[32:47]);
	
	assign result_16_quo[48:63] = DWF_div_uns(ra[48:63], rb[48:63]);
	assign result_16_rem[48:63] = DWF_rem_uns(ra[48:63], rb[48:63]);
	
	
endmodule
//-------------------------------
module div_32 (ra, rb, result_32_quo, result_32_rem );

	input  [0:63] ra, rb;
	output [0:63] result_32_quo, result_32_rem;
	
	parameter a_width = 32;
	parameter b_width = 32;
	`include "./include/DW_div_function.inc"
	
	assign result_32_quo[0:31] = DWF_div_uns(ra[0:31], rb[0:31]);
	assign result_32_rem[0:31] = DWF_rem_uns(ra[0:31], rb[0:31]);
	
	assign result_32_quo[32:63] = DWF_div_uns(ra[32:63], rb[32:63]);
	assign result_32_rem[32:63] = DWF_rem_uns(ra[32:63], rb[32:63]);
	
	
endmodule
//------------------------
module div_64 (ra, rb, result_64_quo, result_64_rem );

	input  [0:63] ra, rb;
	output [0:63] result_64_quo, result_64_rem;
	
	parameter a_width = 64;
	parameter b_width = 64;
	`include "./include/DW_div_function.inc"
	
	assign result_64_quo[0:63] = DWF_div_uns(ra[0:63], rb[0:63]);
	assign result_64_rem[0:63] = DWF_rem_uns(ra[0:63], rb[0:63]);
	
	
endmodule
//sfu end
//alu&sfu end


module cardinal_processor ( input clk, reset,
                            input [0:`INSTR_WIDTH-1] instr_in,
                            input [0:`DOUBLE_WORD-1] mem_re_data,
                            input [0:`DOUBLE_WORD-1] nic_re_data,
                            output [0:`WORD-1] pc_out,
                            output reg [0:`DOUBLE_WORD-1] mem_wr_data,
                            output reg [0:`DOUBLE_WORD-1] nic_wr_data,
                            output reg [0:`WORD-1] mem_addr,
                            output reg mem_wr, mem_en, nic_wr, nic_en,
                            output reg [0:1] nic_addr);

reg pc_write, rf_write;
reg branch;
wire instruction_type;
reg [0:4] rb_in, rd_in;
reg [0:`WORD-1] pc_in;
wire [0:`WORD-1] id_operation;
reg [0:`WORD-1] alu_operation;
reg [0:`INSTR_WIDTH-1] instruction;
wire [0:`WW_WIDTH-1] id_operand_width;
reg [0:`WW_WIDTH-1] alu_operand_width;
reg [0:`DOUBLE_WORD-1] rf_rd, rf_rd_load, rf_rd_temp, alu_ra, alu_rb;
reg [0:1] nic_signal;
wire [0:`DOUBLE_WORD-1] rf_ra, rf_rb, alu_result;
wire rd_ra_1, rd_rb_1, rd_ra_2, rd_rb_2;
//
program_counter pc(clk, reset, pc_write, pc_in, pc_out);
instruction_decoder id(instruction, instruction_type, id_operand_width, id_operation);
hazard_detector hd(clk, reset, instr_in, rd_ra_1, rd_rb_1, rd_ra_2, rd_rb_2);
register_file rf(clk, reset, rf_write, instruction[11:15], rb_in, rd_in, rf_rd, rf_ra, rf_rb);
alu alu_ins(alu_ra, alu_rb, alu_operand_width, alu_operation, alu_result);

always @ (posedge clk) begin
    if (reset) begin

    end
    else begin
        rd_in <= instruction[6:10];
        //rf_write <= wb_en;
        alu_operand_width <= id_operand_width;
        alu_operation <= id_operation;
        rf_rd_temp <= rf_rd;
		nic_signal <= instruction[16:17];

        // hazard mux
        if (instruction[11:15] != 5'b00000) begin
            if (rd_ra_1) alu_ra <= rf_rd;
            else if (rd_ra_2) alu_ra <= rf_rd_temp;
            else alu_ra <= rf_ra;
        end
        else begin
            alu_ra <= rf_ra;
        end

        if (instruction[16:20] != 5'b00000) begin
            if (rd_rb_1) alu_rb <= rf_rd;
            else if (rd_rb_2) alu_rb <= rf_rd_temp;
            else alu_rb <= rf_rb;
        end
        else begin
            alu_rb <= rf_rb;
        end

        // branch ez
        if (branch == 1'b1) begin
            instruction <= 32'hF0000000; // nop
        end
        else begin
            instruction <= instr_in;
        end

    end
end

always @ ( * ) begin
    rb_in = instruction[16:20];
    // wb_en
    if (alu_operation & 32'b0000_0000_0000_0111_1111_1111_1111_1111) begin
        rf_write = `ENABLED;
    end
    else begin
        rf_write = `DISENABLED;
    end

    if (id_operation == `VLD) begin
        // memory load
        if ((instruction[16] == 0) || (instruction[17] == 0) ) begin
            mem_en = `ENABLED;
            mem_addr[24:31] = instruction[24:`WORD-1];
        end
        // nic load
        else begin
            nic_en = `ENABLED;
            nic_addr = instruction[30:31];
        end

    end // mem_wr
    else begin
        if (id_operation == `VSD) begin
            // memory store
           if ( (instruction[16] == 0) || (instruction[17] == 0)  ) begin
                rb_in = instruction[6:10];
                mem_wr_data = rf_rb;
                mem_wr = `ENABLED;
                mem_en = `ENABLED;
                mem_addr[24:31] = instruction[16:`WORD-1];
           end
            // nic store
           else begin
                rb_in = instruction[6:10];
                nic_wr_data = rf_rb;
                nic_wr = `ENABLED;
                nic_en = `ENABLED;
                nic_addr = instruction[30:31];
            end

        end
        else begin
            mem_wr = `DISENABLED;
            mem_en = `DISENABLED;
            nic_wr = `DISENABLED;
            nic_en = `DISENABLED;
        end
        // rf_rd = alu_result;
    end

    // wb mux
    if (alu_operation == `VLD) begin
        // memory load
		if ((nic_signal[0] == 0) || (nic_signal[1] == 0) ) begin
            rf_rd = mem_re_data;
            // mem_en = `ENABLED;
            // mem_addr[24:31] = instruction[24:`WORD-1];
		end
        // nic load
		else begin
            rf_rd = nic_re_data;
            // nic_en = `ENABLED;
            // nic_addr = instruction[30:31];
        end

    end // mem_wr
    else begin
        // if (alu_operation == `VSD) begin
        //     // memory store
        //    if ( (nic_signal[0] == 0) || (nic_signal[1] == 0)  ) begin
        //         rb_in = instruction[6:10];
        //         mem_wr_data = rf_rb;
        //         mem_wr = `ENABLED;
        //         mem_en = `ENABLED;
        //         mem_addr[24:31] = instruction[16:`WORD-1];
        //    end
        //     // nic store
        //    else begin
        //         rb_in = instruction[6:10];
        //         nic_wr_data = rf_rb;
        //         nic_wr = `ENABLED;
        //         nic_en = `ENABLED;
        //         nic_addr = instruction[30:31];
        //     end
        //
        // end
        // else begin
        //     mem_wr = `DISENABLED;
        //     mem_en = `DISENABLED;
        //     nic_wr = `DISENABLED;
        //     nic_en = `DISENABLED;
        // end
        rf_rd = alu_result;
    end

    // branch ez
    if (id_operation == `VBEZ) begin
        rb_in = instruction[6:10];
        if (rf_rb == 0) begin
            pc_write = `ENABLED;
            pc_in = instruction[16:`WORD-1];
            branch = 1'b1;
        end
        else begin
            pc_write = `DISENABLED;
            branch = 1'b0;
        end
    end // branch not ez
    else if (id_operation == `VBNEZ) begin
        rb_in = instruction[6:10];
        if (rf_rb != 0) begin
            pc_write = `ENABLED;
            pc_in = instruction[16:`WORD-1];
            branch = 1'b1;
        end
        else begin
            pc_write = `DISENABLED;
            branch = 1'b0;
        end
    end
    else begin
        pc_write = `DISENABLED;
        branch = 1'b0;
    end

     // if (alu_operation == `VNOP) begin
     //     rf_rd <= 32'h00000000;
     // end

end
endmodule // cardinal_processor

module cardinal_cmp (   input clk, reset,

                        input [0:`INSTR_WIDTH-1] node0_inst_in,
                        input [0:`DOUBLE_WORD-1] node0_d_in,
                        output [0:`WORD-1] node0_pc_out,
                        output [0:`DOUBLE_WORD-1] node0_d_out,
                        output [0:`WORD-1] node0_addr_out,
                        output node0_memWrEn, node0_memEn,

                        input [0:`INSTR_WIDTH-1] node1_inst_in,
                        input [0:`DOUBLE_WORD-1] node1_d_in,
                        output [0:`WORD-1] node1_pc_out,
                        output [0:`DOUBLE_WORD-1] node1_d_out,
                        output [0:`WORD-1] node1_addr_out,
                        output node1_memWrEn, node1_memEn,

                        input [0:`INSTR_WIDTH-1] node2_inst_in,
                        input [0:`DOUBLE_WORD-1] node2_d_in,
                        output [0:`WORD-1] node2_pc_out,
                        output [0:`DOUBLE_WORD-1] node2_d_out,
                        output [0:`WORD-1] node2_addr_out,
                        output node2_memWrEn, node2_memEn,

                        input [0:`INSTR_WIDTH-1] node3_inst_in,
                        input [0:`DOUBLE_WORD-1] node3_d_in,
                        output [0:`WORD-1] node3_pc_out,
                        output [0:`DOUBLE_WORD-1] node3_d_out,
                        output [0:`WORD-1] node3_addr_out,
                        output node3_memWrEn, node3_memEn);

wire [0:1] node0_nic_addr, node1_nic_addr, node2_nic_addr, node3_nic_addr;
wire [0:`DOUBLE_WORD-1] node0_nic_wr_data, node1_nic_wr_data, node2_nic_wr_data, node3_nic_wr_data;
wire [0:`DOUBLE_WORD-1] node0_nic_re_data, node1_nic_re_data, node2_nic_re_data, node3_nic_re_data;
wire [0:`DOUBLE_WORD-1] node0_pedi,node1_pedi,node2_pedi,node3_pedi, node0_pedo, node1_pedo, node2_pedo, node3_pedo;
wire node0_nic_en, node0_nic_wr, node1_nic_en, node1_nic_wr, node2_nic_en, node2_nic_wr, node3_nic_en, node3_nic_wr;
wire node0_pesi, node0_peri,  node0_peso, node0_pero, node0_polarity;
wire node1_pesi, node1_peri,  node1_peso, node1_pero, node1_polarity;
wire node2_pesi, node2_peri,  node2_peso, node2_pero, node2_polarity;
wire node3_pesi, node3_peri,  node3_peso, node3_pero, node3_polarity;

cardinal_processor cp0(	clk,
                    	reset,
                    	node0_inst_in,
                    	node0_d_in,
                        node0_nic_re_data,
                    	node0_pc_out,
                    	node0_d_out,
                        node0_nic_wr_data,
                    	node0_addr_out,
                    	node0_memWrEn,
                    	node0_memEn,
                        node0_nic_wr,
                        node0_nic_en,
                        node0_nic_addr);

cardinal_processor cp1(	clk,
                    	reset,
                    	node1_inst_in,
                    	node1_d_in,
                        node1_nic_re_data,
                    	node1_pc_out,
                    	node1_d_out,
                        node1_nic_wr_data,
                    	node1_addr_out,
                    	node1_memWrEn,
                    	node1_memEn,
                        node1_nic_wr,
                        node1_nic_en,
                        node1_nic_addr);

cardinal_processor cp2(	clk,
                    	reset,
                    	node2_inst_in,
                    	node2_d_in,
                        node2_nic_re_data,
                    	node2_pc_out,
                    	node2_d_out,
                        node2_nic_wr_data,
                    	node2_addr_out,
                    	node2_memWrEn,
                    	node2_memEn,
                        node2_nic_wr,
                        node2_nic_en,
                        node2_nic_addr);

cardinal_processor cp3(	clk,
                    	reset,
                    	node3_inst_in,
                    	node3_d_in,
                        node3_nic_re_data,
                    	node3_pc_out,
                    	node3_d_out,
                        node3_nic_wr_data,
                    	node3_addr_out,
                    	node3_memWrEn,
                    	node3_memEn,
                        node3_nic_wr,
                        node3_nic_en,
                        node3_nic_addr);

cardinal_nic cn0(       clk,
                        reset,
                        node0_nic_addr,
                        node0_nic_wr_data,
						node0_nic_re_data,
                        node0_nic_en,
                        node0_nic_wr,
                        node0_pesi,
                        node0_peri,
                        node0_pedi,
                        node0_peso,
                        node0_pero,
                        node0_pedo,
                        node0_polarity);

cardinal_nic cn1(       clk,
                        reset,
                        node1_nic_addr,
                        node1_nic_wr_data,
						node1_nic_re_data,
                        node1_nic_en,
                        node1_nic_wr,
                        node1_pesi,
                        node1_peri,
                        node1_pedi,
                        node1_peso,
                        node1_pero,
                        node1_pedo,
                        node1_polarity);

cardinal_nic cn2(       clk,
                        reset,
                        node2_nic_addr,
                        node2_nic_wr_data,
						node2_nic_re_data,
                        node2_nic_en,
                        node2_nic_wr,
                        node2_pesi,
                        node2_peri,
                        node2_pedi,
                        node2_peso,
                        node2_pero,
                        node2_pedo,
                        node2_polarity);

cardinal_nic cn3(       clk,
                        reset,
                        node3_nic_addr,
                        node3_nic_wr_data,
						node3_nic_re_data,
                        node3_nic_en,
                        node3_nic_wr,
                        node3_pesi,
                        node3_peri,
                        node3_pedi,
                        node3_peso,
                        node3_pero,
                        node3_pedo,
                        node3_polarity);

cardinal_ring cr(       clk,
                        reset,
                        node0_pesi,
                        node0_peri,
                        node0_pedi,
                        node0_peso,
                        node0_pero,
                        node0_pedo,
                        node0_polarity,
                        node1_pesi,
                        node1_peri,
                        node1_pedi,
                        node1_peso,
                        node1_pero,
                        node1_pedo,
                        node1_polarity,
                        node2_pesi,
                        node2_peri,
                        node2_pedi,
                        node2_peso,
                        node2_pero,
                        node2_pedo,
                        node2_polarity,
                        node3_pesi,
                        node3_peri,
                        node3_pedi,
                        node3_peso,
                        node3_pero,
                        node3_pedo,
                        node3_polarity);

endmodule // cardinal_cmp
