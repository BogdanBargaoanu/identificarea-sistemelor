load('datemotor.mat');%50 200 * prbs0.7 100 200*0.4
u = [zeros(1,50),idinput(N,'prbs',[],[-0.7 0.7])',zeros(1,100),0.4*ones(1,200)];
na = 20;
nb = 20;
u_id = u(50:250);
y_id = vel(50:250);
u_val = u(350:end);
y_val = vel(350:end);

phi = zeros(length(y_id),na+nb);

for i=1:length(y_id)
    for j=1:na
        if(i > j)
        phi(i,j) = -y_id(i-j);
        phi(i,j+na) = u_id(i-j);
        end
    end
end

theta = phi\y_id';
yaprox = zeros(1,length(y_val));
for i=1:length(yaprox)
    for j=1:na
        if(i > j)
           yaprox(i) = yaprox(i) - theta(j)*y_val(i-j)  + theta(j+na)*u_val(i-j);   
        end
    end
end
figure;
plot(y_val);
hold on;
plot(yaprox);