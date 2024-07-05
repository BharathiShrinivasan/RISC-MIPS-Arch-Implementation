`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2023 21:30:48
// Design Name: 
// Module Name: EXLocalController
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


module EXLocalController(
    input [31:0] Instruction,
    output reg AddrCalSignal,
    output reg [3:0] Function
    );
    wire [3:0] OpCode;
    wire [3:0] FunctionCode;
    
    assign OpCode=Instruction[31:28],FunctionCode=Instruction[3:0];
    
    
    always@(*) // Control signal
    begin
        case (OpCode)
            1:  begin // ADD
                    AddrCalSignal<=0;
                    Function<=FunctionCode;
                end
            2:  begin // LW
                    AddrCalSignal<=1;
                    Function<=0;
                end     
            3:  begin // SW
                    AddrCalSignal<=1;
                    Function<=0;
                end
            4:  begin // BEQ
                    AddrCalSignal<=0;
                    Function<=1;
                end
            default:  begin // none
                    AddrCalSignal<=0;
                    Function<=0;
                end
        endcase
    end
endmodule
