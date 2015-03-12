function y=f(x,n)    
  y=-20*exp(-0.2*sqrt(sum(x.^2)/n))-exp(sum(cos(2*pi*x))/n)+20+2.7183;