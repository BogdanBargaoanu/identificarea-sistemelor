x = 0:0.25:4;
y = 2*exp(-power(x,2)) + 2 * sin(0.67*x + 0.1);
y2 = 2.2159 + 1.2430*x - 2.6002 * power(x,2) + 1.7223 * power(x,3) - 0.4683 * power(x,4) + 0.0437 * power(x,5);
e = y - y2;
epatratica = round(sum(power(e,2)) / length(x),4);
figure
plot(x,y)
hold on
plot(x,y2)
figure
plot(x,e)
title  (sprintf('Eroare patratica: %f', epatratica));