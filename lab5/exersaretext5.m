load('lab5_1.mat');
x_id = id.InputData;
y_id = id.OutputData;
x_val = val.InputData;
y_val = val.OutputData;

M = 100;
ru=zeros(1,length(x_id));
ryu = zeros(1,length(x_id));

for tau=1:length(x_id)
    for k=1:length(x_id) - (tau -1)
    ru(tau) = ru(tau) + x_id(k+tau-1)*x_id(k);
    ryu(tau) = ryu(tau) + y_id(k+tau-1) * x_id(k);
    end
    ru(tau) = ru(tau) / length(x_id);
    ryu(tau) = ryu(tau) / length(x_id);
end

phi = zeros(length(x_id),M);
for i=1:length(x_id)
    for j=1:M
    phi(i,j) = ru(abs(i-j) + 1);
    end
end

h=phi\ryu';
y_aprox_id = conv(h,x_id);
y_aprox_val = conv(h,x_val);
y_aprox_id = y_aprox_id(1:length(y_id));
y_aprox_val = y_aprox_val(1:length(y_val));

e_id = y_id - y_aprox_id;
MSE_id = 1/length(e_id) * sum(e_id.^2);
e_val = y_val - y_aprox_val;
MSE_val = 1/length(e_val) * sum(e_val.^2);

figure;
plot(tid,y_id);
hold on;
plot(tid,y_aprox_id);
title(['MSE ',num2str(MSE_id)]);

figure;
plot(tval,y_val);
hold on;
plot(tval,y_aprox_val);
title(['MSE ',num2str(MSE_val)]);
