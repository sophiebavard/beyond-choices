#!/usr/bin/env python2

#===========================================================
# Importing Modules
#===========================================================
from __future__ import absolute_import, division
from psychopy import gui, visual, core, data, event, logging, parallel
import numpy as np
import math

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
def timetrial(win, trialCounter, trial_elements, interval_1, interval_2, first_second=True):

    end_exp_now = False
    quest=False
    # create some variables
    thisChoice = 99
    thisRT = 0
    # amount of money split
    pool = 10

    # draw stimuli
    stim1 = visual.Rect(win=win, name='stim1',
        width=11, height=11, units='cm',
        ori=0.0, pos=(0, 0), anchor='center',
        lineWidth=5.0,     colorSpace='rgb',  lineColor='none', fillColor='black',
        opacity=None, depth=0.0, interpolate=True)

    stim2 = visual.Rect(win=win, name='stim2',
        width=11, height=11, units='cm',
        ori=0.0, pos=(0, 0), anchor='center',
        lineWidth=5.0,     colorSpace='rgb',  lineColor='none', fillColor='black',
        opacity=None, depth=0.0, interpolate=True)

    question = visual.TextStim(win=win, name='question', text=u"War das zweite Quadrat im Vergleich zum ersten kürzer (Q) oder länger (P) präsentiert?",
        font='Arial', pos=(0, 0), height=0.06, wrapWidth=None, ori=0, color='black',
        colorSpace='rgb', opacity=1, depth=-2.0)

    #left_right = decides if the higher amount is displayed left or right (random, generated in main exp file)
    if first_second:
        first_interval = interval_1/1000
        secon_interval = interval_2/1000
    else:
        first_interval = interval_2/1000
        secon_interval = interval_1/1000
    
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
    #---------- Routine: Time perception task ----------
    #---------------------------------------------------
    
    # Prepare to start routine
    continue_routine = True
    event.clearEvents()

    win.callOnFlip(trial_elements.ChoiceClock.reset)
    
    # update component parameters for each repeat
    # keep track of which components have finished
    trialComponents = [stim1, stim2]
    for thisComponent in trialComponents:
        thisComponent.tStart = None
        thisComponent.tStop = None
        thisComponent.tStartRefresh = None
        thisComponent.tStopRefresh = None
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
        trialClock = core.Clock()
    # reset timers
    t = 0
    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
    trialClock.reset(-_timeToFirstFrame)  # t0 is time of first possible flip
    frameN = -1
    frameTolerance = 0.001  # how close to onset before 'same' frame

    while continue_routine:

        win.flip()

        # get current time
        t = trialClock.getTime()
        tThisFlip = win.getFutureFlipTime(clock=trialClock)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame

        # *stim1* updates
        if stim1.status == NOT_STARTED and tThisFlip >= 0-frameTolerance:
            # keep track of start time/frame for later
            stim1.frameNStart = frameN  # exact frame index
            stim1.tStart = t  # local t and not account for scr refresh
            stim1.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(stim1, 'tStartRefresh')  # time at next scr refresh
            stim1.setAutoDraw(True)
        if stim1.status == STARTED:
            # is it time to stop? (based on global clock, using actual start)
            if tThisFlipGlobal > stim1.tStartRefresh + first_interval-frameTolerance:
                # keep track of stop time/frame for later
                stim1.tStop = t  # not accounting for scr refresh
                stim1.frameNStop = frameN  # exact frame index
                win.timeOnFlip(stim1, 'tStopRefresh')  # time at next scr refresh
                stim1.setAutoDraw(False)

        # *stim2* updates
        if stim2.status == NOT_STARTED and tThisFlip >= first_interval+0.5-frameTolerance:
            # keep track of start time/frame for later
            stim2.frameNStart = frameN  # exact frame index
            stim2.tStart = t  # local t and not account for scr refresh
            stim2.tStartRefresh = tThisFlipGlobal  # on global time
            #win.timeOnFlip(stim2, 'tStartRefresh')  # time at next scr refresh
            stim2.setAutoDraw(True)
        if stim2.status == STARTED:
            # is it time to stop? (based on global clock, using actual start)
            if tThisFlipGlobal > stim2.tStartRefresh + secon_interval-frameTolerance:
                # keep track of stop time/frame for later
                stim2.tStop = t  # not accounting for scr refresh
                stim2.frameNStop = frameN  # exact frame index
                #win.timeOnFlip(stim2, 'tStopRefresh')  # time at next scr refresh
                stim2.setAutoDraw(False)

        # ask which stim was the shortest
        if tThisFlip >= first_interval+0.5+secon_interval-frameTolerance:
            question.draw(win)
            quest=True

        # Check whether one of the keys has been pressed: 
        these_keys = event.getKeys(keyList=['q','p','escape'])
        if quest:
            if these_keys:
                these_keys = these_keys[0]
                if these_keys == 'escape':
                    end_exp_now = True
                elif these_keys == 'q':
                    thisChoice = -1 # that means "shorter" was chosen
                    thisRT = t     # record reaction time
                    continue_routine = False
                elif these_keys == 'p':
                    thisChoice = 1 # that means "longer" was chosen
                    thisRT = t
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


    return thisChoice, thisRT, first_interval, secon_interval