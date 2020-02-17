function pricesFFT = CallPricesNIGFFT(forward, discount, moneyness, timeToMaturity, sigma, k, eta,numericalMethodParameters)
%pricesFFT = CallPricesNIGFFT(forward, discount, moneyness, timeToMaturity, sigma, k, eta,numericalMethodParameters)
%function that compute the price of the european call with FFT in the NIG framework
%
%INPUT
%  _ forward = forward price
%  _ discount = discount at maturity date
%  _ moneyness = moneyness of interest as a vector 
%  _ sigma = volatility parameter of the model
%  _ k =  convexity parameter of the model
%  _ eta = simmetry parameter of the model
%  _ timeToMaturity = time to maturity 
%  _ numericalMethodParameters = parameters of the numerical method as a struct
%  
%
%OUTPUT
%
%  _ pricesFFT = prices of european calls with FFT


  %z=numericalMethodParameters.z_1:numericalMethodParameters.dz:numericalMethodParameters.z_N;
  LaplaceExp= @(w) timeToMaturity/k * (1-sqrt(1+2*k*w*sigma^2)); %NIG
  phi= @(x) exp(-1i*x.*LaplaceExp(eta)).*exp(LaplaceExp( (x.^2+1i*(1+eta*2)*x)/2)); %characteristic function
  f = @(x) 1./(0.25 + x.^2).*phi(-x-1i/2)/(2*pi) ;
  
  method=1;
  modelParams = struct() ;
  
  I = computeIntegral(f, moneyness, modelParams, numericalMethodParameters, method);
  pricesFFT=forward.*discount.*(1-exp(-moneyness/2).*I);
  
end

