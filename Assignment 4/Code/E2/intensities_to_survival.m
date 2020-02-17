function survival_prob = intensities_to_survival(SetDate,datesCDS,intensities)
%Compute survival probabilities from intensities 
%
%INPUT
%  _ SetDate = settlement date
%  _ datesCDS = CDS payment dates
%  _ intensities = intensity parameter of the exponential
%
%OUTPUT
%  _ survival_prob = survival probability

    thirty360 = 6;
    year_fractions = yearfrac([SetDate; datesCDS(1:end-1)],datesCDS,thirty360); % to check basis
    survival_prob = exp(-cumsum(intensities.*year_fractions));
end

