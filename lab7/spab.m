function [ufinal] = spab(N,m,a,b)
ufinal = zeros(1,N);
aa = zeros(1,m);

if m==3
    aa(1)=1;
    aa(3)=1;
end

if m==4
    aa(1)=1;
    aa(4)=1;
end

if m==5
    aa(2)=1;
    aa(5)=1;
end

if m==6
    aa(1)=1;
    aa(6)=1;
end

if m==7
    aa(1)=1;
    aa(7)=1;
end

if m==8
    aa(1)=1;
    aa(2)=1;
    aa(7)=1;
    aa(8)=1;
end

if m==9
    aa(4)=1;
    aa(9)=1;
end

if m==10
    aa(3)=1;
    aa(10)=1;
end
xcurrent = ones(1,m);
xnou = zeros(1,m);
u = zeros(1,N);

for i=1:N
    xnou(1) = mod(sum(aa.*xcurrent),2);
    xnou(2:end) = xcurrent(1:end-1);
    u(i) = xnou(1);
    xcurrent = xnou;
end

ufinal = a + (b-a)*u;
end