#include <msp430.h>


/////////////////////
// Variables Globales
/////////////////////

char RXBUF[30];

int READ1;
int READ2;

char aux;

void init(void){

	WDTCTL = WDTPW | WDTHOLD;	// Stop watchdog timer

	//////////////
	// Osciladores
	//////////////

    P2DIR |= BIT2;                       	// P2.2 (SMCLK),
    P2SEL |= BIT2;

    P7SEL |= BIT7;							// P7.7 (MCLK)
    P7DIR |= BIT7;

    P1SEL |= BIT0;							// P1.0 (ACLK)
    P1DIR |= BIT0;

    // Configuración

    UCSCTL3 = SELREF__XT2CLK; 				// Select XT2
    P5SEL |= BIT2; 							// Set the PSEL bit for XT2IN

    UCSCTL6 &= ~(XT2OFF); 					// Enable XT2
    UCSCTL6 &= ~(XT2DRIVE0);				// set the correct drive level for 4MHz

    UCSCTL4 |= SELA__DCOCLKDIV;				// Cambiamos el ACLK de XT1 A DCOCLKDIV

    __bis_SR_register(SCG0);                // Disable the FLL control loop

    UCSCTL0 = 0x0000;                      	// Set lowest possible DCOx, MODx
    UCSCTL1 = DCORSEL_6;                    // Select DCO range 20MHz operation (6)

    UCSCTL2 = FLLD_0 + 4;                 	// Set DCO Multiplier for 20MHz
                                            // (N + 1) * FLLRef = fDCOCLKDIV
                                            // (4 + 1) * 4MHz = 20MHz
                                            // Set fDCOCLKDIV = fDCOCLK/1
    __bic_SR_register(SCG0);              	// Enable the FLL control loop

    // Worst-case settling time for the DCO when the DCO range bits have been
    // changed is n x 32 x 32 x f_MCLK / f_FLL_reference. See UCS chapter in 5xx
    // UG for optimization.
    // 32 x 32 x 4 MHz / 20 MHz = 205 = MCLK cycles for DCO to settle
    __delay_cycles(205);

    // Loop until XT1,XT2 & DCO fault flag is cleared
	do
	{
		UCSCTL7 &= ~(XT2OFFG + XT1LFOFFG + DCOFFG);
                                                		// Clear XT2,XT1,DCO fault flags
        SFRIFG1 &= ~OFIFG;                      		// Clear fault flags
	}while (SFRIFG1&OFIFG);                 			// Test oscillator fault flag


	UCSCTL4 = SELA__XT2CLK | SELS__DCOCLKDIV | SELM__DCOCLKDIV;


	//////////////////////////////
	// Puertos de Entrada y Salida
	//////////////////////////////

	P2OUT = 0;
	P2DIR &= ~BIT5;		// Done de FPGA P2.5
	P2DIR |= BIT4;		// P2.4 como salida
	P2OUT &= ~BIT4;

	//////////////////////////////////
	// Configuración del puerto SPI A0
	//////////////////////////////////

	// 	P2.7 UCA0CLK
	//	P3.3 UCA0TXD
	//	P3.4 UCA0RXD

	P2SEL |= BIT7;			// UCA0CLK
	P3SEL |= BIT3 | BIT4;	//UCA0TXD | UCA0RXD

	UCA0CTL0 |= UCMSB | UCMST | UCSYNC | UCCKPH;		// Phase = 1, Polarity = 0, MSB First, 8-bit, Master Mode, 3-Pin, Synchronous.
	UCA0CTL1 |= UCSSEL__ACLK;							// AMCLK Clock Source. (4MHz)

	UCA0BR0 = 0x0A;							// Prescaler Clock = (UCxxBR0 + UCxxBR1 × 256)
	UCA0BR1	= 0x00;
	
	UCA0CTL1 &= ~UCSWRST;					// Se inicia la máquina de estados del módulo SPI.

	///////////////////////////////////
	// Configuración del Puerto UART A1
	///////////////////////////////////

	P2DIR |= BIT2;                       	// P2.2 SMCLK set out to pins
	P2SEL |= BIT2;

	P4SEL |= BIT4 | BIT5; 					// P4.4 (TX), P4.5 (RX)
	// El registro UCA1CTL0 Se deja nulo. Esto implica
	//		Paridad desactivada
	//		LSB First
	//		8-bit
	//		1 stop bit
	//		Modo Uart y Asíncrono.

	UCA1CTL1 |= UCSSEL_2;                   	// SMCLK Clock Source (20MHz)
	UCA1BR0 = 173;                           	// 115200 (see User's Guide)
	UCA1BR1 = 0;                           		// COM4

	UCA1MCTL |= UCBRS_5 + UCBRF_0;				// Modulacion UCBRSx = 5 , UCBRFx = 0, UCOS16 = 0.

	UCA1CTL1 &= ~UCSWRST;               		// **Initialize USCI state machine

}

