function [ Spread ] = CalculateAssetSwapSpread(settlementDate,coupon,Bondprice,fixedLegPaymentDates,floatLegPaymentDates,dates,discounts)
% Compute the Asset Swap Spread 
%
% INPUT 
%   _ settlementDate:  Date of the settlement
%   _ coupon: Coupon value
%   _ Bondprice : Bond value
%   _ fixedLegPaymentDates: Payment dates of the fixed leg
%   _ floatLegPaymentDates:  Payment dates of the floating leg
%   _ dates: dates on which the discount curve is defined
%   _ discounts:discounts of the curve obtained via bootstrap
%
% OUTPUT
%   _ S: spread of the asset swap
%FUNCTION 
%  _ calcBPV = computes the BPV on the corrisponding dates of paymentdate given the
%              curve dates, discounts
%
%  _ queryDiscount = main function to performe queries on the disc curve.
%                    if t is in between the start date and end date the 
%                    function performes interpolation of the discount factor 
%                    on the curve defined on dates and with correpsonding 
%                    discounts at a query point t calling interpolateDiscount
%                    if the query point t is greater that the last given date, 
%                    it performs an extrapolation according to the function
%                    extrapolateDiscount.


BpvFloat=calcBPV(floatLegPaymentDates,dates,discounts);
%BPV CALCULATION FOR THE FIXED LEG
BpvFixed = calcBPV(fixedLegPaymentDates,dates,discounts);
B = queryDiscount(dates,discounts,fixedLegPaymentDates(3));
%CALCULATION OF THE SPREAD
C_Zero = coupon*BpvFixed+B;
Spread = (C_Zero - Bondprice)/BpvFloat;


end

