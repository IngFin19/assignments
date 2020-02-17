function [datesCDS, survProbs, intensities] = bootstrapCDS(datesDF, discounts, datesCDS, spreadsCDS, flag, recovery)
%Infers survival probabilities and intensity from term structure 
%
%INPUT
%  _ datesDF = dates on which the discount curve is defined
%  _ discounts = discounts of the curve obtained via bootstrap
%  _ datesCDS = CDS payment dates  
%  _ spreadsCDS = CDS market spreads
%  _ flag = '1' for approx, '2' for exact, '3' for JT
%  _ recovery = recovery rate of the underlying contract
%
%OUTPUT
%  _ datesCDS = CDS payment dates 
%  _ survProbs = survival probabilities P(0,t)
%  _ intensities = intensity parameter of the exponential
% 
%FUNCTION
%  _ queryDiscount=main function to performe queries on the disc curve.
%                  if t is in between the start date and end date the 
%                  function performes interpolation of the discount factor 
%                  on the curve defined on dates and with correpsonding 
%                  discounts at a query point t calling interpolateDiscount
%                  if the query point t is greater that the last given date, 
%                  it performs an extrapolation according to the function
%                  extrapolateDiscount. 
%  _ survival_to_intensities = compute intensities from survival probabilities
%  _ intensities_to_survival = compute survival probabilities from intensities 
    
    act365 = 3;
    SetDate = datesDF(1);
    year_fractions = yearfrac([SetDate; datesCDS(1:end-1)],datesCDS,act365); % to check basis 
    
    if(flag == 1 || flag == 2)
        
        e = zeros(size(datesCDS));
        B_bar = zeros(size(datesCDS));
        accrual_flag = (flag==2);
        P = [1];
        
        i=1;
        t = SetDate(i);
        dt = year_fractions(i);
        B = queryDiscount(datesDF,discounts,t);
        s=spreadsCDS(i);
        accrual_term = dt*s*0.5*(flag==2);
        
        tmp = (1-recovery-accrual_term)/(1-recovery-accrual_term+s*dt);
        
        P=[P;tmp];
        
        for i=2:length(datesCDS)
            t = datesCDS(i);
            dt = year_fractions(i);
            B = queryDiscount(datesDF,discounts,t);
            s = spreadsCDS(i);
            accrual_term = year_fractions(i)*s*0.5*accrual_flag;
            e(i-1) = queryDiscount(datesDF,discounts,datesCDS(i-1))*(P(i-1)-P(i));
            B_bar(i-1) = queryDiscount(datesDF,discounts,datesCDS(i-1)) * P(i);

            tmp = (e'*((1-recovery)-accrual_term*year_fractions) + (1-recovery-accrual_term)*B*P(i) -...
                s*B_bar'*year_fractions)/(B*(s*dt-accrual_term+1-recovery));
            
            P = [P;tmp];
        end
    
        survProbs = P(2:end); % to exclude P(0,0)=1 so its consistent in length
        intensities = survival_to_intensities(SetDate,datesCDS,survProbs);
    else
        intensities = spreadsCDS/(1-recovery);
        survProbs = intensities_to_survival(SetDate,datesCDS,intensities);
    end
end

