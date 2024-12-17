load('lab3_order1_1.mat');
x = data.InputData;
y = data.OutputData;
xfinal = x(201:end);
yfinal = y(201:end);
tfinal = t(201:end);

figure;
plot(t,x);
hold on;
plot(t,y);
K = 1.5/0.5;
T = 4.2;
H = tf(K,[T 1]);

figure;
lsim(H,xfinal,tfinal);
hold on;
plot(tfinal,yfinal);
y_aprox = lsim(H,xfinal,tfinal);
e = yfinal - y_aprox;
MSE = 1/length(e) * sum(e.^2);
title(['MSE',num2str(MSE)]);

%%
load('lab3_order2_1.mat');
x= data.InputData;
y= data.OutputData;
xfinal = x(201:end);
yfinal = y(201:end);
tfinal = t(201:end);

figure;
plot(t,x);
hold on;
plot(t,y);

K=1;
T = 4;
M = 0.17;
zeta = log(1/M)/sqrt(pi^2 + log(M)^2);
wn = 2*pi/(T*(1-zeta^2));
H = tf(K*wn^2,[1 2*zeta*wn wn^2]);

figure;
lsim(H,xfinal,tfinal);
hold on;
plot(tfinal,yfinal);
y_aprox = lsim(H,xfinal,tfinal);
e = yfinal - y_aprox;
MSE = 1/length(e) * sum(e.^2);
title(['MSE',num2str(MSE)]);