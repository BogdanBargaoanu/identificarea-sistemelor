function data_w = utwrite(u)
% Input u = PWM ratio in [-1, 1], negative = push clockwise, positive = push counterclockwise

global utip

u = max(min(u,1),-1);
u = floor(255*u);
% transform to raw input in 0, ..., 255 enforcing the bounds
% zeros is at torque0 = 128

data_w = uint8(u);
rs232('write', utip.com, data_w);

