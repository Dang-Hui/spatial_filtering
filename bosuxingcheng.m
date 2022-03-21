direction=[104 317 258];
D=direction;
R=X*X';
f=500e6;
r=0.525;
c = 3e8;
k_rec = (1:9)';
R12 = R;
[U1,S,~] = svd(R12);
v1 = U1(:,1)*sqrt(S(1,1));
v2 = U1(:,2)*sqrt(S(2,2));
v3 = U1(:,3)*sqrt(S(3,3));  

U_mcmc = [v1,v2,v3]*Umcmc;
u1_mcmc = U_mcmc(:,1);
u2_mcmc = U_mcmc(:,2);
u3_mcmc = U_mcmc(:,3);
[u1_mcmc,u2_mcmc,u3_mcmc] = t_swap(u1_mcmc,u2_mcmc,u3_mcmc,direction,D);
 %=========================================================================
U_pso = [v1,v2,v3]*Upso;
u1_pso = U_pso(:,1);
u2_pso = U_pso(:,2);
u3_pso = U_pso(:,3);
[u1_pso,u2_pso,u3_pso] = t_swap(u1_pso,u2_pso,u3_pso,direction,D);

%##########################################################################
% u1 = u1_original;
% u2 = u2_original;
% u3 = u3_original;

%##########################################################################

%==========================================================================
%================ 接下来的工作：波束合成算法 ================================

u_mcmc = perp_2( {u2_mcmc, u3_mcmc}, u1_mcmc );
u_mcmc = (u_mcmc');
X_syn_mcmc = u_mcmc*X;

u_pso = perp_2( {u2_pso, u3_pso}, u1_pso );
u_pso = (u_pso');
X_syn_pso = u_pso*X;

xrange = cal_range(X(1,:),0.1);

figure(1);
Copy_of_plot_fft2(xrange,X(1,:),'k',X_syn_mcmc,'k',X_syn_pso,'k');
ylabel('归一化幅值');
xlabel('频率/Hz');
legend('滤波前','MCMC算法滤波后','PSO算法滤波后')
%====================================================
u_mcmc = perp_2( {u1_mcmc, u3_mcmc}, u2_mcmc );
u_mcmc = (u_mcmc');
X_syn_mcmc = u_mcmc*X;

u_pso = perp_2( {u1_pso, u2_pso}, u3_pso );
u_pso = (u_pso');
X_syn_pso = u_pso*X;

% xrange = cal_range(X(1,:),0.1);
figure(2);
Copy_of_plot_fft2(xrange,X(1,:),'k',X_syn_mcmc,'k',X_syn_pso,'k');
ylabel('归一化幅值');
xlabel('频率/Hz');
legend('滤波前','MCMC算法滤波后','PSO算法滤波后')
%==========================================================================
u_mcmc = perp_2( {u1_mcmc, u2_mcmc}, u3_mcmc );
u_mcmc = (u_mcmc');
X_syn_mcmc = u_mcmc*X;

u_pso = perp_2( {u1_pso, u3_pso}, u2_pso );
u_pso = (u_pso');
X_syn_pso = u_pso*X;

% xrange = cal_range(X(1,:),0.1);
figure(3);
Copy_of_plot_fft2(xrange,X(1,:),'k',X_syn_mcmc,'k',X_syn_pso,'k');
% Copy_of_plot_fft2(xrange,X(1,:),'r',X_syn_mcmc,[0 0.5 0],X_syn_pso,[0.3 0.3 1]);
ylabel('归一化幅值');
xlabel('频率/Hz');
legend('滤波前','MCMC算法滤波后','PSO算法滤波后')



% u = perp_2( {u1_mcmc, u3_mcmc}, u2_mcmc );
% u = (u');
% X_syn = u*X;
% figure(2);
% plot_fft2(X(1,:),'r',X_syn,'b');
% 
% xlim(xrange)
% legend('滤波前','滤波后')
% 
% %==========================================================================
% 
% u = perp_2( {u1_mcmc, u2_mcmc}, u3_mcmc );
% u = (u');
% X_syn = u*X;
% figure(3);
% plot_fft2(X(1,:),'r',X_syn,'b');%
% xlim(xrange)
% legend('滤波前','滤波后')


% axes(handles.axes8)
% DML_spectrum(u1,f,r,c,'b');
% hold on;
% axes(handles.axes9)
% DML_spectrum(u2,f,r,c,'b');
% hold on;
% axes(handles.axes10)
% DML_spectrum(u3,f,r,c,'b');
% hold on;