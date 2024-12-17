u = 0.5*ones(1000, 1);
[vel, alpha, t] = run(u, '4');
plot(t, vel);