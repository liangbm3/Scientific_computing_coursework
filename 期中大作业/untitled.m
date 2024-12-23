info = functions(func);
    if strcmp(info.function, 'mmse_fun')
        bit_stream_rx=func(H,x,sqrt(sigma));
    else
        bit_stream_rx=func(H,x);
    end