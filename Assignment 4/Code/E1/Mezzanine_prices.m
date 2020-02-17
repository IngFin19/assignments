function [p_LHP,p_HP,p_KL] = Mezzanine_prices(corr,p,Ku,Kd,recovery,Is,flag)
% Compute the price of the mezanine tranche for KL, homogenous portfolio,
% and homogenous portfolio with large number of mortages assumption.
% 
% INPUT
%  _ corr = correlation between morteges
%  _ p = default probability of single defaults
%  _ Ku = upper pinnging point of the mezzanine 
%  _ Kd = lower pinnging point of the mezzanine 
%  _ recovery = recovery in case of default on single name
%  _ Is = number of mortages to consider
% 
% OUTPUT
%  _ p_LHP = vector prices in case of large assumption
%  _ p_HP = vector prices in case of homogenous portfolio
%  _ p_KL = vector prices in case of KL
% 
% FUNTION
%  _ HP_Vasicek = price of the mezzanine tranche
%  _ KL_Vasicek = KL price for the Vasicek model
%  _ LHP_Vasicek = Compute Vasicek Mezzanine price with Large Portfolio Hypotesis 

p_LHP = ones(size(Is))*LHP_Vasicek(corr,p,Ku,Kd,recovery);
p_HP = zeros(size(Is));
p_KL = zeros(size(Is));

for i=1:length(Is)
    p_HP(i) = HP_Vasicek(corr,p,Ku,Kd,recovery,Is(i));
    p_KL(i) = KL_Vasicek(corr,p,Ku,Kd,recovery,Is(i),flag);
end

end

