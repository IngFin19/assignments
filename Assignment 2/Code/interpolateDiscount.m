function B = interpolateDiscount(B1,B2,t0,t1,t2,t,mode)
% function that interpolates discount factors according to the linear
% discount inteprolation or the log zero rate interpolation
% should only be called by queryDiscount.

% B1: first value of the discount
% B2: first value of the discount
% t0: current date
% t1: date for first value
% t2: date for second value
% t: time of interest
% mode: 1-Log-Linear Discount
%       2-Linear Zero Rate

% year frac convention used for log linear interpolation: act/365
act365 = 3;

% discount are in act/360
act360 = 2;

if (nargin<6)
    error("Not enought inputs")
    return
elseif nargin == 6
    mode = 1;
end

if (t==t1)
    B=B1;
elseif (t==t2)
    B=B2;
elseif (t<t1)
    error("Date %s is smaller that %s",datestr(t),datestr(t1))
elseif ( t>t2)
    error("Date %s is greater than %s",datestr(t),datestr(t2))
else
    switch (mode)
        case 1  % Log-Linear Discount
            y1=-log(B1)/yearfrac(t0, t1, act365);
            y2=-log(B2)/yearfrac(t0, t2, act365);
            y=y1+(y2-y1)/yearfrac(t1, t2, act365)*yearfrac(t1, t, act365);
            B=exp(-yearfrac(t0, t, act365)*y);
        case 2  % Linear Zero Rate
            B=B1+(B2-B1)/yearfrac(t1, t2, act360)*...
                yearfrac(t1, t, act360);
        otherwise
    end
end 

end

