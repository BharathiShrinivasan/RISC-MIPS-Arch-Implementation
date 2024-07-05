`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: BStronics
// Engineer: Bharathi TR
// 
// Create Date: 15.07.2023 01:02:29
// Design Name: 
// Module Name: MIPS_Complete
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


module MIPS_Complete(
    input ClockSource, input ClockPipeline
    );
    
wire ClockPhase1,ClockPhase2;
assign ClockPhase1=ClockSource, ClockPhase2=ClockSource;
 
reg[63:0] IF_ID_Pipeline=0;
parameter IF_ID_InstructionIndex=0,IF_ID_ProgramCounterIndex=32;
wire Hazard_StallReq,IF_ID_Purge; // Stall= ChipDisable, Purge=Reset
//IF_ID_Pipeline[(IF_ID_InstructionIndex+31):IF_ID_InstructionIndex],IF_ID_Pipeline[(IF_ID_ProgramCounterIndex+31):IF_ID_ProgramCounterIndex]

reg[131:0] ID_EX_Pipeline=0;
parameter  ID_EX_InstructionIndex=0,ID_EX_ProgramCounterIndex=32,ID_EX_RdestinationIndex=64,ID_EX_ReadPrimaryIndex=100,ID_EX_ReadSecondaryIndex=68;
wire ID_EX_Stall,ID_EX_Purge; // Stall= ChipDisable, Purge=Reset
//ID_EX_Pipeline[(ID_EX_InstructionIndex+31):ID_EX_InstructionIndex],ID_EX_Pipeline[(ID_EX_ProgramCounterIndex+31):ID_EX_ProgramCounterIndex],
//ID_EX_Pipeline[(ID_EX_RdestinationIndex+3):ID_EX_RdestinationIndexnIndex],ID_EX_Pipeline[(ID_EX_ReadPrimaryIndex+31):ID_EX_ReadPrimaryIndex],D_EX_Pipeline[(ID_EX_ReadSecondaryIndex+31):ID_EX_ReadSecondaryIndex]

reg[132:0] EX_MEM_Pipeline=0;
parameter EX_MEM_InstructionIndex=0,EX_MEM_ProgramCounterIndex=32,EX_MEM_RdestinationIndex=64,EX_MEM_ReadSecondaryIndex=68,EX_MEM_ResultIndex=100,EX_MEM_FlagIndex=132;
wire EX_MEM_Stall,EX_MEM_Purge; // Stall= ChipDisable, Purge=Reset
//EX_MEM_Pipeline[(EX_MEM_InstructionIndex+31):EX_MEM_InstructionIndex],EX_MEM_Pipeline[(EX_MEM_ProgramCounterIndex+31):EX_MEM_ProgramCounterIndex],
//EX_MEM_Pipeline[(EX_MEM_RdestinationIndex+3):EX_MEM_RdestinationIndex],EX_MEM_Pipeline[(EX_MEM_ReadSecondaryIndex+31):EX_MEM_ReadSecondaryIndex],EX_MEM_Pipeline[(EX_MEM_ResultIndex+31):EX_MEM_ResultIndex],EX_MEM_Pipeline[EX_MEM_FlagIndex]

reg[99:0] MEM_WB_Pipeline=0;
parameter MEM_WB_InstructionIndex=0,MEM_WB_RdestinationIndex=32,MEM_WB_ResultIndex=36,MEM_WB_ReadDataIndex=68;
wire MEM_WB_Stall,MEM_WB_Purge; // Stall= ChipDisable, Purge=Reset
//MEM_WB_Pipeline[(MEM_WB_InstructionIndex+31):MEM_WB_InstructionIndex], MEM_WB_Pipeline[(MEM_WB_RdestinationIndex+3):MEM_WB_RdestinationIndex], MEM_WB_Pipeline[(MEM_WB_ResultIndex+31):MEM_WB_ResultIndex]
//MEM_WB_Pipeline[(MEM_WB_ReadDataIndex+31):MEM_WB_ReadDataIndex]

wire MEM_BranchSignal;
wire[31:0] MEM_BranchAddress;
wire[31:0] WB_WriteData;
wire WB_RegWriteSignal;


wire [1:0] ID_FwdPrimary,ID_FwdSecondary; // Port forwarding unit
parameter FwdEX_ALUResult=2'h1,FwdMEM_ALUResult=2'h2,FwdMEM_MemoryRead=2'h3; // portforwarding enumeration
wire[31:0] MEM_ReadData,MEM_ALUResult; // used in portforwarding
wire[31:0] EX_Result; // used in portforwarding

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

wire[31:0] IF_Instruction,IF_ProgramCounter;
IFStage IF_Module(
    ClockPhase1,
    MEM_BranchAddress, // JUMP of BEQ lable from MEM
    MEM_BranchSignal, // whether to branch=1 / normal pc->pc+1 branch=0 from MEM
    Hazard_StallReq, // Stall request for bubble (nop) insertion in case of Hazard detection
    IF_Instruction, // throw Instruction read
    IF_ProgramCounter // Throw PC value = address of next instruction
    );

// write IF_ID_Pipeline 
always @(posedge ClockPipeline)
begin
    if(IF_ID_Purge)IF_ID_Pipeline<=64'b0; // Purge the pipe
    else    begin
                if(~Hazard_StallReq)begin // if no stall
                    IF_ID_Pipeline[(IF_ID_InstructionIndex+31):IF_ID_InstructionIndex]<=IF_Instruction;
                    IF_ID_Pipeline[(IF_ID_ProgramCounterIndex+31):IF_ID_ProgramCounterIndex]<=IF_ProgramCounter;
                end
            end
end

// IF-ID pipeline ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

wire[31:0] ID_ReadPrimary,ID_ReadSecondary; wire[3:0] ID_Rdestination,ID_RPrimary,ID_RSecondary;
reg[31:0] ID_FinalPrimary, ID_FinalSecondary;

IDStage ID_Module(
    ClockPhase1,
    IF_ID_Pipeline[(IF_ID_InstructionIndex+31):IF_ID_InstructionIndex], // catch Instruction read
    MEM_WB_Pipeline[(MEM_WB_RdestinationIndex+3):MEM_WB_RdestinationIndex], // Write operation from Write-back stage
    WB_RegWriteSignal, // operation from Write-back stage
    WB_WriteData, // operation from Write-back stage
    ID_ReadPrimary, // Throw Primary value = Rs or Rbase
    ID_ReadSecondary, // Throw second operand or word to store in MEM
    ID_Rdestination, // Throw distination reg no.
    ID_RPrimary, // Primary reg accessed
    ID_RSecondary // secondary reg accessed    
    );
    
// PORT FORWARDING realted

    always @(*) //ID_FwdPrimary,EX_Result,MEM_ALUResult,MEM_ReadData,ID_ReadPrimary
    begin
        case (ID_FwdPrimary)
            FwdEX_ALUResult:ID_FinalPrimary<=EX_Result;
            FwdMEM_ALUResult:ID_FinalPrimary<=MEM_ALUResult;
            FwdMEM_MemoryRead:ID_FinalPrimary<=MEM_ReadData;
            default:ID_FinalPrimary<=ID_ReadPrimary;
        endcase 
    end
    
    always @(*) //ID_FwdSecondary,EX_Result,MEM_ALUResult,MEM_ReadData,ID_ReadSecondary
    begin
        case (ID_FwdSecondary)
            FwdEX_ALUResult:ID_FinalSecondary<=EX_Result;
            FwdMEM_ALUResult:ID_FinalSecondary<=MEM_ALUResult;
            FwdMEM_MemoryRead:ID_FinalSecondary<=MEM_ReadData;
            default:ID_FinalSecondary<=ID_ReadSecondary;
        endcase 
    end
    
// write ID_EX_Pipeline
always @(posedge ClockPipeline)
begin
    if(ID_EX_Purge)ID_EX_Pipeline<=132'b0; // Purge the pipe
    else    begin
                if(~ID_EX_Stall)begin // if no stall
                     ID_EX_Pipeline[(ID_EX_InstructionIndex+31):ID_EX_InstructionIndex]<=IF_ID_Pipeline[(IF_ID_InstructionIndex+31):IF_ID_InstructionIndex];
                     ID_EX_Pipeline[(ID_EX_ProgramCounterIndex+31):ID_EX_ProgramCounterIndex]<=IF_ID_Pipeline[(IF_ID_ProgramCounterIndex+31):IF_ID_ProgramCounterIndex];
                     ID_EX_Pipeline[(ID_EX_RdestinationIndex+3):ID_EX_RdestinationIndex]<=ID_Rdestination;
                     ID_EX_Pipeline[(ID_EX_ReadPrimaryIndex+31):ID_EX_ReadPrimaryIndex]<=ID_FinalPrimary;
                     ID_EX_Pipeline[(ID_EX_ReadSecondaryIndex+31):ID_EX_ReadSecondaryIndex]<=ID_FinalSecondary;
                end
            end
end

// ID-EX pipeline /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

wire EX_flag; wire[3:0] EX_Rdestination,EX_OpCode;
EXStage EX_Module(
    ClockPhase1,
    ID_EX_Pipeline[(ID_EX_InstructionIndex+31):ID_EX_InstructionIndex],
    ID_EX_Pipeline[(ID_EX_ReadPrimaryIndex+31):ID_EX_ReadPrimaryIndex],
    ID_EX_Pipeline[(ID_EX_ReadSecondaryIndex+31):ID_EX_ReadSecondaryIndex],
    EX_Result,
    EX_flag
    );
assign EX_Rdestination=ID_EX_Pipeline[(ID_EX_RdestinationIndex+3):ID_EX_RdestinationIndex],EX_OpCode=ID_EX_Pipeline[(ID_EX_InstructionIndex+31):(ID_EX_InstructionIndex+28)];
    
// Write EX_MEM pipeline
always @(posedge ClockPipeline)
begin
    if(EX_MEM_Purge)EX_MEM_Pipeline<=133'b0; // Purge the pipe
    else    begin
                if(~EX_MEM_Stall)begin // if no stall
                       EX_MEM_Pipeline[(EX_MEM_InstructionIndex+31):EX_MEM_InstructionIndex]<= ID_EX_Pipeline[(ID_EX_InstructionIndex+31):ID_EX_InstructionIndex];
                       EX_MEM_Pipeline[(EX_MEM_ProgramCounterIndex+31):EX_MEM_ProgramCounterIndex]<=ID_EX_Pipeline[(ID_EX_ProgramCounterIndex+31):ID_EX_ProgramCounterIndex];
                       EX_MEM_Pipeline[(EX_MEM_RdestinationIndex+3):EX_MEM_RdestinationIndex]<=ID_EX_Pipeline[(ID_EX_RdestinationIndex+3):ID_EX_RdestinationIndex];
                       EX_MEM_Pipeline[(EX_MEM_ReadSecondaryIndex+31):EX_MEM_ReadSecondaryIndex]<=ID_EX_Pipeline[(ID_EX_ReadSecondaryIndex+31):ID_EX_ReadSecondaryIndex];
                       EX_MEM_Pipeline[(EX_MEM_ResultIndex+31):EX_MEM_ResultIndex]<=EX_Result;
                       EX_MEM_Pipeline[EX_MEM_FlagIndex]<=EX_flag;
                end
            end
end

// EX-MEM pipeline /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

wire[3:0] MEM_Rdestination,MEM_OpCode;
MEMStage Memory_Module(
    ClockPhase1,
    EX_MEM_Pipeline[(EX_MEM_InstructionIndex+31):EX_MEM_InstructionIndex],
    EX_MEM_Pipeline[(EX_MEM_ProgramCounterIndex+31):EX_MEM_ProgramCounterIndex],
    EX_MEM_Pipeline[(EX_MEM_ResultIndex+31):EX_MEM_ResultIndex], // ALU result
    EX_MEM_Pipeline[EX_MEM_FlagIndex],
    EX_MEM_Pipeline[(EX_MEM_ReadSecondaryIndex+31):EX_MEM_ReadSecondaryIndex], // Store word Rt_store
    MEM_ReadData,
    MEM_BranchSignal,
    MEM_BranchAddress
    );
assign MEM_Rdestination=EX_MEM_Pipeline[(EX_MEM_RdestinationIndex+3):EX_MEM_RdestinationIndex],MEM_OpCode=EX_MEM_Pipeline[(EX_MEM_InstructionIndex+31):(EX_MEM_InstructionIndex+28)];
assign MEM_ALUResult=EX_MEM_Pipeline[(EX_MEM_ResultIndex+31):EX_MEM_ResultIndex];

//Write MEM-WB pipeline
always @(posedge ClockPipeline)
begin
    if(MEM_WB_Purge)MEM_WB_Pipeline<=100'b0; // Purge the pipe
    else    begin
                if(~MEM_WB_Stall)begin // if no stall
                        MEM_WB_Pipeline[(MEM_WB_InstructionIndex+31):MEM_WB_InstructionIndex]<=EX_MEM_Pipeline[(EX_MEM_InstructionIndex+31):EX_MEM_InstructionIndex];
                        MEM_WB_Pipeline[(MEM_WB_RdestinationIndex+3):MEM_WB_RdestinationIndex]<=EX_MEM_Pipeline[(EX_MEM_RdestinationIndex+3):EX_MEM_RdestinationIndex];
                        MEM_WB_Pipeline[(MEM_WB_ResultIndex+31):MEM_WB_ResultIndex]<=EX_MEM_Pipeline[(EX_MEM_ResultIndex+31):EX_MEM_ResultIndex];
                        MEM_WB_Pipeline[(MEM_WB_ReadDataIndex+31):MEM_WB_ReadDataIndex]<=MEM_ReadData;
                end
            end
end

// MEM-WB pipeline ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

WBStage WB_Module(
    ClockPhase1,
    MEM_WB_Pipeline[(MEM_WB_InstructionIndex+31):MEM_WB_InstructionIndex],
    MEM_WB_Pipeline[(MEM_WB_ReadDataIndex+31):MEM_WB_ReadDataIndex],
    MEM_WB_Pipeline[(MEM_WB_ResultIndex+31):MEM_WB_ResultIndex],
    WB_WriteData,
    WB_RegWriteSignal
    );
    
// Internal Port-forwarding unit integration =================================================================================================================================================================================================================

wire PortFwd_StallRquest;

PortForwardingController PortForwarder_Module( // writes @ posedge
    ClockPhase1,
    ID_RPrimary,
    ID_RSecondary,
    EX_Rdestination,
    EX_OpCode,
    MEM_Rdestination,
    MEM_OpCode,
    ID_FwdPrimary,
    ID_FwdSecondary,
    PortFwd_StallRquest
    );

// HAZARD Addressing Unit integration

HazardAddresser HazardAddresser_Module( // writes @ negedge
    ClockPhase1,
    MEM_BranchSignal,
    PortFwd_StallRquest,
    Hazard_StallReq,
    IF_ID_Purge,
    ID_EX_Stall,
    ID_EX_Purge,
    EX_MEM_Stall,
    EX_MEM_Purge,
    MEM_WB_Stall,
    MEM_WB_Purge
    );
    
endmodule
