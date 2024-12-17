v=30:-1:1;
for i=1:30
if(mod(i,2) ~= 0)
  v(i) = sin(v(i));
end
end
v
for i=1:(30-1)
    for j=1:(30-i-1)
        if(mod(j,2) == 0)
            if(v(j) > v(j+2))
               aux = v(j);
               v(j) = v(j+2);
               v(j+2) = aux;
            end
        end
    end
end
v