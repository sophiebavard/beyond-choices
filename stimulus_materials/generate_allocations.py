import os
import numpy as np
import random

import scipy.stats as stats

# build function that can be called from the main exp script (DG_2_round.py)
def create_expl_trials(vpn):
    
    # define options for split 1
    splits_1 = [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1] 
    #splits_1 = [0,0.5,1] 
    
    # define options for split 2
    splits_2 =[0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]
    #splits_2 = [0,0.5,1] 
    
    # create variables 
    options = np.empty((0,2))
    splits_1_options = []
    splits_2_options = []

    #create some noise (normaldistributed, nr in the range -.05 to .05; truncated normal distribution)
    lower = (-0.05)
    upper = 0.05
    mu = 0
    sigma = 0.02
    N = 1
    x = 0
    #print(noise)

    #create 3 times combinations of the splits (165 trials)
    #create 1 times combinations of the splits (55 trials)
    for x in range (1):
        for this_split_1 in splits_1: 
            for this_split_2 in splits_2: 
                if this_split_1 > this_split_2: # otherwise we get the combinations twice
                    noise_1 = stats.truncnorm.rvs((lower-mu)/sigma,(upper-mu)/sigma,loc=mu,scale=sigma,size=N) # noise for split1
                    noise_2 = stats.truncnorm.rvs((lower-mu)/sigma,(upper-mu)/sigma,loc=mu,scale=sigma,size=N) # noise for split2
                    result_1 = (this_split_1 + noise_1)
                    result_2 = (this_split_2 + noise_2)
                    
                    # the value for the split can not be negative
                    if result_1 < 0: 
                        result_1 = 0 
                    if result_2 < 0: 
                        result_2 = 0
                   
                    # the value for the split can not be higher than 1
                    if result_1 > 1: 
                        result_1 = 1
                    if result_2 > 1: 
                        result_2 = 1
                   
                    #bind the options together
                    splits_1_options = np.append(splits_1_options, result_1)
                    splits_2_options = np.append(splits_2_options, result_2)
                    x += 1


    #combine the data
    data_generated = np.stack((splits_1_options,splits_2_options), axis=1)

    # save the data with default name so that it can used as input in main exp file
    np.savetxt(u'GeneratedTrials.csv', data_generated, header='split_1,split_2', delimiter=',', fmt='%.6f', comments='')

    # save data with participant id to keep track of the trials of the specific participant
    np.savetxt(u'data' + os.sep + u'GeneratedTrials_' + str(vpn) + u'.csv', data_generated, header='split_1,split_2',
                   delimiter=',', fmt='%.6f', comments='')
                   
    return data_generated
