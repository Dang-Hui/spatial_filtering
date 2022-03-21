function [u1,u2,u3]=mcmc_optimization(X,R,f,r,c,direction,handles,D)
[U_,S,~]=svd(R);
s1=U_(:,1)*sqrt(S(1,1));
s2=U_(:,2)*sqrt(S(2,2));
s3=U_(:,3)*sqrt(S(3,3));
W=[s1,s2,s3];%信号子空间
k_rec=(1:9)';
A1=exp(1i*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/9-direction(1)*pi/180)));
A2=exp(1i*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/9-direction(2)*pi/180)));
A3=exp(1i*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/9-direction(3)*pi/180)));
PA1=A1*pinv(A1'*A1)*A1';
PA2=A2*pinv(A2'*A2)*A2';
PA3=A3*pinv(A3'*A3)*A3';

o=R(1,1);
j=0;
while(abs(o/10)>1)
    j=j+1;
    o=o/10;
end

start_U=randn(3)+1i*randn(3);
[e,ff]=qr(start_U);
ff=diag(diag(ff)./abs(diag(ff)));
start_U=e*ff;
iteration=2500;
mcmc_chain=mh(start_U,iteration);
U=mcmc_chain{end};
save('U','U');
U2=W*U;
v1=U2(:,1);
v2=U2(:,2);
v3=U2(:,3);
[u1,u2,u3]=t_swap(v1,v2,v3,direction,D);
%===========================================
axes(handles.axes2)
plot_background;
visual2(abs(u1)/max(abs(u1)),'b');
xlim([-1.2,1.2]);
ylim([-1.2,1.2]);
hold on;

axes(handles.axes3)
plot_background;
visual2(abs(u2)/max(abs(u2)),'b');
xlim([-1.2,1.2]);
ylim([-1.2,1.2]);
hold on;


axes(handles.axes4);
plot_background;
visual2(abs(u3)/max(abs(u3)),'b');
xlim([-1.2,1.2]);
ylim([-1.2,1.2]);
hold on;

%%波速合成算法
%=======================================

u=perp_2({u2,u3},u1);
% u=perp_2({u2},u1);
u=(u');
X_syn=u*X;

xrange=cal_range(X(1,:),0.1);

axes(handles.axes5);
plot_fft2(X(1,:),'r',X_syn,'b');
grid on;

xlim(xrange);
legend('滤波前','滤波后');

hold on;
%=====================================================
u=perp_2({u1,u3},u2);
% u=perp_2({u1},u2);
u=(u');
X_syn=u*X;
axes(handles.axes6);
plot_fft2(X(1,:),'r',X_syn,'b');
grid on;

xlim(xrange);
legend('滤波前','滤波后');
%================================================================
u=perp_2({u1,u2},u3);
u=(u');
X_syn=u*X;
axes(handles.axes7);
plot_fft2(X(1,:),'r',X_syn,'b');
grid on;

xlim(xrange);
legend('滤波前','滤波后');
hold on;

axes(handles.axes8);
DML_spectrum(u1,f,r,c,'b');
hold on;
axes(handles.axes9);
DML_spectrum(u2,f,r,c,'b');
hold on;
axes(handles.axes10);
DML_spectrum(u3,f,r,c,'b');
hold on;

%% 提议分布
function U=proposal_function(U,iteration,i)
sig=exp(3*(((iteration-i)/iteration)-1));
I=ones(3);
U=normrnd(real(U),sig*I)+1i*normrnd(imag(U),sig*I);
[a,b]=qr(U);
b=diag(diag(b)./abs(diag(b)));
U=a*b;
end

%% 目标分布
function max_value=target_distribution(U,i)
V=W*U;
v1=V(:,1);
v2=V(:,2);
v3=V(:,3);
T=1/log(1+i);
target=v1'*PA1*v1+v2'*PA2*v2+v3'*PA3*v3;
max_value=exp(target/10^j/T);
end

%% M-H
function mcmc_chain=mh(start_U,iteration)
chain{1}=start_U;
for i=1:iteration
    proposal=proposal_function(chain{i},iteration,i);
    lanmuda=target_distribution(proposal,i)/target_distribution(chain{i},i);
    alpha=min(1,lanmuda);
    p=rand();
    if p<alpha
        chain{i+1}=proposal;
    else
        chain{i+1}=chain{i};
    end
end
mcmc_chain=chain;
end
end

