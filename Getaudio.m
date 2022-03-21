%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% 按相位提取声音 %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function raw_audio = Getaudio( data )


    re = real(data);
    im = imag(data);

    raw_audio=zeros(1,length(data));
for i=1:1:length(data)
    if i==1
        tmp=(re(1)+1i*im(1))*(re(1)+1i*im(1));
        raw_audio(1)=atan2(real(tmp),imag(tmp));
    else
        tmp=(re(i)-1i*im(i))*(re(i-1)+1i*im(i-1));
        raw_audio(i)=atan2(imag(tmp),real(tmp));
    end
end
end