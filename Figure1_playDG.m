%% Sophie BAVARD -- Jan 2023

clear

load data_playDG16.mat

% COLUMN 1  = participant's number
% COLUMN 2  = choice (-1 left, 1 right)
% COLUMN 3  = RT in seconds
% COLUMN 4  = proportion of won points for left option
% COLUMN 5  = proportion of won points for right option

%%

subjects = 1:16;

sub=0;

options = optimset('Algorithm', 'interior-point', 'Display', 'off', 'MaxIter', 10000,'MaxFunEval',10000);

for nsub = subjects

    sub = sub+1;

    % Load data
    data_sub = data(data(:,1)==nsub,:);

    % behavior
    reac(:,sub) = data_sub(:,3);
    diff(:,sub) = abs(data_sub(:,4) - data_sub(:,5));

    % choices towards selfish allocation
    choice_max(:,sub) = double((data_sub(:,2)==-1 & data_sub(:,4)>data_sub(:,5)) | (data_sub(:,2)==1 & data_sub(:,4)<data_sub(:,5)));

    % average allocation chosen
    for i=1:length(data_sub)
        if data_sub(i,2)==1
            average_allocation(i,sub) = data_sub(i,4);
        elseif data_sub(i,2)==0
            average_allocation(i,sub) = data_sub(i,5);
        end
    end

    % estimate preferred allocation according to "single-peak" model
    % (choices only)

    for repet = 1:10
        [p, ll(repet)] = fmincon(@(x) single_peak(x,data_sub(:,4),data_sub(:,5),(1+data_sub(:,2))/2+1),[rand rand*10],[],[],[],[],[0 0],[1 Inf],[], options);

        if min(ll) == ll(repet)
            parameters_ch(:,sub) = p;
        end
    end
    clear ll
    clear p

    % estimate preferred allocation according to "single-peak" model
    % (response times only)

    for repet = 1:10

        [p, ll(repet)] = fmincon(@(x) ddm_peak(x,data_sub(:,4),data_sub(:,5),data_sub(:,3)),[rand rand*10 rand*10 rand],[],[],[],[],[0 0.0001 -20 0],[1 20 20 1],[], options);

        if min(ll) == ll(repet)
            parameters_rt(:,sub) = p;
        end

    end

    [~, density_functionRT(:,sub)] = ddm_peak(parameters_rt(:,sub),data_sub(:,4),data_sub(:,5),data_sub(:,3));

    clear ll
    clear p

    % estimate preferred allocation according to "single-peak" model
    % (both choices and RT)

    for repet = 1:10

        [p, ll(repet)] = fmincon(@(x) fit_PA(x,data_sub(:,4),data_sub(:,5),(1+data_sub(:,2))/2+1,data_sub(:,3)),[rand rand*10 rand*10 rand],[],[],[],[],[0 0.0001 -20 0],[1 20 20 1],[], options);

        if min(ll) == ll(repet)
            parameters(:,sub) = p;
        end

    end

    [~, density_function(:,sub)] = fit_PA(parameters(:,sub),data_sub(:,4),data_sub(:,5),(1+data_sub(:,2))/2+1,data_sub(:,3));

    clear ll
    clear p

    % test if likelihood is random
    value(1,sub) = single_peak(parameters_ch(:,sub),data_sub(:,4),data_sub(:,5),(1+data_sub(:,2))/2+1);
    value(2,sub) = ddm_peak(parameters_rt(:,sub),data_sub(:,4),data_sub(:,5),data_sub(:,3));

    % calculate our variable of interest
    delta_ch(:,sub) = abs(1-(data_sub(:,4)-parameters_ch(1,sub)).^2 - (1-(data_sub(:,5)-parameters_ch(1,sub)).^2));
    delta_rt(:,sub) = abs(1-(data_sub(:,4)-parameters_rt(1,sub)).^2 - (1-(data_sub(:,5)-parameters_rt(1,sub)).^2));
    delta_bo(:,sub) = abs(1-(data_sub(:,4)-parameters(1,sub)).^2 - (1-(data_sub(:,5)-parameters(1,sub)).^2));

    % test whether single-peak model predicts RT
    mod1(:,sub) = glmfit((delta_rt(:,sub)), ((reac(:,sub))));
    mod2(:,sub) = glmfit((delta_ch(:,sub)), ((reac(:,sub))));
    mod3(:,sub) = glmfit((delta_bo(:,sub)), ((reac(:,sub))));

