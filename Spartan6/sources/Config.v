`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.09.2015 14:14:46
// Design Name: 
// Module Name: Config
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


module Config(
    input sclk,
    input [7:0] din_word,
    input lclk,
    input control_done,
    
    output reg [7:0] opamp,
    output reg rst,
    
    output [79:0] upi,
    output [79:0] downi,
    output reg [7:0] upi_states,
    output reg [7:0] downi_states,
    output reg [7:0] IIDLE,
    output reg [7:0] divider_i,
    output reg [7:0] divider_i2,
            
    output [79:0] upr,
    output [79:0] downr,
    output reg [7:0] upr_states,
    output reg [7:0] downr_states,
    output reg [7:0] RIDLE,
    output reg [7:0] divider_r,
    output reg [7:0] divider_r2,
    
    output reg [7:0] ADC_setup,
    output reg [7:0] ADC_aver,
    output reg [7:0] ADC_conv,
    output ADC_1,
    output ADC_2,
    output ADC_read,
    
    output reconfig,
    
    output done,
    
    output [7:0] aux
    );
    
    //////////////
    // Comentarios
    //////////////
    
    // Los estados en donde "done" puede ser nulo es cuando se reconfigura o cuando 
    
    ////////////////////
    // Wires y Registros
    ////////////////////
    
    wire clk_en;
    
    reg [7:0] state_next;
    
    reg [7:0] state = 8'b0;
    
    ////////////////////
    // Estados Iniciales
    ////////////////////
    
    reg [7:0] upi_1 = 8'd115;
    reg [7:0] upi_2 = 8'd118;
    reg [7:0] upi_3 = 8'd121;
    reg [7:0] upi_4 = 8'd124;
    reg [7:0] upi_5 = 8'd127;
    reg [7:0] upi_6 = 8'd128;
    reg [7:0] upi_7 = 8'd131;
    reg [7:0] upi_8 = 8'd134;
    reg [7:0] upi_9 = 8'd137;
    reg [7:0] upi_10 = 8'd140;
     
    reg [7:0] downi_1 = 8'd140;
    reg [7:0] downi_2 = 8'd137;
    reg [7:0] downi_3 = 8'd134;
    reg [7:0] downi_4 = 8'd131;
    reg [7:0] downi_5 = 8'd128;
    reg [7:0] downi_6 = 8'd127;
    reg [7:0] downi_7 = 8'd124;
    reg [7:0] downi_8 = 8'd121;
    reg [7:0] downi_9 = 8'd118;
    reg [7:0] downi_10 = 8'd115;
     
    reg [7:0] upr_1 = 8'd115;
    reg [7:0] upr_2 = 8'd118;
    reg [7:0] upr_3 = 8'd121;
    reg [7:0] upr_4 = 8'd124;
    reg [7:0] upr_5 = 8'd127;
    reg [7:0] upr_6 = 8'd128;
    reg [7:0] upr_7 = 8'd131;
    reg [7:0] upr_8 = 8'd134;
    reg [7:0] upr_9 = 8'd137;
    reg [7:0] upr_10 = 8'd140;
     
    reg [7:0] downr_1 = 8'd140;
    reg [7:0] downr_2 = 8'd137;
    reg [7:0] downr_3 = 8'd134;
    reg [7:0] downr_4 = 8'd131;
    reg [7:0] downr_5 = 8'd128;
    reg [7:0] downr_6 = 8'd127;
    reg [7:0] downr_7 = 8'd124;
    reg [7:0] downr_8 = 8'd121;
    reg [7:0] downr_9 = 8'd118;
    reg [7:0] downr_10 = 8'd115;
    

    
    initial
    begin
        opamp = 8'b0;
        rst = 1'b0;
                
        upi_states = 8'd10;         // Cantidad Estados de subida Imagen                
        downi_states = 8'd10;       // Cantidad Estados de bajada Imagen
        IIDLE = 8'd0;               // Estado idle Imagen
        divider_i = 8'd10;          // Divisor reloj Imagen
        divider_i2 = 8'd0;
                
        upr_states = 8'd10;         // Registro
        downr_states = 8'd10;
        RIDLE = 8'd0;
        divider_r = 8'd10;
        divider_r2 = 8'd0;
        
        ADC_setup = 8'b01_10_01_00; // Clock mode 10, Ext Reference.
        ADC_aver = 8'b001_111_00;   // 32 conversions and return the average.
        ADC_conv = 8'b0;            // No scan, only N channel. Este es el unico modo admitido. Toda palabra debe ser de la forma 1_xxxx_11_x.
    end
    
    /////////////
    // Simulacion
    /////////////
    
    //assign aux = state;
    assign aux = opamp;
    
    ////////////////////////
    // Always y Asignaciones
    ////////////////////////
    
    assign clk_en = lclk;
    
    assign done = (control_done && (state == 8'b0))?    1'b1 : 1'b0;
   
    assign upi = {upi_10, upi_9, upi_8, upi_7, upi_6, upi_5, upi_4, upi_3, upi_2, upi_1};
    assign downi = {downi_10, downi_9, downi_8, downi_7, downi_6, downi_5, downi_4, downi_3, downi_2, downi_1};
            
    assign upr = {upr_10, upr_9, upr_8, upr_7, upr_6, upr_5, upr_4, upr_3, upr_2, upr_1};
    assign downr = {downr_10, downr_9, downr_8, downr_7, downr_6, downr_5, downr_4, downr_3, downr_2, downr_1};
    
    always @*
    begin
        if(din_word == 8'd1)        state_next = 8'd1;      // Opamp
        else if(din_word == 8'd2)   state_next = 8'd2;      // rst (solo importa el bit menos significativo)
        else if(din_word == 8'd3)   state_next = 8'd3;      // DACI
        else if(din_word == 8'd4)   state_next = 8'd27;     // DACR
        else if(din_word == 8'd5)   state_next = 8'd51;     // ADC Config
        else if(din_word == 8'd6)   state_next = 8'd53;     // Reconfiguracion.
        else if(din_word == 8'd7)   state_next = 8'd54;     // ADC1 Meas
        else if(din_word == 8'd8)   state_next = 8'd55;     // ADC2 Meas
        else if(din_word == 8'd9)   state_next = 8'd58;     // divider_i
        else if(din_word == 8'd10)  state_next = 8'd59;     // divider_r
        
        else                        state_next = 8'b0;
    end
    
    
    
    always @(negedge sclk)
    begin
        if(clk_en)
        begin
            if(state == 8'd0)               state <= state_next;            // IDLE
            
            else if(state == 8'd1)          state <= 8'd0;                  // Opamp
            
            else if(state == 8'd2)          state <= 8'd0;                  // rst

            else if(state == 8'd3)          state <= 8'd4;                  // upi_1
            else if(state == 8'd4)          state <= 8'd5;                  // upi_2
            else if(state == 8'd5)          state <= 8'd6;                  // upi_3
            else if(state == 8'd6)          state <= 8'd7;                  // upi_4
            else if(state == 8'd7)          state <= 8'd8;                  // upi_5
            else if(state == 8'd8)          state <= 8'd9;                  // upi_6
            else if(state == 8'd9)          state <= 8'd10;                 // upi_7
            else if(state == 8'd10)         state <= 8'd11;                 // upi_8
            else if(state == 8'd11)         state <= 8'd12;                 // upi_9
            else if(state == 8'd12)         state <= 8'd13;                 // upi_10
            else if(state == 8'd13)         state <= 8'd14;                 // downi_1
            else if(state == 8'd14)         state <= 8'd15;                 // downi_2
            else if(state == 8'd15)         state <= 8'd16;                 // downi_3
            else if(state == 8'd16)         state <= 8'd17;                 // downi_4
            else if(state == 8'd17)         state <= 8'd18;                 // downi_5
            else if(state == 8'd18)         state <= 8'd19;                 // downi_6
            else if(state == 8'd19)         state <= 8'd20;                 // downi_7
            else if(state == 8'd20)         state <= 8'd21;                 // downi_8
            else if(state == 8'd21)         state <= 8'd22;                 // downi_9
            else if(state == 8'd22)         state <= 8'd23;                 // downi_10
            else if(state == 8'd23)         state <= 8'd24;                 // upi_states
            else if(state == 8'd24)         state <= 8'd25;                 // downi_states
            else if(state == 8'd25)         state <= 8'd26;                 // IIDLE
            else if(state == 8'd26)         state <= 8'd58;                 // divider_i
            
            else if(state == 8'd27)         state <= 8'd28;                 // upr_1
            else if(state == 8'd28)         state <= 8'd29;                 // upr_2
            else if(state == 8'd29)         state <= 8'd30;                 // upr_3
            else if(state == 8'd30)         state <= 8'd31;                 // upr_4
            else if(state == 8'd31)         state <= 8'd32;                 // upr_5
            else if(state == 8'd32)         state <= 8'd33;                 // upr_6
            else if(state == 8'd33)         state <= 8'd34;                 // upr_7
            else if(state == 8'd34)         state <= 8'd35;                 // upr_8
            else if(state == 8'd35)         state <= 8'd36;                 // upr_9
            else if(state == 8'd36)         state <= 8'd37;                 // upr_10
            else if(state == 8'd37)         state <= 8'd38;                 // downr_1
            else if(state == 8'd38)         state <= 8'd39;                 // downr_2
            else if(state == 8'd39)         state <= 8'd40;                 // downr_3
            else if(state == 8'd40)         state <= 8'd41;                 // downr_4
            else if(state == 8'd41)         state <= 8'd42;                 // downr_5
            else if(state == 8'd42)         state <= 8'd43;                 // downr_6
            else if(state == 8'd43)         state <= 8'd44;                 // downr_7
            else if(state == 8'd44)         state <= 8'd45;                 // downr_8
            else if(state == 8'd45)         state <= 8'd46;                 // downr_9
            else if(state == 8'd46)         state <= 8'd47;                 // downr_10
            else if(state == 8'd47)         state <= 8'd48;                 // upr_states
            else if(state == 8'd48)         state <= 8'd49;                 // downr_states
            else if(state == 8'd49)         state <= 8'd50;                 // RIDLE
            else if(state == 8'd50)         state <= 8'd59;                 // divider_r
            
            else if(state == 8'd51)         state <= 8'd52;                 // ADC_setup
            else if(state == 8'd52)         state <= 8'd0;                  // ADC_aver
            
            else if(state == 8'd53)         state <= 8'd0;                  // Reconfig
            
            else if(state == 8'd54)         state <= 8'd56;                 // ADC_1 Conversion Register
            else if(state == 8'd55)         state <= 8'd56;                 // ADC_2 Conversion Register
            else if(state == 8'd56)         state <= 8'd57;                 // ADC Read 1
            else if(state == 8'd57)         state <= 8'd0;                  // ADC Read 2
            
            // Nuevos Estados
            
            else if(state == 8'd58)         state <= 8'd0;                  // divider_i2
            
            else if(state == 8'd59)         state <= 8'd0;                  // divider_r2
  
            else                            state <= state;
        end
        
        else    state <= state;
    end
    
    // Asignaciones
    
    assign reconfig =   (state == 8'd53)?   1'b1    :   1'b0;
    
    assign ADC_1 =      (state == 8'd54)?   1'b1    :   1'b0;
    assign ADC_2 =      (state == 8'd55)?   1'b1    :   1'b0;
    assign ADC_read =   (state == 8'd56)?   1'b1    :   1'b0;
    
    always @(negedge sclk)
    begin
        opamp <=        (clk_en && (state == 8'd1))?   din_word     :   opamp;
        
        rst <=          (clk_en && (state == 8'd2))?  din_word[0]   :   rst;
        
        upi_1 <=        (clk_en && (state == 8'd3))?   din_word     :   upi_1;
        upi_2 <=        (clk_en && (state == 8'd4))?   din_word     :   upi_2;
        upi_3 <=        (clk_en && (state == 8'd5))?  din_word      :   upi_3;
        upi_4 <=        (clk_en && (state == 8'd6))?  din_word      :   upi_4;
        upi_5 <=        (clk_en && (state == 8'd7))?  din_word      :   upi_5;
        upi_6 <=        (clk_en && (state == 8'd8))?  din_word      :   upi_6;
        upi_7 <=        (clk_en && (state == 8'd9))?  din_word      :   upi_7;
        upi_8 <=        (clk_en && (state == 8'd10))?  din_word     :   upi_8;
        upi_9 <=        (clk_en && (state == 8'd11))?  din_word     :   upi_9;
        upi_10 <=       (clk_en && (state == 8'd12))?  din_word     :   upi_10;
        downi_1 <=      (clk_en && (state == 8'd13))?  din_word     :   downi_1;
        downi_2 <=      (clk_en && (state == 8'd14))?  din_word     :   downi_2;
        downi_3 <=      (clk_en && (state == 8'd15))?  din_word     :   downi_3;
        downi_4 <=      (clk_en && (state == 8'd16))?  din_word     :   downi_4;
        downi_5 <=      (clk_en && (state == 8'd17))?  din_word     :   downi_5;
        downi_6 <=      (clk_en && (state == 8'd18))?  din_word     :   downi_6;
        downi_7 <=      (clk_en && (state == 8'd19))?  din_word     :   downi_7;
        downi_8 <=      (clk_en && (state == 8'd20))?  din_word     :   downi_8;
        downi_9 <=      (clk_en && (state == 8'd21))?  din_word     :   downi_9;
        downi_10 <=     (clk_en && (state == 8'd22))?  din_word     :   downi_10;
        upi_states  <=  (clk_en && (state == 8'd23))?  din_word     :   upi_states;
        downi_states <= (clk_en && (state == 8'd24))?  din_word     :   downi_states;
        IIDLE <=        (clk_en && (state == 8'd25))?  din_word     :   IIDLE;
        divider_i <=    (clk_en && (state == 8'd26))?  din_word     :   divider_i;
        divider_i2 <=   (clk_en && (state == 8'd58))?  din_word     :   divider_i2;
        
        upr_1 <=        (clk_en && (state == 8'd27))?  din_word     :   upr_1;
        upr_2 <=        (clk_en && (state == 8'd28))?  din_word     :   upr_2;
        upr_3 <=        (clk_en && (state == 8'd29))?  din_word     :   upr_3;
        upr_4 <=        (clk_en && (state == 8'd30))?  din_word     :   upr_4;
        upr_5 <=        (clk_en && (state == 8'd31))?  din_word     :   upr_5;
        upr_6 <=        (clk_en && (state == 8'd32))?  din_word     :   upr_6;
        upr_7 <=        (clk_en && (state == 8'd33))?  din_word     :   upr_7;
        upr_8 <=        (clk_en && (state == 8'd34))?  din_word     :   upr_8;
        upr_9 <=        (clk_en && (state == 8'd35))?  din_word     :   upr_9;
        upr_10 <=       (clk_en && (state == 8'd36))?  din_word     :   upr_10;
        downr_1 <=      (clk_en && (state == 8'd37))?  din_word     :   downr_1;
        downr_2 <=      (clk_en && (state == 8'd38))?  din_word     :   downr_2;
        downr_3 <=      (clk_en && (state == 8'd39))?  din_word     :   downr_3;
        downr_4 <=      (clk_en && (state == 8'd40))?  din_word     :   downr_4;
        downr_5 <=      (clk_en && (state == 8'd41))?  din_word     :   downr_5;
        downr_6 <=      (clk_en && (state == 8'd42))?  din_word     :   downr_6;
        downr_7 <=      (clk_en && (state == 8'd43))?  din_word     :   downr_7;
        downr_8 <=      (clk_en && (state == 8'd44))?  din_word     :   downr_8;
        downr_9 <=      (clk_en && (state == 8'd45))?  din_word     :   downr_9;
        downr_10 <=     (clk_en && (state == 8'd46))?  din_word     :   downr_10;
        upr_states  <=  (clk_en && (state == 8'd47))?  din_word     :   upr_states;
        downr_states <= (clk_en && (state == 8'd48))?  din_word     :   downr_states;
        RIDLE <=        (clk_en && (state == 8'd49))?  din_word     :   RIDLE;
        divider_r <=    (clk_en && (state == 8'd50))?  din_word     :   divider_r;
        divider_r2 <=   (clk_en && (state == 8'd59))?  din_word     :   divider_r2;
        
        ADC_setup <=    (clk_en && (state == 8'd51))?  din_word     :   ADC_setup;
        ADC_aver <=     (clk_en && (state == 8'd52))?  din_word     :   ADC_aver;
        
        ADC_conv <=     (clk_en && ((state == 8'd54) || (state == 8'd55)))?  din_word     :   ADC_conv; 
    end

    
endmodule
