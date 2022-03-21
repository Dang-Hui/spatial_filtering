function [ x1_fft,x2_fft ] = plot_fft2( x1,color1,x2,color2 )

  len = floor(length(x1)/2);
  x_fft1 = abs(fft(x1))/length(x1);
  x_fft1 = x_fft1([len+1:end,1:len]);
  
  len = floor(length(x2)/2);
  x_fft2 = abs(fft(x2))/length(x2);
  x_fft2 = x_fft2([len+1:end,1:len]);
  
  plot(x_fft1/max(max(x_fft1)),'color',color1);%
  hold on;
  plot(x_fft2/max(max(x_fft2)),'color',color2);%
  hold on;
end

