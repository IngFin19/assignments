function price_ctp= price_ctp_risk(sigma,Nsim,SetDate,datesPayoff,dates,discounts,recovery,spreadsCDS,datesCDS)
%function calculate the price for the Cliquet option considering the
%counterparty risk
%
%INPUT
%  _ sigma = volatility
%  _ Nsim = number of simulations 
%  _ SetDate = settlement date 
%  _ datesPayoff = vector of payment dates for the option
%  _ dates = dates on which the discount curve is defined
%  _ discounts = discounts of the curve
%  _ recovery = recovery rate of the underlying contract
%  _ spreadsCDS = CDS market spreads
%  _ datesCDS = CDS payment dates 
%
%OUTPUT
%  _ price_ctp = price for the Cliquet option considering the 
%                counterparty risk
%
%FUNCTION
%  _ Simulate_Levels = function that simulate the underlying prices using the 
%               Monte Carlo method with antithetic variables 
%  _ CliquetPayoff = function that calculate the payoffs for the Cliquet option
%  _ queryDiscount = main function to performe queries on the disc curve.
%                    if t is in between the start date and end date the 
%                    function performes interpolation of the discount factor 
%                    on the curve defined on dates and with correpsonding 
%                    discounts at a query point t if the query point t is 
%                    greater that the last given date, it performs an extrapolation
%  _ Simulate_Tau = function that simulate credit events times with intensities 
%                    bootstrapped from CDS spreads
%
    S = Simulate_Levels(sigma,Nsim,dates,discounts,datesPayoff,SetDate);
    payoffs = CliquePayoff(S);
    B = queryDiscount(dates,discounts,datesPayoff);
    tau = Simulate_Tau(Nsim,dates,spreadsCDS,datesCDS,discounts,datesPayoff,SetDate,recovery);
    [~,indexFirstDefault] = max((datesPayoff'>=tau),[],2);
    price_ctp = mean(sum(B'.*((datesPayoff'<tau).*payoffs),2)+...
        recovery*(sum(datesPayoff'>=tau,2)>0).*... % if I have a credit event I get the following payoff times the recovery
        sum(payoffs.*bsxfun(@eq, cumsum(ones(size(payoffs)), 2), indexFirstDefault), 2).*...
        B(indexFirstDefault)); % discounting in ti if tau in ti-1,ti

end