module Pipe #
(
    parameter [31:0] RESET = 32'h0000_0000
)
(
    input logic clk,
    input logic reset,
    input logic stall,
    output logic exception,

    // Interface of instruction Memory
    input logic inst_mem_is_valid,
    input logic [31:0] inst_mem_read_data,
    input logic [31:0] dmem_read_data_temp,
    input logic dmem_write_valid,
    input logic dmem_read_valid
);

    // Declaring Wires and Registers

    // Data Memory Wires

    logic [31:0] dmem_read_data;
    logic dmem_write_ready;
    logic dmem_read_ready;
    logic [31:0] dmem_write_address;
    logic [31:0] dmem_read_address;
    logic [31:0] dmem_write_data;
    logic [3:0] dmem_write_byte;
    logic inst_mem_is_ready;
    logic dmem_read_valid_checker;

    // Instruction Fetch/Decode Stage

    logic [31:0] immediate;
    logic immediate_sel;
    logic [4:0] src1_select;
    logic [4:0] src2_select;
    logic [4:0] dest_reg_sel;
    logic [2:0] alu_operation;
    logic arithsubtype;
    logic mem_write;
    logic mem_to_reg;
    logic illegal_inst;
    logic [31:0] execute_immediate;
    logic alu;
    logic lui;
    logic jal;
    logic jalr;
    logic branch;
    logic stall_read;
    logic [31:0] instruction;
    logic [31:0] reg_rdata2;
    logic [31:0] reg_rdata1;
    logic [31:0] regs [31:1];

    // PC

    logic [31:0] pc;
    logic [31:0] inst_fetch_pc;
    logic [31:0] fetch_pc;

    // Stalls

    logic wb_stall_first;
    logic wb_stall_second;
    logic wb_stall;

    // Execute Stage

    logic [32:0] result_subs;
    logic [32:0] result_subu;
    logic [31:0] result;
    logic [31:0] next_pc;
    logic [31:0] write_address;
    logic branch_taken;
    logic branch_stall;
    logic [31:0] alu_operand1;
    logic [31:0] alu_operand2;

    // Write Back

    logic wb_alu_to_reg;
    logic [31:0] wb_result;
    logic [2:0] wb_alu_operation;
    logic wb_mem_write;
    logic wb_mem_to_reg;
    logic [4:0] wb_dest_reg_sel;
    logic wb_branch;
    logic wb_branch_nxt;
    logic [31:0] wb_write_address;
    logic [1:0] wb_read_address;
    logic [3:0] wb_write_byte;
    logic [31:0] wb_write_data;
    logic [31:0] wb_read_data;
    logic [31:0] inst_mem_address;

//------------------------------------------------------//
assign dmem_write_address = wb_write_address;     // assigning where to write
assign dmem_read_address = alu_operand1 + execute_immediate;  // Assigning address to read from the data memory
assign dmem_read_ready = mem_to_reg;   // load instruction flag to read from memory
assign dmem_write_ready = wb_mem_write;     // flag to write into the memory
assign dmem_write_data = wb_write_data;    // assigning data to write
assign dmem_write_byte = wb_write_byte;    // flag for writing the data bytes
assign dmem_read_data = dmem_read_data_temp;      // data read from the memory
assign dmem_read_valid_checker = 1'b1;
// -----------------------------------------------------//

// Instantiating Instruction fetch module -----------------------
IF_ID IF_ID(
    .clk (clk),
    .reset (reset),
    .stall (stall),
    .exception (exception),
    .inst_mem_read_data (inst_mem_read_data),
    .inst_mem_is_valid (inst_mem_is_valid)
);

// Instantiating execute module -----------------------------------
execute execute(
    .clk (clk),
    .reset (reset)
);

// Instantiating Writeback module ----------------------------------
wb wb(
    .clk (clk),
    .reset (reset)
);

endmodule
