function [out] = Plot_Clock3(in)
%PLOT_IMAGEN Summary of this function goes here
%   Detailed explanation goes here

% Esta función de Matlab permite graficar un periodo de la señal de salida
% dados. in es una estructura con:
    % f_clock: Frecuencia de la señal de reloj del CCD.
    % Duty: Trabajo de la señal de reloj
    % f_step: Frecuencia de cambio de cada paso de la señal de reloj.
    % C : Capacitancia de la carga.
    % A_i : Amplitud Máxima de la señal de corriente [-A_i, A_i].
    % i_rms : Corriente rms máxima permitida.
    % up: Estados de subida en [A].
    % down : Estados de bajada en [A].
    
    % out: Estructura de salida con los datos corregidos.
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Verificación de Parámetros
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    n_up = length(in.up);
    n_down = length(in.down);
    
    T_clock = 1/in.f_clock;
    T_step = 1/in.f_step;
    

    if(n_up>10)
        in.up = in.up(1:10);
        n_up = 10;
    end
    
    if(n_down>10)
        in.down = in.down(1:10);
        n_down = 10;
    end
    
    Duty = abs(in.Duty);
    
    if(abs(Duty)>0.8)
       Duty = 0.8;
    end
    
    % Verificamos que la forma de señal sea la correcta
    
    if(T_step*(n_up+n_down)>= T_clock)
        T_clock = T_step*(n_up+n_down+2);
    end
    
    if(T_step*n_up>T_clock*Duty)
        Duty = T_step*(n_up+1)/T_clock;
        
    end
    
    
    % Saturamos la entrada.
    
    for i= 1:n_up
       if(abs(in.up(i))>in.A_i)
          in.up(i) = in.A_i*sign(in.up(i)); 
       end
    end
    
    for i = 1:n_down
       if(abs(in.down(i))>in.A_i)
          in.down(i) = in.A_i*sign(in.down(i)); 
       end 
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Convertimos los datos a valores cuantizados
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    m = (2^8-1)/(2*in.A_i);
    
    up_b = zeros(1,n_up);
    down_b = zeros(1, n_down);
     
    
    for i = 1:n_up
        up_b(i) = num2FPGA3(in.A_i, 8, in.up(i));
        in.up(i) = floor((up_b(i) - (2^8-1)/2+1))/m; 
    end
    
    for i = 1:n_down
       down_b(i) = num2FPGA3(in.A_i, 8, in.down(i));
       in.down(i) = -floor(-(down_b(i) - (2^8-1)/2)+1)/m;
    end
    
    
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%
    % Inicio del bucle
    %%%%%%%%%%%%%%%%%%
    
    p = 100e6;  % Precisión
    
    out.t_plot = 0:(1/p):T_clock;
    m = length(out.t_plot);
    out.v_plot = zeros(1,m);
    out.i_plot = zeros(1,m);
    
    out.v_plot(1) = in.A_v_m;      % Se asume que comenzamos en el mínimo.
    
    % Cálculo del Voltaje
    
    for i= 1:(m-1) 
        s_up = min(n_up, floor(out.t_plot(i)/T_step) + 1);
        s_down = min(n_down, floor((out.t_plot(i) - T_clock*Duty)/T_step) + 1);
        
        if(out.t_plot(i) <= T_clock*Duty)
           out.v_plot(i+1) = in.up(s_up)/(in.C*p) + out.v_plot(i);
        else
            out.v_plot(i+1) = in.down(s_down)/(in.C*p) + out.v_plot(i);
        end
        
        out.v_plot(i+1) = min(in.A_v_p, max(in.A_v_m, out.v_plot(i+1)));
        out.i_plot(i) = in.C*p*(out.v_plot(i+1) - out.v_plot(i));
    end
    
    out.i_plot(m) = out.i_plot(m-1);
    
    % Cálculo de la Potencia RMS
    
    out.i_rms = sqrt((out.i_plot*out.i_plot')/(T_clock*p));
    
    % Corrección de Datos
    
    out.T_step = T_step;
    out.T_clock = T_clock;
    out.Duty = Duty;
    
    
    % Transformamos los datos a bits
    
   
    
    out.idle_b = num2FPGA(in.A_i, 8, -abs(in.idle));
    
    
    out.up = in.up(1:n_up);
    out.down = in.down(1:n_down);
    
    out.up_b = up_b;
    out.down_b = down_b;
    
    out.n_up = n_up;
    out.n_down = n_down;
    
end

