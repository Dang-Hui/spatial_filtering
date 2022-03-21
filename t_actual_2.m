function [ PP] = t_actual_2(W,f,r,c,pre_direction)  

    k_rec = (1:9)';
    %=====================================================================================================================================
    A = [exp(1i*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/9-pre_direction(1)*pi/180))), exp(1i*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/9-pre_direction(2)*pi/180)))];
    A1 = exp(1i*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/9-pre_direction(1)*pi/180)));
    A2 = exp(1i*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/9-pre_direction(2)*pi/180)));
    B = A1*pinv(A1'*A1)*A1' + A2*pinv(A2'*A2)*A2';
    C = W'*B*W;
    D = W'*W;
    [P,S] = eig(C,D);
    [max_val,in] = t_index(S);
    P = P(:,in);
    
    %plot_background; hold on;
    PP = W*P;
    PP = PP/norm(PP);
end

