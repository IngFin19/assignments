%%Portfolio of 2 stocks
%
%This script is done with given data and use the AnalyticMeasurements
%function to provide the numerical results
%
%FUNCTIONS
%  _ Analytic Measurements = compute VaR & ES reffered to normal distribution
%                            (flag = 1, or nothing) and and t-Student distribution (flag = 2)
% Risk Measurements of a Linear Portfolio
% Financial Engineering: Politecnico Milano
% 
%
% In order to run the script:
% >> runExercise3
%
% Last Modified: 19.03.2017

clc;
clear all;

%% Data

w=[0.6;0.4];
vol=[0.15;0.30];
mu=[0.03;0.05];
Corr=[1, 0.3;0.3,1];
alpha=0.99;
DoF=3;
numberDaysYear = 256;
H=1/numberDaysYear;

%% Compute the Covariance Matrix

V=[Corr(1,1)*vol(1)^2,Corr(1,2)*vol(1)*vol(2);
    Corr(2,1)*vol(1)*vol(2), Corr(2,2)*vol(2)^2];

%% compute Var & ES

[ES, VaR] = AnalyticMeasurements(V,mu,w,H,alpha)
[ES_t, VaR_t] = AnalyticMeasurements(V, mu, w, H, alpha, DoF,2)
