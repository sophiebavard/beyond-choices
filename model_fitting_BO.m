%% Sophie BAVARD -- Jan 2023
 
clear

load data_modelling.mat

% DATA MATRIX
% COLUMN 1  = participant number
% COLUMN 2  = dictator number
% COLUMN 3  = trial number
% COLUMN 4  = proportion of won points for left option
% COLUMN 5  = proportion of won points for right option
% COLUMN 6  = choice (1 left, 2 right)
% COLUMN 7  = RT in seconds
% COLUMN 8  = participant's choice (1 left, 2 right)
% COLUMN 9  = dictator true pref
% COLUMN 10 = estimated pref
% COLUMN 11 = condition (1 = both, 2 = ch only, 3 = rt only, 4 = none)
% COLUMN 12 = phase (1=estimation, 2=prediction)

subjects = 1:46;

sub=0;

for nsub = subjects

    sub = sub+1;
    
    f=waitbar(sub/numel(subjects));

    % Load data

    data_sub = data(data(:,1)==nsub,:); 
    data_sub_obs  = data_sub(data_sub(:,12)==1,:);
    data_sub_pred = data_sub(data_sub(:,12)==2,:);
 
    for dict = 1:16

        % accuracy in the prediction
        choice_dictator(sub,dict,:)   = -(data_sub_pred(data_sub_pred(:,2)==dict,8)-2);
        % p(choose_left)
        predictionsL(sub,dict,:)   =-(data_sub_pred(data_sub_pred(:,2)==dict,6)-2);
        % p(choose_max)
        predictionsM(sub,dict,:)  = double(((data_sub_pred(data_sub_pred(:,2)==dict,6)==1) & (data_sub_pred(data_sub_pred(:,2)==dict,4)>data_sub_pred(data_sub_pred(:,2)==dict,5))) | ...
                                           ((data_sub_pred(data_sub_pred(:,2)==dict,6)==2) & (data_sub_pred(data_sub_pred(:,2)==dict,4)<data_sub_pred(data_sub_pred(:,2)==dict,5)))); 

    end

