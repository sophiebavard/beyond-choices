%% Sophie BAVARD -- Jan 2023
 
clear

load data_fig.mat

%% Rearrange some variables

accuracy_predi=[nanmean(acc_pred_cond4);nanmean(acc_pred_cond3);nanmean(acc_pred_cond2);nanmean(acc_pred_cond1)];
consistency_predi=[nanmean(pred_estim_cond4);nanmean(pred_estim_cond3);nanmean(pred_estim_cond2);nanmean(pred_estim_cond1)];

pred_RT_dict = [mean(pred_dict_short4);mean(pred_dict_long4);mean(pred_dict_short3);mean(pred_dict_long3);mean(pred_dict_short2);mean(pred_dict_long2);mean(pred_dict_short1);mean(pred_dict_long1)];
pred_RT_obs = [mean(pred_obs_short4);mean(pred_obs_long4);mean(pred_obs_short3);mean(pred_obs_long3);mean(pred_obs_short2);mean(pred_obs_long2);mean(pred_obs_short1);mean(pred_obs_long1)];
pred_RT_own = [mean(pred_own_short4);mean(pred_own_long4);mean(pred_own_short3);mean(pred_own_long3);mean(pred_own_short2);mean(pred_own_long2);mean(pred_own_short1);mean(pred_own_long1)];

pred_RT_obs_simi = [mean(pred_sub_short4simi);mean(pred_sub_long4simi);mean(pred_sub_short3simi);mean(pred_sub_long3simi);mean(pred_sub_short2simi);mean(pred_sub_long2simi);mean(pred_sub_short1simi);mean(pred_sub_long1simi)];
pred_RT_obs_diss = [mean(pred_sub_short4diss);mean(pred_sub_long4diss);mean(pred_sub_short3diss);mean(pred_sub_long3diss);mean(pred_sub_short2diss);mean(pred_sub_long2diss);mean(pred_sub_short1diss);mean(pred_sub_long1diss)];

pred_RT_own_simi = [mean(pred_own_short4simi);mean(pred_own_long4simi);mean(pred_own_short3simi);mean(pred_own_long3simi);mean(pred_own_short2simi);mean(pred_own_long2simi);mean(pred_own_short1simi);mean(pred_own_long1simi)];
pred_RT_own_diss = [mean(pred_own_short4diss);mean(pred_own_long4diss);mean(pred_own_short3diss);mean(pred_own_long3diss);mean(pred_own_short2diss);mean(pred_own_long2diss);mean(pred_own_short1diss);mean(pred_own_long1diss)];

Colors(1,:)=[196 227 125]/255;
Colors(2,:)=[90 186 167]/255;
Colors(3,:)=[49 130 188]/255;
Colors(4,:)=[94 79 162]/255;

%% Accuracy and Consistency

figure;
% Figure 3A: accuracy
subplot(1,2,1)
violinplotSB(accuracy_predi,Colors,0,1,10,'','','','');
box off

% Figure 3B: consistency
subplot(1,2,2)
violinplotSB(consistency_predi,Colors,0,1,10,'','','','');
box off


%% Supp figure 1C

% Dictators' RT
figure;
violinplotSB(pred_RT_dict,Colors([1 1 2 2 3 3 4 4],:),0,5,12,'','',''); box off

%% Figure 3C: response times

% Predicting for other; similar; dissimilar
figure;
violinplotSB(pred_RT_obs,Colors([1 1 2 2 3 3 4 4],:),0,5,12,'','',''); box off
figure;
violinplotSB(pred_RT_obs_simi,Colors([1 1 2 2 3 3 4 4],:),0,5,12,'','',''); box off
figure;
violinplotSB(pred_RT_obs_diss,Colors([1 1 2 2 3 3 4 4],:),0,5,12,'','',''); box off

%% Figure 3D: response times

% Choosing for self; similar; dissimilar
figure;
violinplotSB(pred_RT_own,Colors([1 1 2 2 3 3 4 4],:),0,5,12,'','',''); box off
figure;
violinplotSB(pred_RT_own_simi,Colors([1 1 2 2 3 3 4 4],:),0,5,12,'','',''); box off
figure;
violinplotSB(pred_RT_own_diss,Colors([1 1 2 2 3 3 4 4],:),0,5,12,'','',''); box off


