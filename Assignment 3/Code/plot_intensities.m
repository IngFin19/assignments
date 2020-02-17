function plot_intensities(SetDate,datesCDS,intensities1,intensities2,intensities3)
%Compute the plot for a CDS intensity
%Input
% SetDate = Settlement Date 
%  _ datesCDS = CDS payment dates 
%  _ intensities 1 = intensity parameter of the exponential
%  _ intensities 2 = intensity parameter of the exponential
% _ intensities 3 = intensity parameter of the exponential

    figure()
    ax = axes;
    stairs([SetDate;datesCDS],[intensities1;intensities1(end)],'s-','LineWidth',1);
    hold on
    stairs([SetDate;datesCDS],[intensities2;intensities2(end)],'s-','LineWidth',1);
    numberOfColors = length(ax.ColorOrder);
    ax.ColorOrderIndex = 3;
    for i=1:length(datesCDS)
        stairs([SetDate;datesCDS(i)],[intensities3(i);intensities3(i)],'o-','LineWidth',1);
        ax.ColorOrderIndex = mod(ax.ColorOrderIndex-2,numberOfColors)+1;
    end
    legend('approx','exact','JT')
    datetick('x','mmm-yy','keepticks')
    title('Hazard Rates')
    grid on
end

