function F = SimulateNIG(forward, timeToMaturity, sigma, k, eta, numberOfSamples)
%function that compute the price of the european call with Monte Carlo method in the NIG framework
%
%INPUT
%  _ forward = forward price
%  _ discount = discount at maturity date
%  _ moneyness = moneyness of interest as a vector 
%  _ sigma = volatility parameter of the model
%  _ k =  convexity parameter of the model
%  _ eta = simmetry parameter of the model
%  _ timeToMaturity = time to maturity 
%  _ numberOfSamples = number of samples
%  
%
%OUTPUT
%
%  _ pricesMC = prices of european calls with mc


N = length(timeToMaturity);

u = rand(numberOfSamples,N); 
u = [u;1-u]; %av

z = randn(numberOfSamples,N);
z = ([z;-z]).^2; %av chi

G_star = 1 - k./(2*timeToMaturity) .* (sqrt(z.^2+4*z.*timeToMaturity/k) - z);
G = G_star;
idx = (1+G_star).*u>1;
G(idx) = 1./G_star(idx);

g = randn(numberOfSamples,N);
g = [g;-g];

LaplaceExp= @(w) timeToMaturity/k * (1-sqrt(1+2*k*w*sigma^2));
f=sqrt(timeToMaturity)*sigma.*sqrt(G).*g-(0.5+eta)*(timeToMaturity)*sigma^2.*G-LaplaceExp(eta);

F=forward*exp(cumsum(f,2));
    
end




    


