function [ES, VaR] = HSMeasurements(returns, alpha, weights, portfolioValue)
%Function that compute VaR and ES with Historical Simulation
%
%INPUT 
%  _ weights = weights of the portfolio
%  _ alpha = confidence level
%  _ portfolioValue = value of the portfolio
%  _ returns = logarithmic returns
%
%OUTPUT
%  _ ES = expected shortfall computed with Historical Simulation
%  _ VaR = Value at risk computed with Historical Simulation

    NumberOfDays = size(returns,1);
    Losses = ComputeAndSortLosses(returns,weights);
    index_alpha = round((1-alpha)*NumberOfDays);
    VaR = Losses(index_alpha)*portfolioValue;
    ES = mean(Losses(1:index_alpha))*portfolioValue;
end

