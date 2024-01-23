%% Sophie BAVARD -- Jan 2023
 
clear

%% estimation data
% COLUMN 1  = participant's number
% COLUMN 2  = condition (1 = both, 2 = ch, 3 = RT, 4 = none)
% COLUMN 3  = estimation number
% COLUMN 4  = dictator's number
% COLUMN 5  = dictator's preferred allocation
% COLUMN 6  = estimated allocation
% COLUMN 7  = response time
% COLUMN 8  = prediction accuracy

%% prediction data
% COLUMN 1  = participant's number
% COLUMN 2  = condition (1 = both, 2 = ch, 3 = RT, 4 = none)
% COLUMN 3  = dictator's number
% COLUMN 4  = dictator's choice (-1 = left, 1 = right)
% COLUMN 5  = dictator's response time
% COLUMN 6  = left split
% COLUMN 7  = right split
% COLUMN 8  = participant's choice (-1 = left, 1 = right)
% COLUMN 9  = participant's response time
% COLUMN 10 = participant's last PA estimation
% COLUMN 11 = short/long trial (0=short, 1=long)
% COLUMN 12 = observer's choice for own trial (choose for self, not prediction)
% COLUMN 13 = observer's RT for own trial (choose for self, not prediction)
% COLUMN 14 = observer's similarity with dictator

%% time perception data
% COLUMN 1  = participant's number
% COLUMN 2  = choice (-1 = second shorter, 1 = second longer)
% COLUMN 3  = response time
% COLUMN 4  = first duration
% COLUMN 5  = second duration
% COLUMN 6  = accuracy

subjects = 1:46;

sub=0;
chrt=[]; onlyCh=[]; onlyRT=[]; none=[]; RT_chrt=[]; RT_onlyCh=[]; RT_onlyRT=[]; RT_none=[];

estimations_cond1=NaN(numel(subjects),16);
estimations_cond2=NaN(numel(subjects),16);
estimations_cond3=NaN(numel(subjects),16);
estimations_cond4=NaN(numel(subjects),16);

