function VaR = FullMonteCarloVaR(logReturns, numberOfShares, numberOfPuts, stockPrice, strike, rate, dividend, volatility, timeToMaturityInYears, riskMeasureTimeIntervalInYears, alpha) 
%function which compute the VaR using the full monte carlo valuation
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
%  _ VaR = VaR computed via Full-Valuation Monte Carlo method 
%

[~,Put_initial] = blsprice(stockPrice, strike, rate, timeToMaturityInYears, volatility, dividend);
losses = ComputeLosses(numberOfShares,numberOfPuts,stockPrice,logReturns,riskMeasureTimeIntervalInYears,strike,rate,timeToMaturityInYears,volatility,dividend,'MC');

sorted_losses = sort(losses,'descend');
index = ceil(length(losses)*(1-alpha));

initial_portfolio = numberOfShares*stockPrice+numberOfPuts*Put_initial;
VaR=sorted_losses(index)/initial_portfolio;

end