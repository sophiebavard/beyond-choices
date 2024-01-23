function [curve sem] = SurfaceCurvePlot(DataMatrix,Chance,Color,Line,Alpha,Yinf,Ysup,Font,Title,LabelX,LabelY)

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
% plot(curve+sem,...
%     'Color',Color,...
%     'LineWidth',Line);
% hold on
% plot(curve-sem,...
%     'Color',Color,...
%     'LineWidth',Line);
% hold on
plot(curve,...
    'Color',Color,...
    'LineWidth',Line*2);
hold on
fill([1:Ntrial flipud([1:Ntrial]')'],[curveSup' flipud(curveInf)'],'k',...
    'LineWidth',1,...
    'LineStyle','none',...
    'FaceColor',Color,...
    'FaceAlpha',Alpha);
plot(chance,'k:',...
    'LineWidth',Line/4);
axis([0 Ntrial+1 Yinf Ysup]);
set(gca,'Fontsize',Font);
title(Title);
xlabel(LabelX);
ylabel(LabelY);
box ON