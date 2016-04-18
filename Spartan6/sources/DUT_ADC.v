`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.09.2015 12:00:24
// Design Name: 
// Module Name: DUT_ADC
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


module DUT_ADC(
    input en,
    input sclk,
    input in,
    
    output reg [7:0] setup,
    output reg [7:0] aver,
    output reg [7:0] conver
    );
    
    // Comentarios
    
    // Iniciales
    initial begin
        setup = 8'b0;
        aver = 8'b0;
        conver = 8'b0;
    end
    
    // Wires y Registros
    reg [7:0] state = 8'b0;
    reg [7:0] registro = 8'b0;
    
    
    
    // Modulos
    
    // Always y Asignaciones
    always @(posedge sclk)
    begin
        if(en)
        begin
            state <= (state < 8'd8)?    (state + 8'b1)  :   8'b1;
            registro <= {registro[6:0] , in};
        end
        
        else
        begin
            state <= state;
            registro <= registro;
        end
    end
    
    always @(negedge sclk)
    begin
        if(state == 8'd8)
        begin
            setup <= (registro[7:6] == 2'b1)?   registro    :   setup;
            aver <= (registro[7:5] == 3'b1)?    registro    :   aver;
            conver <= (registro[7] == 1'b1)?    registro    :   conver;
        end
        
        else
        begin
            setup <= setup;
            aver <= aver;
            conver <= conver;
        end
    end
    
    
    
    
    
    
    
endmodule
