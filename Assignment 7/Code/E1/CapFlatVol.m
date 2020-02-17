function [capPrice] = CapFlatVol(year,idx_K,capVolatilityData,discountCurve)
%CapFlatVol(year,idx_K,capVolatilityData,discountCurve)
%function which compute the price of the cap using the flat volatility
%
%INPUT
%  _ year = number of years that we are considering 
%  _ idx_K = index of the strike
%  _ capVolatilityData = matrix with strikes, maturities and flat
%                        volatilities
%  _ discountCurve = struct containing dates and discounts
%
%OUTPUT
%  _ capPrice = price of the cap using the flat volatility
%
%FUNCTION
%  _ CapletPrice = function which compute the price of every caplet using the black formula
%
    sigma = capVolatilityData.surface(idx_K,year);
    paymentDates = capVolatilityData.payment_dates(1:2*year);
    K = capVolatilityData.strikes(idx_K);
    capPrice = sum(CapletPrice(K,sigma,paymentDates(1:end-1),paymentDates(2:end),discountCurve));
end

