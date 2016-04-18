function [ result ] = num2FPGA3( A, B, input )
%NUM2FPGA Summary of this function goes here
%   Detailed explanation goes here
    
    if(A<0)
        A = -A;
    end
    
    if(input> A)
        input = A;
    elseif(input < -A)
        input = -A;
    end
    
    
    m = (2^B-1)/(2*A);
    
    aux = m*input + (2^B-1)/2;
    aux2 = (2^B-1)/2;
    
    
    if(aux >= aux2)
        result = floor(aux);
    else
        result = -floor(-aux);
    end
    
    
end

