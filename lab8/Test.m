u = 0.5*ones(1000, 1);
[vel, alpha, t] = run(u, '3');
plot(t, vel);