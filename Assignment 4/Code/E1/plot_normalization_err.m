function [p_KL_app,p_KL_ex] = plot_normalization_err(Is,corr,p,Ku,Kd,recovery)
%Function that plots the mezzanie prices errors in case of exact
%normalization or numerlical one.
%
%INPUT
%  _ corr = correlation between morteges
%  _ p = default probability of single defaults
%  _ Ku = upper pinnging point of the mezzanine 
%  _ Kd = lower pinnging point of the mezzanine 
%  _ recovery = recovery in case of default on single name
% 
%OUTPUT
%  _ p_KL_app = KL price with approximate renomralization 
%  _ p_KL_ex = KL price with exact renomralization
%
p_KL_ex = zeros(size(Is));
p_KL_app = zeros(size(Is));

for i=1:length(Is)
    Is(i)
    p_KL_ex(i) =  KL_Vasicek(corr,p,Ku,Kd,recovery,Is(i),2);
    p_KL_app(i) =  KL_Vasicek(corr,p,Ku,Kd,recovery,Is(i),1);
end

figure
semilogx(Is,p_KL_ex,'b-','LineWidth',2)
title('Numerical normalization error')
hold on
semilogx(Is,p_KL_app,'go-','LineWidth',2,'MarkerSize',10)
grid on
ylabel("Price")
yyaxis right
semilogx(Is,abs(p_KL_app-p_KL_ex)*100,'d--')
legend('Ex','App','err')
xlabel("Number of mortages")
ylabel("err (bps)")

end

