function upfront = certificatePricing(certificate, discountCurve, capletVolatilityData) 
%certificatePricing(certificate, discountCurve, capletVolatilityData) 
%function which compute the vaue of the upfront 
%
%INPUT
%  _ certificate = struct containing settlement date, maturity,
%                  fixingEUR6M, spol, flagYearfrac
%  _ discountCurve = struct containing dates and discounts
%  _ capletVolatilityData = matrix with strikes, maturities and flat
%                        volatilities
%  
%OUTPUT
%  _  upfront = value of the upfront
%
%FUNCTION
%  _ queryDiscount = main function to performe queries on the discount curve
%                    if t is in between the start date and end date the 
%                    function performes interpolation of the  discount factor 
%                    on the curve defined on dates and with correpsonding 
%                    discounts at a query point t if the query point t is greater
%                    than the last given date, it performs an extrapolation according 
%                    to the function 
%  _ interpSurface = function which compute the volatility through interpolation if 
%                    the strike that we need does not exist
%  _ CapletPrice = function which compute the price of every caplet using the black formula

    B = queryDiscount(discountCurve.dates,discountCurve.discounts, capletVolatilityData.fixings(1));
    act360 = 2;
    idx = capletVolatilityData.fixings(2:end)<=certificate.maturity;
    PaymentDate = capletVolatilityData.fixings(logical([0;idx]));
    
    strikes = zeros(11,1)-certificate.spol;
    strikes(1:5) = strikes(1:5)+4.2/100;
    strikes(6:end) = strikes(6:end)+4.6/100;
    
    sigma = interpSurface(strikes,PaymentDate,capletVolatilityData);
    
    FixingDate = capletVolatilityData.fixings(capletVolatilityData.fixings(1:end)<certificate.maturity);
    caplets_prices = sum(CapletPrice(strikes,sigma,FixingDate,PaymentDate,discountCurve));
    
    d = yearfrac(certificate.setDate,FixingDate(1),act360);
    
    upfront = caplets_prices+...
        d*(certificate.fixingEUR6M+certificate.spol-0.03)*B;
    
end

