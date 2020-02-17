function [priceBlack,priceSmile] = priceDigital(cSelect, notional, optionPayoff, optionStrike, optionTTM, discount)
%function which compute the price of the digital option via black formula
%and smile 
%
%INPUT
%  _ cSelect = input dataset
%  _ notional = derivative notional
%  _ optionPayoff = payoff of the digital option
%  _ optionStrike = strike of the digital option
%  _ optionTTM = time to maturity
%  _ discount = discount factor 1y
%
%OUTPUT
%  _ priceBlack = price computed via black formula 
%  _ priceSmile = price computed via smile 

    % parameters
    r = -log(discount)/optionTTM;
    sigma = interp1(cSelect.strikes,cSelect.surface,optionStrike,'spline');
    d2 = log((cSelect.reference*exp(-cSelect.dividends*optionTTM) / discount)/optionStrike)/sqrt(sigma^2*optionTTM)-0.5*sqrt(sigma^2*optionTTM);
    d1 = d2+sigma*sqrt(optionTTM);
    vega = normpdf(d1)*exp(-r*optionTTM)*cSelect.reference*sqrt(optionTTM);
    
    % numerical derivative of vol
    idx1 = find(optionStrike>cSelect.strikes,1,'last');
    idx2 = find(optionStrike<cSelect.strikes,1,'first');
    numericalDerivativeOfVol = (cSelect.surface(idx2)-cSelect.surface(idx1))/...
        (cSelect.strikes(idx2)-cSelect.strikes(idx1));
    
    % results
    priceBlack = discount*normcdf(d2)*optionPayoff*notional;
    smileCorrection = discount*optionPayoff*notional*(numericalDerivativeOfVol*vega);
    priceSmile = priceBlack - smileCorrection;
end
