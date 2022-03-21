 function [ u1,u2,u3] = DBF_PSO_G( X,R,f,r,c,direction,handles,D )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
k_rec = (1:9)';
R12 = R;
[U,S,~] = svd(R12);
v1 = U(:,1)*sqrt(S(1,1));
v2 = U(:,2)*sqrt(S(2,2));
v3 = U(:,3)*sqrt(S(3,3));

%==========================================================================
%=============================================================================

A1 = exp(1i*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/9-direction(1)*pi/180)   ));
A2 = exp(1i*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/9-direction(2)*pi/180)   ));
A3 = exp(1i*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/9-direction(3)*pi/180)   ));
PA1 = A1*pinv(A1'*A1)*A1' ;
PA2 = A2*pinv(A2'*A2)*A2' ;
PA3 = A3*pinv(A3'*A3)*A3' ;

%==========================================================================

%==========================================================================
       

       particle_num = 10000;
       iteration_num = 10;
       factor1 = 0.2;
       factor2 = 0.2;
       for i = 1:particle_num
           Q{i} = (randn(3)+1i*randn(3));
           local_Q{i} = Q{i};
           local_min{i} = 9e120;
       end
       global_Q = Q{1};
       global_min = 9e120;
       global_min_rec = [];
       for iteration = 1:iteration_num
           for i = 1:particle_num
                Q{i} = Q{i} + factor1*(local_Q{i} - Q{i}) + factor2*(global_Q - Q{i});%local_Q{i+1}  %
                [P,R] = qr(Q{i});
                R = diag(diag(R)./abs(diag(R)));
                U = P*R;
                U2 = [v1,v2,v3]*U;
                u1 = U2(:,1);
                u2 = U2(:,2);
                u3 = U2(:,3);
               residue = -real(u1'*PA1*u1+ u2'*PA2*u2 + u3'*PA3*u3); % DML法
               % residue = -1/abs(A1'*[u2,u3]*[u2,u3]'*A1) -1/abs(A2'*[u1,u3]*[u1,u3]'*A2) -1/abs(A3'*[u2,u1]*[u2,u1]'*A3) % MUSIC法
               %=====================================================
%                M = R.*(conj(A)*conj(A'));
%                C = (M + conj(M))/2;
%                D = diag(A.*conj(A));
%                P_tp = Q{i};
%                residue = - (P_tp'*C*P_tp) /(P_tp'*D*P_tp)
               %=====================================================
               if residue < local_min{i}             
                   local_Q{i} = Q{i};
                   local_min{i} = residue;
               end
               if residue < global_min                  
                 % [ 'residue ', num2str(residue),' iteration ',num2str(iteration) ]
                   global_Q = Q{i};
                   global_min = residue;
                  
               end
           end
           global_min_rec = [global_min_rec, global_min];
       end
       [P,R] = qr(global_Q);
       R = diag(diag(R)./abs(diag(R)));
       U = P*R;
       %========================================

       %========================================
       U2 = [v1,v2,v3]*U;
       u1 = U2(:,1);
       u2 = U2(:,2);
       u3 = U2(:,3);
       [u1,u2,u3] = t_swap(u1,u2,u3,direction,D);


 %=========================================================================
% =========================================================================
axes(handles.axes2)
plot_background;
visual2(abs(u1)/max(abs(u1)),'b')
xlim([-1.2 1.2]);ylim([-1.2 1.2]);
hold on;

%==========================================================================
axes(handles.axes3)
plot_background;
visual2(abs(u2)/max(abs(u2)),'b')
xlim([-1.2 1.2]);ylim([-1.2 1.2]);
hold on;

%==========================================================================
axes(handles.axes4)
plot_background;
visual2(abs(u3)/max(abs(u3)),'b')
xlim([-1.2 1.2]);ylim([-1.2 1.2]);
hold on;

%##########################################################################
% u1 = u1_original;
% u2 = u2_original;
% u3 = u3_original;

%##########################################################################

%==========================================================================
%================ 接下来的工作：波束合成算法 ================================

u = perp_2( {u2, u3}, u1 );
u = (u');
X_syn = u*X;

xrange = cal_range(X(1,:),0.1);

axes(handles.axes5)
plot_fft2(X(1,:),'r',X_syn,'b');
grid on;

xlim(xrange)
legend('滤波前','滤波后')

hold on;

%==========================================================================

u = perp_2( {u1, u3}, u2 );
u = (u');
X_syn = u*X;
axes(handles.axes6)
plot_fft2(X(1,:),'r',X_syn,'b');
grid on;

xlim(xrange)
legend('滤波前','滤波后')

%==========================================================================

u = perp_2( {u1, u2}, u3 );
u = (u');
X_syn = u*X;
axes(handles.axes7)
plot_fft2(X(1,:),'r',X_syn,'b');%
grid on;

xlim(xrange)
legend('滤波前','滤波后')

hold on;

axes(handles.axes8)
DML_spectrum(u1,f,r,c,'b');
hold on;
axes(handles.axes9)
DML_spectrum(u2,f,r,c,'b');
hold on;
axes(handles.axes10)
DML_spectrum(u3,f,r,c,'b');
hold on;

end

