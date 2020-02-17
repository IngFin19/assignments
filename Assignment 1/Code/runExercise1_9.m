%Assignment_1
%  Group 9, AA2018-2019

%% Pricing parameters
S0=1;
K=1;
r=0.03;
T0 = datenum('15-Feb-2008');
TTM=1.00; 
sigma=0.20;
flag=1;          % flag:  1 call, -1 put
Yield=0.04;
%% Quantity of interest
B=exp(-r*TTM); % Discount

%% Pricing 
F0=S0/B;     % Forward in B&S Model

%TBM: Modify with a cicle
Ms=[0,100,1e6];
for pricingMode=1:3 % 1 ClosedFormula, 2 CRR, 3 Monte Carlo
    M=Ms(pricingMode); % M = simulations for MC, steps for CRR;
    OptionPrice=EuropeanOptionPrice(F0,K,B,TTM,sigma,pricingMode,M,flag)
end

%% Errors Rescaling 

% plot Errors for CRR varing number of steps
% Note: both functions plot also the Errors of interest as side-effect 
[nCRR,errCRR]=PlotErrorCRR(F0,K,B,TTM,sigma);

% plot Errors for MC varing number of simulations N 
[nMC,stdEstim]=PlotErrorMC(F0,K,B,TTM,sigma);

%% Plot Delta and Vega for a Call Option with Black&Scholes model

%TBM: Set the interval of interest for S

S=0.8:0.05:1.2;
flag=1; %call
pricingMode = 1; %closed form
vegaVector=[];
deltaVector=[];
priceVector=[];

for S0=S
    F0 = S0/B;     % Forward in B&S Model
    price = EuropeanOptionPrice(F0,K,B,TTM,sigma,pricingMode,M,flag);
    delta = DeltaBlackScholes(F0,K,B,TTM,sigma,flag);
    vega = VegaBlackScholes(F0,K,B,TTM,sigma,flag);
    vegaVector=[vegaVector,vega];
    deltaVector=[deltaVector,delta];
    priceVector=[priceVector,price];
end

figure
subplot(3,1,1);
plot(S,priceVector)
title('price')
subplot(3,1,2);
plot(S,deltaVector)
title('delta')
subplot(3,1,3);
plot(S,vegaVector)
title('vega')

