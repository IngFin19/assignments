function [] = plot_results_vasicek(Is,p_LHP,p_HP,p_KL,Kd,Ku)
%plots the prices for different models
%
%INPUTS
%  _ Is = vector of number of mortages
%  _ p_LHP = Vasiceck price with large assumption
%  _ p_HP = Vasiceck price with large ptf assumption
%  _ p_KL = Vasiceck price with KL formula
%  _ Kd = lower pinning point of the tranche
%  _ Ku = upper pinning point of the tranche

    figure
    semilogx(Is,p_LHP,'b-','LineWidth',2)
    hold on
    semilogx(Is,p_HP,'go-','LineWidth',2,'MarkerSize',10)
    semilogx(Is,p_KL,'rd-','LineWidth',2)
    grid on
    legend('LHP','HP','KL')
    title('Tranche price for MBS in Vasicek, K_d='+string(Kd*100)+'%,K_u='+...
        string(Ku*100)+'%')
    xlabel('Number of mortages')
    ylabel('Price')
end

