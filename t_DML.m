function [ direction, measure,text_DML, Rs ] = t_DML( R,f,r,c, sig_num, nofilter )
%
%'DML calculation begins'
%R = temp1*R*temp1;

array_num = length(R);
% if length(direction)==1
%     meas_max = -999;
% else
%     meas_max = max(measure);
% end
meas_max = -999;
k_rec = (1:array_num)';
%====================== below: initializing ===============================
A_past = [];
% for i=1:length(direction)
%     angle_temp = direction(i)*pi/180;
%     A_past = [A_past, exp(sqrt(-1)*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/array_num-angle_temp*pi/180) ))];
% end
iter_num = 0;
direction = [];
measure = [];
while iter_num<sig_num
    iter_num = iter_num+1;
    max_temp = -999;
    for angle1 = 1:360
    if length(direction==0)||prod(angle1~=direction)
        A_temp1 = exp(sqrt(-1)*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/array_num-angle1*pi/180) ));
        A = [A_past,A_temp1];
        P = A*pinv(A'*A)*A';
        res = sum(diag(P*R));
        if abs(res)>max_temp
           max_temp=abs(res);
           ang_rec_1 = angle1;
           A_temp1_save = A_temp1;
        end
    end
    end
    a = A_temp1_save;
    Q = pinv(a'*a)*a';
    S = Q*R*Q';
    meas_temp = real(S);
%     if meas_temp>0.2*meas_max
        A_past = [A_past,A_temp1_save];
        direction = [direction, ang_rec_1];
        measure = [measure, meas_temp];
        if meas_temp>meas_max
            meas_max = meas_temp;
        end
%     else
%         break;
%     end
    
end
% sig_num = length(direction);
%========= below:iteration ===========================================
if nofilter==0

for iteration = 1:2
    for sig_iter = 1:sig_num
        max_temp=-999;
        b = 1:sig_num;
        b = b(b~=sig_iter);
        B= A_past(:,b);
        Coeff = eye(array_num) - B*pinv(B'*B)*B'; 
        for angle1 = 1:360
        if prod(angle1~=direction(b))
            A_temp = exp(sqrt(-1)*(2*pi*f*r/c*cos(2*pi*(k_rec-1)/array_num-angle1*pi/180) ));
            a = Coeff*A_temp;
            res = sum(diag(a*pinv(a'*a)*a'*R));
           % P
            if abs(res)>max_temp
               max_temp=abs(res);
               ang_rec = angle1;
               A_temp_save = A_temp;
            end
        end
        end
        direction(sig_iter) = ang_rec;
        A_past(:,sig_iter) = A_temp_save;
    end
    %ang_result
%    ['The result is ',num2str(ang_result(1)), '°and ',num2str(ang_result(2)),'°']
end

end
% for i=1:sig_num
%     a = A_past;
%     %a = A_past(:,i);
%     Q = pinv(a'*a)*a';
%     S = Q*R*Q';
%     measure(i) = (real(S(i,i)));
%     %measure(i) = real(S);
% end
a0 = 0;
for i=1:sig_num
   if i==1
        a = A_past(:,i);
        Q = pinv(a'*a)*a';
        S = Q*R*Q';
        measure(i) = real(S);
        a0 = a;
     else
        a = [A_past(:,1),A_past(:,i)];
        Q = pinv(a'*a)*a';
        S = Q*R*Q';
        measure(i) = measure(1)*real(S(2,2))/real(S(1,1));
    end
    
end
text(0.9,-1.1,['DML'],'color',[0.7 0 0]);
text_DML = ['DML角度: ',num2str(sort(direction))];
%================ 下面的程序：生成波束合成矩阵 ==============================
temp = a*pinv(a'*a)*a';
Rs = temp * R * temp;
%==========================================================================
end

