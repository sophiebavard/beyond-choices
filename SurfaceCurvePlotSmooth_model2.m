function [curve sem] = SurfaceCurvePlotSmooth_model(DataMatrix,Model1_DataMatrix,Model2_DataMatrix,Chance,Color,Line,Alpha,Yinf,Ysup,Font,Title,LabelX,LabelY)

[Ntrial, Nsub]=size(DataMatrix);

curve= nanmean(DataMatrix,2);
sem  = nanstd(DataMatrix')'/sqrt(Nsub);

curve_model1= nanmean(Model1_DataMatrix,2);
curve_model2= nanmean(Model2_DataMatrix,2);
model_interval = [1 5:5:Ntrial];

curveSup = (curve+sem);
curveInf = (curve-sem);

for n=1:Ntrial
    for i = 1:length(Chance)
        chance(n,i)=Chance(i);
    end
end

plot(smooth(curve),...
    'Color',Color,....
    'LineWidth',Line*2);

hold on

fill([1:Ntrial flipud([1:Ntrial]')'],[smooth(curveSup)' smooth(flipud(curveInf))'],'k',...
    'LineWidth',1,...
    'LineStyle','none',...
    'FaceColor',Color,...
    'FaceAlpha',Alpha);

hold on
plot(model_interval,smooth(curve_model1(model_interval)),...
    'Color',Color,...
    'Marker','o',...
    'MarkerFaceColor',[1 1 1],...
    'MarkerEdgeColor','k',...
    'LineStyle','none');

hold on
plot(model_interval,smooth(curve_model2(model_interval)),...
    'Color',Color,...
    'Marker','o',...
    'MarkerFaceColor',[0 0 0],...
    'MarkerEdgeColor','k',...
    'LineStyle','none');

plot(chance,'k:',...
   'LineWidth',Line/4);
axis([0 Ntrial+1 Yinf Ysup]);

set(gca,'Fontsize',Font);
title(Title);
xlabel(LabelX);
ylabel(LabelY);
box ON