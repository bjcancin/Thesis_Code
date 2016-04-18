`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.09.2015 18:04:30
// Design Name: 
// Module Name: DUT_Registro
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


module DUT_Registro(
    input sclk,
    input lclk,
    input en_n,
    input in,
    
    output [7:0] opamp,
    output [2:0] psave,
    output [1:0] rst,
    output [4:0] supply,
    output [1:0] ADC,
    output [3:0] DPOT,
    output [23:0] aux
    );
    
    // Comentarios
    
    // Parametros
    
        parameter CS_NONE  = 6'b111111;
        parameter CS_ADC1  = 6'b111110;
        parameter CS_ADC2  = 6'b111101;
        parameter CS_DPOT1 = 6'b111011;
        parameter CS_DPOT2 = 6'b110111;
        parameter CS_DPOT3 = 6'b101111;
        parameter CS_DPOT4 = 6'b011111;
            
        parameter EN_IOP1 = 13'd1;
        parameter EN_IOP2 = 13'd2;
        parameter EN_IOP3 = 13'd4;
        parameter EN_IOP4 = 13'd8;
        parameter EN_ROP1 = 13'd16;
        parameter EN_ROP2 = 13'd32;
        parameter EN_ROP3 = 13'd64;
        parameter EN_ROP4 = 13'd128;
        parameter EN_IS1  = 13'd256;    // Imagen OP1 Supply
        parameter EN_IS2  = 13'd512;    // Imagen OP2 Supply
        parameter EN_IS3  = 13'd1024;   // Imagen OP3 Supply
        parameter EN_IS4  = 13'd2048;   // Imagen OP4 Supply
        parameter EN_RS   = 13'd4096;   // Register OP Supply
        
        parameter PSAVE1 = 3'b001;
        parameter PSAVE2 = 3'b010;
        parameter PSAVE3 = 3'b100;
        
        parameter EN_RESET1 = 2'b01;    // Supply Reset
        parameter EN_RESET2 = 2'b10;    // Enable Reset Inputs
        
    
    // Wires y Registros
    
    reg [23:0] registro_in = 24'b0;
    reg [23:0] registro_load = 24'b0;
    
    
    // Always y Asignaciones
    // reg_word = {reg_word3, reg_word2, reg_word1};
    
    wire [23:0] out = (!en_n)?   registro_load : 24'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz;
    
    wire [7:0] reg1 = out[7:0];    //{en_rst[1], cs[5], en_rst[0], cs[1], psave[2], en[12], cs[4], en[11]};
    wire [7:0] reg2 = out[15:8];   //{psave[1], en[3], en[2], en[1], en[0], en[10], cs[3], en[7]};
    wire [7:0] reg3 = out[23:16];  //{en[6], en[5], en[4], cs[0], en[9], psave[0], cs[2], en[8]};
    
    wire [12:0] en = {reg1[2], reg1[0], reg2[2], reg3[3], reg3[0], reg2[0], reg3[7], reg3[6], reg3[5], reg2[6], reg2[5], reg2[4], reg2[3]};
    
    wire [5:0] cs = {reg1[6], reg1[1], reg2[1], reg3[1], reg1[4], reg3[4]};
    
    
    /////////////
    // Simulación
    /////////////
    
    assign aux = registro_in;
    
    
    
    
    assign opamp = en[7:0];
    assign psave = {reg1[3], reg2[7], reg3[2]};
    assign rst = {reg1[7], reg1[5]};
    assign supply = en[12:8];
    assign ADC = ~cs[1:0];
    assign DPOT = ~cs[5:2];
    
    
    
    always @(posedge sclk)
        registro_in <= {in, registro_in[23:1]};
        
    always @(posedge lclk)
        registro_load <= registro_in;
    
    
    
    
    
endmodule
