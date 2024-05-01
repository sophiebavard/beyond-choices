import os
import numpy as np
import random
import csv
import itertools
import pandas

def create_obs_trials(vpn):
    
    # define the function that will shuffle dictators without shuffling trials
    def shuffle_by_blocks(seq, blocksize):
        blocks = [seq[idx*blocksize: (idx+1)*blocksize] for idx in range(len(seq)//blocksize)]
        random.shuffle(blocks)
        return [elt for block in blocks for elt in block ]

    # get the first element of each sublist (dictators' number)
    def extract(lst):
        return [item[0] for item in lst]

    # open the dictators file
    with open('data_toObserve.csv', newline='') as csvfile:
        
        trials = csv.reader(csvfile, delimiter=',', quotechar='|')
        rows = []
        cond = []
        count=0
        
        # create the condition vector (1:4)
        for row in trials:
            count+=1
            cond.append(((count-1)%4) +1)
            rows.append(row)
    
    cond.sort()
    
    # -------------------------------
    # create the full matrix of trials, pseudo randomizing with PA
    # -------------------------------

    trials_obs=[]
    # split the dictators in 4 levels of PA
    dictators = [rows[i:i+4*12] for i in range(0,len(rows),4*12)]
    
    # shuffle these levels
    random.shuffle(dictators)
    
    # shuffle dictators within each level
    for group in range(0,4):
        dictators[group]=shuffle_by_blocks(dictators[group],int(len(dictators[group])/4))
    
    # sample the dictators for each level, each condition
    for dictpergroup in [slice(0,12),slice(12,24),slice(24,36),slice(36,48)]:
        # randomize the order in which each level is going to be sampled
        a = list(range(0,4))
        random.shuffle(a)
        # finally, increment the trial matrix in the right order
        for i in a:
            trials_obs.extend(dictators[i][dictpergroup])

    # -------------------------------

    # shuffle the dictators and conditions
    cond_obs = shuffle_by_blocks(cond,int(len(cond)/4))

    # create the observation file with dictator data and condition
    sub=[]
    PA=[]
    Choice=[]
    RT=[]
    left_split=[]
    right_split=[]
    cond=[]
    for i in range(len(trials_obs)):
        sub.append(int(trials_obs[i][0]))
        PA.append(float(trials_obs[i][1]))
        Choice.append(int(trials_obs[i][2]))
        RT.append(float(trials_obs[i][3]))
        left_split.append(float(trials_obs[i][4]))
        right_split.append(float(trials_obs[i][5]))
        cond.append(cond_obs[i])

    data_generated = np.stack((sub,PA,Choice,RT,left_split,right_split,cond), axis=1)

    # save the data with default name so that it can used as input in main exp file
    np.savetxt(u'GeneratedTrialsObs.csv', data_generated, header='sub,PA,Choice,RT,left_split,right_split,cond', delimiter=',', fmt='%i,%.6f,%i,%.6f,%.6f,%.6f,%i', comments='')

    # save data with participant id to keep track of the trials of the specific participant
    np.savetxt(u'data' + os.sep + u'GeneratedTrialsObs_' + str(vpn) + u'.csv', data_generated, header='sub,PA,Choice,RT,left_split,right_split,cond',
                   delimiter=',', fmt='%i,%.6f,%i,%.6f,%.6f,%.6f,%i', comments='')
                   
    return data_generated

