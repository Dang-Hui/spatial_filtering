function [ Amp ,D, M ] = IDML_Round( R,sig_num, f,r,c )
%
%'IDML calculation begins'

[W,~,~] = svd(R);
W = W(:,1:sig_num)*sqrt(R(1:sig_num,1:sig_num));

k_rec = (1:9)';

%t_signum( R );
total_N = sig_num;
PP_rec = [];
count = 0;
directions = [];

for N = 1:total_N    
    count = count+1;
    for i = 1:360    
        A = [PP_rec,exp(1i*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/9-i*pi/180)))];
        B = A*pinv(A'*A)*A' ;
        rec(i) = abs(sum(diag(B*R)));
    end
    [~,tp2] = max(rec);    % ¹ÀÖµÎªtp2    

    [PP,amplitude] = t_actual(W,f,r,c,tp2);  


    [ direction_tp,~,~,~] = t_DML( PP*PP',f,r,c, 2, 1 );
    PP_new = t_actual_2(W,f,r,c,direction_tp); 
    [ direction_tp, measure_tp,~, ~ ] = t_DML( PP_new*PP_new',f,r,c, 2, 1 );   
    
    %======================================================================

    directions = [directions, tp2];
    PP_rec = t_actual_multi(W,f,r,c,directions);
    


    Amp(count) = amplitude;
    D{count} = direction_tp;
    M{count} = measure_tp;
end

end

