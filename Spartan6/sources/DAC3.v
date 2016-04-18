`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2015 09:11:03
// Design Name: 
// Module Name: DAC2
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


module DAC3(
    input clk,
    input [15:0] divider,
    input en,
    input set,
    input [79:0] up,
    input [79:0] down,
    input [7:0] up_states,
    input [7:0] down_states,
    input [7:0] IDLE,
    output [7:0] out,
    output [15:0] aux
    );
    
    ////////////////////
    // Wires y Registros
    ////////////////////
           
    wire clk_out;   
    
    parameter mid = 8'd10;
    
    reg [7:0] state = 8'd19;
    reg clk_en = 8'b0;
    wire [7:0] state_next;
    
    wire up_result;
    wire down_result;
    wire mid_result;
    
    wire [7:0] down_aux;
    wire [7:0] up_aux;
    
    //////////
    // Modulos
    //////////
    
    Clk_Divider2 Clk_Div(
        .clk_in(clk),
        .divider(divider),
        .en(clk_en),
        .clk_out(clk_out),
        .aux(aux)
        );
    
    Comparator up_comp(
        .a(state),
        .b(up_aux),
        .lower(up_result)
        );
        
    Comparator down_comp(
        .a(state),
        .b(down_aux),
        .lower(down_result)
        );
    


    
    /////////////
    // Simulación
    /////////////
    
    //assign aux = {8'b0, state};
    
    ////////////////////////
    // Always y Asignaciones
    ////////////////////////
    
    assign mid_result = (state < mid)?      1'b1 : 1'b0;
    
    assign up_aux = up_states - 8'b1;
    
    assign down_aux = down_states + 8'd9;  
    
    assign  state_next = ((up_result == 0) && (down_result == 0) && (mid_result == 0))?      8'd0            :   8'bzzzz_zzzz,
            state_next = ((up_result == 0) && (down_result == 0) && (mid_result == 1))?      8'd0            :   8'bzzzz_zzzz,
            state_next = ((up_result == 0) && (down_result == 1) && (mid_result == 0))?      (state + 8'b1)  :   8'bzzzz_zzzz,
            state_next = ((up_result == 0) && (down_result == 1) && (mid_result == 1))?      8'd10           :   8'bzzzz_zzzz,
            state_next = ((up_result == 1) && (down_result == 0) && (mid_result == 0))?      8'd0            :   8'bzzzz_zzzz,
            state_next = ((up_result == 1) && (down_result == 0) && (mid_result == 1))?      8'd0            :   8'bzzzz_zzzz,
            state_next = ((up_result == 1) && (down_result == 1) && (mid_result == 0))?      8'd0            :   8'bzzzz_zzzz,
            state_next = ((up_result == 1) && (down_result == 1) && (mid_result == 1))?      (state + 8'b1)  :   8'bzzzz_zzzz;
            
    always @(posedge clk)
    begin
        if(up_result && en)
            clk_en <= set;
        else if(~up_result && down_result && en)
            clk_en <= ~set;
        else if(~up_result && ~down_result && en)
            clk_en <= set;
        else
            clk_en <= 1'b0;    
    end
            
    
    assign  out = ((state == 8'd0) && (en == 1))?       up[7:0]         :       8'bzzzz_zzzz,
            out = ((state == 8'd1) && (en == 1))?       up[15:8]        :       8'bzzzz_zzzz,
            out = ((state == 8'd2) && (en == 1))?       up[23:16]       :       8'bzzzz_zzzz,
            out = ((state == 8'd3) && (en == 1))?       up[31:24]       :       8'bzzzz_zzzz,
            out = ((state == 8'd4) && (en == 1))?       up[39:32]       :       8'bzzzz_zzzz,
            out = ((state == 8'd5) && (en == 1))?       up[47:40]       :       8'bzzzz_zzzz,
            out = ((state == 8'd6) && (en == 1))?       up[55:48]       :       8'bzzzz_zzzz,
            out = ((state == 8'd7) && (en == 1))?       up[63:56]       :       8'bzzzz_zzzz,
            out = ((state == 8'd8) && (en == 1))?       up[71:64]       :       8'bzzzz_zzzz,
            out = ((state == 8'd9) && (en == 1))?       up[79:72]       :       8'bzzzz_zzzz,
            
            out = ((state == 8'd10) && (en == 1))?      down[7:0]       :       8'bzzzz_zzzz,
            out = ((state == 8'd11) && (en == 1))?      down[15:8]      :       8'bzzzz_zzzz,
            out = ((state == 8'd12) && (en == 1))?      down[23:16]     :       8'bzzzz_zzzz,
            out = ((state == 8'd13) && (en == 1))?      down[31:24]     :       8'bzzzz_zzzz,
            out = ((state == 8'd14) && (en == 1))?      down[39:32]     :       8'bzzzz_zzzz,
            out = ((state == 8'd15) && (en == 1))?      down[47:40]     :       8'bzzzz_zzzz,
            out = ((state == 8'd16) && (en == 1))?      down[55:48]     :       8'bzzzz_zzzz,
            out = ((state == 8'd17) && (en == 1))?      down[63:56]     :       8'bzzzz_zzzz,
            out = ((state == 8'd18) && (en == 1))?      down[71:64]     :       8'bzzzz_zzzz,
            out = ((state >= 8'd19) && (en == 1))?      down[79:72]     :       8'bzzzz_zzzz,
            
            out = (en == 0)?                            IDLE            :       8'bzzzz_zzzz;                            
                                       
    
    always @(posedge clk_out)
    begin
        state <= state_next;
    end
        
    
endmodule
