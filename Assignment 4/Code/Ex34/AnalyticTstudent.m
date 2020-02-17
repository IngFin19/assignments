function [ES, VaR] = AnalyticTstudent(yearlyCovarianceMatrix, yearlyMeanReturns, portfolioWeights, riskMeasureTimeLag, alpha, degreesOfFreedom)
%Compute the VaR & ES in the framework of t_student distribution
%
%INPUT
%  _ yearlyCovarianceMatrix = yearly Covariance Matrix
%  _ yearlyMeanReturns = yearly Mean Returns
%  _ portfolioWeights = Weights of portfolio
%  _ spreadsCDS = CDS market spreads
%  _ riskMeasureTimeLag = fraction of time with which we want to evaluate our risk 
%  _ alpha = quantile
%  _ degreesOfFreedom = Degrees of freedom of the t_student distribution
%OUTPUT
%  _ ES = Expected shortfall
%  _ VaR = Value at Risk
   

%compute daily mean and variance
MeanOfLoss = -yearlyMeanReturns'*portfolioWeights*riskMeasureTimeLag; 
VarianceOfLoss = portfolioWeights'*yearlyCovarianceMatrix*portfolioWeights*riskMeasureTimeLag;

%compute VaR & ES
VaR = (MeanOfLoss+sqrt(VarianceOfLoss)*tinv(alpha,degreesOfFreedom));
ES  = MeanOfLoss+sqrt(VarianceOfLoss)*(degreesOfFreedom+(tinv(alpha,degreesOfFreedom)^2))/(degreesOfFreedom-1)*...
    (tpdf(tinv(alpha,degreesOfFreedom),degreesOfFreedom))/(1-alpha);
   

end