for nsub = subjects

    sub = sub+1;

    % Load data
    load data_observeDG.mat

    data_sub_esti = dataEsti(dataEsti(:,1)==nsub,:);
    data_sub_pred = dataPred(dataPred(:,1)==nsub,:);
    data_sub_TP   = dataTP(dataTP(:,1)==nsub,:);

    % order of the seen conditions
    condition_order(:,sub)=unique(data_sub_esti(:,2),'stable');

    % accuracy in estimating the PA
    acc_cond1(:,sub) = data_sub_esti(data_sub_esti(:,2)==1,8);
    acc_cond2(:,sub) = data_sub_esti(data_sub_esti(:,2)==2,8);
    acc_cond3(:,sub) = data_sub_esti(data_sub_esti(:,2)==3,8);
    acc_cond4(:,sub) = data_sub_esti(data_sub_esti(:,2)==4,8);
    acc_overall(:,sub) = data_sub_esti(:,8);

    % average accuracy per observer per condition
    for t=1:4
        acc_obs_cond1(sub,t) = nanmean(data_sub_esti(data_sub_esti(:,2)==1 & data_sub_esti(:,3)==t,8));
        acc_obs_cond2(sub,t) = nanmean(data_sub_esti(data_sub_esti(:,2)==2 & data_sub_esti(:,3)==t,8));
        acc_obs_cond3(sub,t) = nanmean(data_sub_esti(data_sub_esti(:,2)==3 & data_sub_esti(:,3)==t,8));
        acc_obs_cond4(sub,t) = nanmean(data_sub_esti(data_sub_esti(:,2)==4 & data_sub_esti(:,3)==t,8));
    end

    % true pref
    truePref_cond1(:,sub) = data_sub_esti(data_sub_esti(:,2)==1,5);
    truePref_cond2(:,sub) = data_sub_esti(data_sub_esti(:,2)==2,5);
    truePref_cond3(:,sub) = data_sub_esti(data_sub_esti(:,2)==3,5);
    truePref_cond4(:,sub) = data_sub_esti(data_sub_esti(:,2)==4,5);

    % estimated PA
    estim_cond1(:,sub) = data_sub_esti(data_sub_esti(:,2)==1,6);
    estim_cond2(:,sub) = data_sub_esti(data_sub_esti(:,2)==2,6);
    estim_cond3(:,sub) = data_sub_esti(data_sub_esti(:,2)==3,6);
    estim_cond4(:,sub) = data_sub_esti(data_sub_esti(:,2)==4,6);

    % estimation RT
    RT_estim_cond1(:,sub) = data_sub_esti(data_sub_esti(:,2)==1,7);
    RT_estim_cond2(:,sub) = data_sub_esti(data_sub_esti(:,2)==2,7);
    RT_estim_cond3(:,sub) = data_sub_esti(data_sub_esti(:,2)==3,7);
    RT_estim_cond4(:,sub) = data_sub_esti(data_sub_esti(:,2)==4,7);

    % last estimation per dictator per condition
    for dict = 1:16

        estimations(sub,dict)=data_sub_esti(find(data_sub_esti(:,4)==dict,1,'last'),6);

        if data_sub_esti(find(data_sub_esti(:,4)==dict,1,'last'),2)==1
            estimations_cond1(sub,dict)=data_sub_esti(find(data_sub_esti(:,4)==dict,1,'last'),6);
        elseif data_sub_esti(find(data_sub_esti(:,4)==dict,1,'last'),2)==2
            estimations_cond2(sub,dict)=data_sub_esti(find(data_sub_esti(:,4)==dict,1,'last'),6);
        elseif data_sub_esti(find(data_sub_esti(:,4)==dict,1,'last'),2)==3
            estimations_cond3(sub,dict)=data_sub_esti(find(data_sub_esti(:,4)==dict,1,'last'),6);
        elseif data_sub_esti(find(data_sub_esti(:,4)==dict,1,'last'),2)==4
            estimations_cond4(sub,dict)=data_sub_esti(find(data_sub_esti(:,4)==dict,1,'last'),6);
        end

        if data_sub_esti(find(data_sub_esti(:,4)==dict,1,'first'),2)==1
            estim_first_cond1(dict,sub)= data_sub_esti(find(data_sub_esti(:,4)==dict,1,'first'),6);
        elseif data_sub_esti(find(data_sub_esti(:,4)==dict,1,'first'),2)==2
            estim_first_cond2(dict,sub)= data_sub_esti(find(data_sub_esti(:,4)==dict,1,'first'),6);
        elseif data_sub_esti(find(data_sub_esti(:,4)==dict,1,'first'),2)==3
            estim_first_cond3(dict,sub)= data_sub_esti(find(data_sub_esti(:,4)==dict,1,'first'),6);
        elseif data_sub_esti(find(data_sub_esti(:,4)==dict,1,'first'),2)==4
            estim_first_cond4(dict,sub)= data_sub_esti(find(data_sub_esti(:,4)==dict,1,'first'),6);
        end
    end

    % accuracy in choice prediction
    acc_pred_cond1(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==1,4)==data_sub_pred(data_sub_pred(:,2)==1,8));
    acc_pred_cond2(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==2,4)==data_sub_pred(data_sub_pred(:,2)==2,8));
    acc_pred_cond3(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==3,4)==data_sub_pred(data_sub_pred(:,2)==3,8));
    acc_pred_cond4(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==4,4)==data_sub_pred(data_sub_pred(:,2)==4,8));

    % RTs in choice prediction

    % long trials, dictators
    pred_dict_long1(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==1,5);
    pred_dict_long2(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==1,5);
    pred_dict_long3(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==1,5);
    pred_dict_long4(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==1,5);
    % short trials, dictators
    pred_dict_short1(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==0,5);
    pred_dict_short2(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==0,5);
    pred_dict_short3(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==0,5);
    pred_dict_short4(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==0,5);

    % long trials, participants
    pred_obs_long1(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==1,9);
    pred_obs_long2(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==1,9);
    pred_obs_long3(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==1,9);
    pred_obs_long4(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==1,9);
    % short trials, participants
    pred_obs_short1(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==0,9);
    pred_obs_short2(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==0,9);
    pred_obs_short3(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==0,9);
    pred_obs_short4(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==0,9);

    % compare predictions RT with actual RT

    % long trials, participants
    pred_own_long1(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==1,13);
    pred_own_long2(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==1,13);
    pred_own_long3(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==1,13);
    pred_own_long4(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==1,13);
    % short trials, participants
    pred_own_short1(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==0,13);
    pred_own_short2(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==0,13);
    pred_own_short3(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==0,13);
    pred_own_short4(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==0,13);

    % which dictator was seen in each condition
    observed_dictator1(:,sub) = data_sub_esti(data_sub_esti(:,2)==1 & data_sub_esti(:,3)==1,4);
    observed_dictator2(:,sub) = data_sub_esti(data_sub_esti(:,2)==2 & data_sub_esti(:,3)==1,4);
    observed_dictator3(:,sub) = data_sub_esti(data_sub_esti(:,2)==3 & data_sub_esti(:,3)==1,4);
    observed_dictator4(:,sub) = data_sub_esti(data_sub_esti(:,2)==4 & data_sub_esti(:,3)==1,4);

    % similarity between dictator and observer
    for dict = 1:16
        similarity(dict,sub) = 1 - abs(pref_obs(sub)-pref_dict(dict));
    end

    % similarity per condition
    similarity1(:,sub) = similarity(observed_dictator1(:,sub),sub);
    similarity2(:,sub) = similarity(observed_dictator2(:,sub),sub);
    similarity3(:,sub) = similarity(observed_dictator3(:,sub),sub);
    similarity4(:,sub) = similarity(observed_dictator4(:,sub),sub);

    % split accuracy by similarity

    % long trials, similar
    pred_acc_long1simi(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity1(:,sub)),4)==data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity1(:,sub)),8));
    pred_acc_long2simi(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity2(:,sub)),4)==data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity2(:,sub)),8));
    pred_acc_long3simi(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity3(:,sub)),4)==data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity3(:,sub)),8));
    pred_acc_long4simi(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity4(:,sub)),4)==data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity4(:,sub)),8));
    % long trials, dissimilar
    pred_acc_long1diss(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity1(:,sub)),4)==data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity1(:,sub)),8));
    pred_acc_long2diss(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity2(:,sub)),4)==data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity2(:,sub)),8));
    pred_acc_long3diss(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity3(:,sub)),4)==data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity3(:,sub)),8));
    pred_acc_long4diss(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity4(:,sub)),4)==data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity4(:,sub)),8));
    % short trials, similar
    pred_acc_short1simi(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity1(:,sub)),4)==data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity1(:,sub)),8));
    pred_acc_short2simi(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity2(:,sub)),4)==data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity2(:,sub)),8));
    pred_acc_short3simi(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity3(:,sub)),4)==data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity3(:,sub)),8));
    pred_acc_short4simi(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity4(:,sub)),4)==data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity4(:,sub)),8));
    % short trials, dissimilar
    pred_acc_short1diss(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity1(:,sub)),4)==data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity1(:,sub)),8));
    pred_acc_short2diss(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity2(:,sub)),4)==data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity2(:,sub)),8));
    pred_acc_short3diss(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity3(:,sub)),4)==data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity3(:,sub)),8));
    pred_acc_short4diss(:,sub) = double(data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity4(:,sub)),4)==data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity4(:,sub)),8));

    % split RT by similarity

    % long trials, similar
    pred_dict_long1simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity1(:,sub)),5);
    pred_dict_long2simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity2(:,sub)),5);
    pred_dict_long3simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity3(:,sub)),5);
    pred_dict_long4simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity4(:,sub)),5);
    % long trials, dissimilar
    pred_dict_long1diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity1(:,sub)),5);
    pred_dict_long2diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity2(:,sub)),5);
    pred_dict_long3diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity3(:,sub)),5);
    pred_dict_long4diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity4(:,sub)),5);

    % short trials, similar
    pred_dict_short1simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity1(:,sub)),5);
    pred_dict_short2simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity2(:,sub)),5);
    pred_dict_short3simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity3(:,sub)),5);
    pred_dict_short4simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity4(:,sub)),5);
    % short trials, dissimilar
    pred_dict_short1diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity1(:,sub)),5);
    pred_dict_short2diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity2(:,sub)),5);
    pred_dict_short3diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity3(:,sub)),5);
    pred_dict_short4diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity4(:,sub)),5);

    % long trials, similar
    pred_sub_long1simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity1(:,sub)),9);
    pred_sub_long2simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity2(:,sub)),9);
    pred_sub_long3simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity3(:,sub)),9);
    pred_sub_long4simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity4(:,sub)),9);
    % long trials, dissimilar
    pred_sub_long1diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity1(:,sub)),9);
    pred_sub_long2diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity2(:,sub)),9);
    pred_sub_long3diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity3(:,sub)),9);
    pred_sub_long4diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity4(:,sub)),9);

    % short trials, similar
    pred_sub_short1simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity1(:,sub)),9);
    pred_sub_short2simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity2(:,sub)),9);
    pred_sub_short3simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity3(:,sub)),9);
    pred_sub_short4simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity4(:,sub)),9);
    % short trials, dissimilar
    pred_sub_short1diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity1(:,sub)),9);
    pred_sub_short2diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity2(:,sub)),9);
    pred_sub_short3diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity3(:,sub)),9);
    pred_sub_short4diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity4(:,sub)),9);

    % long trials, similar
    pred_own_long1simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity1(:,sub)),13);
    pred_own_long2simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity2(:,sub)),13);
    pred_own_long3simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity3(:,sub)),13);
    pred_own_long4simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)>median(similarity4(:,sub)),13);
    % long trials, dissimilar
    pred_own_long1diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity1(:,sub)),13);
    pred_own_long2diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity2(:,sub)),13);
    pred_own_long3diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity3(:,sub)),13);
    pred_own_long4diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==1 & data_sub_pred(:,14)<median(similarity4(:,sub)),13);

    % short trials, similar
    pred_own_short1simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity1(:,sub)),13);
    pred_own_short2simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity2(:,sub)),13);
    pred_own_short3simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity3(:,sub)),13);
    pred_own_short4simi(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)>median(similarity4(:,sub)),13);
    % short trials, dissimilar
    pred_own_short1diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==1 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity1(:,sub)),13);
    pred_own_short2diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==2 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity2(:,sub)),13);
    pred_own_short3diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==3 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity3(:,sub)),13);
    pred_own_short4diss(:,sub) = data_sub_pred(data_sub_pred(:,2)==4 & data_sub_pred(:,11)==0 & data_sub_pred(:,14)<median(similarity4(:,sub)),13);


    % choice prediction compared to estimated allocation
    % correct if the chosen split is the closest to the last predicted allocation
    pred_estim_cond1(:,sub) = double( (abs(data_sub_pred(data_sub_pred(:,2)==1,6)-data_sub_pred(data_sub_pred(:,2)==1,10)) <= abs(data_sub_pred(data_sub_pred(:,2)==1,7)-data_sub_pred(data_sub_pred(:,2)==1,10)) & data_sub_pred(data_sub_pred(:,2)==1,8)==-1) | ...
        (abs(data_sub_pred(data_sub_pred(:,2)==1,6)-data_sub_pred(data_sub_pred(:,2)==1,10)) >= abs(data_sub_pred(data_sub_pred(:,2)==1,7)-data_sub_pred(data_sub_pred(:,2)==1,10)) & data_sub_pred(data_sub_pred(:,2)==1,8)==1) );
    pred_estim_cond2(:,sub) = double( (abs(data_sub_pred(data_sub_pred(:,2)==2,6)-data_sub_pred(data_sub_pred(:,2)==2,10)) <= abs(data_sub_pred(data_sub_pred(:,2)==2,7)-data_sub_pred(data_sub_pred(:,2)==2,10)) & data_sub_pred(data_sub_pred(:,2)==2,8)==-1) | ...
        (abs(data_sub_pred(data_sub_pred(:,2)==2,6)-data_sub_pred(data_sub_pred(:,2)==2,10)) >= abs(data_sub_pred(data_sub_pred(:,2)==2,7)-data_sub_pred(data_sub_pred(:,2)==2,10)) & data_sub_pred(data_sub_pred(:,2)==2,8)==1) );
    pred_estim_cond3(:,sub) = double( (abs(data_sub_pred(data_sub_pred(:,2)==3,6)-data_sub_pred(data_sub_pred(:,2)==3,10)) <= abs(data_sub_pred(data_sub_pred(:,2)==3,7)-data_sub_pred(data_sub_pred(:,2)==3,10)) & data_sub_pred(data_sub_pred(:,2)==3,8)==-1) | ...
        (abs(data_sub_pred(data_sub_pred(:,2)==3,6)-data_sub_pred(data_sub_pred(:,2)==3,10)) >= abs(data_sub_pred(data_sub_pred(:,2)==3,7)-data_sub_pred(data_sub_pred(:,2)==3,10)) & data_sub_pred(data_sub_pred(:,2)==3,8)==1) );
    pred_estim_cond4(:,sub) = double( (abs(data_sub_pred(data_sub_pred(:,2)==4,6)-data_sub_pred(data_sub_pred(:,2)==4,10)) <= abs(data_sub_pred(data_sub_pred(:,2)==4,7)-data_sub_pred(data_sub_pred(:,2)==4,10)) & data_sub_pred(data_sub_pred(:,2)==4,8)==-1) | ...
        (abs(data_sub_pred(data_sub_pred(:,2)==4,6)-data_sub_pred(data_sub_pred(:,2)==4,10)) >= abs(data_sub_pred(data_sub_pred(:,2)==4,7)-data_sub_pred(data_sub_pred(:,2)==4,10)) & data_sub_pred(data_sub_pred(:,2)==4,8)==1) );

    % reshape each condition
    chrt   = [chrt; reshape(acc_cond1(:,sub),4,4)'];
    onlyCh = [onlyCh; reshape(acc_cond2(:,sub),4,4)'];
    onlyRT = [onlyRT; reshape(acc_cond3(:,sub),4,4)'];
    none   = [none; reshape(acc_cond4(:,sub),4,4)'];

    % reshape each condition
    RT_chrt   = [RT_chrt; reshape(RT_estim_cond1(:,sub),4,4)'];
    RT_onlyCh = [RT_onlyCh; reshape(RT_estim_cond2(:,sub),4,4)'];
    RT_onlyRT = [RT_onlyRT; reshape(RT_estim_cond3(:,sub),4,4)'];
    RT_none   = [RT_none; reshape(RT_estim_cond4(:,sub),4,4)'];

    % time perception accuracy
    TPcond250(:,sub) = data_sub_TP(abs(data_sub_TP(:,4)-data_sub_TP(:,5))==0.25,6);
    TPcond500(:,sub) = data_sub_TP(abs(data_sub_TP(:,4)-data_sub_TP(:,5))==0.50,6);
    TPcond750(:,sub) = data_sub_TP(abs(data_sub_TP(:,4)-data_sub_TP(:,5))==0.75,6);

end


%% Empirical chance level

guess=0:0.0001:1;
for i=1:length(guess)
    chance(i,:)=1-abs(pref_dict-guess(i));
end

chance_level=mean(chance); clear chance guess


%% Save variables for plotting

save data_fig

