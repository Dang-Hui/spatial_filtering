function DML_spectrum( u ,f,r,c,color)

   k_rec = (1:9)';
   DS = [];
   for i = 1:360
       a = exp(1i*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/9-i*pi/180)   ));
       PA = a*pinv(a'*a)*a' ;
       val = u'*PA*u;
       DS = [DS,abs(val)];
   end
   plot(DS,color);
   hold on;
   grid on;
end

