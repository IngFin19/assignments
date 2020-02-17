function plot_probability(SetDate,datesCDS,survProbs1,survProbs2,survProbs3)
    figure()
    plot([SetDate; datesCDS], [1;survProbs1],'o--')
    hold on
    plot([SetDate; datesCDS], [1;survProbs2],'o--')
    plot([SetDate; datesCDS], [1;survProbs3],'o--')
    legend('approx','exact','JT')
    datetick('x','mmm-yy','keepticks')
    title('Survival Probability')
    grid on
end

