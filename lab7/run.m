function [speed, alpha, time] = run(u, port, Ts)

if ~exist('Ts', 'var')
    Ts = 5e-3;
end

N = length(u);
time = zeros(1, N);
speed = zeros(1, N);
alpha = zeros(1,N);

utstart(port);                  
utwrite([1 0 1]);

for k = 2:N
    t = tic;
    utwrite(u(k)/2 + 0.5);
    [alpha(k), speed(k)] = utread;
    pauses(Ts, t);
    time(k) = time(k-1) + toc(t);
end

speed(1:10) = 0;
alpha(1:10) = 0;

utwrite([0 185/255 0]);

for i = 1:3
    utread;
end

utstop;
end

