uimp = [1; 1; 0.1*ones(98,1)]; % Impulse Signal
u = [zeros(20,1); uimp; uimp; uimp; zeros(50, 1); 0.2*ones(60, 1)]';
N = length(u);

serialObj = DCMRun.start("Ts", 5e-3);

y = zeros(1, N);

for k = 1:length(u)
        serialObj.wait;
    y(k)= serialObj.step(u(k));
end

serialObj.stop();

plot(y);