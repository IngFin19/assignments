function [BPV] = calcBPV_fwd(ta, paymentdates,dates,discounts)
% computes the BPV on the corrisponding dates of paymentdate given the
% curve dates, discounts.
%
% paymentdate: vector of dates correspoding to the BPV calc
% dates: dates on which the curve is defined
% discounts: discounts of the curve.

thirty360 = 6;

dt = yearfrac([ta;paymentdates(1:end-1)],...
    paymentdates,thirty360);

B = queryDiscount(dates,discounts,paymentdates)/...
    queryDiscount(dates,discounts,ta);

BPV = dt'*B;   

end

