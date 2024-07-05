`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bharathi Shrinivasan T R (h20220182@pilani.bits-pilani.ac.in)
// 
// Create Date: 14.07.2023 16:36:33
// Design Name: 
// Module Name: WriteBack
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


module WriteBack(
    input [31:0] MEMRead,
    input [31:0] ALUResult,
    input MemALUSel, // control signal 0=ALU, 1=MEM
    output reg [31:0] WriteData 
    );
    
    always @(MEMRead,ALUResult,MemALUSel)
    begin
        WriteData<=(MemALUSel?MEMRead:ALUResult);
    end
    
    
endmodule
