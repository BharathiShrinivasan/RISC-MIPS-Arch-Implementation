`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2023 15:41:49
// Design Name: 
// Module Name: Brancher
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


module Brancher(
    input ClockInput,
    input [19:0] RelativeOFFSET,
    input [27:0] DirectBranch,
    input [31:0] PCAddress,
    input [1:0] BranchType, // control signal - 3=ConditionalBranch, 0=None, UnconditionalBranch=1
    input ZeroFlag,
    output reg BranchSignal=0, // generated control signal
    output reg [31:0] BranchAddress=0
    );
    
    parameter ConditionalBranch=3, UnconditionalBranch=1;
    always @(posedge ClockInput)
    begin
        case(BranchType)
            UnconditionalBranch:    begin
                                        BranchAddress<={4'b0000,DirectBranch};
                                        BranchSignal<=1;
                                    end                                    
                                        
            ConditionalBranch:      begin
                                        if(RelativeOFFSET[19])BranchAddress<=PCAddress+{12'hFFF,RelativeOFFSET};
                                        else BranchAddress<=PCAddress+{12'b0,RelativeOFFSET};
                                        BranchSignal<=ZeroFlag;
                                    end
            default: begin 
                        BranchAddress<=0;
                        BranchSignal<=0;
                     end                                                                      
        endcase 
    end
    
    
endmodule
