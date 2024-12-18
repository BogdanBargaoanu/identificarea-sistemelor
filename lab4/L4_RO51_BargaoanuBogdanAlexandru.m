load('lab4_order1_1');
x1 = data.u;
y1 = data.y;
plot(t,y1);
hold on
plot(t,x1);
legend('y1','u1');
hold off
ymax1 = 2.25;
T1 = 3;
K1 = 1.5/0.5;
H1 = tf(K1,[T1 1]);
t1final = t(130:end);
y1final = y1(130:end);
x1final = x1(130:end);
figure;
[A B C D] = tf2ss(K1,[T1 1]);
sstari = ss(A,B,C,D);
lsim(sstari,x1final,t1final,1.5);
hold on;
plot(t1final,y1final,'Color','red');
legend('y1aprox','y1');
hold off;
y1aprox = lsim(H1,x1final,t1final);
e1 = y1final - y1aprox;
MSE1 = 1/length(e1)*sum(e1.^2);


load('lab4_order2_1');
x2 = data.u;
y2 = data.y;
figure;
plot(t,y2);
hold on;
plot(t,x2);
legend('y2','u2');
hold off;
K2 = 0.5/1;
M = 0.1;
zeta = -log(M)/sqrt(pi^2 + log(M)^2);
T2 = 3.4 - 1.85;
wn = 2*pi/(T2*sqrt(1-zeta^2));
H2 = tf(K2*wn^2,[1 2*zeta*wn wn^2]);
[A2 B2 C2 D2] = tf2ss(K2*wn^2,[1 2*zeta*wn wn^2]);
sstari2 = ss(A2,B2,C2,D2);
x2final = data.u(130:end);
y2final = data.y(130:end);
t2final = t(130:end);
figure;
lsim(sstari2,x2final,t2final,[0.5 0]);
hold on;
plot(t2final,y2final,'Color','red');
legend('y2aprox','y2');
hold off;
y2aprox = lsim(sstari2,x2final,t2final,[0.5 0]);
e = y2final - y2aprox;
MSE2 = 1/length(e) * sum(e.^2);
