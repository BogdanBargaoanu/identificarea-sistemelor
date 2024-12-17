load('lab4_order1_1.mat');
x = data.InputData;
y = data.OutputData;
xfinal = x(130:end);
yfinal = y(130:end);
tfinal = t(130:end);

figure;
plot(t,x);
hold on;
plot(t,y);
K = 1.5/0.5;
T = 4.5;
[A B C D] = tf2ss(K,[T 1]);
sstari = ss(A,B,C,D);

figure;
ymax = 2.25;
lsim(sstari,xfinal,tfinal,ymax);
hold on;
plot(tfinal,yfinal);
y_aprox = lsim(sstari,xfinal,tfinal,ymax);
e = yfinal - y_aprox;
MSE = 1/length(e) * sum(e.^2);
title(['MSE ',num2str(MSE)]);

%%
load('lab4_order2_1.mat');
x = data.InputData;
y = data.OutputData;
xfinal = x(130:end);
yfinal = y(130:end);
tfinal = t(130:end);

figure;
plot(t,x);
hold on;
plot(t,y);
K = 0.5;
T = 1.6;
M = 0.34;
zeta = log(1/M)/sqrt(pi^2 + log(M)^2);
wn = 2*pi/(T*(1-zeta^2));
ymax = 1.7;
[A B C D] = tf2ss(K*wn^2,[1 2*wn*zeta wn^2]);
sstari = ss(A,B,C,D);

figure;
lsim(sstari,xfinal,tfinal,[0 0.05]);
hold on;
plot(tfinal,yfinal);
y_aprox = lsim(sstari,xfinal,tfinal,[0 0.05]);
e = yfinal - y_aprox;
MSE = 1/length(e) * sum(e.^2);
title(['MSE ',num2str(MSE)]);