`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2015 18:57:23
// Design Name: 
// Module Name: Control
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


module Control(
    input clk,
    
    input [7:0] opamp,
    
    input EOC1,
    input EOC2,
    
    input rst,
    
    input [7:0] ADC_setup,
    input [7:0] ADC_aver,
    input [7:0] ADC_conv,
    input ADC_1,
    input ADC_2,
    input ADC_read,
    
    input reconfig,
    
    input regspi_done,
    output regspi_load,
    output [23:0] reg_word,
    output [7:0] spi_word8,
    output [3:0] regspi_mode,
    output reg_en_n,
    
    output config_load_en,
    
    output done,
    
    output [15:0] aux
    );
    
    	//////////////////////////////
    	// Configuracion de Parametros
    	//////////////////////////////

    	parameter CS_NONE  = 6'b111111;
        parameter CS_ADC1  = 6'b111110;
        parameter CS_ADC2  = 6'b111101;
        	
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
        
        parameter REG       = 4'd0;
        parameter REG_SPI8  = 4'd1;
    	parameter REG_SPI9  = 4'd2;
    	parameter REG_READ  = 4'd3;
    	parameter SPI8      = 4'd4;
    	parameter SPI9      = 4'd5;
    	parameter READ      = 4'd6;
    	
    	////////////////////
    	// Wires y Registros
    	////////////////////
    	
    	reg [7:0] state = 8'b0;
    	wire clk_en;
    	wire [7:0] state_next;
    	
    	// Shift Register
    	wire [12:0] en;
        wire [5:0] cs;
        wire [2:0] psave;
        wire [1:0] en_rst;
        
    	
    	/////////////
    	// Simulacion
    	/////////////
    	
    	//assign aux = {3'b0, regspi_done, 3'b0, regspi_load, state};
    	//assign aux = {7'b0, ADC_read, state};
    	//assign aux = {3'b0, regspi_done,3'b0, reconfig, state};
    	//assign aux = {8'b0,state};
    	assign aux = {en[7:0],state};
    	
        ////////////////////////
        // Always y Asignaciones
        ////////////////////////
        
        wire [12:0] en_1 = (opamp[0])? EN_IS1 : 13'b0; 
        wire [12:0] en_2 = (opamp[1])? EN_IS2 : 13'b0;
        wire [12:0] en_3 = (opamp[2])? EN_IS3 : 13'b0;
        wire [12:0] en_4 = (opamp[3])? EN_IS4 : 13'b0;
        wire [12:0] en_5 = (opamp[7:4] > 4'b0)? EN_RS : 13'b0;
        //wire [12:0] en_h = en_2_1 | en_2_2 | en_2_3 | en_2_4 | en_2_5;
        
        //wire [1:0] en_rst_2 = (rst)? EN_RESET2 : 2'b0;
        
        
        // EN7, EN6, EN5, CS1, EN10, PSAVE1, CS3, EN9, PSAVE2, EN4, EN3, EN2, EN1, EN11, CS4, EN8, EN_RST2, CS6, EN_RST1, CS2, PSAVE3, EN13, CS5, EN12
        wire [7:0] reg_word1 = {en_rst[1], cs[5], en_rst[0], cs[1], psave[2], en[12], cs[4], en[11]};
        wire [7:0] reg_word2 = {psave[1], en[3], en[2], en[1], en[0], en[10], cs[3], en[7]};
        wire [7:0] reg_word3 = {en[6], en[5], en[4], cs[0], en[9], psave[0], cs[2], en[8]};
        
        wire [2:0] psave_1 = (opamp[2:0] > 3'b0)? PSAVE1 : 3'b0;
        wire [2:0] psave_2 = (opamp[5:3] > 3'b0)? PSAVE2 : 3'b0;
        wire [2:0] psave_3 = (opamp[7:6] > 2'b0)? PSAVE3 : 3'b0;
        
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        assign  clk_en = ((state[0] == 1'b0) && (state <= 8'd7))?       regspi_done     :   1'bz,  // Listo
                clk_en = ((state[0] == 1'b1) && (state <= 8'd7))?       ~regspi_done    :   1'bz,
                
                clk_en = (state == 8'd8)?       ADC_read     :   1'bz,
                clk_en = (state == 8'd9)?       regspi_done  :   1'bz,
                clk_en = (state == 8'd10)?      ~regspi_done :   1'bz,
                clk_en = (state == 8'd11)?      regspi_done  :   1'bz,
                clk_en = (state == 8'd12)?      ~regspi_done :   1'bz,
                clk_en = (state == 8'd13)?      ~EOC1        :   1'bz,
                clk_en = (state == 8'd14)?      regspi_done  :   1'bz,
                clk_en = (state == 8'd15)?      ~regspi_done :   1'bz,
                
                clk_en = (state == 8'd16)?      ADC_read     :   1'bz,
                clk_en = (state == 8'd17)?      regspi_done  :   1'bz,
                clk_en = (state == 8'd18)?      ~regspi_done :   1'bz,
                clk_en = (state == 8'd19)?      regspi_done  :   1'bz,
                clk_en = (state == 8'd20)?      ~regspi_done :   1'bz,
                clk_en = (state == 8'd21)?      ~EOC2        :   1'bz,
                clk_en = (state == 8'd22)?      regspi_done  :   1'bz,
                clk_en = (state == 8'd23)?      ~regspi_done :   1'bz,
                                
                clk_en = (state >  8'd23)?     1'b1         :   1'bz;
                
        assign  state_next = (reconfig)?                        8'd0    :   8'bzzzz_zzzz,   // Listo
                state_next = (ADC_1)?                           8'd8    :   8'bzzzz_zzzz,
                state_next = (ADC_2)?                           8'd16   :   8'bzzzz_zzzz,
                state_next = (~reconfig && ~ADC_1 && ~ADC_2)?   8'd5    :   8'bzzzz_zzzz;
        
        assign  en = (state >= 8'd4)?    (en_1 | en_2 | en_3 | en_4 | en_5) : 13'b0;
                    
        assign  en_rst = ((rst == 1'b1) && (state >= 8'd4))? (EN_RESET2 | EN_RESET1) : 2'b0;
                       
        assign psave = psave_1 | psave_2 | psave_3;     // Listo
        
        assign cs = ((state <= 8'd3))?                          (CS_ADC1 & CS_ADC2)     :   6'bzz_zzzz,
               
               cs = ((state >= 8'd4) && (state <= 8'd7))?       CS_NONE                 :   6'bzz_zzzz,
               
               cs = ((state >= 8'd8) && (state <= 8'd10))?      CS_ADC1                 :   6'bzz_zzzz,
               cs = ((state >= 8'd11) && (state <= 8'd13))?     CS_NONE                 :   6'bzz_zzzz,
               cs = ((state >= 8'd14) && (state <= 8'd15))?     CS_ADC1                 :   6'bzz_zzzz,
               
               cs = ((state >= 8'd16) && (state <= 8'd18))?     CS_ADC2                 :   6'bzz_zzzz,
               cs = ((state >= 8'd19) && (state <= 8'd21))?     CS_NONE                 :   6'bzz_zzzz,
               cs = ((state >= 8'd22) && (state <= 8'd23))?     CS_ADC2                 :   6'bzz_zzzz,
               
               cs = (state >= 8'd24)?                           CS_NONE                 :   6'bzz_zzzz;
                    
       
        assign reg_word = {reg_word3, reg_word2, reg_word1};
                
        assign reg_en_n = 1'b0;                                 // Listo
                             
        assign  regspi_load = (state <= 8'd7)?      ~state[0]   :   1'bz,   // Listo
        
                regspi_load = (state == 8'd8)?      1'b0        :   1'bz,
                regspi_load = (state == 8'd9)?      1'b1        :   1'bz,
                regspi_load = (state == 8'd10)?     1'b0        :   1'bz,
                regspi_load = (state == 8'd11)?     1'b1        :   1'bz,
                regspi_load = (state == 8'd12)?     1'b0        :   1'bz,
                regspi_load = (state == 8'd13)?     1'b0        :   1'bz,
                regspi_load = (state == 8'd14)?     1'b1        :   1'bz,
                regspi_load = (state == 8'd15)?     1'b0        :   1'bz,
                
                regspi_load = (state == 8'd16)?     1'b0        :   1'bz,
                regspi_load = (state == 8'd17)?     1'b1        :   1'bz,
                regspi_load = (state == 8'd18)?     1'b0        :   1'bz,
                regspi_load = (state == 8'd19)?     1'b1        :   1'bz,
                regspi_load = (state == 8'd20)?     1'b0        :   1'bz,
                regspi_load = (state == 8'd21)?     1'b0        :   1'bz,
                regspi_load = (state == 8'd22)?     1'b1        :   1'bz,
                regspi_load = (state == 8'd23)?     1'b0        :   1'bz,                        
                
                regspi_load = (state >  8'd23)?     1'b0        :   1'bz;
                
                            
        assign  spi_word8 =  ((state <= 8'd1))?                         ADC_aver    :   8'bzzzz_zzzz,   // Listo
                spi_word8 =  ((state >= 8'd2)  && (state <= 8'd3))?     ADC_setup   :   8'bzzzz_zzzz,
                spi_word8 =  ((state >= 8'd4)  && (state <= 8'd7))?     8'b0        :   8'bzzzz_zzzz,
                spi_word8 =  ((state >= 8'd8)  && (state <= 8'd23))?    ADC_conv    :   8'bzzzz_zzzz,
                spi_word8 = (state > 8'd23)?                            8'b0        :   8'bzzzz_zzzz;
                
        
        assign  regspi_mode = ((state <= 8'd1))?                        REG_SPI8    :   4'bzzzz,        // Listo
                regspi_mode = ((state >= 8'd2)  && (state <= 8'd3))?    SPI8        :   4'bzzzz,
                
                regspi_mode = ((state >= 8'd4)  && (state <= 8'd7))?    REG         :   4'bzzzz,
                
                regspi_mode = ((state >= 8'd8)  && (state <= 8'd10))?   REG_SPI8    :   4'bzzzz,
                regspi_mode = ((state >= 8'd11)  && (state <= 8'd13))?  REG         :   4'bzzzz,
                regspi_mode = ((state >= 8'd14)  && (state <= 8'd15))?  REG_READ    :   4'bzzzz,
                
                regspi_mode = ((state >= 8'd16)  && (state <= 8'd18))?  REG_SPI8    :   4'bzzzz,
                regspi_mode = ((state >= 8'd19)  && (state <= 8'd21))?  REG         :   4'bzzzz,
                regspi_mode = ((state >= 8'd22)  && (state <= 8'd23))?  REG_READ    :   4'bzzzz,
                
                regspi_mode = (state > 8'd37)?                          4'd7        :   4'bzzzz;    // Nada
        
        assign  config_load_en = ((state == 8'd15) || (state == 8'd23))?  1'b1    :   1'b0;  // Listo
        
        assign  done = (state == 8'd5)?     1'b1 :  1'b0;
        
        
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        always @(posedge clk)
        begin
            if(clk_en)
            begin
                if(state == 8'd0)       state <= 8'd1;         // Configuracion ADC Aver
                else if(state == 8'd1)  state <= 8'd2;         // Fin ADC Aver
                else if(state == 8'd2)  state <= 8'd3;         // Configuracion ADC Setup
                else if(state == 8'd3)  state <= 8'd4;         // Fin ADC Setup
                
                else if(state == 8'd4)  state <= 8'd5;          // Comienzo del fin del encendido de amplificadores
                else if(state == 8'd5)  state <= state_next;    // Estado de Espera.             
                
                else if(state == 8'd6)  state <= 8'd7;          // RECONGIGURACIÓN. Se escribe en_1_old y en_rst_1_old
                else if(state == 8'd7)  state <= 8'd4;          // Se finaliza la pre- reconfiguracion y se vuelve al inicio.
                
                else if(state == 8'd8)  state <= 8'd9;          // ADC1. Esperamos a ADC_Read. Recordar que se deben escribir 2 bytes
                else if(state == 8'd9)  state <= 8'd10;         // Se inicia la escritura en el conversion register.
                else if(state == 8'd10) state <= 8'd11;         // Finaliza la escritura en el conversion register.
                else if(state == 8'd11) state <= 8'd12;         // Inicio up todos los CS.
                else if(state == 8'd12) state <= 8'd13;         // Fin up todos los CS.
                else if(state == 8'd13) state <= 8'd14;         // Esperamos a que EOC1 = 0
                else if(state == 8'd14) state <= 8'd15;         // Inicio escritura CS_ADC1
                else if(state == 8'd15) state <= 8'd5;          // Fin escritura CS_ADC1. Los datos ya estan disponibles para la lectura.

                else if(state == 8'd16) state <= 8'd17;         // ADC2. Esperamos a ADC_Read. Recordar que se deben escribir 2 bytes. 
																// (la dirección más el registro de conversión).
                else if(state == 8'd17) state <= 8'd18;         // Se inicia la escritura en el conversion register.
                else if(state == 8'd18) state <= 8'd19;         // Finaliza la escritura en el conversion register.
                else if(state == 8'd19) state <= 8'd20;         // Inicio up todos los CS.
                else if(state == 8'd20) state <= 8'd21;         // Fin up todos los CS.
                else if(state == 8'd21) state <= 8'd22;         // Esperamos a que EOC2 = 0
                else if(state == 8'd22) state <= 8'd23;         // Inicio escritura CS_ADC2
                else if(state == 8'd23) state <= 8'd5;          // Fin escritura CS_ADC2. Los datos ya estan disponibles para la lectura.
                
                else                    state <= state;
            end
            else
                state <= state;         
        end
    
endmodule