%     % Load data
% 
%     cd data
% 
%     % OBSERVATION
%     data_sub_obs = table2array(readtable(strcat('GeneratedTrialsObs_',num2str(nsub),'.csv')));
%     % reorganize the columns
%     data_sub_obs = data_sub_obs(:,[1 1 5 6 3 4 2 7]);
%     % rename the subject in the data matrix
%     data_sub_obs(:,1)=sub;
%     % recode the choice into 1 and 2
%     data_sub_obs(:,5)=(data_sub_obs(:,5)+1)/2 +1;
%     % add a trial column
%     data_sub_obs = [data_sub_obs(:,1:2), repmat(1:12,1,16)', data_sub_obs(:,3:end)];
%     % add a phase column
%     data_sub_obs(:,10)=1;
% 
%     % ESTIMATION
%     data_sub_est_temp = table2array(readtable(strcat('EstimationData_',num2str(nsub),'.csv')));
%     % extract the estimation every 4 observation trial
%     c = 0;
%     for i = 1:size(data_sub_obs,1)
%         if data_sub_obs(i,10) == 1 && data_sub_obs(i,3) == 1 % first estimation before observing
%             c= c+1;
%             data_sub_est(i,:) = data_sub_est_temp(c,5);
%         elseif data_sub_obs(i,10) == 1 && mod(data_sub_obs(i,3),4) == 0 % last estimation after observing
%             c= c+1;
%             data_sub_est(i,:) = data_sub_est_temp(c,5);
%         else
%             data_sub_est(i,:) = NaN;
%         end
%     end
%     % add the estimation column
%     data_sub_obs = [data_sub_obs(:,1:8), data_sub_est, data_sub_obs(:,9:end)];
% 
%     % PREDICTION
%     data_sub_pred = table2array(readtable(strcat('PredictionData_',num2str(nsub),'.csv')));
%     % reorganize the columns
%     data_sub_pred = data_sub_pred(:,[1 3 6 7 8 9 2]);
%     % rename the subject in the data matrix
%     data_sub_pred(:,1)=sub;
%     % recode the choice into 1 and 2
%     data_sub_pred(:,5)=(data_sub_pred(:,5)+1)/2 +1;
%     % add a trial column
%     data_sub_pred = [data_sub_pred(:,1:2), repmat(1:4,1,16)', data_sub_pred(:,3:end)];
%     % add a True pref column
%     true_pref=data_sub_obs(3:3:end,8);
%     data_sub_pred = [data_sub_pred(:,1:7), true_pref, NaN(64,1), data_sub_pred(:,8:end)];
%     % add a phase column
%     data_sub_pred(:,11)=2;
%     clear true_pref
% 
%     for dict = 1:16
%         data_obs=[data_obs;data_sub_obs(data_sub_obs(:,2)==dict,:)];
%         data_sub=[data_sub;data_sub_obs(data_sub_obs(:,2)==dict,:);data_sub_pred(data_sub_pred(:,2)==dict,:)];
%         predictionsL(sub,dict,:)=-(data_sub_pred(data_sub_pred(:,2)==dict,6)-2);
%     end
% 
%     % increment the data matrix
%     data = [data; data_sub];
% 
%     cd ..

    choice(:,sub) = data_sub_obs(:,6);
    rt(:,sub)     = data_sub_obs(:,7);
    estim(:,sub)  = data_sub_obs(:,10);
    cond(:,sub)   = data_sub_obs(:,11);

    options(:,:,sub) = [data_sub_obs(:,4),data_sub_obs(:,5)];

end

nTrials=length(choice);
nSubj=numel(subjects);


% Perform optimal Bayesian inference based on observing RTs

 % error level for truncating the infinite sum series of the function (cf. Navarro & Fuss, 2009)
err = 1e-29;
x = 0:.001:1;

for s = 1:nSubj

    f=waitbar(s/nSubj);
    loglik(s,:) = 0;

    for t = 1:nTrials

        if mod(t,12) == 1 % first trial of each dictator

            % likelihood calculation
                phi_init = normpdf(x,0.5,1);%sigma); % gaussian PDF with mean = model prediction
                loglik(s,:) = loglik(s,:) + log( phi_init(round(estim(t,s)*(length(x)-1))+1) );


            %%% --- %%% --- %%%
            % Specify priors  %
            %%% --- %%% --- %%%

            nPriors    = 11;         % number of (discretized) priors that are considered
            prefLimits = [0,1];      % limits for preference
            aLimits    = [0.1,10.1]; % limits for boundary separation
            bLimits    = [0,100];    % limits for beta
            vLimits    = [0,20];     % limits for drift rate
            ndtLimits  = [0.1,0.5];  % limits for non decision time

            prefPriorV = linspace(prefLimits(1),prefLimits(2),nPriors); %values of priors for pref
            aPriorV    = linspace(aLimits(1),aLimits(2),nPriors);       %values of priors for a
            bPriorV    = linspace(bLimits(1),bLimits(2),nPriors);       %values of priors for beta
            vPriorV    = linspace(vLimits(1),vLimits(2),nPriors);       %values of priors for v
            ndtPriorV  = linspace(ndtLimits(1),ndtLimits(2),nPriors);   %values of priors for ndt

            % Specific priors
            prefPriorP = betapdf(prefPriorV,3.5,3); % prior probability of pref
            aPriorP    = gampdf(aPriorV,2,2);       % prior probability of a
            bPriorP    = gampdf(bPriorV,1.2,5);     % prior probability of b
            vPriorP    = normpdf(vPriorV,0,5);      % prior probability of v
            ndtPriorP  = unifpdf(ndtPriorV,0,1);    % prior probability of ndt

            % Uniform priors
%             prefPriorP = unifpdf(prefPriorV,0,1);    % prior probability of pref
%             aPriorP    = unifpdf(aPriorV,0.1, 10.1); % prior probability of a (this is a bit ad-hoc, but should be fine)
%             bPriorP    = unifpdf(bPriorV,0,100);     % prior probability of b
%             vPriorP    = unifpdf(vPriorV,0,20);      % prior probability of v
            
            for p1=1:nPriors
                for p2=1:nPriors
                    for p3=1:nPriors
                        for p4=1:nPriors
                            for p5=1:nPriors
                                priorP(p1,p2,p3,p4,p5) = prefPriorP(p1)*aPriorP(p2)*bPriorP(p3)*vPriorP(p4)*ndtPriorP(p5); % prior for joint parameter space
                            end
                        end
                    end
                end
            end

            priorP = priorP./(sum(sum(sum(sum(sum(priorP)))))); % normalize prior

        end

        % get the likelihood of observed behavior, given the parameters pref, a, beta, v, ndt
        likel = zeros(nPriors,nPriors,nPriors,nPriors,nPriors);

        for p1 = 1:nPriors

            prefV = prefPriorV(p1);

            for p2 = 1:nPriors

                aV = aPriorV(p2);

                for p3=1:nPriors

                    betaV = bPriorV(p3);

                    for p4=1:nPriors

                        v = vPriorV(p4);

                        for p5=1:nPriors

                            ndtV = ndtPriorV(p5);

                            zV = aV/2; % no starting point bias
                            reac = max(err,rt(t,s) - ndtV);
                            vst = v*((options(t,choice(t,s),s)-prefV).^2-(options(t,3-choice(t,s),s)-prefV).^2);

                            if cond(t,s) == 1

                                likel(p1,p2,p3,p4,p5) = wfpt(reac,vst,aV,zV,err);

                            elseif cond(t,s) == 2

                                likel(p1,p2,p3,p4,p5) = 1./(1+exp(betaV*(vst)));

                            elseif cond(t,s) == 3

                                likel(p1,p2,p3,p4,p5) = wfpt(reac,vst,aV,zV,err) + ...   % collapse over both boundaries...
                                    wfpt(reac,-vst,aV,aV-zV,err);                        % ...because choice is not known

                            elseif cond(t,s) == 4

                                likel(p1,p2,p3,p4,p5) = 0.5;

                            end
                        end
                    end
                end
            end
        end
        
        %get posterior of the joint parameter space and parameter estimates
        posteriorP = (likel.*priorP)./sum(sum(sum(sum(sum(likel.*priorP)))));

        prefEstimP(:,t,s) = sum(posteriorP,[2 3 4 5]); %probability distribution for pref
        aEstimP(:,t,s) = sum(posteriorP,[1 3 4 5]); %probability distribution for a
        bEstimP(:,t,s) = sum(posteriorP,[1 2 4 5]); %probability distribution for b
        vEstimP(:,t,s) = sum(posteriorP,[1 2 3 5]); %probability distribution for v
        ndtEstimP(:,t,s) = sum(posteriorP,[1 2 3 4]); %probability distribution for ndt

        prefEstimMean(t,s) = prefPriorV*prefEstimP(:,t,s); %conditional mean for pref
        aEstimMean(t,s) = aPriorV*aEstimP(:,t,s); %conditional mean for a
        bEstimMean(t,s) = bPriorV*bEstimP(:,t,s); %conditional mean for b
        vEstimMean(t,s) = vPriorV*vEstimP(:,t,s); %conditional mean for v
        ndtEstimMean(t,s) = ndtPriorV*ndtEstimP(:,t,s); %conditional mean for ndt
        
        % today's posterior is...
        priorP = posteriorP;

        if cond(t,s) == 1
            simu1(t,s) = prefEstimMean(t,s);
        else
            simu1(t,s) = NaN;
        end

        if cond(t,s) == 2
            simu2(t,s) = prefEstimMean(t,s);
        else
            simu2(t,s) = NaN;
        end

        if cond(t,s) == 3
            simu3(t,s) = prefEstimMean(t,s);
        else
            simu3(t,s) = NaN;
        end

        if cond(t,s) == 4
            simu4(t,s) = prefEstimMean(t,s);
        else
            simu4(t,s) = NaN;
        end

        % likelihood calculation
        if mod(t,4) == 0 % trials with prediction
            phi_init = normpdf(x,prefEstimMean(t,s),1);%sigma); % gaussian PDF with mean = model prediction
            loglik(s,:) = loglik(s,:) + log( phi_init(round(estim(t,s)*(length(x)-1))+1) );
        end

    end

    % optimization for participant's temperature

