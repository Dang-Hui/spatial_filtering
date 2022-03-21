function [ sig_num, text_MVDR, direction, measure] = t_MVDR( R,f,r,c, sig_num )
%'call t_MUSIC'
%�˳��������MUSIC�㷨�е��ź�Դ�������ƺͷ������
%==== MUSIC�㷨���� =============================================
[anglenumber]= size(R); % anglenumber - ͨ�����������Ǿ�ͨ��; p - ������
    
%     amp=sum(abs(X),2)/p; % ������ֵ��ʱ����ƽ��
%     fia=sum(atan2(imag(X),real(X)),2)/p; % �����Ƕ���ʱ����ƽ�����������Ӧ��Ϊ0��������ƫ����Ļ��ƫ
%     amp= amp / amp(1);  % ��һ��ͨ��ƽ����ֵ��һ��Ϊ1
%     fia= fia - fia(1);  % ��һ��ͨ��ƽ���Ƕȹ�һ��Ϊ0
    
    RN=pinv(R);
    p_MVDR=[];
for angS=1:360
    % ע�⣺���������Ժ�angS����һ�������ˡ�
    A=1:anglenumber;  
    A=A';              % �ھ�ͨ����A = [1,2,3, ..., 9]'
    %A=AngleMatrixRectify(A,f,angS,amp,fia);      
    %A = amp.* exp(sqrt(-1)*(2*pi*f*r/c*cos(2*pi*(A-1)/length(A)-angS*pi/180) + 1* fia));
    A = 1* exp(sqrt(-1)*(2*pi*f*r/c*cos(2*pi*(A-1)/length(A)-angS*pi/180) ));
    Pmvdr=1/(A'*RN*A);  %  MUSIC�㷨
%    Pmusic=(A'*S*S'*A)/(A'*(eye(anglenumber)-S*S')*A);  %  MUSIC�㷨
%     if angS == 1 
%         ES =(eye(anglenumber)-S*S')
%     end
    p_MVDR = [p_MVDR,abs(Pmvdr)];
end
%====== Ѱ�ҷ�ֵ =================================================
comp_num = 7; %��ֵ���������߼�������Ƚ�
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

%======= ÿ����ֵ�����ǿ�� ======================================
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
text_MVDR = ['MVDR�Ƕ�: ',num2str(sort(direction))];
% visualize(direction, measure,'MVDR'); hold on;
end