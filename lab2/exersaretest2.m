load('lab2_01.mat');

x_id = id.X;
y_id = id.Y;
x_val = val.X;
y_val = val.Y;
n=20;

figure;
plot(x_id,y_id);
hold on;
plot(x_val,y_val);

phi_id = zeros(length(x_id),n);
phi_val = zeros(length(x_val),n);

for i=1:length(x_id)
    for j=1:n
    phi_id(i,j) = x_id(i)^(j-1);
    end
end

for i=1:length(x_val)
    for j=1:n
    phi_val(i,j) = x_val(i)^(j-1);
    end
end

theta = phi_id\y_id';
y_aprox = phi_val * theta;
e = y_val - y_aprox';
MSE = 1/length(e) * sum(e.^2);

figure;
plot(y_aprox);
hold on;
plot(y_val);
