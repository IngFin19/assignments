function [ES, VaR] = WHSMeasurements(returns, alpha, lambda, weights, portfolioValue)
%Function that compute VaR and ES with Historical weighted Simulation
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
    [Losses, indicesLosses] = ComputeAndSortLosses(returns,weights);
    historicalWeights = computeHistoricalWeights(lambda,NumberOfDays);
    SortedHistoricalWeights = historicalWeights(indicesLosses);
    index=find(cumsum(SortedHistoricalWeights)<1-alpha,1,'last');
    VaR = Losses(index)*portfolioValue;
    weightedLoss = SortedHistoricalWeights'.*Losses;
    ES = sum(weightedLoss(1:index))/sum(SortedHistoricalWeights(1:index))*portfolioValue;
end

