function B=extrapolateDiscount(B1,B2,t0,t1,t2,t)
% function that performes linear extrapolation of the 
% discount factor on the curve defined on t1<t2
% with corresponding values B1,B2
% it performes extrapolation only up to n (hardcoded) days

% t1: date of first discount factor
% t2: date of second discount factor
% B1: discount factor at date t1
% B2: discount factor at date t2
% t: query point of the extrapolation

n = 2;
act365 = 3;

if(t-t2<=n)
    %B=B2+(B2-B1)/yearfrac(t1,t2)*yearfrac(t2,t);
    y1=-log(B1)/yearfrac(t0, t1, act365);
    y2=-log(B2)/yearfrac(t0, t2, act365);
    y=y1+(y2-y1)/yearfrac(t1, t2, act365)*yearfrac(t1, t, act365);
    B=exp(-yearfrac(t0, t, act365)*y);
else
    B=nan;
    error("You can only extrapolate for %d days",n)
end

