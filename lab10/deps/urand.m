function u = urand(n)    
    u = randi([-255 255], floor((n-1)/100), 1)/255;
    u = repelem(u, 100);
    u = [zeros(n - length(u), 1); u];
end

