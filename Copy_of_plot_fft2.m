function [ x1_fft,x2_fft ] = Copy_of_plot_fft2( xrange,x1,color1,x2,color2,x3,color3 )

  len = floor(length(x1)/2);
  x_fft1 = abs(fft(x1))/length(x1);
  x_fft1 = x_fft1([len+1:end,1:len]);
  
  len = floor(length(x2)/2);
  x_fft2 = abs(fft(x2))/length(x2);
  x_fft2 = x_fft2([len+1:end,1:len]);
  
  len = floor(length(x3)/2);
  x_fft3 = abs(fft(x3))/length(x3);
  x_fft3 = x_fft3([len+1:end,1:len]);
  
  plot((10e3/8192)*((xrange(1)):1:(xrange(2))),x_fft1(xrange(1):xrange(2))/max(x_fft1),'linewidth',0.8,'color',color1);%
  hold on;
  plot((10e3/8192)*((xrange(1)):1:(xrange(2))),x_fft2(xrange(1):xrange(2))/max(x_fft2),'--','linewidth',0.8,'color',color2);%
  hold on;
  plot((10e3/8192)*((xrange(1)):1:(xrange(2))),x_fft3(xrange(1):xrange(2))/max(x_fft3),'-.','linewidth',0.8,'color',color3);%
  hold on;
  
end

