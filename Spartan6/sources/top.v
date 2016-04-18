`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:05:27 08/11/2015 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top(
	input OSC_GCLK,
	input DEBUG1,
	input DEBUG2,
	input DEBUG3,
	input DEBUG4,
	input DEBUG5,
	input DEBUG6,
	input DEBUG7,
	input DEBUG8,
	input DEBUG9,
	input DEBUG10,	
	
	output CONFIG1,
	input CONFIG2,
	output CONFIG3,
	output CONFIG4,
	
	input SPI_DOUT,
	input EOC1,
	input EOC2,
	
	output [7:0] IN1,	//Salida IOP1
	output [7:0] IN2,	//Salida IOP2
	output [7:0] IN3,	//Salida IOP3
	output [7:0] IN4,	//Salida IOP4
	output [7:0] IN5,	//Salida ROP1
	output [7:0] IN6,	//Salida ROP2
	output [7:0] IN7,	//Salida ROP3
	output [7:0] IN8,	//Salida ROP4
	output REG_EN_N,
	output REG_LCLK,
	output REG_OUT,
	output REG_RST,
	output REG_SCLK,
	output SPI_DIN,
	output SPI_SCLK,
	output DAC_GCLK//,
	// Simulación (sacar al compilar a la FPGA). Además se debe cambiar el clock de regspi por el proveniente del oscilador al simular
	//output [15:0] aux
    );
	
	
	///////////////////////////
	// Instanciacion de Modulos
	///////////////////////////
	 
	wire CLK_RSPI;
	wire CLK_I;
	wire CLK_R;
    //wire CLK_aux;
    
    wire [7:0] divider_i;
    wire [7:0] divider_i2;
    wire [7:0] divider_r;
    wire [7:0] divider_r2;
    
    wire [15:0] dac2_aux; 	  
	  
    Clk_Divider CLK_RegSPI(
		.clk_in(OSC_GCLK),
        .divider(8'd200),
        .clk_out(CLK_RSPI)
        );
	
	wire regspi_load;
	wire [3:0] regspi_mode;
	wire regspi_done;
	wire [23:0] reg_word;
	wire [7:0] spi_word_8;
	wire [15:0] spi_fifo;
	wire [15:0] reg_spi_aux;
	  
    Reg_SPI Reg_SPI(
        .clk(CLK_RSPI),
        //.clk(OSC_GCLK),// Sólo para simulación
        .load(regspi_load),
        .mode(regspi_mode),
        .done(regspi_done),
           
        .reg_word(reg_word),
        .reg_lclk(REG_LCLK),
        .reg_sclk(REG_SCLK),
        .reg_rst(REG_RST),
        .reg_out(REG_OUT),
           
        .spi_word_8(spi_word_8),
        .spi_dout(SPI_DOUT),
        .spi_fifo(spi_fifo),
        .spi_din(SPI_DIN),
        .spi_sclk(SPI_SCLK),
        .aux(reg_spi_aux)
        );
        
    wire [79:0] upi;
    wire [79:0] downi;
    wire [7:0] upi_states;
    wire [7:0] downi_states;  
    wire [7:0] IIDLE;    
    
    wire [79:0] upr;
    wire [79:0] downr;
    wire [7:0] upr_states;
    wire [7:0] downr_states;
    wire [7:0] RIDLE;
    
    DAC3 IOP1(
        .clk(OSC_GCLK),
        .divider({divider_i2, divider_i}),
        .en(opamp[0]),
        .set(DEBUG10),
        .up(upi),
        .down(downi),
        .up_states(upi_states),
        .down_states(downi_states),
        .IDLE(IIDLE),
        .out(IN1)
        );
        
        
    DAC3 IOP2(
        .clk(OSC_GCLK),
        .divider({divider_i2, divider_i}),
        .en(opamp[1]),
        .set(DEBUG9),
        .up(upi),
        .down(downi),
        .up_states(upi_states),
        .down_states(downi_states),
        .IDLE(IIDLE),
        .out(IN2)
        );
            
            
    DAC3 IOP3(
        .clk(OSC_GCLK),
        .divider({divider_i2, divider_i}),
        .en(opamp[2]),
        .set(DEBUG8),
        .up(upi),
        .down(downi),
        .up_states(upi_states),
        .down_states(downi_states),
        .IDLE(IIDLE),
        .out(IN3)
        );
                
                
    DAC3 IOP4(
        .clk(OSC_GCLK),
        .divider({divider_i2, divider_i}),
        .en(opamp[3]),
        .set(DEBUG7),
        .up(upi),
        .down(downi),
        .up_states(upi_states),
        .down_states(downi_states),
        .IDLE(IIDLE),
        .out(IN4),
        .aux(dac2_aux)
        );
                    
    DAC3 ROP1(
        .clk(OSC_GCLK),
        .divider({divider_r2, divider_r}),
        .en(opamp[4]),
        .set(DEBUG6),
        .up(upr),
        .down(downr),
        .up_states(upr_states),
        .down_states(downr_states),
        .IDLE(RIDLE),
        .out(IN5)
        );
        
        
    DAC3 ROP2(
        .clk(OSC_GCLK),
        .divider({divider_r2, divider_r}),
        .en(opamp[5]),
        .set(DEBUG5),
        .up(upr),
        .down(downr),
        .up_states(upr_states),
        .down_states(downr_states),
        .IDLE(RIDLE),
        .out(IN6)
        );
            
            
    DAC3 ROP3(
        .clk(OSC_GCLK),
        .divider({divider_r2, divider_r}),
        .en(opamp[6]),
        .set(DEBUG4),
        .up(upr),
        .down(downr),
        .up_states(upr_states),
        .down_states(downr_states),
        .IDLE(RIDLE),
        .out(IN7)
        );
                
                
    DAC3 ROP4(
        .clk(OSC_GCLK),
        .divider({divider_r2, divider_r}),
        .en(opamp[7]),
        .set(DEBUG3),
        .up(upr),
        .down(downr),
        .up_states(upr_states),
        .down_states(downr_states),
        .IDLE(RIDLE),
        .out(IN8)
        );
                  
                                              
    
    
    wire [7:0] opamp;
    
    wire rst;
    
    wire [7:0] dout_word;
    wire config_load_en;
    
    wire [7:0] ADC_setup;
    wire [7:0] ADC_aver;
    wire [7:0] ADC_conv;
    wire ADC_1;
    wire ADC_2;
    wire ADC_read;
              
    wire reconfig;

    wire control_done;
    
    wire [15:0] control_aux;
    
    Control Control(
        .clk(OSC_GCLK),
        
        .opamp(opamp),
        .rst(rst),
        
        .EOC1(EOC1),
        .EOC2(EOC2),
        
        .ADC_setup(ADC_setup),
        .ADC_aver(ADC_aver),
        .ADC_conv(ADC_conv),
        .ADC_1(ADC_1),
        .ADC_2(ADC_2),
        .ADC_read(ADC_read),
        
        .reconfig(reconfig),
            
        .regspi_done(regspi_done),
        .regspi_load(regspi_load),
        .reg_word(reg_word),
        .spi_word8(spi_word_8),
        .regspi_mode(regspi_mode),
        .reg_en_n(REG_EN_N),
        
        .config_load_en(config_load_en),

        .done(control_done),
        
        .aux(control_aux)
    );
    
    
    wire config_lclk;
    wire [7:0] din_word;
    wire [15:0] spiconfig_aux;
    wire spi_config_done;
    
    SPI_Config SPI_Config(
        .clk(OSC_GCLK),
        .sclk(DEBUG1),
        .din(CONFIG2),
        .load_en(config_load_en),
        .dout_word(spi_fifo),
        
        .lclk(config_lclk),
        .din_word(din_word),
        .done(spi_config_done),
        //.dout(CONFIG3),
        .aux(spiconfig_aux)
    );
    
    wire [7:0] config_aux;
    wire config_done;
    
    Config Config(
        .sclk(DEBUG1),
        .din_word(din_word),
        .lclk(config_lclk),
        .control_done(control_done),
        
        .opamp(opamp),
        
        .rst(rst),
        
        .upi(upi),
        .downi(downi),
        .upi_states(upi_states),
        .downi_states(downi_states),
        .IIDLE(IIDLE),
        .divider_i(divider_i),
        .divider_i2(divider_i2),
                
        .upr(upr),
        .downr(downr),
        .upr_states(upr_states),
        .downr_states(downr_states),
        .RIDLE(RIDLE),
        .divider_r(divider_r),
        .divider_r2(divider_r2),
        
        .ADC_setup(ADC_setup),
        .ADC_aver(ADC_aver),
        .ADC_conv(ADC_conv),
        .ADC_1(ADC_1),
        .ADC_2(ADC_2),
        .ADC_read(ADC_read),
        
        .reconfig(reconfig),
        
        .done(config_done),
        
        .aux(config_aux)
    );
    
    assign CONFIG1 = spi_config_done;
    assign CONFIG4 = config_done;
    
    assign DAC_GCLK = OSC_GCLK;
    
    /////////////
    // Simulacion
    /////////////
    
    //assign aux = {control_aux[7:0], reg_spi_aux[7:0]};
    //assign aux = reg_spi_aux;
	//assign aux = {din_word,control_aux[7:0]};
	//assign aux = {config_aux ,control_aux[7:0]};
	//assign aux = control_aux;
	//assign aux = spiconfig_aux;
	
	/////////////////////
	// Otras Asignaciones
	/////////////////////
	    
    
    //assign {DEBUG10, DEBUG9, DEBUG8, DEBUG7, DEBUG6, DEBUG5, DEBUG4, DEBUG3} = control_aux[7:0];
    assign CONFIG3 = dac2_aux[0];
   // assign {DEBUG10, DEBUG9, DEBUG8, DEBUG7, DEBUG6, DEBUG5, DEBUG4, DEBUG3} = dac2_aux[15:8];
    //assign {DEBUG10, DEBUG9, DEBUG8, DEBUG7, DEBUG6, DEBUG5, DEBUG4, DEBUG3} = spiconfig_aux[7:0];
    //assign {DEBUG10, DEBUG9, DEBUG8, DEBUG7, DEBUG6, DEBUG5, DEBUG4, DEBUG3} = 8'b0;
        
	
	
endmodule
