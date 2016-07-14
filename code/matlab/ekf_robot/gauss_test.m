
a = -100; b = 100;
x = a + (b-a) * rand(1, 500);
m = (a + b)/2;
s = 30; 

%Then, we plot this information using our bell curve: 
figure;
f = gauss_distribution(x, m, s);
plot(x,f,'.')
grid on
title('Bell Curve')
xlabel('Randomly produced numbers')
ylabel('Gauss Distribution') 