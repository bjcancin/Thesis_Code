`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.09.2015 10:54:00
// Design Name: 
// Module Name: SPI
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


module SPI(
    input clk,
    input load,
    input dout,
    input [1:0] mode,
    input [8:0] word_9,
    input [7:0] word_8,
    output sclk,
    output din,
    output done,
    output reg [15:0] fifo,
    output [15:0] aux
    );
    
    //////////////
    // Comentarios
    //////////////
    
    // clk: Clock de entrada (10 MHz). El clock del modulo superior a este debe ser igual o menor en freq.
    // load: cargar palabra
    // mode: 0 -> 8 bits, 1 -> 9 bits, 2 -> read.
    // word_i: palabra de i bits a escribir (MSB primero)
    // sclk: reloj del SPI
    // din: palabra de salida.
    // done: señal de terminado. Se activa cuando terminó el proceso o cuando el modulo esta inactivo.
    // dout: palabra de entrada. Each result contains 2 bytes, with the
    //      MSB preceded by four leading zeros. After each falling
    //      edge of CS, the oldest available byte of data is available at
    //      DOUT, MSB first. When the FIFO is empty, DOUT is zero.
    //      Serial Data Output. Data is clocked out on the falling edge of
    //      SCLK. High impedance when CS is connected to VDD.
    
    ////////////////////
    // Wires y Registros
    ////////////////////
    
    parameter state_aux = 8'd20;
    parameter state_auxr = 8'd34;
    
    reg [7:0] state = 8'b0;
    reg [7:0] state_r = 8'b0;
    
    reg [7:0] state_next = 8'b0;
    reg [7:0] state_nextr = 8'b0;
    
    reg [8:0] s_reg = 9'b0;
    
    wire sclk_8, sclk_9, sclk_r;
    wire done_8, done_9, done_r;
    
    ////////////////////
    // Estados Iniciales
    ////////////////////
    
    initial
    begin
        fifo = 0;
    end
    
    /////////////
    // Simulacion
    /////////////
    
    assign aux = {8'b0, state_r};
    
    ////////////////////////
    // Always y Asignaciones
    //////////////////////// 
    
    always @(posedge clk)
    begin
        if(load == 1'b1)
            begin
            if(mode == 2'd0) // 8 bits
            begin
                if(state == 8'b0)
                begin
                    s_reg <= {word_8, 1'b0};
                    state <= state_aux;
                    state_next <= 8'd1;
                end
                
                else if(state == 8'b1)
                begin
                    s_reg <= s_reg;
                    state <= 8'd2;
                    state_next <= state_next;
                end
                
                else if((state> 8'b1) && (state < 8'd16) && (state[0] == 1'b0))
                begin
                    s_reg <= {s_reg[7:0], 1'b0};
                    state <= state_aux;
                    state_next <= state + 8'b1;
                end
                
                else if((state> 8'b1) && (state < 8'd16) && (state[0] == 1'b1))
                begin
                    s_reg <= s_reg;
                    state <= state + 8'b1;
                    state_next <= state_next;
                end
                
                else if(state == 8'd16)
                begin
                    s_reg <= s_reg;
                    state <= 8'd17;
                    state_next <= state_next;
                end
                
                else if(state == state_aux)
                begin
                    s_reg <= s_reg;
                    state <= state_next;
                    state_next <= state_next;
                end
                
                else
                begin
                    s_reg <= s_reg;
                    state <= 8'd17;
                    state_next <= state_next;  
                end
            end
            
            else if(mode == 2'd1) // 9 bits
            begin
                if(state == 8'b0)
                begin
                    s_reg <= word_9;
                    state <= state_aux;
                    state_next <= 8'd1;
                end
                
                else if(state == 8'b1)
                begin
                    s_reg <= s_reg;
                    state <= 8'd2;
                    state_next <= state_next;
                end
                
                else if((state> 8'b1) && (state < 8'd18) && (state[0] == 1'b0))
                begin
                    s_reg <= {s_reg[7:0], 1'b0};
                    state <= state_aux;
                    state_next <= state + 8'b1;
                end
                
                else if((state> 8'b1) && (state < 8'd18) && (state[0] == 1'b1))
                begin
                    s_reg <= s_reg;
                    state <= state + 8'b1;
                    state_next <= state_next;
                end
                
                else if(state == 8'd18)
                begin
                    s_reg <= s_reg;
                    state <= 8'd19;
                    state_next <= state_next;
                end
                
                else if(state == state_aux)
                begin
                    s_reg <= s_reg;
                    state <= state_next;
                    state_next <= state_next;
                end
                
                else
                begin
                    s_reg <= s_reg;
                    state <= 8'd19;
                    state_next <= state_next;    
                end
            end
            
            else // read
            begin
                s_reg <= 9'b0;
                state <= 8'b0;
                state_next <= 8'b0;
            end
        end
        
        else
        begin
            s_reg <= s_reg;
            state <= 8'b0;
            state_next <= 9'b0;
        end   
    end
    
    
    always @(posedge clk)
    begin
        if((load == 1'b1) && (mode == 2'd2))
        begin
            if(state_r == 8'b0)
            begin
                fifo <= fifo;
                state_r <= 8'd1;
            end
            
            else if(state_r == 8'b1)
            begin
                fifo <= {fifo[14:0], dout};
                state_r <= 8'd2;
            end
            
            else if((state_r> 8'd1) && (state_r < 8'd32) && (state_r[0] == 1'b0))
            begin
                fifo <= fifo;
                state_r <= state_r + 8'b1;
            end
            
            else if((state_r> 8'd1) && (state_r < 8'd32) && (state_r[0] == 1'b1))
            begin
                fifo <= {fifo[14:0], dout};
                //fifo <= 16'b1100_0000_0000_0001;    // Solo para efectos de simulación
                state_r <= state_r + 8'b1;
            end
            
            else if(state == 8'd32)
            begin
                fifo <= fifo;
                state_r <= 8'd33;
            end
            
            else
            begin
                fifo <= fifo;
                state_r <= 8'd33;    
            end 
        end
        
        else
        begin
            fifo <= fifo;
            state_r <= 8'b0;
        end
    end     
    
    assign sclk_8 = ((state[0] == 1'b1) && (state < 8'd16))?  (mode == 4'b0000) : 1'b0;
    assign done_8 = (mode == 4'b0000)?    (state == 8'd17) : 1'b1;
    
    assign sclk_9 = ((state[0] == 1'b1) && (state < 8'd18))?  (mode == 4'b0001) : 1'b0;
    assign done_9 = (mode == 4'b0001)?    (state == 8'd19) : 1'b1;
    
    assign sclk_r = ((state_r[0] == 1'b1) && (state_r < 8'd32))?  (mode == 4'b0010) : 1'b0;
    assign done_r = (mode == 4'b0010)?    (state_r == 8'd33) : 1'b1;
    
    assign din = s_reg[8];
    assign done = done_8 & done_9 & done_r;
    assign sclk = sclk_8 | sclk_9 | sclk_r;
    
endmodule
