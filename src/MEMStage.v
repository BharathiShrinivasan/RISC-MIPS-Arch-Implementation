`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bharathi Shrinivasan T R (h20220182@pilani.bits-pilani.ac.in)
// 
// Create Date: 14.07.2023 23:16:12
// Design Name: 
// Module Name: IDStage
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MEMStage(
    input ClockInput,
    input[31:0] Instruction,
    input[31:0] PCAddress,
    input[31:0] Address, // ALU result
    input ZeroFlag,
    input[31:0] WriteData, // Store word Rt_store
    output[31:0] ReadData,
    output BranchSignal,
    output [31:0] BranchAddress
    );
    
    wire WriteSignal;
    wire[1:0] BranchType;
    
DataRAM MEMUnit(
    ClockInput,
    Address,
    WriteData,
    WriteSignal, //control sginal
    ReadData
    );
    
Brancher BranchUnit(
    ClockInput,
    Instruction[19:0],
    Instruction[27:0],
    PCAddress,
    BranchType, // control signal - 3=ConditionalBranch, 0=None, UnconditionalBranch=1
    ZeroFlag,
    BranchSignal, // generated control signal
    BranchAddress
    );
    
MEMLocalController MEMControl(
    Instruction,
    BranchType,
    WriteSignal
    );
    
endmodule
