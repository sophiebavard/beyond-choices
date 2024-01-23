function [lik, pref, proba_left, proba_max,learned_pref] = function_fit_simu(params, left, right, choice, reac, estim, cond, phase, model, fit)

pref0 = params(1); % initial pref
beta  = params(2); % choice temperature
sigma = params(3); % variance of the normal distribution deviance
alpha = params(4); % learning rate
w     = params(5); % ch/RT weight

lik = 0;

for i = 1:length(reac)

    if phase(i)==1 % observing and learning

        if mod(i,16) == 1 % first trial of each dictator

            pref = pref0;

            if fit == 1

                lik = lik + log(normpdf(estim(i),pref,sigma)/normpdf(estim(i),estim(i),sigma));

            end

            learned_pref(i)=pref;

        end

        % subjective values
        subjL(i) = 1-(left(i)  - pref).^2;
        subjR(i) = 1-(right(i) - pref).^2;

        if model == 1 % Q-learning

            if cond(i) == 1 % both

                R_ch(i) = (left(i)>right(i) & choice(i)==1) + (left(i)<right(i) & choice(i)==2);

                if reac(i)>= mean(reac(1:i)) % slow trials
                    R_rt(i) = (left(i) + right(i))/2;
                else
                    if  subjL(i) > subjR(i)
                        R_rt(i) = left(i)>right(i);
                    else
                        R_rt(i) = left(i)<right(i);
                    end
                end

            elseif cond(i) == 2 % choice only

                R_rt(i) = pref;
                R_ch(i) = (left(i)>right(i) & choice(i)==1) + (left(i)<right(i) & choice(i)==2);

            elseif cond(i) == 3 % rt only

                R_ch(i) = pref;

                if reac(i)>= mean(reac(1:i)) % slow trials
                    R_rt(i) = (left(i) + right(i))/2;
                else
                    if  subjL(i) > subjR(i)
                        R_rt(i) = left(i)>right(i);
                    else
                        R_rt(i) = left(i)<right(i);
                    end
                end

            else % none
                R_rt(i)=(left(i)+right(i))/2;
                R_ch(i)=(left(i)+right(i))/2;
            end

            R(i) = R_rt(i) * w + R_ch(i) * (1-w);

        elseif model == 2

            if cond(i) == 1 % both

                if reac(i)>= mean(reac(1:i)) % slow trials
                    R(i) = (left(i) + right(i))/2;
                else
                    R(i) = (left(i)>right(i) & choice(i)==1) + (left(i)<right(i) & choice(i)==2);
                end

            elseif cond(i) == 2 % choice only

                R(i) = (left(i)>right(i) & choice(i)==1) + (left(i)<right(i) & choice(i)==2);

            elseif cond(i) == 3 % rt only

                if mod(i,12)~=1 % from second trial on

                    if reac(i)>= mean(reac(1:i)) % slow trials
                        R(i) = (left(i) + right(i))/2;
                    else
                        if  subjL(i) > subjR(i)
                            R(i) = left(i)>right(i);
                        else
                            R(i) = left(i)<right(i);
                        end
                    end
                else
                    R(i)=pref;
                end

            else % none

                R(i)=(left(i)+right(i))/2;

            end

            % learning the preferred allocation
            delta(i) = R(i) - pref;
            pref = pref + alpha * delta(i);

        end

        % learning the preferred allocation
        delta(i) = R(i) - pref;
        pref = pref + alpha * delta(i);

        learned_pref(i+1)=pref;

        if fit == 1

            if mod(i,4) == 0 % trials with prediction

                lik = lik + log(normpdf(pref,estim(i),sigma)/normpdf(estim(i),estim(i),sigma));

            end

        end

    elseif phase(i) == 2 % prediction

        % subjective values
        subjL(i) = 1-(left(i)  - pref).^2;
        subjR(i) = 1-(right(i) - pref).^2;

        if fit == 1

            lik = lik + log(1/(1+exp(beta*(subjR(i)-subjL(i)))))*(choice(i)==1) + log(1/(1+exp(beta*(subjL(i)-subjR(i)))))*(choice(i)==2);

        elseif fit == 2

            proba_max(i-12) = 1/(1+exp(beta*(subjR(i)-subjL(i))))*(left(i)>=right(i)) + 1/(1+exp(beta*(subjL(i)-subjR(i))))*(left(i)<right(i));
            proba_left(i-12) = 1/(1+exp(beta*(subjR(i)-subjL(i))));

        end

    end
end

lik = -lik;



