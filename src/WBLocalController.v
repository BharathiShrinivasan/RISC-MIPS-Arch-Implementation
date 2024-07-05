`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2023 21:34:42
// Design Name: 
// Module Name: WBLocalController
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


module WBLocalController(
    input [31:0] Instruction,
    output reg MemALUSel,
    output reg RegWriteSignal
    );
    wire [3:0] OpCode;
    assign OpCode=Instruction[31:28];
    
    always@(*) // Control signal
    begin
        case (OpCode)
            1:  begin // ADD
                    MemALUSel<=0;
                    RegWriteSignal<=1;
                end
            2:  begin // LW
                    MemALUSel<=1;
                    RegWriteSignal<=1;
                end     
            default:    begin // SW, BEQ, JUMP, None
                            MemALUSel<=0;
                            RegWriteSignal<=0;
                        end
        endcase
    end
endmodule
