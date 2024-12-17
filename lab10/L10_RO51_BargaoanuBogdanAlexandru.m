obj = DCMRun.start();
try
na = 2;
nb = 2;
N = 200;
u_id = idinput(N, 'prbs', [], [-0.8 0.8])';
u_val = [zeros(1,30),0.3*ones(1,70),zeros(1,50)];

theta = zeros(na+nb,1);
Pinvers = 1000*eye(na+nb);
for i=1:N
    y_id(i) = obj.step(u_id(i));
    phi = zeros(na+nb,1);
    for j=1:na
        if(i>j)
            phi(j) = -y_id(i-j);
            phi(j+na) = u_id(i-j);
        end
    end
    e = y_id(i) - phi'*theta;
    Pinvers = Pinvers - (Pinvers*phi*phi'*Pinvers)/(1+phi'*Pinvers*phi);
    W = Pinvers*phi;
    theta = theta + W*e;
    if(i <= 10)
        theta5procente = theta;
    end
    obj.wait();
end
obj.stop();
theta = theta';
theta5procente = theta5procente';
A=[1 theta(1:na)];
B=[0 theta(na+1:na+nb)];
A5procente=[1 theta5procente(1:na)];
B5procente=[0 theta5procente(na+1:na+nb)];

y_val = DCMRun.run(u_val);

model = idpoly(A,B,[],[],[],0,10e-3); 
model5procente = idpoly(A5procente,B5procente,[],[],[],0,10e-3);
yaproxfinal = lsim(model,u_val);
yaprox5procente = lsim(model5procente,u_val);
figure;
plot(y_val);
hold on;
plot(yaproxfinal);

figure;
plot(y_val);
hold on;
plot(yaprox5procente);
catch e
obj.stop();
rethrow(e);
end

