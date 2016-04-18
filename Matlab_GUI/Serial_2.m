function [] = Serial_2(in)
%SERIAL_2 Summary of this function goes here
%   Detailed explanation goes here

    
    %%%%%%%%%%%%%%%%%%%%%%%
    % Parámetros de Usuario
    %%%%%%%%%%%%%%%%%%%%%%%

    IOP1 = in.iop1;
    IOP2 = in.iop2;
    IOP3 = in.iop3;
    IOP4 = in.iop4;
    ROP1 = in.rop1;
    ROP2 = in.rop2;
    ROP3 = in.rop3;
    ROP4 = in.rop4;

    RESET = in.rst;

    UPI_1 = in.up_i(1);
    UPI_2 = in.up_i(2);
    UPI_3 = in.up_i(3);
    UPI_4 = in.up_i(4);
    UPI_5 = in.up_i(5);
    UPI_6 = in.up_i(6);
    UPI_7 = in.up_i(7);
    UPI_8 = in.up_i(8);
    UPI_9 = in.up_i(9);
    UPI_10 = in.up_i(10);

    DOWNI_1 = in.down_i(1);
    DOWNI_2 = in.down_i(2);
    DOWNI_3 = in.down_i(3);
    DOWNI_4 = in.down_i(4);
    DOWNI_5 = in.down_i(5);
    DOWNI_6 = in.down_i(6);
    DOWNI_7 = in.down_i(7);
    DOWNI_8 = in.down_i(8);
    DOWNI_9 = in.down_i(9);
    DOWNI_10 = in.down_i(10);
    
    UPI_STATES = in.nup_i;
    DOWNI_STATES = in.ndown_i;
    IIDLE = in.idle_i;
    DIVIDER_I = floor(100e6/in.fstep_i);

    UPR_1 = in.up_r(1);
    UPR_2 = in.up_r(2);
    UPR_3 = in.up_r(3);
    UPR_4 = in.up_r(4);
    UPR_5 = in.up_r(5);
    UPR_6 = in.up_r(6);
    UPR_7 = in.up_r(7);
    UPR_8 = in.up_r(8);
    UPR_9 = in.up_r(9);
    UPR_10 = in.up_r(10);

    DOWNR_1 = in.down_r(1);
    DOWNR_2 = in.down_r(2);
    DOWNR_3 = in.down_r(3);
    DOWNR_4 = in.down_r(4);
    DOWNR_5 = in.down_r(5);
    DOWNR_6 = in.down_r(6);
    DOWNR_7 = in.down_r(7);
    DOWNR_8 = in.down_r(8);
    DOWNR_9 = in.down_r(9);
    DOWNR_10 = in.down_r(10);
    UPR_STATES = in.nup_r;
    DOWNR_STATES = in.ndown_r;
    RIDLE = in.idle_r;
    DIVIDER_R = floor(100e6/in.fstep_r);

    %ADC_SETUP = 0;
    %ADC_AVER = 0;

    %ADC_CONVER1 = 0;
    %ADC_CONVER2 = 0;


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Parametros de Configuración
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    UART_OPAMP = [1 bin2dec(num2str([ROP4 ROP3 ROP2 ROP1 IOP4 IOP3 IOP2 IOP1]))];    % El primer elemento es el identificador.

    UART_RESET = [2 RESET];

    UPI = [UPI_1 UPI_2 UPI_3 UPI_4 UPI_5 UPI_6 UPI_7 UPI_8 UPI_9 UPI_10];
    DOWNI = [DOWNI_1 DOWNI_2 DOWNI_3 DOWNI_4 DOWNI_5 DOWNI_6 DOWNI_7 DOWNI_8 DOWNI_9 DOWNI_10];
    CONFI = [UPI_STATES DOWNI_STATES IIDLE (DIVIDER_I-floor(DIVIDER_I/2^8)*2^8) floor(DIVIDER_I/2^8)];
    UART_DACI = [3 UPI DOWNI CONFI];

    UPR = [UPR_1 UPR_2 UPR_3 UPR_4 UPR_5 UPR_6 UPR_7 UPR_8 UPR_9 UPR_10];
    DOWNR = [DOWNR_1 DOWNR_2 DOWNR_3 DOWNR_4 DOWNR_5 DOWNR_6 DOWNR_7 DOWNR_8 DOWNR_9 DOWNR_10];
    CONFR = [UPR_STATES DOWNR_STATES RIDLE (DIVIDER_R-floor(DIVIDER_R/2^8)*2^8) floor(DIVIDER_R/2^8)];
    UART_DACR = [4 UPR DOWNR CONFR];


    UART_RECONFIG = [6 10];



    %%%%%%%%%%%%%%%%%%%%%%
    % Configuración Puerto
    %%%%%%%%%%%%%%%%%%%%%%
    if(isempty(instrfind) == 0)
        fclose(instrfind);          % Cerramos todos los puertos.
    end
    s = serial(in.serial_port);

    set(s,'BaudRate', 115200);      % Baudrate 115200.
    set(s,'InputBufferSize',1);     % El proceso de lectura terminará cuando se llene el buffer. Cambiar en caso contrario.

    if(strcmp(s.Status,'closed'))
        fopen(s);
    end

    s.ReadAsyncMode = 'manual';



    %%%%%%%%%%
    % Mensajes
    %%%%%%%%%%

    UART_TXstring(s, UART_OPAMP);
    UART_TXstring(s, UART_RESET);
    UART_TXstring(s,UART_DACI);
    UART_TXstring(s,UART_DACR);
    UART_TXstring(s,UART_RECONFIG);

    %%%%%%%%
    % Cierre
    %%%%%%%%

    fclose(s);

    %%%%%%%%%%%%%%%%
    % Lectura de ADC
    %%%%%%%%%%%%%%%%


end