% DATA MATRIX
% COLUMN 1  = participant number
% COLUMN 2  = dictator number
% COLUMN 3  = trial number
% COLUMN 4  = proportion of won points for left option
% COLUMN 5  = proportion of won points for right option
% COLUMN 6  = choice (1 left, 2 right)
% COLUMN 7  = RT in seconds
% COLUMN 8  = participant's choice (1 left, 2 right)
% COLUMN 9  = dictator true pref
% COLUMN 10 = estimated pref
% COLUMN 11 = condition (1 = both, 2 = ch only, 3 = rt only, 4 = none)
% COLUMN 12 = phase (1=estimation, 2=prediction)


    
%     pred = data(data(:,1)==s & data(:,11)==2,:);
    pref   = repmat(prefEstimMean(12:12:end,s),1,4)'; pref = pref(:);
    cho  = data_sub_pred(:,6);
    subjL = 1-(data_sub_pred(:,4)-pref).^2;
    subjR = 1-(data_sub_pred(:,5)-pref).^2;

    for repet = 1:1%%%%%%10

        [p, ll(repet)] = fmincon(@(beta) -sum(log(1./(1+exp(beta.*(subjR-subjL)))).*(cho==1) + log(1./(1+exp(beta.*(subjL-subjR)))).*(cho==2)),...
            gamrnd(1.2,5),...
            [],[],[],[],0,Inf,[],...
            optimset('Algorithm', 'interior-point', 'Display', 'off', 'MaxIter', 10000,'MaxFunEval',10000));

        if min(ll) == ll(repet)
            parameters(:,s) = p;
            logpost(s,:) = ll(repet);
        end

    end

    clear p ll subjL subjR beta

    for t=1:4
        for d=1:16

