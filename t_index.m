function [max_val,y] = t_index(S)

   tp = abs(diag(S));
   [max_val,y] = max(tp);

end