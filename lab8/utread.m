function [alpha, speed] = utread
% Returns alpha: 0 = pointing down, negative = turned clockwise from 0, positive = counterclockwise
global utip
%send read command
[data_r, ~] = rs232('read', utip.com, 8);
if (isempty(data_r))
    data_r = zeros(8, 1);
end
%processing positive and negative signals
sig=1;
if data_r(4)>=128
   sig = -1;
   data_r(1:4)=255-data_r(1:4);
   data_r(1)=data_r(1)+1;   
end

sigv1 = 1;
if data_r(8)>=128
   sigv1 = -1;
   data_r(5:8)=255-data_r(5:8);
   data_r(5)=data_r(5)+1;   
end

dat = sig*cast(typecast(uint8(data_r(1:4)), 'int32'), 'double');
speed = sigv1*cast(typecast(uint8(data_r(5:8)), 'int32'), 'double')*60/1024/0.0025/3.2902;

alpha = dat*utip.k_ang;

end
