`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.07.2023 00:16:39
// Design Name: 
// Module Name: HazardAddresser
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


module HazardAddresser(
    input ClockInput,
    input MEM_BranchSignal,
    input PortFwd_StallRquest,
    output reg IF_StallRequest=0,
    output reg IF_ID_Purge=0,
    output reg ID_EX_Stall=0,
    output reg ID_EX_Purge=0,
    output reg EX_MEM_Stall=0,
    output reg EX_MEM_Purge=0,
    output reg MEM_WB_Stall=0,
    output reg MEM_WB_Purge=0
    );
    
    always @(negedge ClockInput) // inputs are asserted in posedge
    begin
        if(MEM_BranchSignal)begin // Purge IF_ID_Pipereg, ID_EX pipereg, EX_MEM pipereg ; 
            IF_ID_Purge<=1;
            ID_EX_Purge<=1;
            EX_MEM_Purge<=1;
            IF_StallRequest<=0;
        end
        else begin
            if(PortFwd_StallRquest)begin // Purge ID_EX, Stall IF
                IF_ID_Purge<=0;
                ID_EX_Purge<=1;
                EX_MEM_Purge<=0;
                IF_StallRequest<=1;
            end
            else begin
                IF_ID_Purge<=0;
                ID_EX_Purge<=0;
                EX_MEM_Purge<=0;
                IF_StallRequest<=0;
            end
        end
    end
endmodule
