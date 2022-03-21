function [ PP, max_val] = t_actual_multi(W,f,r,c,pre_direction)  

    k_rec = (1:9)';
    B = 0;
    len = length(pre_direction);
    for i = 1:len
        A = exp(1i*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/9-pre_direction(i)*pi/180)));
        B = B + A*pinv(A'*A)*A' ;
    end
    C = W'*B*W;
    D = W'*W;
    [P,S] = eig(C,D);
    s = abs(diag(S))
    [~,in] = sort(s,'descend');
    in = in(1:len);
    P = P(:,in);
    for i = 1:length(P(1,:))
        P(:,i) = P(:,i)/norm(P(:,i));
    end
    PP = W*P;
    max_val = max(s);
    
end

