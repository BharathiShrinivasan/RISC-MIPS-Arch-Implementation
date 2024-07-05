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


module WBStage(
    input ClockInput,
    input[31:0] Instruction,
    input[31:0] MEMRead,
    input [31:0] ALUResult,
    output[31:0] WriteData,
    output RegWriteSignal
    );
    
    wire MemALUSel;
WriteBack WriteBackUnit(
    MEMRead,
    ALUResult,
    MemALUSel, // control signal 0=ALU, 1=MEM
    WriteData 
    );
    
WBLocalController WBControl(
    Instruction,
    MemALUSel,
    RegWriteSignal
    );

    
endmodule
