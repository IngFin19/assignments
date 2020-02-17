function price_no_ctp = price_no_ctp_risk(sigma,Nsim,SetDate,datesPayoff,dates,discounts)
%function calculate the price for the Cliquet option without considering
%the counterparty risk
%
%INPUT
%  _ sigma = volatility
%  _ Nsim = number of simulations 
%  _ SetDate = settlement date 
%  _ datesPayoff = vector of payment dates for the option
%  _ dates = dates on which the discount curve is defined
%  _ discounts = discounts of the curve
%
%OUTPUT
%  _ price_no_ctp = price for the Cliquet option without considering
%                   the counterparty risk
%
%FUNCTION
%  _ Simulate_Levels = function that simulate the underlying prices using the Monte 
%               Carlo method with antithetic variables
%  _ CliquetPayoff = function that calculate the payoffs for the Cliquet option
%  _ queryDiscount = main function to performe queries on the disc curve.
%                    if t is in between the start date and end date the 
%                    function performes interpolation of the discount factor 
%                    on the curve defined on dates and with correpsonding 
%                    discounts at a query point t calling interpolateDiscount
%                    if the query point t is greater that the last given date, 
%                    it performs an extrapolation according to the function
%                    extrapolateDiscount.

    S = Simulate_Levels(sigma,Nsim,dates,discounts,datesPayoff,SetDate);
    payoffs = CliquePayoff(S);
    B = queryDiscount(dates,discounts,datesPayoff);
    price_no_ctp=mean(sum(B'.*payoffs,2));

end

