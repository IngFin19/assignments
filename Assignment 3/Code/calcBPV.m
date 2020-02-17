function [BPV] = calcBPV(paymentdates,dates,discounts)
% computes the BPV on the corrisponding dates of paymentdate given the
% curve dates, discounts.
%
%INPUT
%  _ paymentdate = vector of dates correspoding to the BPV calc
%  _ dates =  dates on which the curve is defined
%  _ discounts =  discounts of the curve
% 
%OUTPUT
%  _ BPV = basis point value 
% 
%FUNCTION
%  _queryDiscount = main function to performe queries on the disc curve.
%                  if t is in between the start date and end date the 
%                  function performes interpolation of the discount factor 
%                  on the curve defined on dates and with correpsonding 
%                  discounts at a query point t calling interpolateDiscount
%                  if the query point t is greater that the last given date, 
%                  it performs an extrapolation according to the function
%                  extrapolateDiscount. 

thirty360 = 6;
setDate = dates(1);

dt = yearfrac([setDate;paymentdates(1:end-1)],...
    paymentdates,thirty360);
B = zeros(size(paymentdates));

for i=1:length(paymentdates)
    B(i) = queryDiscount(dates,discounts,paymentdates(i));
end

BPV = dt'*B;   

end

