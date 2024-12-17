load('datemotor.mat');
N = 200;
u = [zeros(1,50) ,idinput(N, 'prbs', [], [-0.7 0.7])' , zeros(1,100) , 0.4*ones(1,200)];
u_id = u(50:250);
u_val = u(350:end);
y_id = vel(50:250);
y_val = vel(350:end);

na = 20;
nb = 20;

id = iddata(y_id',u_id',t(2) - t(1));
model = arx(id,[na,nb,1]);
yidhat = lsim(model,u_id);
phi = zeros(length(u_id),na+nb);

for i=1:length(y_id)
    for j=1:na
    if(i > j)
    phi(i,j) = -yidhat(i-j);
    phi(i,j+na) = u_id(i-j);
    end
    end
end

teta = phi\yidhat;

A = [1;teta(1:na)];
B = [0;teta(na+1:na*2)];

ivmodel = idpoly(A',B',1,1,1,0,t(2)-t(1));
yhat2 = lsim(ivmodel,u_val);

plot(yhat2);
hold on;
plot(y_val);