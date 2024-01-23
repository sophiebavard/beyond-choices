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

        prefEstimP(:,t,s)  = sum(posteriorP,[2 3 4 5]);     %probability distribution for pref
        aEstimP(:,t,s)     = sum(posteriorP,[1 3 4 5]);     %probability distribution for a
        bEstimP(:,t,s)     = sum(posteriorP,[1 2 4 5]);     %probability distribution for b
        vEstimP(:,t,s)     = sum(posteriorP,[1 2 3 5]);     %probability distribution for v
        ndtEstimP(:,t,s)   = sum(posteriorP,[1 2 3 4]);     %probability distribution for ndt

        prefEstimMean(t,s) = prefPriorV*prefEstimP(:,t,s);  %conditional mean for pref
        aEstimMean(t,s)    = aPriorV*aEstimP(:,t,s);        %conditional mean for a
        bEstimMean(t,s)    = bPriorV*bEstimP(:,t,s);        %conditional mean for b
        vEstimMean(t,s)    = vPriorV*vEstimP(:,t,s);        %conditional mean for v
        ndtEstimMean(t,s)  = ndtPriorV*ndtEstimP(:,t,s);    %conditional mean for ndt
        
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

    pref   = repmat(prefEstimMean(12:12:end,s),1,4)'; pref = pref(:);
    cho  = data_sub_pred(:,6);
    subjL = 1-(data_sub_pred(:,4)-pref).^2;
    subjR = 1-(data_sub_pred(:,5)-pref).^2;

    for repet = 1:10

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

            subjL = 1-(data_sub_pred(t,4)-prefEstimMean(12*d,s))^2;
            subjR = 1-(data_sub_pred(t,5)-prefEstimMean(12*d,s))^2;

            sim_left(s,d,t)=1./(1+exp(parameters(1,s)*(subjR-subjL)));
            clear pref cho subjL subjR

        end
    end
end

delete(f);

logsum=loglik-logpost;
pref_per_dict_per_sub = reshape(prefEstimMean,[12,16,nSubj]);

%%

sim_pref1 = simu1(12:12:end,:)';
sim_pref2 = simu2(12:12:end,:)';
sim_pref3 = simu3(12:12:end,:)';
sim_pref4 = simu4(12:12:end,:)';

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

%%

save data_fitting_BO
