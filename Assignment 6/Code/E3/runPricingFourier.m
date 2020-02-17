%% exercise 3 group 9

clear all
clc

%% parameters
M=15;
x_1=-1000;
N=2^M;
dx=-2*x_1/(N-1);
dz=2*pi/(N*dx);
z_1=-dz*(N-1)/2;
x_1=-dx*(N-1)/2;
x_N=-x_1;
z_N=-z_1;
numericalParams=struct('M',M,'x_1',x_1,'N',N,'dx',dx,'dz',dz,'z_1',z_1,'x_N',x_N,'z_N',z_N);
modelParams=struct([]);
moneyness=[-0.025223;0;0.01];
f=@(x) 1./(x.^2+0.25);
%% Via FFT

method=1;
I_fft=computeIntegral(f, moneyness, modelParams, numericalParams, method) 

%% With Quadrature

method=0;
I_quad = computeIntegral(f, moneyness, modelParams, numericalParams, method) 

