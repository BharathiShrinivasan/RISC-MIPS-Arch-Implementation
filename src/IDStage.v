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


module IDStage(
    input ClockInput,
    input[31:0] Instruction,
    input[3:0] Rwrite, // From WB stage to access Register File
    input WriteRegSignal,
    input[31:0] WriteData,
    output[31:0] ReadPrimary,
    output[31:0] ReadSecondary, // second operand or store word
    output[3:0] Rdestination, // distination reg for given instruction
    output [3:0] Rprimary_base,//Reg no.
    output [3:0] Rsecondary_store//Reg no.
    );
    
RegisterFile RegBank(
    ClockInput,
    Rprimary_base,
    Rsecondary_store,
    Rwrite,
    WriteRegSignal, //control sginal
    WriteData,
    ReadPrimary,
    ReadSecondary);
    
Decoder RegDecoder(
    Instruction,
    Rprimary_base, // holds register no. of either primary or base
    Rsecondary_store, // holds  register no. of either secondary or store-word to put in MEM
    Rdestination
    );
    
endmodule
