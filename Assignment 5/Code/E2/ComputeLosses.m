function losses = ComputeLosses(numberOfShares,numberOfPuts,stockPrice,logReturns,riskMeasureTime,strike,rate,timeToMaturityInYears,volatility,dividend,flag)
%function which compute the losses with different methods
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
%  _ flag= 'MC' for the Montecarlo, 'Delta' for the Delta-Normal...
%  ...'Gamma' for the Delta-Gamma-Normal, 'GammaTheta' for the Gamma-Theta
%OUTPUT
%  _ losses = losses compute with the selected method
%

    DT = riskMeasureTime;
    % sensitivities
    d1 = (log(stockPrice/strike)+(rate-dividend+0.5*volatility^2)*timeToMaturityInYears)/(sqrt(timeToMaturityInYears)*volatility);
    [~,delta_put]=blsdelta(stockPrice,strike,rate,timeToMaturityInYears,volatility,dividend);
    gamma_put = blsgamma(stockPrice,strike,rate,timeToMaturityInYears,volatility,dividend);
    [~,theta_put] = blstheta(stockPrice,strike,rate,timeToMaturityInYears,volatility,dividend);

    % exapnsion error
    DS = stockPrice*(exp(logReturns)-1);
    
    if strcmp(flag,'MC')
        % MC losses
        new_portfolio = ComputePortfolio(strike,timeToMaturityInYears-DT,volatility,rate,dividend,logReturns,stockPrice,numberOfShares,numberOfPuts);
        initial_portfolio = ComputePortfolio(strike,timeToMaturityInYears,volatility,rate,dividend,0,stockPrice,numberOfShares,numberOfPuts);
        losses = initial_portfolio-new_portfolio;
        
    elseif strcmp(flag,'Delta')
        % delta losses
        losses=-(numberOfShares+numberOfPuts*delta_put)*DS;
    
    elseif strcmp(flag,'Gamma')
        % gamma losses
        losses = -(numberOfShares+numberOfPuts*delta_put)*DS...
            -numberOfPuts.*gamma_put.*DS.^2/2;
        
    elseif strcmp(flag,'GammaTheta')
        % theta and speed losses
        losses = -(numberOfShares+numberOfPuts*delta_put)*DS...
            -numberOfPuts.*gamma_put.*DS.^2/2+...
            -numberOfPuts*theta_put*DT;
    else
        losses = zeros(size(logReturns));
    end
    
end

