function VaR = plausibilityCheck(returns, portfolioWeights, alpha, portfolioValue)
%function that compute the plausibilty check for the risk measures
%
%INPUT
%  _ returns = logarithmic returns
%  _ portfolioWeights = portfolio's weights
%  _ alpha = confidence level
%  _ portfolioValue = value of the portfolio
%
%OUTPUT
%  _ VaR = Value at risk computed with the plausibilty check

    mu = mean(returns)';
    sigma = std(returns)';
    l = mu + sigma*norminv(1-alpha);
    u = mu + sigma*norminv(alpha);
    sVaR = portfolioWeights.*(abs(l)+abs(u))/2;
    C = corr(returns);
    VaR = sqrt(sVaR'*C*sVaR)*portfolioValue;
end

