`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
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


module IFStage(
    input ClockInput,
    input [31:0] BranchAddress,
    input BranchSelection,
    input IF_StallReq,
    output[31:0] Instruction,
    output[31:0] ProgramCounter
    );
    
InstructionROM ProgramMEM(
    ClockInput,
    BranchAddress,
    BranchSelection, // control signal
    IF_StallReq,
    Instruction,
    ProgramCounter
    ); 

endmodule
