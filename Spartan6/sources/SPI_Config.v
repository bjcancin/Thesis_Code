`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2015 20:05:06
// Design Name: 
// Module Name: SPI_Config
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


module SPI_Config(
    input clk,
    input sclk,
    input din,
    input load_en,
    input [15:0] dout_word,
    output lclk,
    output [7:0] din_word,
    output dout,
    output done,
    output [15:0] aux
    );
    
    //////////////
    // Comentarios
    //////////////
    
    // sclk : set clock
    // din : palabra de entrada (8 bits). MSB primero
    // dout_word : palabra de entrada que se va a escribir a la salida
    // lclk : load clock
    // din_word: palabra de salida que se escribio en la entrada.
    // dout : palabra de salida (8 bits). MSB primero
    // load_en: señal para cargar la palabra leída por el SPI. 
    
    // cpol = cpha = 0
    
    
    ////////////////////
    // Wires y Registros
    ////////////////////
    
    reg [7:0] state_in = 8'b0;
    reg [7:0] reg_in = 8'b0;
    
    reg [7:0] state_out = 8'b0;
    reg [15:0] reg_out = 16'b0;
    
    ////////////////////
    // Estados Iniciales
    ////////////////////
    

 
    
    //////////////
    // Simulacion
    //////////////
    
    assign aux = {7'b0, state_in};
    
    ////////////////////////
    // Always y Asignaciones
    ////////////////////////
    
    assign din_word = reg_in;
    
    assign done = ((state_in == 8'd0) || (state_in == 8'd8))?       1'b1 : 1'b0;
    
    assign  lclk =  (state_in == 8'd8)?     1'b1 : 1'b0;    
    
    assign  dout =  (state_out == 8'd0)?    reg_out[15]  :   1'bz,
            dout =  (state_out == 8'd1)?    reg_out[14]  :   1'bz,
            dout =  (state_out == 8'd2)?    reg_out[13]  :   1'bz,
            dout =  (state_out == 8'd3)?    reg_out[12]  :   1'bz,
            dout =  (state_out == 8'd4)?    reg_out[11]  :   1'bz,
            dout =  (state_out == 8'd5)?    reg_out[10]  :   1'bz,
            dout =  (state_out == 8'd6)?    reg_out[9]   :   1'bz,
            dout =  (state_out == 8'd7)?    reg_out[8]   :   1'bz,
            dout =  (state_out == 8'd8)?    reg_out[7]   :   1'bz,
            dout =  (state_out == 8'd9)?    reg_out[6]   :   1'bz,
            dout =  (state_out == 8'd10)?   reg_out[5]   :   1'bz,
            dout =  (state_out == 8'd11)?   reg_out[4]   :   1'bz,
            dout =  (state_out == 8'd12)?   reg_out[3]   :   1'bz,
            dout =  (state_out == 8'd13)?   reg_out[2]   :   1'bz,
            dout =  (state_out == 8'd14)?   reg_out[1]   :   1'bz,
            dout =  (state_out >= 8'd15)?   reg_out[0]   :   1'bz;

    
    
    always @(posedge sclk)  // din
    begin
        reg_in <= {reg_in[6:0], din};
        state_in <= (state_in <8'd8)? (state_in +8'b1) : 8'b1;
    end
    

    
    always @(negedge sclk)  // dout
    begin
        state_out <= (state_out <8'd15)? (state_out +8'b1) : 8'b0;    
    end
    
    always @(posedge clk)
    begin
        reg_out <= (load_en)? dout_word : reg_out;
    end
    
    
endmodule
