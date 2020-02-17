function [ES, VaR] = AnalyticNormal(yearlyCovarianceMatrix, yearlyMeanReturns, portfolioWeights, riskMeasureTimeLag, alpha)
%Compute the VaR & ES in the framework of normal distribution
%
%INPUT
%  _ yearlyCovarianceMatrix = yearly Covariance Matrix
%  _ yearlyMeanReturns = yearly Mean Returns
%  _ portfolioWeights = Weights of portfolio
%  _ spreadsCDS = CDS market spreads
%  _ riskMeasureTimeLag = fraction of time with which we want to evaluate our risk 
%  _ alpha = quantile
%
%OUTPUT
%  _ ES = Expected shortfall
%  _ VaR = Value at Risk

%compute daily mean and variance
yearlyMeanReturns = yearlyMeanReturns(:);
meanOfLoss = -yearlyMeanReturns'*portfolioWeights*riskMeasureTimeLag;
varianceOfLoss = portfolioWeights'*yearlyCovarianceMatrix*portfolioWeights*riskMeasureTimeLag;
    
%compute VaR & ES
VaR = meanOfLoss+sqrt(varianceOfLoss)*norminv(alpha);
ES = meanOfLoss+sqrt(varianceOfLoss)*normpdf(norminv(alpha))/(1-alpha);
    
end

