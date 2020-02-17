function I=computeIntegral(f, moneyness, modelParams, numericalParams, method) 
%function that compute integral with fast fourier transform and quadrature
%
%INPUT
%  _ f = integrand as a function handle
%  _ moneyness = moneyness of interest as a vector 
%  _ modelParams = model parameters  
%  _ numericalParams = parameters of the numerical method as a struct
%  _ method = flag: 0 for quadrature, 1 for fft 
%
%OUTPUT
%
%  _ I = value of the integral

I=zeros(size(moneyness));

if method == 1 %fft
    
    z=numericalParams.z_1:numericalParams.dz:numericalParams.z_N;
    x=numericalParams.x_1:numericalParams.dx:numericalParams.x_N;
    F=exp(-1i*numericalParams.z_1*(0:numericalParams.N-1)*numericalParams.dx).*f(x);

    FFT=fft(F);
    if(norm(imag(numericalParams.dx*exp(-1i*numericalParams.x_1*z).*FFT),'inf')<1e-6)
        I_N=real(numericalParams.dx*exp(-1i*numericalParams.x_1*z).*FFT);
    else
        warning('Imaginary part not negligible!: %d', norm(imag(numericalParams.dx*exp(-1i*numericalParams.x_1*z).*FFT),'inf'))
        I_N=zeros(size(FFT));
    end
    I = interp1(z,I_N,moneyness,'spline');
  
elseif method == 0 %quadrature
   for ii=1:length(moneyness)
        expFunction = @(x) exp(-1i*moneyness(ii)*x);
        fun = @(x) expFunction(x).*f(x);
        I(ii) = quadgk(fun,numericalParams.x_1,numericalParams.x_N);
   end
    if(norm(imag(I),'inf')<1e-9)
        I=real(I);
    else
        warning('Imaginary part not negligible!')
        I=zeros(size(moneyness));
    end
end