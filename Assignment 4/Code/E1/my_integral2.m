function Integral=my_integral2(integrand,x_min,x_max,y_min,y_max)
%computes the integral of a handle function of two variables in specified
%domain using quadgk and integral
%
%INPUT
%  _ integrand = integrand handle function
%  _ x_min = lower bound in the x domain
%  _ x_max = upper bound in the x domain
%  _ y_min = lower bound in the y domain
%  _ y_max = upper bound in the y domain
%
%OUTPUT
%  _ Integral = result of the double integral.

    Integral_x = @(y) integral(@(x) integrand(x,y),x_min,x_max,'ArrayValued',true);
    Integral = quadgk(Integral_x,y_min,y_max);
end

