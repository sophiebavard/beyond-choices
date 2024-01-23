function [curve sem] = SurfaceCurvePlot_model2(DataMatrix,Chance,Color,Line,Alpha,Yinf,Ysup,Font,Title,LabelX,LabelY)

[Ntrial Nsub]=size(DataMatrix);

if Nsub>1
    curve= nanmean(DataMatrix,2);
    sem  = nanstd(DataMatrix')'/sqrt(Nsub);
else
    curve=DataMatrix;
    sem=0;
end

curveSup = (curve+sem);
curveInf = (curve-sem);

for n=1:Ntrial
    for c = 1:length(Chance)
        chance(n,c)=Chance(c);
    end
end

if Line>0
    errorbar(1:Ntrial,curve,sem,...
        '-o',...
        'Color',Color,...
        'MarkerSize',8,...
        'MarkerFaceColor',Color,...
        'MarkerEdgeColor','k',...
        'LineWidth',Line);
else
    errorbar(1:Ntrial,curve,sem,...
        'o',...
        'Color','k',...
        'MarkerSize',8,...
        'MarkerFaceColor',Color,...
        'MarkerEdgeColor','k');
end

hold on
plot(chance,'k:',...
    'LineWidth',.25);
axis([0 Ntrial+1 Yinf Ysup]);
set(gca,'Fontsize',Font);
title(Title);
xlabel(LabelX);
ylabel(LabelY);
box ON