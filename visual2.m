function  visual2( P_show2, color)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
for i = 2:9
        x1 = P_show2(i-1)*sin((i-2)/9*2*pi);
        x2 = P_show2(i)*sin((i-1)/9*2*pi);
        y1 = P_show2(i-1)*cos((i-2)/9*2*pi);
        y2 = P_show2(i)*cos((i-1)/9*2*pi);
        line([x1,x2],[y1,y2],'linewidth',2,'color',color);
        hold on;
    end
    x1 = P_show2(1)*sin((0)/9*2*pi);
    x2 = P_show2(9)*sin((8)/9*2*pi);
    y1 = P_show2(1)*cos((0)/9*2*pi);
    y2 = P_show2(9)*cos((8)/9*2*pi);
    line([x1,x2],[y1,y2],'linewidth',2,'color',color);
    hold on;

end

