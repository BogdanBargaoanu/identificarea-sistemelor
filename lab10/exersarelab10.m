obj = DCMRun.start();
%200 prbs -08
%30 70*0.3 50
u_id = idinput(200,'prbs',[],[-0.8 0.8]);
u_val = [zeros(1,30),0.3*ones(1,70),zeros(1,50)];
N = length(u_id);
na = 2;
nb = 2;
invP = 1000*eye(na+nb);
theta = zeros(na+nb,1);
for i=1:N
    y_id(i) = obj.step(u_id(i));
    phi = zeros(na+nb,1);
    for j=1:na
        if(i>j)
        phi(j) = -y_id(i-j);
        phi(j+na) = u_id(i-j);
        end
    end
    e = y(i) - phi'*theta;
    invP = invP - (invP*phi*phi'*invP)/(1+phi'*invP*phi);
    W = invP*phi;
    theta = theta + W*e;
    obj.wait();
end
obj.stop();
y_val = DCMRun.run(u_val);

A = [1 theta(1:na)'];
B = [0 theta(na+1:end)'];
model = idpoly(A,B,[],[],[],0,10e-3);
yaprox = lsim(model,u_val);