%             pred=data(data(:,1)==s & data(:,2)==d & data(:,11)==2,:);
            subjL = 1-(data_sub_pred(t,4)-prefEstimMean(12*d,s))^2;
            subjR = 1-(data_sub_pred(t,5)-prefEstimMean(12*d,s))^2;

            sim_left(s,d,t)=1./(1+exp(parameters(1,s)*(subjR-subjL)));
            clear pref cho subjL subjR
        end
    end
end

delete(f);

logsum=loglik-logpost;


%%

%%% --- %%% --- %%% --- %%% --- %%%
% Plot Bayesian updating process  %
%%% --- %%% --- %%% --- %%% --- %%%

% load('estimated_pref.mat');
% load('fit_12_trials.mat');
% [~,order] = sort(pref_max);
% 
% % pref_per_dict = reshape(paEstimMean(:,1),[12,16]);
% % pref_per_dict=[repmat(0.666214100836815,1,16);pref_per_dict];
% 
pref_per_dict_per_sub = reshape(prefEstimMean,[12,16,nSubj]);
% 
% figure;
% BarsAndErrorPlot_Total_nodots(estimated_pref(:,order)',[1 0.75 0 0.3],0,1,12,'','','');
% hold on
% SurfaceCurvePlot_model2(squeeze(pref_per_dict_per_sub(end,order,:)),[25 50 75],'k',0,.3,0,1,12,'','','Estimated pref');


%%

Colors(1,:)=[196 227 125]/255;
Colors(2,:)=[90 186 167]/255;
Colors(3,:)=[49 130 188]/255;
Colors(4,:)=[94 79 162]/255;

sim_pref1 = simu1(12:12:end,:)';
sim_pref2 = simu2(12:12:end,:)';
sim_pref3 = simu3(12:12:end,:)';
sim_pref4 = simu4(12:12:end,:)';
% 
% figure;
% 
% subplot(2,2,1)
% BarsAndErrorPlot_Total_nodots(estimated_pref4(:,order)',[Colors(1,:) 0.3],0,1,12,'','','');
% hold on
% SurfaceCurvePlot_model2(sim_pref4(:,order)',[25 50 75],'k',0,.3,0,1,12,'','','');
% 
% subplot(2,2,2)
% BarsAndErrorPlot_Total_nodots(estimated_pref3(:,order)',[Colors(2,:) 0.3],0,1,12,'','','');
% hold on
% SurfaceCurvePlot_model2(sim_pref3(:,order)',[25 50 75],'k',0,.3,0,1,12,'','','');
% 
% subplot(2,2,3)
% BarsAndErrorPlot_Total_nodots(estimated_pref2(:,order)',[Colors(3,:) 0.3],0,1,12,'','','');
% hold on
% SurfaceCurvePlot_model2(sim_pref2(:,order)',[25 50 75],'k',0,.3,0,1,12,'','','');
% 
% subplot(2,2,4)
% BarsAndErrorPlot_Total_nodots(estimated_pref1(:,order)',[Colors(4,:) 0.3],0,1,12,'','','');
% hold on
% SurfaceCurvePlot_model2(sim_pref1(:,order)',[25 50 75],'k',0,.3,0,1,12,'','','');
% 
% set(gcf,'position',[200,100,650,650])
% 
% %%
% 
% figure;
% BarsAndErrorPlot_Total_nodots(mean(predictionsL(:,order,:),3)',[0.5 0 1 0.3],0,1,12,'','','');
% hold on
% SurfaceCurvePlot_model2(mean(sim_left(:,order,:),3)',[25 50 75],'k',0,.3,0,1,12,'','','p(choose left)');
% yline(0.5,':');


%% order by dictator

learned_pref1(1,:,:) = repmat(sim_pref4(10,1),46,16);
learned_pref1(2,:,:) = simu1(4:12:end,:)';
learned_pref1(3,:,:) = simu1(8:12:end,:)';
learned_pref1(4,:,:) = simu1(12:12:end,:)';

learned_pref2(1,:,:) = repmat(sim_pref4(10,1),46,16);
learned_pref2(2,:,:) = simu2(4:12:end,:)';
learned_pref2(3,:,:) = simu2(8:12:end,:)';
learned_pref2(4,:,:) = simu2(12:12:end,:)';

learned_pref3(1,:,:) = repmat(sim_pref4(10,1),46,16);
learned_pref3(2,:,:) = simu3(4:12:end,:)';
learned_pref3(3,:,:) = simu3(8:12:end,:)';
learned_pref3(4,:,:) = simu3(12:12:end,:)';

learned_pref4(1,:,:) = repmat(sim_pref4(10,1),46,16);
learned_pref4(2,:,:) = simu4(4:12:end,:)';
learned_pref4(3,:,:) = simu4(8:12:end,:)';
learned_pref4(4,:,:) = simu4(12:12:end,:)';

%%

accuracy_pref = [repmat(sim_pref4(10,1),1,46,16); permute(pref_per_dict_per_sub(4:4:end,:,:),[1 3 2])];

accuracy_pref1(1,:,:) = 1-abs(pref_dict-repmat(sim_pref4(10,1),46,16));
accuracy_pref1(2,:,:) = 1-abs(pref_dict-simu1(4:12:end,:)');
accuracy_pref1(3,:,:) = 1-abs(pref_dict-simu1(8:12:end,:)');
accuracy_pref1(4,:,:) = 1-abs(pref_dict-simu1(12:12:end,:)');

accuracy_pref2(1,:,:) = 1-abs(pref_dict-repmat(sim_pref4(10,1),46,16));
accuracy_pref2(2,:,:) = 1-abs(pref_dict-simu2(4:12:end,:)');
accuracy_pref2(3,:,:) = 1-abs(pref_dict-simu2(8:12:end,:)');
accuracy_pref2(4,:,:) = 1-abs(pref_dict-simu2(12:12:end,:)');

accuracy_pref3(1,:,:) = 1-abs(pref_dict-repmat(sim_pref4(10,1),46,16));
accuracy_pref3(2,:,:) = 1-abs(pref_dict-simu3(4:12:end,:)');
accuracy_pref3(3,:,:) = 1-abs(pref_dict-simu3(8:12:end,:)');
accuracy_pref3(4,:,:) = 1-abs(pref_dict-simu3(12:12:end,:)');

accuracy_pref4(1,:,:) = 1-abs(pref_dict-repmat(sim_pref4(10,1),46,16));
accuracy_pref4(2,:,:) = 1-abs(pref_dict-simu4(4:12:end,:)');
accuracy_pref4(3,:,:) = 1-abs(pref_dict-simu4(8:12:end,:)');
accuracy_pref4(4,:,:) = 1-abs(pref_dict-simu4(12:12:end,:)');

% learning_data=load('data_fig_obs.mat');

%%

% guess=0:0.0001:1;
% for i=1:length(guess)
%     chance(i,:)=1-abs(pref_dict-guess(i));
% end
% 
% chance_level=mean(chance); clear chance
% 
% figure;
% 
% SurfaceCurvePlot(learning_data.acc_sub_cond4',10,Colors(1,:),1,.3,0.4,1,10,'','',''); xlim([1 4]);
% hold on
% SurfaceCurvePlot(learning_data.acc_sub_cond3',10,Colors(2,:),1,.3,0.4,1,10,'','',''); xlim([1 4]);
% hold on
% SurfaceCurvePlot(learning_data.acc_sub_cond2',10,Colors(3,:),1,.3,0.4,1,10,'','',''); xlim([1 4]);
% hold on
% SurfaceCurvePlot(learning_data.acc_sub_cond1',10,Colors(4,:),1,.3,0.4,1,10,'','',''); xlim([1 4]); yline(mean(chance_level),':k');
% hold on
% 
% SurfaceCurvePlot_model2(nanmean(accuracy_pref4,3),[25 50 75],Colors(1,:),1,.3,0.5,1,12,'','','');
% hold on
% SurfaceCurvePlot_model2(nanmean(accuracy_pref3,3),[25 50 75],Colors(2,:),1,.3,0.5,1,12,'','','');
% hold on
% SurfaceCurvePlot_model2(nanmean(accuracy_pref2,3),[25 50 75],Colors(3,:),1,.3,0.5,1,12,'','','');
% hold on
% SurfaceCurvePlot_model2(nanmean(accuracy_pref1,3),[25 50 75],Colors(4,:),1,.3,0.5,1,12,'','','');



