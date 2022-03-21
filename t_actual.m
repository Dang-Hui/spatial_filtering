function [ PP, max_val] = t_actual(W,f,r,c,pre_direction)  

    k_rec = (1:9)';
    A = exp(1i*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/9-pre_direction*pi/180)));
    B = A*pinv(A'*A)*A' ;
    C = W'*B*W;
    %=============================================================
%     B = A*A';
%     C = 0;
%     for i = 1:360
%         F = exp(1i*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/9-i*pi/180)));
%         C = C + (F'*B*F) *B;
%     end
%     C = W'*C*W;
    %=============================================================
    
    
    D = W'*W;
    [P,S] = eig(C,D);
    [max_val,in] = t_index(S);
    P = P(:,in);
    
    %plot_background; hold on;
    PP = W*P;
    PP = PP/norm(PP);
end