int SPI_TXRX(unsigned char input){

	UCA0TXBUF = input;						// Enviamos el dato.

	while(!(UCA0IFG & UCRXIFG));			// Esperamos a que el dato se envíe y se reciva correctamente.

	int output = (int) UCA0RXBUF;			// Leímos el buffer de entrada

	return output;
}

void UART_TXchar(char c )
{
	while (!(UCA1IFG & UCTXIFG));
	UCA1TXBUF = c;
}

char UART_RXchar(){

	char out;

	while(!(UCA1IFG & UCRXIFG));
		out = UCA1RXBUF;

	return out;
}



void UART_TXstring(char* c)
{
    int i;

    for(i=0; i<strlen(c); i++){
    	UART_TXchar(*(c + i));
    }
}

void UART_TXstring2(char* c, int count)
{
    int i;

    for(i=0; i<count; i++){
    	UART_TXchar(*(c + i));
    }
}

void UART_RXstring(){

	// Recibimos el primer byte que nos informa cuantos bytes recibiremos a futuro.
	int count = (int) UART_RXchar();
	UART_TXchar(0x55);

	// Ahora recibimos los demás bytes y los guardamos en RXBUF que posee un tamaño de 30.
	int i;
	for(i=0; i<count; i++){
		RXBUF[i] = UART_RXchar();
		UART_TXchar(0x55);
	}


}


void UART_Response(){

	int i;

	// Primero enviamos la función de la FPGA
	SPI_TXRX(RXBUF[0]);

	switch (RXBUF[0]) {
	case 0x01:	// Configure Opamp.
		SPI_TXRX(RXBUF[1]);
		break;

	case 0x02:	// rst
		SPI_TXRX(RXBUF[1]);
		break;

	case 0x03:	// DACI
		for(i=1; i < 26; i++){
			SPI_TXRX(RXBUF[i]);
		}
		break;

	case 0x04:	// DACR
		for(i=1; i < 26; i++){
			SPI_TXRX(RXBUF[i]);
		}
		break;

	case 0x05:	// ADC Config
		SPI_TXRX(RXBUF[1]);
		SPI_TXRX(RXBUF[2]);
		break;

	case 0x06:	// Reconfiguración
		SPI_TXRX(0x0A);		// Se envía cualquier dato.
		break;

	case 0x07:						// ADC1 Meas
		SPI_TXRX(RXBUF[1]);			// Se escribe el registro de conversión.

		while(!(P2IN & BIT5));			// Esperamos a la FPGA

		READ1 = SPI_TXRX(0x0A);		// Leímos el primer byte.
		READ2 = SPI_TXRX(0x0A);		// Leímos el segundo byte.

		UART_TXchar((unsigned char) READ1);
		UART_TXchar((unsigned char) READ2);

		break;
	case 0x08:				// AD2 Meas
		SPI_TXRX(RXBUF[1]);			// Se escribe el registro de conversión.

		while(!(P2IN & BIT5));			// Esperamos a la FPGA

		READ1 = SPI_TXRX(0x0A);		// Leímos el primer byte.
		READ2 = SPI_TXRX(0x0A);		// Leímos el segundo byte.

		UART_TXchar((char) READ1);
		UART_TXchar((char) READ2);

		break;

	default:
	  break;
	}
}


void main(void){

	init();							// Inicializamos el sistema



	while(1){

		// Esperamos a que la FPGA ya este inicializada.

		//while(!(P2IN & BIT5));

		UART_RXstring();
		UART_Response();
		P2OUT &= ~BIT4;

		// Final

		int i;
		for(i=1; i < 150; i++){
			__delay_cycles(100000);
		}

		UART_TXchar(0x55);
;	}





}
