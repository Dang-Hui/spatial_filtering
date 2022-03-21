function [ ] = visualize1( direction, measure, mode, axes1 )
% ¼«×ø±ê»­Í¼

  if length(mode)==4
      r = 1.05;
      color = [0 0.5 0];
  elseif length(mode)==5
      r = 1.1;
      color = [0 0 0.7];
  elseif length(mode)==3
      r = 1.15;
      color = [0.7 0 0];
  elseif length(mode)==2
      r = 1.2;
      color = [1 0.5 0];      
  end
  for i=1:length(direction)

      dire_temp = direction(i)*pi/180;
      dire_temp = pi/2 - dire_temp;
      meas_temp = measure(i);

      line([0,meas_temp*cos(dire_temp)],[0,meas_temp*sin(dire_temp)],'LineWidth',2,'color',color);
      hold on;
      plot(meas_temp*cos(dire_temp)+0.01*rand,meas_temp*sin(dire_temp)+0.01*rand,'x','color',color);
      hold on;
      plot(r*cos(dire_temp),r*sin(dire_temp),'o','color',color);
      hold on;
  end


end

