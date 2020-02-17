function [NPV_first_strategy] = ProfitandLoss(N,dates,datesSet,discounts,internalMid,tardedPrice)
%Compute Profit and Loss for a 5Y swap 
%INPUT
%  _ N = Notional
%  _ dates = vector of dates for Depos Futures and Swaps
%  _ discounts = discounts factors defined on dates
%
%OUTPUT
%  _ NPV_first_strategy = NPV computed substituting in B our discout obtained
%                         by our bootstrap
%FUNCTION
%  _ calcBPV = computes the BPV on the corrisponding dates of paymentdate given the
%              curve dates, discounts

Paymentdate = datesSet.swaps(1:5);
BPV = calcBPV(Paymentdate,dates,discounts);
NPV_first_strategy = N*BPV*(internalMid-tardedPrice);

end

