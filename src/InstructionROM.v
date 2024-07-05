`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Bharathi Shrinivasan T R (h20220182@pilani.bits-pilani.ac.in)
// 
// Create Date: 14.07.2023 12:38:38
// Design Name: 
// Module Name: InstructionROM
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


module InstructionROM(
    input ClockInput,
    input [31:0] BranchAddress,
    input BranchSelection, // control signal
    input IF_StallReq, // Stall the IF
    output reg [31:0] InstructionFetched=0,
    output reg [31:0] ProgramCounter=0
    );
    
    reg[31:0] ProgramMEM[511:0]; //512 instructions can be stored (instruction of 32 bit)
    
    
    always@(posedge ClockInput)
    begin
        if(~IF_StallReq)
            begin
            if(BranchSelection==1)  begin // Branching to different location.
                                        InstructionFetched<=ProgramMEM[BranchAddress];
                                        ProgramCounter<=BranchAddress+1;
                                    end
             else   begin // routine branch PC=PC+1
                    InstructionFetched<=ProgramMEM[ProgramCounter];
                    ProgramCounter<=ProgramCounter+1;
                    end       
            end                                                                     
    end
    
    
    initial begin // Write your Program here
ProgramMEM[0]=32'h20100000;
ProgramMEM[1]=32'h20200001;
ProgramMEM[2]=32'h11230000;
ProgramMEM[3]=32'h434FFFFC;
ProgramMEM[4]=32'h12010000;
ProgramMEM[5]=32'h13020000;
ProgramMEM[6]=32'h50000002;
ProgramMEM[7]=32'h0;
ProgramMEM[8]=32'h0;


        ProgramMEM[8]=0;
        ProgramMEM[9]=0;
        ProgramMEM[10]=0;
        ProgramMEM[11]=0;
        ProgramMEM[12]=0;
        ProgramMEM[13]=0;
        ProgramMEM[14]=0;
        ProgramMEM[15]=0;
        ProgramMEM[16]=0;
        ProgramMEM[17]=0;
    end
endmodule
