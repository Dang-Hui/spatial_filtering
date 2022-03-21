function [ sig_num, p_MUSIC, direction, measure ] = t_MUSIC( R,f,r,c, sig_num)
%'call t_MUSIC'
%�˳��������MUSIC�㷨�е��ź�Դ�������ƺͷ������


% show_Data = Data(:,1:10);
% stop
%======== ����R����==============================================

% V0 = sqrt(diag(diag(R)));
% temp1 = sqrt(diag(1./diag(R,0)));
%R = temp1*R*temp1;
%R
%R = tem% music_R = R
% stop;
%R = p1*R*temp1;
%show = R(1,4)
%====   �����ź�Դ���� ===========================================
[U S V] = svd(R);

for i=1:length(S)
    s(i) = S(i,i)/S(1,1);
end
s1 =  s - [s(2:end),0];
for i=1:length(R)
    if s1(i)<0.2
        break
    end
end
% sig_num = i-1;
% sig_num = 2;
%==== MUSIC�㷨���� =============================================
[anglenumber]= size(R); % anglenumber - ͨ�����������Ǿ�ͨ��; p - ������
    
%     amp=sum(abs(X),2)/p; % ������ֵ��ʱ����ƽ��
%     fia=sum(atan2(imag(X),real(X)),2)/p; % �����Ƕ���ʱ����ƽ�����������Ӧ��Ϊ0��������ƫ����Ļ��ƫ
%     amp= amp / amp(1);  % ��һ��ͨ��ƽ����ֵ��һ��Ϊ1
%     fia= fia - fia(1);  % ��һ��ͨ��ƽ���Ƕȹ�һ��Ϊ0
    
S = U(:,1:sig_num);
% S
% SS = S*S'
p_MUSIC = [];
for angS=1:360
    % ע�⣺���������Ժ�angS����һ�������ˡ�
    A=1:anglenumber;  
    A=A';              % �ھ�ͨ����A = [1,2,3, ..., 9]'
    %A=AngleMatrixRectify(A,f,angS,amp,fia);      
    %A = amp.* exp(sqrt(-1)*(2*pi*f*r/c*cos(2*pi*(A-1)/length(A)-angS*pi/180) + 1* fia));
    A = 1* exp(sqrt(-1)*(2*pi*f*r/c*cos(2*pi*(A-1)/length(A)-angS*pi/180) ));
    Pmusic=A'*A/(A'*(eye(anglenumber)-S*S')*A);  %  MUSIC�㷨
%    Pmusic=(A'*S*S'*A)/(A'*(eye(anglenumber)-S*S')*A);  %  MUSIC�㷨
%     if angS == 1 
%         ES =(eye(anglenumber)-S*S')
%     end
    p_MUSIC = [p_MUSIC,abs(Pmusic)];
end
%====== Ѱ�ҷ�ֵ =================================================
comp_num = 7; %��ֵ���������߼�������Ƚ�
direction = [];
peak_val = [];
p_MUSIC_extended = [p_MUSIC(end-comp_num+1:end),p_MUSIC,p_MUSIC(1:comp_num)];
for i=1:length(p_MUSIC)
%    i
%   [prod(p_MUSIC_extended(i+comp_num)>p_MUSIC_extended(i:i+comp_num-1)), prod(p_MUSIC_extended(i+comp_num)>p_MUSIC_extended(i+comp_num+1:i+2*comp_num))]
    
    if prod(p_MUSIC_extended(i+comp_num)>p_MUSIC_extended(i:i+comp_num-1)) && prod(p_MUSIC_extended(i+comp_num)>p_MUSIC_extended(i+comp_num+1:i+2*comp_num)) ==1
        direction = [direction,i];
        peak_val = [peak_val,p_MUSIC(i)];
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

text(0.9,-1.1,['MUSIC'],'color',[0 1 0]);
text_DML = ['MUSIC�Ƕ�: ',num2str(sort(direction))];
end