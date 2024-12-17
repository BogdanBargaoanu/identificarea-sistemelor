load('datemotorlab8.mat');
%30 prbs 200 30 70*0.4
u = [zeros(1,30),idinput(200,'prbs',[],[-0.7 0.7])',zeros(1,30),0.4*ones(1,70)];
u_id = u(30:230);
y_id = y(30:230);
u_val = u(260:end);
y_val = y(260:end);
N = length(y_id);
nk = 4;
na = 20;
nb = 20;
bcurrent = 2;
fcurrent = 1;
theta = zeros(2,N);
theta(1,1) = bcurrent;
theta(2,1) = fcurrent;
dedb = zeros(1,N);
dedf = zeros(1,N);
e = zeros(1,N);
dV = [0;0];
H = [0 0;0 0];

alfa = 0.6;
delta = 1/10000;
lmax = 1000;

for l=1:lmax
    dedb(1) = 0;
    dedf(1) = 0;
    e(1) = y_id(1);
    sumadedb = 0;
    sumadedf = 0;
    bcurrent = theta(1,l);
    fcurrent = theta(2,l);
    for k=nk+1:N
    e(k) = -fcurrent*e(k-1) + y_id(k) + fcurrent*y_id(k-1) - bcurrent*u_id(k-nk);
    dedb(k) = -fcurrent*dedb(k-1) - u_id(k-nk);
    dedf(k) = -e(k-1) -fcurrent*dedf(k-1) + y_id(k-1);

    sumadedb = sumadedb + e(k)*dedb(k);
    sumadedf = sumadedf + e(k)*dedf(k);
    H = H + [dedb(k);dedf(k)]*[dedb(k),dedf(k)];
    end
    dV = 2/(N-nk) * [sumadedb;sumadedf];
    H = 2/(N-nk) * H;
    theta(:,l+1) = theta(:,l) - alfa*(inv(H))*dV;
    if(mean(abs(theta(:,l+1)-theta(:,l))) <= delta)
    thetafinal = theta(:,l);
    break;
    end
    thetafinal = theta(:,l+1);
end

A = 1;
B = [zeros(1,nk) thetafinal(1,1)];
C = 1;
D = 1;
F = [1 thetafinal(2,1)];
oemodel = idpoly(A,B,C,D,F,0,t(2)-t(1));
yaprox = lsim(oemodel,u_val);
figure;
plot(y_val);
hold on;
plot(yaprox);