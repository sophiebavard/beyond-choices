%% Sophie BAVARD -- Jan 2023
 
clear

Colors(1,:)=[196 227 125]/255;
Colors(2,:)=[90 186 167]/255;
Colors(3,:)=[49 130 188]/255;
Colors(4,:)=[94 79 162]/255;

%%

model = load('data_fitting_BO.mat');

learning_data = load('data_fig.mat');

[~,order] = sort(learning_data.pref_dict);

pref_data  = learning_data.estimations(:,order)';
pref_data1 = learning_data.estimations_cond1(:,order)';
pref_data2 = learning_data.estimations_cond2(:,order)';
pref_data3 = learning_data.estimations_cond3(:,order)';
pref_data4 = learning_data.estimations_cond4(:,order)';

left_data  = mean(model.predictionsL(:,order,:),3)';
left_sim  = mean(model.sim_left(:,order,:),3)';

pref_sim1 = model.sim_pref1(:,order)';
pref_sim2 = model.sim_pref2(:,order)';
pref_sim3 = model.sim_pref3(:,order)';
pref_sim4 = model.sim_pref4(:,order)';
pref_mAv1 = squeeze(mean(model.learned_pref1))';
pref_mAv2 = squeeze(mean(model.learned_pref2))';
pref_mAv3 = squeeze(mean(model.learned_pref3))';
pref_mAv4 = squeeze(mean(model.learned_pref4))';



%% Figure 4A,D: estimation accuracy

figure;

