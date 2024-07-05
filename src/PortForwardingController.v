`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.07.2023 22:09:11
// Design Name: 
// Module Name: PortForwardingController
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


module PortForwardingController(
    input ClockInput,
    input [3:0] ID_RPrimary,
    input [3:0] ID_RSecondary,
    input [3:0] EX_Rdestination,
    input [3:0] EX_OpCode,
    input [3:0] MEM_Rdestination,
    input [3:0] MEM_OpCode,
    output reg [1:0] ID_FwdPrimary=0,
    output reg [1:0] ID_FwdSecondary=0,
    output reg StallRequest=0
    );
    
    parameter FwdEX_ALUResult=2'h1,FwdMEM_ALUResult=2'h2,FwdMEM_MemoryRead=2'h3;
    
    always @(posedge ClockInput)
    begin
        //Check in EX unit as its latest
        if(EX_OpCode==1 && EX_Rdestination==ID_RPrimary && (|ID_RPrimary)) ID_FwdPrimary<=FwdEX_ALUResult;
        else begin //Check in MEM unit
            if(MEM_OpCode==1 && MEM_Rdestination==ID_RPrimary && (|ID_RPrimary))ID_FwdPrimary<=FwdMEM_ALUResult;
            else begin
                if(MEM_OpCode==2 && MEM_Rdestination==ID_RPrimary && (|ID_RPrimary))ID_FwdPrimary<=FwdMEM_MemoryRead;
                else ID_FwdPrimary<=0;
            end            
        end
    end
    
    always @(posedge ClockInput)
    begin
        //Check in EX unit as its latest
        if(EX_OpCode==1 && EX_Rdestination==ID_RSecondary && (|ID_RSecondary)) ID_FwdSecondary<=FwdEX_ALUResult;
        else begin //Check in MEM unit
            if(MEM_OpCode==1 && MEM_Rdestination==ID_RSecondary && (|ID_RSecondary))ID_FwdSecondary<=FwdMEM_ALUResult;
            else begin
                if(MEM_OpCode==2 && MEM_Rdestination==ID_RSecondary && (|ID_RSecondary))ID_FwdSecondary<=FwdMEM_MemoryRead;
                else ID_FwdSecondary<=0;
            end            
        end
    end
    
    always @(posedge ClockInput)
    begin
        if(EX_OpCode==2)begin//LW
            if(((EX_Rdestination==ID_RPrimary)&&(|ID_RPrimary)) || ((EX_Rdestination==ID_RSecondary)&&(|ID_RSecondary)))begin
                StallRequest<=1;
            end
            else StallRequest<=0;
        end
        else StallRequest<=0;
    end
    
endmodule
