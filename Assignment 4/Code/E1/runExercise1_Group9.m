% runAssignment4
% group 9, AY2018-2019
% 
% to run:
% > runExercise1_9

clear all;
close all;
clc;

%% Data

notional = 1e9;
T=2;
Ku = 0.09;
Kd = 0.06;
p=0.065;
corr=0.4;
recovery=0.65;

%% a) Mezzanine Tranche with Large Homogeneous Portfolio in Vasicek

price_LHP = LHP_Vasicek(corr,p,Ku,Kd,recovery)

%% b) impact of Large Portfolio assumption

I = 500;
price_HP = HP_Vasicek(corr,p,Ku,Kd,recovery,I)
err = abs(price_LHP-price_HP)

%% b) KL approach

I = 500;
price_KL = KL_Vasicek(corr,p,Ku,Kd,recovery,I)

%% plot results

Is=round(10.^linspace(1,4,10));
flag = 1;
[p_LHP,p_HP,p_KL] = Mezzanine_prices(corr,p,Ku,Kd,recovery,Is,flag);
plot_results_vasicek(Is,p_LHP,p_HP,p_KL,Kd,Ku)

%% normalization error

% it takes about 3minutes to run. Plot in the document.
% Uncomment to run.
% 
% Is=round(10.^linspace(1,3,5));
% [p_KL_app,p_KL_ex] = plot_normalization_err(Is,corr,p,Ku,Kd,recovery);
%

%% d) Equity tranche

e_Ku = 0.06;
Is=round(10.^linspace(1,4,10));
[ep_LHP,ep_HP,ep_KL] = Equity_prices(corr,p,e_Ku,recovery,Is);
plot_results_vasicek(Is,ep_LHP,ep_HP,ep_KL,0,e_Ku)
