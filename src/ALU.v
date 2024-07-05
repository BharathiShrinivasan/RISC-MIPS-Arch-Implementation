`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2023 13:52:13
// Design Name: 
// Module Name: ALU
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


module ALU(
    input ClockInput,
    input [31:0] PriOperand,
    input [31:0] SecOperand,
    input [31:0] OFFSETOperand,
    input AddressCalculateSignal, //control sginal
    input [3:0] Function, //control sginal
    output reg [31:0] Result=0,
    output reg ZeroFlag=0
    );
    
    parameter Addition=0, Subtraction=1, ANDbits=2, ORbits=3, XORbits=4; // default is addition
    
    always @(negedge ClockInput) // second half. First half wait for the control signals to settle.
    begin
        case(Function)
            Addition: Result<=PriOperand + (AddressCalculateSignal?OFFSETOperand:SecOperand);
            Subtraction: Result<=PriOperand - (AddressCalculateSignal?OFFSETOperand:SecOperand);
            ANDbits: Result<=PriOperand & (AddressCalculateSignal?OFFSETOperand:SecOperand);
            ORbits: Result<=PriOperand | (AddressCalculateSignal?OFFSETOperand:SecOperand);
            XORbits: Result<=PriOperand ^ (AddressCalculateSignal?OFFSETOperand:SecOperand);
            default: Result<=PriOperand + (AddressCalculateSignal?OFFSETOperand:SecOperand);
        endcase
    end
    
    always @(Result) ZeroFlag<=(Result==0)?1:0;
    
endmodule
