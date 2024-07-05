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


module EXStage(
    input ClockInput,
    input[31:0] Instruction,
    input [31:0] PriOperand,
    input [31:0] SecOperand,
    output [31:0] Result,
    output ZeroFlag
    );

    wire[31:0] OFFSETOperand;
    assign OFFSETOperand={12'b0,Instruction[19:0]};
    
    wire AddrCalSignal; // 1=OFFSET , 0=Second operand
    wire[3:0] Function;
    
ALU ALUUnit(
    ClockInput,
    PriOperand,
    SecOperand,
    OFFSETOperand,
    AddrCalSignal, //control sginal
    Function, //control sginal
    Result,
    ZeroFlag);

EXLocalController EXControl(
    Instruction,
    AddrCalSignal,
    Function
    );
endmodule
