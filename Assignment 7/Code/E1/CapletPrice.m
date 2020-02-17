function Caplet = CapletPrice(K,sigma,FixingDate,PaymentDate,discountCurve)
%CapletPrice(K,sigma,FixingDate,PaymentDate,discountCurve)
%function which compute the price of every caplet using the black formula 
%
%INPUT
%  _ K = strike
%  _ sigma = volatility
%  _ FixingDate = dates fixed which correspond to T(i)
%  _ PaymentDate = dates of the payment which correspond to T(i+1) 
%  _ discountCurve = struct containing dates and discounts
%
%OUTPUT
%  _ Caplet = price of the caplet 
%
%FUNCTION
%  _ queryDiscount = main function to performe queries on the discount curve
%                    if t is in between the start date and end date the 
%                    function performes interpolation of the  discount factor 
%                    on the curve defined on dates and with correpsonding 
%                    discounts at a query point t if the query point t is greater
%                    than the last given date, it performs an extrapolation according 
%                    to the function
    act365 = 3;
    act360 = 2;
    
    settlement = discountCurve.dates(1);
    dt = yearfrac(FixingDate,PaymentDate,act360);
    BT1 = queryDiscount(discountCurve.dates,discountCurve.discounts,FixingDate);
    BT2 = queryDiscount(discountCurve.dates,discountCurve.discounts,PaymentDate);
    L = 1./dt.*(BT1./BT2-1);
    r = 0;
    TTF = yearfrac(settlement,FixingDate,act365);
    
    Caplet = dt.*BT2.*blkprice(L, K, r, TTF, sigma);
    
end

