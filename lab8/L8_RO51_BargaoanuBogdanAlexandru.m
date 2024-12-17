load('datemotorlab8.mat');
u = [zeros(30,1) ; idinput(200, 'prbs', [], [-0.7 0.7]) ; zeros(30,1) ; 0.4*ones(70,1)];

te=t(2)-t(1);
uid = u(30:230);
yid = y(30:230);
uval = u(260:end);
yval = y(260:end);
val = iddata(yval',uval,te);

bcurrent=2;
fcurrent=1;

alfa=0.6;
lmax=1000;
delta=1/10000;


N=length(uid);
teta = zeros(2,N);
teta(1,1) = bcurrent;
teta(2,1) = fcurrent;

e = zeros(1,N);
dedb = zeros(1,N);
dedf = zeros(1,N);
dV = [0;0];
H = [0,0;0,0];
nk = 4;

for l=1:lmax
    bcurrent = teta(1,l);
    fcurrent = teta(2,l);
    e(1) = yid(1);  
    dedb(1) = 0;
    dedf(1) = 0;
    sumadedb = 0;
    sumadedf = 0;
    
    for k=nk+1:N
        e(k) = -fcurrent*e(k-1) + yid(k) + fcurrent*yid(k-1) - bcurrent*uid(k-nk);

        dedb(k) = -fcurrent*dedb(k-1) - uid(k-nk);
        dedf(k) = -e(k-1) - fcurrent*dedf(k-1) + yid(k-1);
        
        sumadedb = sumadedb + e(k)*dedb(k);
        sumadedf = sumadedf + e(k)*dedf(k);
        
        H = H + [dedb(k);dedf(k)]*[dedb(k),dedf(k)];
    end
    
    dV = 2/(N-1) * [sumadedb;sumadedf];
    H = 2/(N-1) * H;
    teta(:,l+1) = teta(:,l) - alfa*(inv(H))*dV;
    
    if (mean(abs(teta(:,l+1) - teta(:,l))) <= delta)  
        tetafinal = teta(:,l);
        break;
    end

    tetafinal = teta(:,l+1);
end
A=1;
B=[0 tetafinal(1)];
C=1;
D=1;
F=[1 tetafinal(2)];
figure,
model=idpoly(A,B,C,D,F,0,te);
yhat = lsim(model,uval);
plot(yhat);
hold on;
plot(yval);