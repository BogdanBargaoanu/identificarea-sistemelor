load('lab3_order1_1');
u = data.u;
y = data.y;

figure;
subplot(211);
plot(t,u);
hold on
plot(t,y);
hold off
legend('u1','y1')

K1 = 1.5/0.5;
T1 = 4.2;
H1 = tf(K1,[T1 1]);

subplot(212);
lsim(H1,u,t);
hold on
plot(t,y,'Color','red');
hold off
legend('H1(s)','y1')

figure;
treal = t(201:end);
ureal = u(201:end);
yreal = y(201:end);
lsim(H1,ureal,treal);
hold on
plot(treal,yreal,'Color','red');
yaprox = lsim(H1,ureal,treal);
e = y(201:end) - yaprox;
MSE = 1/length(e) * sum(e.^2);
legend('H1(s) validare','y1 validare')


load('lab3_order2_1');
u2 = data.u;
y2 = data.y;
figure;
subplot(211);
plot(t,u2);
hold on
plot(t,y2);
hold off
legend('u2','y2')

K2 = 1;
M = 0.17;
T2 = 3.4;
zeta = log(1/M) / sqrt(pi^2 + log(M)^2);
Wn = 2*pi /(T2*sqrt(1-zeta^2));
H2 = tf(K2 * Wn^2,[1 2*zeta*Wn Wn^2]);

subplot(212)
lsim(H2,u2,t);
hold on
plot(t,y2,'Color','red');
hold off
legend('H2(s)','y2');

figure;
treal2 = t(201:end);
ureal2 = u2(201:end);
yreal2 = y2(201:end);
lsim(H2,ureal2,treal2);
hold on
plot(treal2,yreal2,'Color','red');
hold off
legend('H2(s) validare','y2 validare');

yaprox2 = lsim(H2,ureal2,treal2);
e2 = y2(201:end) - yaprox2;
MSE2 = 1/length(e2) * sum(e2.^2);


