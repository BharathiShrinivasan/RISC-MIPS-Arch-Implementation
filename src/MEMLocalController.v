`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2023 21:34:42
// Design Name: 
// Module Name: MEMLocalController
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


module MEMLocalController(
    input [31:0] Instruction,
    output reg[1:0] BranchType,
    output reg WriteSignal
    );
    
    wire [3:0] OpCode;
    assign OpCode=Instruction[31:28];
    
    always@(*) // Control signal
    begin
        case (OpCode)  
            3:  begin // SW
                    BranchType<=0;
                    WriteSignal<=1;
                end
            4:  begin // BEQ
                    BranchType<=3;
                    WriteSignal<=0;
                end
            5:  begin // JUMP
                    BranchType<=1;
                    WriteSignal<=0;
                end  
          default:  begin // ADD, LW, None
                        BranchType<=0;
                        WriteSignal<=0;
                    end 
        endcase
    end
endmodule
