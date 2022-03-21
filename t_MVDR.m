function [ sig_num, text_MVDR, direction, measure] = t_MVDR( R,f,r,c, sig_num )
%'call t_MUSIC'
%此程序包含了MUSIC算法中的信号源个数估计和方向计算
%==== MUSIC算法主体 =============================================
[anglenumber]= size(R); % anglenumber - 通道数，这里是九通道; p - 样本数
    
%     amp=sum(abs(X),2)/p; % 样本幅值随时间求平均
%     fia=sum(atan2(imag(X),real(X)),2)/p; % 样本角度随时间求平均，理想情况应该为0，但是有偏差，下文会纠偏
%     amp= amp / amp(1);  % 第一个通道平均幅值归一化为1
%     fia= fia - fia(1);  % 第一个通道平均角度归一化为0
    
    RN=pinv(R);
    p_MVDR=[];
for angS=1:360
    % 注意：到了这里以后，angS就是一个标量了。
    A=1:anglenumber;  
    A=A';              % 在九通道中A = [1,2,3, ..., 9]'
    %A=AngleMatrixRectify(A,f,angS,amp,fia);      
    %A = amp.* exp(sqrt(-1)*(2*pi*f*r/c*cos(2*pi*(A-1)/length(A)-angS*pi/180) + 1* fia));
    A = 1* exp(sqrt(-1)*(2*pi*f*r/c*cos(2*pi*(A-1)/length(A)-angS*pi/180) ));
    Pmvdr=1/(A'*RN*A);  %  MUSIC算法
%    Pmusic=(A'*S*S'*A)/(A'*(eye(anglenumber)-S*S')*A);  %  MUSIC算法
%     if angS == 1 
%         ES =(eye(anglenumber)-S*S')
%     end
    p_MVDR = [p_MVDR,abs(Pmvdr)];
end
%====== 寻找峰值 =================================================
comp_num = 7; %峰值和左右两边几个数相比较
direction = [];
peak_val = [];
p_MVDR_extended = [p_MVDR(end-comp_num+1:end),p_MVDR,p_MVDR(1:comp_num)];
for i=1:length(p_MVDR)
%    i
%   [prod(p_MUSIC_extended(i+comp_num)>p_MUSIC_extended(i:i+comp_num-1)), prod(p_MUSIC_extended(i+comp_num)>p_MUSIC_extended(i+comp_num+1:i+2*comp_num))]
    
    if prod(p_MVDR_extended(i+comp_num)>p_MVDR_extended(i:i+comp_num-1)) && prod(p_MVDR_extended(i+comp_num)>p_MVDR_extended(i+comp_num+1:i+2*comp_num)) ==1
        direction = [direction,i];
        peak_val = [peak_val,p_MVDR(i)];
    end
end

[a,b]=sort(peak_val);
direction = direction(b);
if length(direction)>=sig_num
   direction = direction(end:-1:end-sig_num+1);
   measure = a(end:-1:end-sig_num+1);
else
   measure = a;
end

%======= 每个峰值的相对强度 ======================================
% for i=1:sig_num
%     %a = A;
%     k_rec = 1:9;
%     angle_temp = direction(i);
%     a = exp(sqrt(-1)*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/9-angle_temp*pi/180) ));
%     a = a';
%     Q = inv(a'*a)*a';
%     S = Q*R*Q';
%     measure(i) = real(S);
% end
% measure = measure;
text(0.9,-1,['MVDR'],'color',[0 0 1])
text_MVDR = ['MVDR角度: ',num2str(sort(direction))];
% visualize(direction, measure,'MVDR'); hold on;
end