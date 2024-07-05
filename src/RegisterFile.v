`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bharathi Shrinivasan T R (h20220182@pilani.bits-pilani.ac.in)
// 
// Create Date: 14.07.2023 13:01:09
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile(
    input ClockInput,
    input [3:0] Rprimary,
    input [3:0] Rsecondary,
    input [3:0] Rwrite,
    input WriteRegSignal, //control sginal
    input [31:0] WriteData,
    output reg [31:0] ReadPrimary,
    output reg [31:0] ReadSecondary
    );
    
    reg[31:0] Reg[15:0]; // R0-R15 register bank
        
    always @(posedge ClockInput) // first Half - write register // ensures any write-back complete before reading same.
    begin
        if(WriteRegSignal) Reg[Rwrite]<=WriteData;
    end
    
    always @(negedge ClockInput) // second Half - read register
    begin
        ReadPrimary<=Reg[Rprimary];
        ReadSecondary<=Reg[Rsecondary];
    end
    
    initial begin
       Reg[1]=45;
        Reg[2]=100;
        Reg[7]=543;
        Reg[9]=890;
        Reg[10]=100; 
        //Reg[0]=0;
        //Reg[3]=1;
        //Reg[4]=32'h1A6D;
    end
    
endmodule
