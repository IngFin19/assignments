function [sigma, k, eta] = CalibrateNIGToVolatilitySurface(volatilityData, discountCurve)
%function that Calibrate the NIG model, with constant weights starting from
%EUROSTOXX50.
%
%INPUT
%  _ volatilityData = struct containing EUROSTOXX50 data
%  _ discountCurve = struct containing dates and discounts
%
%OUTPUT
%  _ sigma = volatility parameter of the model
%  _ k =  convexity parameter of the model
%  _ eta = simmetry parameter of the model
%% surface params

    act365 = 3;
    maturityDate = datenum('19-Feb-2009');
    timeToMaturity= yearfrac(discountCurve.dates(1), maturityDate, act365);

    discount = queryDiscount(discountCurve.dates, discountCurve.discounts, maturityDate);
    rate = -log(discount)/timeToMaturity;
    price = volatilityData.reference;
    forward_price = price*exp((rate-volatilityData.dividends)*timeToMaturity);

    call_blk = blkprice(forward_price, volatilityData.strikes, rate, timeToMaturity, volatilityData.surface);

    moneyness = log(forward_price./volatilityData.strikes);
    
%% Param for FFT
  
    M = 15;
    N = 2^M;
    x_1 = -1000;
    dx = -2*x_1/(N-1);
    dz = 2*pi/(N*dx);
    z_1 = -dz*(N-1)/2;
    x_1 = -dx*(N-1)/2;

    param_fftnumericalMethodParameters = struct('M',15,'x_1',-1000,'N',N,'dx',dx,'dz',dz,...
                                     'z_1',z_1,'x_N',-x_1,'z_N',-z_1);
    
%% calibration obj fnc

    Call_FFT = @(x, sigma, k, eta) ...
        CallPricesNIGFFT(forward_price,discount,x,timeToMaturity,sigma,k,eta,param_fftnumericalMethodParameters);
    
    lowerbound = @(sigma, k) 1./(0.5*k.*(sigma.^2)); %lowerbound in NIG framework
    
    L = length(volatilityData.surface);
    
    d = @(p) (1/L)*(norm(Call_FFT(moneyness, p(1), p(2), p(3)) - call_blk, 2)^2) +...
        1e16 * ( p(3) <= -lowerbound(p(1),p(2)) );  %obj function with constrains

%% calibration
 
    sigma_start = 0.25;
    k_start = 1;
    eta_start = 5;
    
    %% grid search
    [grid_sigma,grid_k,grid_eta] = ndgrid(sigma_start*[0.5,1,1.5],k_start*[0.5,1,1.5],eta_start*[0.5,1,1.5]);
    grid = [grid_sigma(:),grid_k(:),grid_eta(:)];
    
    d0 = 9999999;
    for i=1:length(grid)
        if d(grid(i,:))<d0
            d0 = grid(i,:);
            p0 = grid(i,:);
        end
    end
    
    %% calibration
    
    [ p, D] = fminsearch(d, p0);
    
    sigma=p(1);
    k=p(2);
    eta=p(3);
    
end

