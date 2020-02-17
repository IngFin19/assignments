function [intensities] = survival_to_intensities(SetDate,datesCDS,survival_prob)
%Compute intensities from survival probabilities
%
%INPUT
%  _ SetDate = settlement date
%  _ datesCDS = CDS payment dates
%  _ survival_prob = survival probability
% 
%OUTPUT
%  _ intensities = intensity parameter of the exponential
    
    thirty360 = 6;
    P = [1;survival_prob];
    year_fractions = yearfrac([SetDate; datesCDS(1:end-1)],datesCDS,thirty360); % to check basis
    intensities = log(P(1:end-1)./P(2:end))./year_fractions;
end

