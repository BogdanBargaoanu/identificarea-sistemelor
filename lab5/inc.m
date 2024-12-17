u = [zeros(10,1);1.4*rand(800,1)-0.7;zeros(50,1);0.2*ones(100,1)];
%[vel, alpha, t] = run(u, '8');

load('corelatie date.mat');
figure;
plot(t,vel)
vel = detrend(vel);
vel_aleator = vel(10:800);
vel_aleator = detrend(vel_aleator);
t_aleator = t(10:800);
u_aleator = u(10:800);
plot(t_aleator,vel_aleator);
%N = length(u_aleator);
N = 20;
ru = zeros(1,N);
for tau=1:N
    for k=1:N-tau
       ru(tau) = ru(tau) + u_aleator(k+tau) * u_aleator(k);
    end
    %ru(tau) = ru(tau) / (N-tau+1);
    ru(tau) = ru(tau) / N;
end

ryu = zeros(1,N);
for tau=1:N
    for k=1:N-tau
       ryu(tau) = ryu(tau) + vel_aleator(k+tau) * u_aleator(k);
    end
    %ryu(tau) = ryu(tau) / (N-tau+1);
    ryu(tau) = ryu(tau) / N;
end

Matr = zeros(N,N);
for i=1:N
    for j=1:N
    Matr(i,j) = ru(abs(j-i) + 1);
    end
end

h = Matr\ryu';
y_aprox = zeros(1,length(vel_aleator));
for k=100:length(vel_aleator)
    for j=1:M
    y_aprox(k) = y_aprox(k) + h(j)*u_aleator(k-j);
    end
end

e = vel_aleator - y_aprox;
MSE = 1/length(e) * sum(e.^2);
figure;
plot(y_aprox)
hold on
plot(vel_aleator)