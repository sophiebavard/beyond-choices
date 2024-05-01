#!/usr/bin/env python2

#===========================================================
# Importing Modules
#===========================================================
from __future__ import absolute_import, division
import numpy as np
import math
from psychopy import locale_setup
from psychopy import prefs
from psychopy import gui, visual, core, data, event, logging, clock, colors, layout
from psychopy.constants import (NOT_STARTED, STARTED, PLAYING, PAUSED,
                                STOPPED, FINISHED, PRESSED, RELEASED, FOREVER)

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
def trial(win, image_predi_path, trialCounter, trial_elements, dictator):
    
    Nsub=[]
    D_choices=[]
    D_resptimes=[]
    left_splits=[]
    right_splits=[]
    thisChoices=[]
    thisRTs=[]
    
#    InstructPrediction = visual.TextStim(win=win, name='InstructPrediction',
#                                  text=u'Welche Aufteilung würde diese Person wählen?\n\n',
#                                  font='Arial', pos=(0, 0.6), height=0.06, wrapWidth=None, ori=0, color='Black',
#                                  colorSpace='rgb', opacity=1, depth=0.0)

#    InstructPrediction = visual.TextBox2(win=win, name='InstructAllocation',
#                                text=u'Welche Aufteilung würde diese Person wählen?\n\n',
#                                font='Arial', pos=(0, 0.6), letterHeight=0.06, color='Black',
#                                colorSpace='rgb', opacity=1, alignment='center')

    InstructPrediction = visual.ImageStim(win=win, name='PicPredi', image=image_predi_path, pos=(0, 0), size=2)

    PredictTrials = data.TrialHandler(nReps=1, method='fullRandom', originPath=-1,
                                    trialList=data.importConditions('data_toPredict.csv'), seed=None, name='PredictTrials')
    
    end_exp_now = False
    # create some variables
    thisChoice = 99
    thisRT = 0
    # amount of money split
    pool = 10
    
    for thisTrial in PredictTrials:
        sub = thisTrial['sub']
        D_choice = thisTrial['Choice']
        D_resptime = thisTrial['RT']
        left_split = thisTrial['left_split']
        right_split = thisTrial['right_split']
        
        # multiply splits with total amount round to one decimal place
        # create string variable for the result screen
        left_split_am = round(left_split * pool,1)
        txt_left = str(left_split_am) + ' CHF'
   
        right_split_am = round (right_split * pool,1)
        txt_right = str(right_split_am)+ ' CHF'
        
        # defines the area in the circle representing the participants share
        visible_wedge_left = (left_split_am* 360)/10
        visible_wedge_right = (right_split_am*360)/10

        # keep track of which components have finished
        trialComponents = [InstructPrediction]
        for thisComponent in trialComponents:
            thisComponent.tStart = None
            thisComponent.tStop = None
            thisComponent.tStartRefresh = None
            thisComponent.tStopRefresh = None
            if hasattr(thisComponent, 'status'):
                thisComponent.status = NOT_STARTED
    
        if sub == dictator:
            
            #---------------------------------------------------
            #------ Routine: Fixation Cross --------------------
            #---------------------------------------------------
            routineTimer.reset()
            routineTimer.addTime(-myJitter[trialCounter])

            trial_elements.FixCross.draw(win)
            win.flip()
            
            #InstructPrediction.draw()

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
            
            while continue_routine:
                
                # instruction
                InstructPrediction.draw(win)
                
                t = trial_elements.ChoiceClock.getTime()
                #update/draw components in each frame
                trial_elements.Pie_background_L.draw(win)
                trial_elements.Pie_me_L.draw(win)
                trial_elements.Pie_background_R.draw(win)
                trial_elements.Pie_me_R.draw(win)
                win.flip()
                #win.flip(clearBuffer=False) # the argument is to keep the text

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
                    Nsub.append(sub)
                    D_choices.append(D_choice)
                    D_resptimes.append(D_resptime)
                    left_splits.append(left_split)
                    right_splits.append(right_split)
                    thisChoices.append(thisChoice)
                    thisRTs.append(thisRT)
                    break

                # check for quit (the escape key)
                if end_exp_now or event.getKeys(keyList=["escape"]):
                    core.quit()

            # -------Ending Routine "trial"-------
            for thisComponent in trialComponents:
                if hasattr(thisComponent, "setAutoDraw"):
                    thisComponent.setAutoDraw(False)

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
    
    return Nsub, D_choices, D_resptimes, left_splits, right_splits, thisChoices, thisRTs