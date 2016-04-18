`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.09.2015 13:31:23
// Design Name: 
// Module Name: Reg_SPI
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


module Reg_SPI(
    input clk,
    input load,
    input [3:0] mode,
    output done,
    
    input [23:0] reg_word,
    output reg_lclk,
    output reg_sclk,
    output reg_rst,
    output reg_out,
    
    input [7:0] spi_word_8,
    input [8:0] spi_word_9,
    input spi_dout,
    output [15:0] spi_fifo,
    output spi_din,
    output spi_sclk,
    output [15:0] aux
    );
    
    //////////////
    // Comentarios
    //////////////
    
    // clk : Clock del Shift Register (<=10 MHz).
    // load: Carga la palabra en el flanco de subida y debe permanecer en 1 durante todo el proceso.
    // x_word_i : Palabra a escribir.
    // mode:
    //      0 -> Escribe solo el registro
    //      1 -> Escribe el registro mas el SPI_8
    //      2 -> Escribe el registro mas el SPI_9
    //      3 -> Se escribe el registro y se lee el SPI
    //      4 -> Se escribe el SPI_8
    //      5 -> Se escribe el SPI_9
    //      6 -> Se lee el SPI
    
    
    ////////////////////
    // Wires y Registros
    ////////////////////
    
    reg [7:0] state = 8'b0;
    wire [7:0] state_ini;
    wire [7:0] state_next;
    wire clk_en;
    
    wire reg_load;
    wire reg_done;
    wire [15:0] reg_aux;
    
    wire spi_load;
    wire spi_done;
    wire [1:0] spi_mode;
    wire [15:0] spi_aux;
    
    
    ////////////////////
    // Estados Iniciales
    ////////////////////
    
    initial
    begin
    
    end
    
    ////////////////////
    // Modulos
    ////////////////////
    
    Shift_Register Shift_Register(
        .clk(clk),
        .load(reg_load),
        .word(reg_word),
        .out(reg_out),
        .rst(reg_rst),
        .lclk(reg_lclk),
        .sclk(reg_sclk),
        .done(reg_done),
        .aux(reg_aux)
        );
        
    SPI SPI(
        .clk(clk),
        .load(spi_load),
        .dout(spi_dout),
        .mode(spi_mode),
        .word_9(spi_word_9),
        .word_8(spi_word_8),
        .sclk(spi_sclk),
        .din(spi_din),
        .done(spi_done),
        .fifo(spi_fifo),
        .aux(spi_aux)
    );
    
    /////////////
    // Simulacion
    /////////////
    
    //assign aux = {clk_g, 7'b0, state};
    //assign aux = {7'b0, load, state};
    assign aux = {8'b0, state};
    
    
    ////////////////////////
    // Always y Asignaciones
    ////////////////////////
    
    assign  clk_en = (state == 8'd0)?    1'b1 : 1'bz,
            clk_en = (state == 8'd1)?    reg_done : 1'bz,
            clk_en = (state == 8'd2)?    spi_done : 1'bz,
            clk_en = (state >= 8'd3)?    1'b1 : 1'bz;
    
    assign done = (state == 8'd3)? 1'b1 : 1'b0;
    
    assign state_ini = (mode < 4'd4)?  8'd1 : 8'bzzzzzzzz,
           state_ini = (mode > 4'd3)?  8'd2 : 8'bzzzzzzzz;
    
    assign state_next = (mode == 4'd0)? 8'd3 : 8'd2;
    
	assign reg_load = (state == 8'd1)?	1'b1 : 1'b0;
	
	assign spi_load = (state == 8'd2)?	1'b1 : 1'b0;
	
	assign  spi_mode = ((mode == 4'd1) || (mode == 4'd4))?  2'd0 : 2'bzz,
            spi_mode = ((mode == 4'd2) || (mode == 4'd5))?  2'd1 : 2'bzz,
            spi_mode = ((mode == 4'd3) || (mode == 4'd6))?  2'd2 : 2'bzz,
            spi_mode = ((mode == 4'd0) || (mode > 4'd6))?   2'd3 : 2'bzz;	

	always @(posedge clk)
    begin
        if(clk_en)
        begin
            if(load == 1)
            begin
                if(state == 8'd0)
                    state <= state_ini;
                    
                else if(state == 8'd1)  // Se escribe el registro. // reg_load <= 1; Solo pasa de estado con reg_done
                    state <= state_next;
                       
                    
                else if(state == 8'd2)	// Se escribe el SPI. spi_load <= 1. Solo passa de estado con spi_done
                    state <= 8'd3;
                        
                else if(state == 8'd3)   // Se espera a que load baje a 0
                    state <= 8'd3;
            end
            
            else
            begin
                state <= 8'b0;
            end
        end
        
        else
            state <= state;
    end
    
endmodule
