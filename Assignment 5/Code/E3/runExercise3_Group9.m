%%% runAssignment5
% group 9, AY2018-2019
% 
% to run:
% > runExercise3_9

clear all
close all
clc

%% Parameters and input functions
intensity = 50*1e-4;
timeInterval = 30;
Nsim = 10^3;
alpha = 0.01;

%% a) simulation

tau = Simulate_tau(Nsim,intensity);

%% Calibration

[lambda_fit,CI]=unbiasedExponentialEstimator(tau,alpha);

%% Plot survival

plot_survProb(tau,CI,lambda_fit);
