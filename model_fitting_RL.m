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
% COLUMN 9  = dictator true PA
% COLUMN 10 = estimated PA
% COLUMN 11 = condition (1 = both, 2 = ch only, 3 = rt only, 4 = none)
% COLUMN 12 = phase (1=estimation, 2=prediction)

model = 1;

% 1 RL hybrid
% 2 RL original

subjects = 1:46;

options = optimset('Algorithm', 'interior-point', 'Display', 'off', 'MaxIter', 10000,'MaxFunEval',10000);

rep=100;
sub=0;

for nsub = subjects

    sub = sub+1;
    
    f=waitbar(sub/numel(subjects));

    % Load data

    data_sub = data(data(:,1)==nsub,:);
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

    % FITTING

    for repet = 1:50

        [p, ll(repet)] = fmincon(@(x) function_fit_simu(x,data_sub(:,4),data_sub(:,5),data_sub(:,6),data_sub(:,7),data_sub(:,10),data_sub(:,11),data_sub(:,12),model,1),...
            [betarnd(1.1,1.1) gamrnd(1.2,5) .5 betarnd(1.1,1.1) betarnd(1.1,1.1)],...
            [],[],[],[],[0 0 0 0 0],[1 Inf 1 1 1],[], options);

        if min(ll) == ll(repet)
            parameters(:,sub) = p;
            logpost(sub,:) = ll(repet);
        end
    end

    clear ll
    clear p

    % SIMULATIONS

    for dict = 1:16

        data_dict = data_sub(data_sub(:,2)==dict,:);

        sim_pref(sub,dict)  = 0;
        sim_left(sub,dict,:) = zeros(4,1);
        sim_left1(sub,dict,:) = zeros(4,1);
        sim_left2(sub,dict,:) = zeros(4,1);
        sim_left3(sub,dict,:) = zeros(4,1);
        sim_left4(sub,dict,:) = zeros(4,1);
        sim_max(sub,dict,:) = zeros(4,1);
        sim_max1(sub,dict,:) = zeros(4,1);
        sim_max2(sub,dict,:) = zeros(4,1);
        sim_max3(sub,dict,:) = zeros(4,1);
        sim_max4(sub,dict,:) = zeros(4,1);
        learned_pref(:,sub,dict) = zeros(4,1);
        learned_pref1(:,sub,dict) = zeros(4,1);
        learned_pref2(:,sub,dict) = zeros(4,1);
        learned_pref3(:,sub,dict) = zeros(4,1);
        learned_pref4(:,sub,dict) = zeros(4,1);
        accuracy_pref(:,sub,dict) = zeros(4,1);
        accuracy_pref1(:,sub,dict) = zeros(4,1);
        accuracy_pref2(:,sub,dict) = zeros(4,1);
        accuracy_pref3(:,sub,dict) = zeros(4,1);
        accuracy_pref4(:,sub,dict) = zeros(4,1);

        for r = 1:rep

            [~, pref(:,dict,sub),sim_L(sub,dict,:),sim_M(sub,dict,:),learned_pref_m(:,sub,dict)] = function_fit_simu(parameters(:,sub),data_dict(:,4),data_dict(:,5),data_dict(:,6),data_dict(:,7),data_dict(:,10),data_dict(:,11),data_dict(:,12),model,2);

            sim_pref(sub,dict)  = sim_pref(sub,dict)  + pref(end,dict,sub)/rep;
            sim_left(sub,dict,:) = sim_left(sub,dict,:) + sim_L(sub,dict,:)/rep;
            sim_max(sub,dict,:) = sim_max(sub,dict,:) + sim_M(sub,dict,:)/rep;
            learned_pref(:,sub,dict) = learned_pref(:,sub,dict) + [learned_pref_m(1,sub,dict); learned_pref_m(5:4:end,sub,dict)]/rep;
            accuracy_pref(:,sub,dict) = accuracy_pref(:,sub,dict)+ [1-abs(learned_pref_m(1,sub,dict)-pref_dict(dict)); 1-abs(learned_pref_m(5:4:end,sub,dict)-pref_dict(dict))]/rep;

        end

        if data_dict(1,11) == 1 % cond 1
            sim_pref1(sub,dict) = sim_pref(sub,dict);
            sim_left1(sub,dict,:) = sim_left(sub,dict,:);
            sim_max1(sub,dict,:) = sim_max(sub,dict,:);
            learned_pref1(:,sub,dict)=learned_pref(:,sub,dict);
            accuracy_pref1(:,sub,dict)=1-abs(learned_pref(:,sub,dict)-pref_dict(dict));
        else
            sim_pref1(sub,dict) = NaN;
            sim_left1(sub,dict,:) = NaN;
            sim_max1(sub,dict,:) = NaN;
            learned_pref1(:,sub,dict) = NaN;
            accuracy_pref1(:,sub,dict) = NaN;
        end

        if data_dict(1,11) == 2 % cond 2
            sim_pref2(sub,dict) = sim_pref(sub,dict);
            sim_left2(sub,dict,:) = sim_left(sub,dict,:);
            sim_max2(sub,dict,:) = sim_max(sub,dict,:);
            learned_pref2(:,sub,dict)=learned_pref(:,sub,dict);
            accuracy_pref2(:,sub,dict)=1-abs(learned_pref(:,sub,dict)-pref_dict(dict));
        else
            sim_pref2(sub,dict) = NaN;
            sim_left2(sub,dict,:) = NaN;
            sim_max2(sub,dict,:) = NaN;
            learned_pref2(:,sub,dict) = NaN;
            accuracy_pref2(:,sub,dict) = NaN;
        end

        if data_dict(1,11) == 3 % cond 3
            sim_pref3(sub,dict) = sim_pref(sub,dict);
            sim_left3(sub,dict,:) = sim_left(sub,dict,:);
            sim_max3(sub,dict,:) = sim_max(sub,dict,:);
            learned_pref3(:,sub,dict)=learned_pref(:,sub,dict);
            accuracy_pref3(:,sub,dict)=1-abs(learned_pref(:,sub,dict)-pref_dict(dict));
        else
            sim_pref3(sub,dict) = NaN;
            sim_left3(sub,dict,:) = NaN;
            sim_max3(sub,dict,:) = NaN;
            learned_pref3(:,sub,dict) = NaN;
            accuracy_pref3(:,sub,dict) = NaN;
        end

        if data_dict(1,11) == 4 % cond 4
            sim_pref4(sub,dict) = sim_pref(sub,dict);
            sim_left4(sub,dict,:) = sim_left(sub,dict,:);
            sim_max4(sub,dict,:) = sim_max(sub,dict,:);
            learned_pref4(:,sub,dict)=learned_pref(:,sub,dict);
            accuracy_pref4(:,sub,dict)=1-abs(learned_pref(:,sub,dict)-pref_dict(dict));
        else
            sim_pref4(sub,dict) = NaN;
            sim_left4(sub,dict,:) = NaN;
            sim_max4(sub,dict,:) = NaN;
            learned_pref4(:,sub,dict) = NaN;
            accuracy_pref4(:,sub,dict) = NaN;
        end

    end

end

delete(f);


%%

save(strcat('data_fitting_RL',num2str(model),'.mat'));




