#!/usr/bin/env python2

#===========================================================
# Importing Modules
#===========================================================
from __future__ import absolute_import, division
from psychopy import core, event
import numpy as np
import math

#===========================================================
# Setup
#===========================================================
plotSize = .15 # Change here and in the main experiment file

routineTimer = core.CountdownTimer()

# one set random nr between 1 and 4; np.random.rand() samples from uniform distribution on [0, 1).
# duration of fixation cross
myJitter = 3* np.random.rand(200) +1 

#===========================================================
# The Trial Function
#===========================================================
def trial(win, trialCounter, trial_elements, split_1, split_2, training=False, left_right=True):

    end_exp_now = False
    # create some variables
    thisChoice = 99
    thisRT = 0
    # amount of money split
    pool = 3

    #left_right = decides if the higher amount is displayed left or right (random, generated in main exp file)
    if left_right:
        left_split = split_1
        right_split = split_2 
     
        # multiply splits with total amount round to one decimal place
        # create string variable for the result screen
        left_split_am = round(left_split * pool,1)
        txt_left = str(left_split_am) + ' €'
   
        right_split_am = round (right_split * pool,1)
        txt_right = str(right_split_am)+ ' €'
        
        # defines the area in the circle representing the participants share
        visible_wedge_left = (left_split_am* 360)/pool
        visible_wedge_right = (right_split_am*360)/pool
    
    else:
        left_split = split_2
        right_split = split_1
        
        left_split_am = round(left_split * pool,1)
        txt_left = str(left_split_am) + ' €'
   
        right_split_am = round (right_split * pool,1)
        txt_right = str(right_split_am)+ ' €'
    
        visible_wedge_left = (left_split_am * 360)/pool 
        visible_wedge_right = (right_split_am * 360)/pool
    
    
    #---------------------------------------------------
    #------ Routine: Fixation Cross --------------------
    #---------------------------------------------------
    routineTimer.reset()
    routineTimer.addTime(-myJitter[trialCounter])

    trial_elements.FixCross.draw(win)
    
    win.flip()

    while routineTimer.getTime() > 0:
        # check for quit (the Esc key)
        if event.getKeys(keyList=["escape"]):
            core.quit()
            
    #---------------------------------------------------
    #---------- Routine: DG 2_0  ---------------------------
    #---------------------------------------------------
    # Prepare to start routine
    continue_routine = True
    event.clearEvents()
    
    #Define the size of the different options in the pie charts left
    trial_elements.Pie_me_L.visibleWedge=(0.0,visible_wedge_left) 
    
    # set the orientation of the "ME"-wedge left
    trial_elements.Pie_me_L.setOri(30) 
    
    #Define the size of the different options in the pie charts right
    trial_elements.Pie_me_R.visibleWedge=(0.0,visible_wedge_right) 
    
    # set the orientation of the "ME"-wedge right
    trial_elements.Pie_me_R.setOri(30) 
    
    win.callOnFlip(trial_elements.ChoiceClock.reset)
    
    # draw piecharts on the window (all elements of class "trial_elements")
    trial_elements.Pie_background_L.draw(win)
    trial_elements.Pie_background_R.draw(win)
    trial_elements.Pie_me_L.draw(win)
    trial_elements.Pie_me_R.draw(win)
    
    if training:
        while continue_routine:
            # get current time
            t = trial_elements.ChoiceClock.getTime()
            # update/draw components in each frame
            trial_elements.Pie_background_L.draw(win)
            trial_elements.Pie_me_L.draw(win)
            trial_elements.Pie_background_R.draw(win)
            trial_elements.Pie_me_R.draw(win)
            win.flip()
            
            # Check whether one of the keys has been pressed:
            these_keys = event.getKeys(keyList = ['q', 'p', 'escape'])
            
            if these_keys:
                these_keys = these_keys[0]
                # if escape was pressed quit experiment
                if these_keys == 'escape':
                    end_exp_now = True
                # if a decision was made continue in the loop
                elif these_keys in ['q', 'p']:
                    continue_routine = False
            
            if not continue_routine: # a component has requested a forced-end of routine
                break
            
            if end_exp_now or event.getKeys(keyList=["escape"]):
                core.quit()
    

    else: # if we are not in the training round
        while continue_routine:
            t = trial_elements.ChoiceClock.getTime()
            #update/draw components in each frame
            trial_elements.Pie_background_L.draw(win)
            trial_elements.Pie_me_L.draw(win)
            trial_elements.Pie_background_R.draw(win)
            trial_elements.Pie_me_R.draw(win)
            win.flip()



            # Check whether one of the keys has been pressed: 
            these_keys = event.getKeys(keyList=['q', 'p', 'escape'])
            if these_keys:
                    these_keys = these_keys[0]
                    if these_keys == 'escape':
                        end_exp_now = True
                    elif these_keys == 'q':
                        thisChoice = -1 # that means left_split was chosen
                        thisRT = t     # record reaction time
                        #thisSplit = left_split 
                        continue_routine = False
                    elif these_keys == 'p':
                        thisChoice = 1 # that means right_split was chosen
                        thisRT = t
                        #thisSplit = right_split
                        continue_routine = False
                            
            if not continue_routine: 
                break
           

            # check for quit (the escape key)
            if end_exp_now or event.getKeys(keyList=["escape"]):
                core.quit()

# ============================
# Routine: ISI
# ============================
    # ------Prepare to start Routine "ISI"-------
    routineTimer.reset()
    routineTimer.addTime(-1) # ISI = 1sec

    win.flip()

    # -------Start Routine "ISI"-------
    while routineTimer.getTime() > 0:
        # check for quit (the Esc key)
        if end_exp_now or event.getKeys(keyList=["escape"]):
            core.quit()




    return thisChoice, thisRT, left_split, right_split