end

%% PLOT

Colors(1,:)=[196 227 125]/255;
Colors(2,:)=[90 186 167]/255;
Colors(3,:)=[49 130 188]/255;
Colors(4,:)=[94 79 162]/255;

%% Figure 1D

figure;
subplot(1,3,1)
violinplotSB(mod1,[Colors(2,:);Colors(2,:)],-6,4,12,'','',''); yline(0,'Color','k');
box off
subplot(1,3,2)
violinplotSB(mod2,[Colors(3,:);Colors(3,:)],-6,4,12,'','',''); yline(0,'Color','k');
box off
subplot(1,3,3)
violinplotSB(mod3,[Colors(4,:);Colors(4,:)],-6,4,12,'','',''); yline(0,'Color','k');
box off


%% Figure 1E

figure;
% scatter plot
scatter(parameters_ch(1,:)',parameters_rt(1,:)',60,mean(choice_max)','filled'); ylim([0 1]); pbaspect([1 1 1]);
% correlation
hold on
P = polyfit(parameters_ch(1,:)',parameters_rt(1,:)',1);
Yf = polyval(P,parameters_ch(1,:)');
plot(parameters_ch(1,:)',Yf,'k');
% legend from 0 to 1
caxis([0 1]);
% colors from yellow to blue
colormap(flipud(parula));
% display colorbar
colorbar


%%

function likelihood  = single_peak(parameters, left, right, choice)

pref    = parameters(1); % preferred allocation
beta  = parameters(2);

% subjective values
subjL = 1-(left  - pref).^2;
subjR = 1-(right - pref).^2;

probability = 1./(1+exp(beta*(subjR-subjL))) .* (choice==1) + 1./(1+exp(beta*(subjL-subjR))) .* (choice==2);

likelihood = -2*sum(log(probability));

end


%%

function [lik, P] = ddm_peak(params, left, right, reac)

pref = params(1); % preferred allocation
b    = params(2); % threshold
z    = params(3); % drift rate differential utility weight
T    = params(4); % non-decision time

lik = 0;
RT = max(eps,reac - T);

for n = 1:length(reac)

    % subjective values
    subjL = 1-(left(n)  - pref).^2;
    subjR = 1-(right(n) - pref).^2;

    % drift rate
    v = z*(subjR-subjL);

    % accumulate log-likelihod

    P(n) = wfpt(RT(n),-v,b) + wfpt(RT(n),v,b) ;  % Wiener first passage time distribution

    if isnan(P(n)) || P(n)==0; P(n) = realmin; end % avoid NaNs and zeros in the logarithm

    lik = lik -2* log(P(n));

end

end



%%

function [lik, P] = fit_PA(params, left, right, choice, reac)

pref = params(1); % preferred allocation
b    = params(2); % threshold
z    = params(3); % drift rate differential utility weight
T    = params(4); % non-decision time

lik = 0;
RT = max(eps,reac - T);

for n = 1:length(reac)

    c = choice(n);              % choice

    % subjective values
    subjL = 1-(left(n)  - pref).^2;
    subjR = 1-(right(n) - pref).^2;

    % drift rate
    v = z*(subjR-subjL);

    % accumulate log-likelihod
    if c == 1; v = -v; end

    % probability that x is chosen given RT
    P(n) = wfpt(RT(n),v,b) ;  % Wiener first passage time distribution

    if isnan(P(n)) || P(n)==0; P(n) = realmin; end % avoid NaNs and zeros in the logarithm

    lik = lik -2* log(P(n));

end

end


