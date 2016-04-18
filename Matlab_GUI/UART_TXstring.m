function [ n_return ] = UART_TXstring(s, in)
%UART_TXSTRING Summary of this function goes here
%   Detailed explanation goes here
    % s: Objeto Serial
    % in: vector del mensaje. Deben ser números enteros
    % error: envía 1 si no se recibe correctamente el mensaje.
    
    % s debe estar configurado s.ReadAsyncMode = 'manual';
    
    n = length(in); % n<256.
    
    % Ejecutamos la lectura
    
    p = 10/1000;
    
    % Primero envíamos un indicador del número de bits a enviar.
    
    readasync(s);
    fwrite(s,n,'uint8');
    disp(0);
    pause(p);
    
    while(1)
        if(s.BytesAvailable == 1)
           n_return = fread(s);
           break; 
        end
    end
    
    % Luego envíamos el mensaje.
    
    for i =1:n
        readasync(s);
        disp(i);
        fwrite(s,in(i),'uint8');
        
        while(1)
        if(s.BytesAvailable == 1)
           n_return = fread(s);
           break; 
        end
        end
        
        
    end
        
    disp('fin');
    readasync(s);
    while(1)
        if(s.BytesAvailable == 1)
           n_return = fread(s);
           break; 
        end
    end
    
    pause(p);
    
    
    
end

