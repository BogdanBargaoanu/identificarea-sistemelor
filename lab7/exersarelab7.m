 load('datemotor.mat');
 %30 spab 30 spab 30 70*0.4
 N = 200;
 m1 = 3;
 m2 = 10;
 na = 20;
 nb = 20;
 a = -0.7;
 b = 0.7;
 u = [zeros(1,30),spab(N,m1,a,b),zeros(1,30),spab(N,m2,a,b),zeros(1,30),0.4*ones(1,70)];
 plot(u);
u_id1 = u(30:230);
y_id1 = vel(30:230);
u_id2 = u(260:460);
y_id2 = vel(260:460);
u_val = u(490:end);
y_val = vel(490:end);

id1 = iddata(y_id1',u_id1',t(2)-t(1));
id2 = iddata(y_id2',u_id2',t(2)-t(1));
val = iddata(y_val',u_val',t(2)-t(1));

model1 = arx(id1,[na nb 1]);
model2 = arx(id2,[na nb 1]);
model3 = arx(val,[na nb 1]);

yval1 = lsim(model1,u_val);
yval2 = lsim(model2,u_val);

figure;
plot(y_val);
hold on;
plot(yval1);
plot(yval2);


function [u_spab] = spab(N,m,a,b)
aa = zeros(1,m);
switch(m)
    case 3
        aa(1) = 1;
        aa(3) = 1;
    case 4
        aa(1) = 1;
        aa(4) = 1;
    case 5
        aa(2) = 1;
        aa(5) = 1;
    case 6
        aa(1) = 1;
        aa(6) = 1;
    case 7
        aa(1) = 1;
        aa(7) = 1;
    case 8
        aa(1) = 1;
        aa(2) = 1;
        aa(7) = 1;
        aa(8) = 1;
    case 9
        aa(4) = 1;
        aa(9) = 1;
    case 10
        aa(3) = 1;
        aa(10) = 1;
end
u = zeros(1,N);
xcurrent = ones(1,m);
xnou = zeros(1,m);

for i=1:N
xnou(1) = mod(sum(aa.*xcurrent),2);
xnou(2:end) = xcurrent(1:end-1);
xcurrent = xnou;
u(i) = xnou(1);
end
u_spab = a + (b-a)*u;
end