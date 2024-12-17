load('datemotor.mat');
%50 prbs 100, 200*0.4
u = [zeros(1,50),idinput(200,'prbs',[],[-0.7 0.7])',zeros(1,100),0.4*ones(1,200)];
u_id = u(50:250);
y_id = vel(50:250);
u_val = u(350:end);
y_val = vel(350:end);

na = 20;
nb = 20;
id = iddata(y_id',u_id',t(2)-t(1));
model = arx(id,[na nb 1]);
yhat = lsim(model,u_id);

phi = zeros(length(yhat),na+nb);

for i=1:length(yhat)
    for j=1:na
        if(i>j)
            phi(i,j) = -yhat(i-j);
            phi(i,j+na) = u_id(i-j);
        end
    end
end
theta = phi\yhat;
A = [1 theta(1:na)'];
B = [0 theta(na+1:end)'];
ivmodel = idpoly(A,B,[],[],[],0,t(2)-t(1));
yaprox = lsim(ivmodel,u_val);
figure;
plot(y_val);
hold on;
plot(yaprox);
