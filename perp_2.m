function [ Ap ] = perp_2( A, A1 )

%      Q = 0; 
%      for i = 1:length(A)
%          Q = Q + A{i}*A{i}';
%      end
%        [U S V] = svd(Q);
% %        for i = 1:7
% %            Ap_rec{i} = U(:,i+2);
% %            rec(i) = abs(A3'*Ap_rec{i});
% %        end
% %        [tp2, index] = max(rec);
% %        Ap = Ap_rec{index};
%      a = A1;
%      U = U(:,length(A)+1:end);
%      C = U'*a*a'*U;
%      D = U'*U;
% 
%      [p_set, lambda_set] = eig(C,D);
%       show = diag(lambda_set)
%      [max_val,i_index] = max(abs(diag(lambda_set)));
%      p = p_set(:,i_index);
%      Ap = U*p;

     
     Q = 0; 
     for i = 1:length(A)
         Q = Q + A{i}*A{i}';
     end
     [v,d]=eig(Q);
     [val_0,i_index] = min(abs(diag(d)));
     p = v(:,i_index);
     Ap=p;

end

