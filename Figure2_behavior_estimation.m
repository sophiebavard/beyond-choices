%% Sophie BAVARD -- Jan 2023
 
clear

load data_fig.mat

%% Rearrange some variables

accuracy_estim=[nanmean(acc_cond4);nanmean(acc_cond3);nanmean(acc_cond2);nanmean(acc_cond1)];

dict1 = truePref_cond1(:);
dict2 = truePref_cond2(:);
dict3 = truePref_cond3(:);
dict4 = truePref_cond4(:);

estim1 = estim_cond1(:);
estim2 = estim_cond2(:);
estim3 = estim_cond3(:);
estim4 = estim_cond4(:);

Colors(1,:)=[196 227 125]/255;
Colors(2,:)=[90 186 167]/255;
Colors(3,:)=[49 130 188]/255;
Colors(4,:)=[94 79 162]/255;

%% Figure 1A: Learning curves

figure;
subplot(1,2,1)
SurfaceCurvePlot(acc_obs_cond4',10,Colors(1,:),1,.3,0.4,1,10,'','',''); xlim([1 4]);
hold on
SurfaceCurvePlot(acc_obs_cond3',10,Colors(2,:),1,.3,0.4,1,10,'','',''); xlim([1 4]);
hold on
SurfaceCurvePlot(acc_obs_cond2',10,Colors(3,:),1,.3,0.4,1,10,'','',''); xlim([1 4]);
hold on
SurfaceCurvePlot(acc_obs_cond1',10,Colors(4,:),1,.3,0.4,1,10,'','',''); xlim([1 4]); yline(mean(chance_level),':k');
set(gca,'XTick',1:4,'XTickLabel',{'','','',''});
hold off
legend('none','','','RT','','','Ch','','','both','','','Location','southeast')
box off

subplot(1,2,2)
violinplotSB(accuracy_estim,Colors,0.4,1,10,'','',''); yline(mean(chance_level),':k');
box off

%% Figure 1B: Correlation per condition

figure;
subplot(2,2,1)
scatterCorrColorSpear(dict4(4:4:end),estim4(4:4:end),1,0,30,Colors(1,:)); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
subplot(2,2,2)
scatterCorrColorSpear(dict3(4:4:end),estim3(4:4:end),1,0,30,Colors(2,:)); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
subplot(2,2,3)
scatterCorrColorSpear(dict2(4:4:end),estim2(4:4:end),1,0,30,Colors(3,:)); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
subplot(2,2,4)
scatterCorrColorSpear(dict1(4:4:end),estim1(4:4:end),1,0,30,Colors(4,:)); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
set(gcf,'position',[100,100,650,650])

%% Supp. Figure 3: Correlation per condition, per dictator (averaged over observers)

figure;
subplot(2,2,1)
scatterCorrColorSpear(pref_dict',nanmean(estimations_cond4)',1,0,30,Colors(1,:)); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
subplot(2,2,2)
scatterCorrColorSpear(pref_dict',nanmean(estimations_cond3)',1,0,30,Colors(2,:)); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
subplot(2,2,3)
scatterCorrColorSpear(pref_dict',nanmean(estimations_cond2)',1,0,30,Colors(3,:)); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
subplot(2,2,4)
scatterCorrColorSpear(pref_dict',nanmean(estimations_cond1)',1,0,30,Colors(4,:)); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
set(gcf,'position',[100,100,650,650])


%% Supp. Figure 2B: ObserversB estimations as a function of their own preference

figure;
subplot(2,2,1)
scatterCorrColorSpear(pref_obs',mean(estim_cond4)',1,0,30,Colors(1,:)); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
subplot(2,2,2)
scatterCorrColorSpear(pref_obs',mean(estim_cond3)',1,0,30,Colors(2,:)); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
subplot(2,2,3)
scatterCorrColorSpear(pref_obs',mean(estim_cond2)',1,0,30,Colors(3,:)); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
subplot(2,2,4)
scatterCorrColorSpear(pref_obs',mean(estim_cond1)',1,0,30,Colors(4,:)); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
set(gcf,'position',[100,100,650,650])
