function VaR=HigherNormalVar(logReturns, numberOfShares, numberOfPuts, stockPrice, strike, rate, dividend, volatility, timeToMaturityInYears, riskMeasureTimeIntervalInYears, alpha)
%function which compute the VaR using a high order method 
%
%INPUT
%  _ logReturns = logarithm of the profit on an investment
%  _ numberOfShares = number of shares
%  _ numberOfPuts = number of puts
%  _ stockPrice = price of the stock
%  _ strike = strike 
%  _ rate = rate
%  _ dividend = dividend
%  _ volatility = sigma 
%  _ timeToMaturityInYears = T-t0 in years 
%  _ riskMeasureTimeIntervalInYears = scaling 
%  _ alpha = alpha 
%
%OUTPUT
%  _ VaR = VaR computed via a higher order approximation of the derivatives
%
    DT = riskMeasureTimeIntervalInYears;
    
    %initial portfolio
    [~,Put_initial] = blsprice(stockPrice, strike, rate, timeToMaturityInYears, volatility, dividend);
    initial_portfolio = numberOfShares*stockPrice+numberOfPuts*Put_initial;

    %losses
    losses = ComputeLosses(numberOfShares,numberOfPuts,stockPrice,logReturns,...
        DT,strike,rate,timeToMaturityInYears,volatility,dividend,'GammaTheta');
    
    sorted_losses=sort(losses,'descend');
    idx = ceil(length(losses)*(1-alpha));
    VaR=sorted_losses(idx)/initial_portfolio;
    
end