SurfaceCurvePlot(learning_data.acc_obs_cond4',NaN,Colors(1,:),1,.3,0.5,1,10,'','',''); xlim([1 4]);
hold on
SurfaceCurvePlot(learning_data.acc_obs_cond3',NaN,Colors(2,:),1,.3,0.5,1,10,'','',''); xlim([1 4]);
hold on
SurfaceCurvePlot(learning_data.acc_obs_cond2',NaN,Colors(3,:),1,.3,0.5,1,10,'','',''); xlim([1 4]);
hold on
SurfaceCurvePlot(learning_data.acc_obs_cond1',NaN,Colors(4,:),1,.3,0.5,1,10,'','',''); xlim([1 4]); yline(mean(learning_data.chance_level),':k');
hold on

SurfaceCurvePlot_model2(nanmean(model.accuracy_pref4,3),NaN,Colors(1,:),1,.3,0.5,1,12,'','','');
hold on
SurfaceCurvePlot_model2(nanmean(model.accuracy_pref3,3),NaN,Colors(2,:),1,.3,0.5,1,12,'','','');
hold on
SurfaceCurvePlot_model2(nanmean(model.accuracy_pref2,3),NaN,Colors(3,:),1,.3,0.5,1,12,'','','');
hold on
SurfaceCurvePlot_model2(nanmean(model.accuracy_pref1,3),NaN,Colors(4,:),1,.3,0.5,1,12,'','','');

hold off
legend('none','','','RT','','','Ch','','','both','','','Location','southeast')
set(gca,'XTick',1:4,'XTickLabel',{'','','',''});

box off
pbaspect([1 1 1]);

%%

last=[learning_data.acc_obs_cond4(:,4);learning_data.acc_obs_cond3(:,4);learning_data.acc_obs_cond2(:,4);learning_data.acc_obs_cond1(:,4)];
last_model=[nanmean(model.accuracy_pref4(4,:,:),3)';nanmean(model.accuracy_pref3(4,:,:),3)';nanmean(model.accuracy_pref2(4,:,:),3)';nanmean(model.accuracy_pref1(4,:,:),3)'];

all=[learning_data.acc_obs_cond4(:);learning_data.acc_obs_cond3(:);learning_data.acc_obs_cond2(:);learning_data.acc_obs_cond1(:)];
all_model=[reshape(nanmean(model.accuracy_pref4,3)',46*4,1);reshape(nanmean(model.accuracy_pref3,3)',46*4,1);reshape(nanmean(model.accuracy_pref2,3)',46*4,1);reshape(nanmean(model.accuracy_pref1,3)',46*4,1)];


%% Figure 4B,E: accuracy model vs data (last estimation only)

figure;
for i=1:46
    scatter((learning_data.acc_obs_cond4(i,4)),(nanmean(model.accuracy_pref4(4,i,:),3)),'MarkerFaceColor',Colors(1,:),'MarkerEdgeColor',Colors(1,:));
    hold on
    scatter((learning_data.acc_obs_cond3(i,4)),(nanmean(model.accuracy_pref3(4,i,:),3)),'MarkerFaceColor',Colors(2,:),'MarkerEdgeColor',Colors(2,:));
    hold on
    scatter((learning_data.acc_obs_cond2(i,4)),(nanmean(model.accuracy_pref2(4,i,:),3)),'MarkerFaceColor',Colors(3,:),'MarkerEdgeColor',Colors(3,:));
    hold on
    scatter((learning_data.acc_obs_cond1(i,4)),(nanmean(model.accuracy_pref1(4,i,:),3)),'MarkerFaceColor',Colors(4,:),'MarkerEdgeColor',Colors(4,:));
    hold on
end

xlim([0.2 1]); xticks(.2:.2:1);
ylim([0.2 1]); yticks(.2:.2:1);
line([0 1],[0 1],'Color','k','LineStyle',':');
pbaspect([1 1 1]);


%% Supp. Figure 4B: p(choose left)

ColorPred=[0 153 204]/255;

figure;

for i = 1:length(mean(left_data,2))
    errorbar(mean(left_data(i,:)),mean(left_sim(i,:)),sem(left_data(i,:)),sem(left_data(i,:)),sem(left_sim(i,:)),sem(left_sim(i,:)),'Color',ColorPred);
    hold on
end
scatterCorrColorSpear(mean(left_data,2),mean(left_sim,2),1,0,30,ColorPred); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
box off

%% Supp. Figure 4C: correlation data/model per condition (last)

figure;
set(gcf,'position',[100,100,650,650])

subplot(2,2,1)
scatterCorrColorSpear(pref_data4(~isnan(pref_data4(:))),pref_sim4(~isnan(pref_sim4(:))),1,0,30,Colors(1,:)); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
box off

subplot(2,2,2)
scatterCorrColorSpear(pref_data3(~isnan(pref_data3(:))),pref_sim3(~isnan(pref_sim3(:))),1,0,30,Colors(2,:)); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
box off

subplot(2,2,3)
scatterCorrColorSpear(pref_data2(~isnan(pref_data2(:))),pref_sim2(~isnan(pref_sim2(:))),1,0,30,Colors(3,:)); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
box off

subplot(2,2,4)
scatterCorrColorSpear(pref_data1(~isnan(pref_data1(:))),pref_sim1(~isnan(pref_sim1(:))),1,0,30,Colors(4,:)); xlim([0,1]); ylim([0,1]); pbaspect([1 1 1]);
box off

%% Supp. Figure 5: accuracy model vs data (last estimation only)

limits4 = [0.3 1];
limits3 = [0.5 1];
limits2 = [0.7 1];
limits1 = [0.7 1];

figure;
set(gcf,'position',[100,100,650,650])

subplot(2,2,1)
scatterCorrColorSpear(learning_data.acc_obs_cond4(:,4),nanmean(model.accuracy_pref4(4,:,:),3)',1,0,30,Colors(1,:)); xlim(limits4); ylim(limits4); pbaspect([1 1 1]);
subplot(2,2,2)
scatterCorrColorSpear(learning_data.acc_obs_cond3(:,4),nanmean(model.accuracy_pref3(4,:,:),3)',1,0,30,Colors(2,:)); xlim(limits3); ylim(limits3); pbaspect([1 1 1]);
subplot(2,2,3)
scatterCorrColorSpear(learning_data.acc_obs_cond2(:,4),nanmean(model.accuracy_pref2(4,:,:),3)',1,0,30,Colors(3,:)); xlim(limits2); ylim(limits2); pbaspect([1 1 1]);
subplot(2,2,4)
scatterCorrColorSpear(learning_data.acc_obs_cond1(:,4),nanmean(model.accuracy_pref1(4,:,:),3)',1,0,30,Colors(4,:)); xlim(limits1); ylim(limits1); pbaspect([1 1 1]);

%%

function s = sem(x)
s = nanstd(x)/sqrt(length(x));
end

