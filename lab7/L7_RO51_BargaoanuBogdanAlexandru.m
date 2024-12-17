load('datemotor.mat');
N = 200;
m = 3;
aa = zeros(1,m);
na = 20;
nb = 20;
a = -0.7;
b = 0.7;
m2 = 10;

u = [zeros(1,30),spab(N,m,a,b),zeros(1,30),spab(N,m2,a,b),zeros(1,30),0.4*ones(1,70)];
u_id1 = u(30:230);
y_id1 = vel(30:230);
u_id2 = u(260:460);
y_id2 = vel(260:460);
u_val = u(490:end);
y_val = vel(490:end);

id1 = iddata(y_id1',u_id1',t(2) - t(1));
id2 = iddata(y_id2',u_id2',t(2) - t(1));
val = iddata(y_val',u_val',t(2) - t(1));
model1 = arx(id1,[na,nb,1]);
model2 = arx(id2,[na,nb,1]);
model3 = arx(val,[na,nb,1]);

yid1 = lsim(model1,u_id1);
yid2 = lsim(model2,u_id2);
yval = lsim(model3,u_val);
yval1 = lsim(model1,u_val);
yval2 = lsim(model2,u_val);

figure;
plot(y_val);
hold on;
plot(yval1);
plot(yval2);
e1 = y_val - yval1';
e2 = y_val - yval2';
MSE1 = 1/length(e1) * sum(e1.^2);
MSE2 = 1/length(e2) * sum(e2.^2);

function [ufinal] = spab(N,m,a,b)
ufinal = zeros(1,N);
aa = zeros(1,m);

if m==3
    aa(1)=1;
    aa(3)=1;
end

if m==4
    aa(1)=1;
    aa(4)=1;
end

if m==5
    aa(2)=1;
    aa(5)=1;
end

if m==6
    aa(1)=1;
    aa(6)=1;
end

if m==7
    aa(1)=1;
    aa(7)=1;
end

if m==8
    aa(1)=1;
    aa(2)=1;
    aa(7)=1;
    aa(8)=1;
end

if m==9
    aa(4)=1;
    aa(9)=1;
end

if m==10
    aa(3)=1;
    aa(10)=1;
end
xcurrent = ones(1,m);
xnou = zeros(1,m);
u = zeros(1,N);

for i=1:N
    xnou(1) = mod(sum(aa.*xcurrent),2);
    xnou(2:end) = xcurrent(1:end-1);
    u(i) = xnou(1);
    xcurrent = xnou;
end

ufinal = a + (b-a)*u;
end
