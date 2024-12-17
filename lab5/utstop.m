function utstop
global utip
%close serial
result = rs232('close',utip.com);
%clear variable
clear utip;
disp('Session terminated.');