`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.07.2023 18:30:46
// Design Name: 
// Module Name: Decoder
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


module Decoder(
    input [31:0] Instruction,
    output reg [3:0] Rprimary_base, // holds register no. of either primary or base
    output reg [3:0] Rsecondary_store, // holds  register no. of either secondary or store-word to put in MEM
    output reg [3:0] Rdestination
    );
    
    wire [3:0] OpCode;    
    assign OpCode=Instruction[31:28];
    
    always@(*) // extract register and offset
    begin
        case (OpCode)
            1:  begin //ADD,AND
                    Rprimary_base<=Instruction[27:24];
                    Rsecondary_store<=Instruction[23:20];
                    Rdestination<=Instruction[19:16];

                end
            2:  begin // LW
                    Rprimary_base<=Instruction[27:24];
                    Rsecondary_store<=0;
                    Rdestination<=Instruction[23:20];
                end     
            3:  begin  //SW 
                    Rprimary_base<=Instruction[27:24];
                    Rsecondary_store<=Instruction[23:20];
                    Rdestination<=0;
                end   
            4:  begin   // Branch
                    Rprimary_base<=Instruction[27:24];
                    Rsecondary_store<=Instruction[23:20];
                    Rdestination<=0;
                end         
            default:  begin   
                        Rprimary_base<=0;
                        Rsecondary_store<=0;
                        Rdestination<=0;
                       end  
        endcase
    end
    
endmodule
