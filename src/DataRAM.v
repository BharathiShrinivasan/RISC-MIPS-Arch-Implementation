`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2023 13:25:33
// Design Name: 
// Module Name: DataRAM
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


module DataRAM(
    input ClockInput,
    input [31:0] Address,
    input [31:0] WriteData,
    input WriteSignal, //control sginal
    output reg [31:0] ReadData=0
    );
    
    reg[31:0] Data[127:0]; // 128 datas it can hold
    
    always @(posedge ClockInput)
    begin
        if(WriteSignal) Data[Address]<=WriteData;
    end
    
    always @(negedge ClockInput)
    begin
        ReadData<=Data[Address];
    end
    
    initial begin
        Data[0]=0;
        Data[1]=1;
    end
    
endmodule
