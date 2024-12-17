clear all
load('lab2_01');
n = 30;
max_MSE = inf;
gradfinal = 1;
x_id = id.X;
x_val = val.X;
y_id = id.Y;
y_val = val.Y;

%date identificare
figure;
plot(x_id,y_id);
title('Date Identificare');
phi = zeros(length(x_id),n);
phival = zeros(length(x_val),n);
MSE = zeros(1,n);
for z=1:n

for i=1:length(x_id)
  for j=1:z
   phi(i,j) = x_id(i)^(j-1);
  end
end

for i=1:length(x_val)
    for j=1:z
    phival(i,j) = x_val(i)^(j-1);
    end
end

teta = phi\y_id';
yaprox = phival * teta;
e = y_val - yaprox';
MSE(z) = 1/length(e) * sum(e.^2);
if MSE(z) < max_MSE
max_MSE = MSE(z);
yfinal = yaprox;
end

end
figure;
plot(x_val,yfinal);
title('Aproximare');
hold on
plot(x_val,y_val);
legend('Aproximare', 'Validare');
hold off
figure;
plot(1:n,MSE);
title('Eroare');
