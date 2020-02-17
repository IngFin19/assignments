function S = basketSimulation(underlyings,ratesCurve,M,timeToMaturity,maturityDate)
%function which simulate the basket 
%
%INPUT
%  _ underlyings = struct containing underlying value, dividend, sigma
%                  and correlation
%  _ ratesCurve = struct containing dates and rates 
%  _ M = number of simulations 
%  _ timeToMaturity = time between settlement date and the date of maturity
%  _ maturityDate = date of maturity 
%
%OUTPUT
%  _ S = simulated basket 
%
%FUNCTION
%  _ zeroRatesToDiscount = computes the continuosly comp. zero rate corresponding 
%                          to the discounts gives
%  _ queryDiscount = main function to performe queries on the disc curve.
%                    if t is in between the start date and end date the 
%                    function performes interpolation of the 
%                    discount factor on the curve defined on dates and with correpsonding 
%                    discounts at a query point t calling interpolateDiscount
%                    if the query point t is greater that the last given date, it performs an 
%                    extrapolation according to the function extrapolateDiscount. 


    
    rho = underlyings.corr;
    dividendYieldVector = underlyings.d;
    volatilityVector = underlyings.sigma;
    numberOfAssets = length(underlyings.S0);
    
    discounts = zeroRatesToDiscount(ratesCurve.dates, ratesCurve.rates);
    r = -log(queryDiscount(ratesCurve.dates, discounts, maturityDate))/timeToMaturity;
    Z = randn(M,numberOfAssets);
    Z = [Z;-Z]; %AV
    Z(:,2) = rho * Z(:,1) + sqrt(1-rho^2) * Z(:,2);
    
    returns = ((r-dividendYieldVector-0.5*volatilityVector.^2)*timeToMaturity)'+...
        volatilityVector'.*Z*sqrt(timeToMaturity);
    S = underlyings.S0'.*exp(returns);
end

