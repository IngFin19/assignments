function [portfolio]=ComputePortfolio(strike,timeToMaturityInYears,volatility,rate,dividend,logReturns,stockPrice,numberOfShares,numberOfPuts)
%function which compute the value of the portfolio
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
% 
%OUTPUT
%  _ portfolio = value of the portfolio
%    

    NewPrice=stockPrice*exp(logReturns);
    [~,Put] = blsprice(NewPrice, strike, rate, timeToMaturityInYears, volatility, dividend);
    portfolio=Put*numberOfPuts+NewPrice*numberOfShares;
    
end

