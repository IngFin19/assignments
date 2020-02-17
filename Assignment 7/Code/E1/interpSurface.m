function [sigma] = interpSurface(K,date,capVolatilitySpot)
%interpSurface(K,date,capVolatilitySpot)
%function which compute the volatility through interpolation if the strike that we need does not exist
%
%INPUT
%  _ K = strike 
%  _ date = payment dates
%  _ capVolatilitySpot = matrix of spot volatilities, strikes and maturity
%
%OUTPUT
%  _ sigma = volatility

    if(sum(K>capVolatilitySpot.strikes(end)) || sum(K<capVolatilitySpot.strikes(1)))
        error('Strike out of bound');
    end
    if(sum(date>capVolatilitySpot.fixings(end)) || sum(date<capVolatilitySpot.fixings(1)))
        error('Strike out of bound');
    end
    
    [X,Y] = meshgrid(capVolatilitySpot.strikes,capVolatilitySpot.fixings(2:end));
    
    sigma = interp2(X,Y,capVolatilitySpot.surface',K,date,'spline');
    
end

