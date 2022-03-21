function [ ] = plot_background()
%This function plots a unit circle
step = 0.1;
for pp = 0:step:2*pi
    for r=0.2:0.2:1
        line([r*cos(pp),r*cos(pp+step)],[r*sin(pp),r*sin(pp+step)],'color',[0.7 0.7 0.7]);
        hold on;
    end
    r = 1.05;
    line([r*cos(pp),r*cos(pp+step)],[r*sin(pp),r*sin(pp+step)],'color',[0 0.5 0]);
    hold on;
    r = 1.1;
    line([r*cos(pp),r*cos(pp+step)],[r*sin(pp),r*sin(pp+step)],'color',[0 0 0.7]);
    hold on;
    r = 1.15;
    line([r*cos(pp),r*cos(pp+step)],[r*sin(pp),r*sin(pp+step)],'color',[0.7 0 0]);
    hold on;
    r = 1.2;
    line([r*cos(pp),r*cos(pp+step)],[r*sin(pp),r*sin(pp+step)],'color',[1 0.5 0]);
    hold on;
end
for angle = 0:10*pi/180:2*pi
    line([0,r*cos(angle)],[0,r*sin(angle)],'color',[0.7 0.7 0.7])
end

end

