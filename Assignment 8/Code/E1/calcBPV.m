function [BPV] = calcBPV(paymentdates,dates,discounts)
% computes the BPV on the corrisponding dates of paymentdate given the
% curve dates, discounts.
%
% paymentdate: vector of dates correspoding to the BPV calc
% dates: dates on which the curve is defined
% discounts: discounts of the curve.

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

