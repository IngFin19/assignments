function B = queryDiscount(dates,discounts,t)
% main function to performe queries on the disc curve.
% 
% if t is in between the start date and end date the 
% function performes interpolation of the 
% discount factor on the curve defined on dates and with correpsonding 
% discounts at a query point t
% calling interpolateDiscount

% if the query point t is greater that the last given date, it performs an 
% extrapolation according to the function
% extrapolateDiscount. See the header to check for limitations in the
% extrapolation procedure,

% dates: vector of dates of the already build curve
% discounts: discounts of the already build curve

mode=1; % log-linear interp

t0=dates(1);
if(t>=dates(1) && t<=dates(end))
    idx1=find(dates < t, 1, 'last'); %check
    idx2=find(dates >= t, 1, 'first'); %check
    t1=dates(idx1);
    t2=dates(idx2);
    B1=discounts(idx1);
    B2=discounts(idx2);
    B=interpolateDiscount(B1,B2,t0,t1,t2,t,mode);
elseif(t>dates(end))
    B1=discounts(end-1);
    B2=discounts(end);
    t1=dates(end-1);
    t2=dates(end);
    B=extrapolateDiscount(B1,B2,t0,t1,t2,t);
else
    B=nan;
end

