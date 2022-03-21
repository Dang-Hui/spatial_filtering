function [ x_fft ] = plot_fft( x,color )

  len = floor(length(x)/2);
  x_fft = abs(fft(x));
  x_fft = x_fft([len+1:end,1:len]);
  plot(x_fft/max(x_fft),'color',color);%

end

