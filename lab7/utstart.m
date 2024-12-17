function utstart(comNr)

% default port number
if nargin < 1, comNr = '4'; end

global utip

disp('Starting session...');

% create
utip = struct;
utip.k_ang = 360/1024;                  % conversion rate from raw data to radian
utip.deadzone = 20;                  % if PWM smaller than this, then zero


% set COM parameters
utip.com = rs232('GetParams','default');
utip.com.Port = ['COM' comNr];
utip.com.BaudRate = 1000000;
utip.com.ReadTimeout = 0.005;
utip.com.WriteTimeout = 1;
% the above does not seem necessary, one can also open directly
rs232('open', utip.com);
pause(5);
disp("started");