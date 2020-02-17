function X=certificatePricing(underlyings, certificate, ratesCurve, M)
%function which compute the upfront X
%
%INPUT
%  _ underlyings = struct containing underlying value, dividend, sigma
%                  and correlation
%  _ certificate = struct containing settlement date, maturity date, alpha,
%                  protection, spol and year frac flag
%  _ ratesCurve = struct containing dates and rates 
%  _ M = number of simulations 
%
%OUTPUT
%  _ X = upfront
%
%FUNCTION
%  _ zeroRatesToDiscount = computes the continuosly comp. zero rate corresponding 
%                          to the discounts gives
%  _ floatLegPaymentDates = Compute Payments  dates of the floating leg Over 
%                           Euribor3m on business days 
%  _ calcBPV = computes the BPV on the corrisponding dates of paymentdate given the
%              curve dates, discounts
%  _ queryDiscount = main function to performe queries on the disc curve.
%                    if t is in between the start date and end date the 
%                    function performes interpolation of the 
%                    discount factor on the curve defined on dates and with correpsonding 
%                    discounts at a query point t calling interpolateDiscount
%                    if the query point t is greater that the last given date, it performs an 
%                    extrapolation according to the function extrapolateDiscount. 
%  _ basketSimulation = function which simulate the basket 

    % discount related quantities
    years = floor(yearfrac(certificate.setDate,certificate.maturity,2)*4)/4;
    discounts = zeroRatesToDiscount(ratesCurve.dates, ratesCurve.rates);
    paymentDates = floatLegPaymentDates(certificate.setDate,years);
    BPV_FloatingLeg = calcBPV(paymentDates,ratesCurve.dates,discounts);
    B = queryDiscount(ratesCurve.dates, discounts, certificate.maturity);
    
    % MC simulation
    timeToMaturity = yearfrac(certificate.setDate,certificate.maturity,certificate.flagYearfrac);
    maturityDate = certificate.maturity;
    priceLevels = basketSimulation(underlyings,ratesCurve,M,timeToMaturity,maturityDate);
    S = 0.5*sum(priceLevels./underlyings.S0',2);
    Copuons = certificate.alpha * max(S-certificate.P,0);
    
    % cash flows
    outCashFlows = 1 + certificate.spol*BPV_FloatingLeg - certificate.P*B;
    payoffOption = mean(Copuons)*B;
    
    % result
    X = outCashFlows - payoffOption;
    
end

