load('lab5_1.mat');
figure;
plot(id);
figure;
plot(val);
u1_id = detrend(id.InputData);
y1_id = detrend(id.OutputData);
%detrend la val?
u1_val = val.InputData;
y1_val = val.OutputData;

figure;
plot(tid,u1_id);
hold on
plot(tid,y1_id);
legend('u1 id','y1 id');

figure;
plot(tval,u1_val);
hold on
plot(tval,y1_val);
legend('u1 val','y1 val');

N = length(u1_id);
ru = zeros(1,N);
for tau=1:N
    for k=1:N-(tau-1)
       ru(tau) = ru(tau) + u1_id(k+tau-1) * u1_id(k);
    end
    %ru(tau) = ru(tau) / (N-tau+1);
    ru(tau) = ru(tau) / N;
end

ryu = zeros(1,N);
for tau=1:N
    for k=1:N-(tau-1)
       ryu(tau) = ryu(tau) + y1_id(k+tau-1) * u1_id(k);
    end
    %ryu(tau) = ryu(tau) / (N-tau+1);
    ryu(tau) = ryu(tau) / N;
end

M = 200;
phi = zeros(length(u1_id),M);
for i=1:length(u1_id)
    for j=1:M
        phi(i,j)=ru(abs(i-j)+1);
    end
end

h = phi\ryu';
y_aprox_val = conv(h,u1_val);
y_aprox_val = y_aprox_val(1:length(y1_val));
e_val = y1_val - y_aprox_val;
MSE_val = 1/length(e_val) * sum(e_val.^2);

figure;
plot(y1_val);
hold on
plot(y_aprox_val,'Color','red');
legend('y1 val','y aprox val');
title(['MSE val ', num2str(MSE_val)]);

y_aprox_id = conv(h,u1_id);
y_aprox_id = y_aprox_id(1:length(y1_id));
e_id = y1_id - y_aprox_id;
MSE_id = 1/length(e_id) * sum(e_id.^2);

figure;
plot(y1_id);
hold on
plot(y_aprox_id,'Color','red');
legend('y1 id','y aprox id')
title(['MSE id ', num2str(MSE_id)]);