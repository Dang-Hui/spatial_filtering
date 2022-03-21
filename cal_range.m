function [ xrange ] = cal_range( x,thred1 )

len = floor(length(x)/2);
x_fft = abs(fft(x));
x_fft = x_fft([len+1:end,1:len]);
p = x_fft;
for i = 1:length(p)
    if p(i)>thred1*max(p)
        break;
    end 
end
for j = length(p):-1:1
    if p(j)>thred1*max(p)
        break;
    end
end

i_original = i;
i = i-(j-i);
if i<1
    i = 1;
end
j = j+(j-i_original);
if j>length(p)
    j = length(p);
end
xrange = [i,j];

end

