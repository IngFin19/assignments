function [] = plot_survProb(tau,CI,lambda_fit)
% plot for the survival porbabilities in y-log scale
%
%INPUT
%  _ tau = credit events times
%  _ CI = confidence interval
%  _ lambda_fit = unbiased estimator of lambda parameter

    n = length(tau);
    t = linspace(0,100,n);
    figure
    p3 = semilogy(t,exp(-t*lambda_fit),'r-','LineWidth',2);
    hold on
    semilogy(t,exp(-t.*CI(1)),'r-')
    semilogy(t,exp(-t.*CI(2)),'r-')
    x_plot =[t, fliplr(t)];
    y_plot=[exp(-t.*CI(1)), fliplr(exp(-t.*CI(2)))];
    p2 = fill(x_plot, y_plot, 1,'facecolor', 'red', 'edgecolor', 'none', 'facealpha', 0.1);
    p1 = semilogy(t,sum(sort(tau)'>t)/n,'b-','LineWidth',1.);
    title('y-log scale plot of empirical vs fitted Surv Probability')
    xlabel('Time (years)')
    ylabel('Surv Prob')
    grid on
    legend([p1,p2,p3],'Empirical Surv Prob','1-\alpha Confidence Interval','Fitted Surv Prob')
end

