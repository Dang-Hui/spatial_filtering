function [u1,u2,u3] = t_swap(u1,u2,u3,direction,D)

[~,ind1] = min(abs(angle(exp(1i*(direction-D(1))/180*pi))));
[~,ind2] = min(abs(angle(exp(1i*(direction-D(2))/180*pi))));
[~,ind3] = min(abs(angle(exp(1i*(direction-D(3))/180*pi))));
U = {u1,u2,u3};
u1 = U{ind1};
u2 = U{ind2};
u3 = U{ind3};

end