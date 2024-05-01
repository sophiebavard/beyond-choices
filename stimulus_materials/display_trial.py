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
median_RT= 0.9872

routineTimer = core.CountdownTimer()

# one set random nr between 1 and 4; np.random.rand() samples from uniform distribution on [0, 1).
# duration of fixation cross
myJitter = 3* np.random.rand(200) +1 

#===========================================================
# The Trial Function
#===========================================================
def obstrial(win, trialCounter, trial_elements, D_choice, D_resptime, split_1, split_2,cond):

    end_exp_now = False

    left_split = split_1
    right_split = split_2 
    
    # defines the area in the circle representing the participants share
    visible_wedge_left = (left_split* 360)
    visible_wedge_right = (right_split*360)
    
    
    #---------------------------------------------------
    #------ Routine: Fixation Cross --------------------
    #---------------------------------------------------
    routineTimer.reset()
    routineTimer.addTime(-myJitter[trialCounter])

    trial_elements.FixCross2.draw(win)
    
    win.flip()

    while routineTimer.getTime() > 0:
        # check for quit (the Esc key)
        if event.getKeys(keyList=["escape"]):
            core.quit()
            
    #---------------------------------------------------
    #---------- Routine: observation trial  ------------
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
    
    # choice rectangle
    polygon = visual.Rect(win=win, name='polygon',
        width=11, height=11, units='cm',
        ori=0.0, pos=(0, 0), anchor='center',
        lineWidth=5.0,     colorSpace='rgb',  lineColor='black', fillColor='none',
        opacity=None, depth=0.0, interpolate=True)
    
    trialClock = core.Clock()
    
    # question mark
    QuestionMark = visual.TextStim(win=win, name='QuestionMark',
        text=u'?\n\n',
        font='Arial', pos=(0, 0), height=0.17, wrapWidth=None, ori=0, color='Black',
        colorSpace='rgb', opacity=1, depth=0.0)

    # reset timers
    t = 0
    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
    trialClock.reset(-_timeToFirstFrame)  # t0 is time of first possible flip
    frameN = -1
    frameTolerance = 0.001  # how close to onset before 'same' frame

    while continue_routine:
        t = trial_elements.ChoiceClock.getTime()
        #update/draw components in each frame
        trial_elements.Pie_background_L.draw(win)
        trial_elements.Pie_me_L.draw(win)
        trial_elements.Pie_background_R.draw(win)
        trial_elements.Pie_me_R.draw(win)
        win.flip()

        # get current time
        t = trialClock.getTime()
        tThisFlip = win.getFutureFlipTime(clock=trialClock)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *polygon* updates
        polygon.pos=(D_choice * 7,0)
        
        # display both choice and RT
        if cond == 1:
                        
            if polygon.status == NOT_STARTED and tThisFlip >= D_resptime-frameTolerance:
                # keep track of start time/frame for later
                polygon.frameNStart = frameN  # exact frame index
                polygon.tStart = t  # local t and not account for scr refresh
                polygon.tStartRefresh = tThisFlipGlobal  # on global time
                #win.timeOnFlip(polygon, 'tStartRefresh')  # time at next scr refresh
                polygon.setAutoDraw(True)
            if polygon.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > polygon.tStartRefresh + 2.0-frameTolerance:
                    # keep track of stop time/frame for later
                    polygon.tStop = t  # not accounting for scr refresh
                    polygon.frameNStop = frameN  # exact frame index
                    #win.timeOnFlip(polygon, 'tStopRefresh')  # time at next scr refresh
                    polygon.setAutoDraw(False)
                    continue_routine = False
        
        # display choice only (longer feedback time)
        elif cond == 2:
                      
            if polygon.status == NOT_STARTED and tThisFlip >= frameTolerance:
                # keep track of start time/frame for later
                polygon.frameNStart = frameN  # exact frame index
                polygon.tStart = t  # local t and not account for scr refresh
                polygon.tStartRefresh = tThisFlipGlobal  # on global time
                #win.timeOnFlip(polygon, 'tStartRefresh')  # time at next scr refresh
                polygon.setAutoDraw(True)
            if polygon.status == STARTED:
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > polygon.tStartRefresh + 2.0+median_RT-frameTolerance:
                    # keep track of stop time/frame for later
                    polygon.tStop = t  # not accounting for scr refresh
                    polygon.frameNStop = frameN  # exact frame index
                    #win.timeOnFlip(polygon, 'tStopRefresh')  # time at next scr refresh
                    polygon.setAutoDraw(False)
                    continue_routine = False
        
        # display RT only
        elif cond == 3:
            
            if polygon.status == NOT_STARTED and tThisFlip >= D_resptime-frameTolerance:
                polygon.lineColor='none'
                # keep track of start time/frame for later
                polygon.frameNStart = frameN  # exact frame index
                polygon.tStart = t  # local t and not account for scr refresh
                polygon.tStartRefresh = tThisFlipGlobal  # on global time
                #win.timeOnFlip(polygon, 'tStartRefresh')  # time at next scr refresh
                polygon.setAutoDraw(True)                
            if polygon.status == STARTED:
                QuestionMark.draw(win)
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > polygon.tStartRefresh + 2.0-frameTolerance:
                    # keep track of stop time/frame for later
                    polygon.tStop = t  # not accounting for scr refresh
                    polygon.frameNStop = frameN  # exact frame index
                    #win.timeOnFlip(polygon, 'tStopRefresh')  # time at next scr refresh
                    polygon.setAutoDraw(False)
                    win.flip()
                    continue_routine = False
        
        # display nothing (longer feedback time)
        else:
            
            if polygon.status == NOT_STARTED and tThisFlip >= frameTolerance:
                polygon.lineColor='none'
                # keep track of start time/frame for later
                polygon.frameNStart = frameN  # exact frame index
                polygon.tStart = t  # local t and not account for scr refresh
                polygon.tStartRefresh = tThisFlipGlobal  # on global time
                #win.timeOnFlip(polygon, 'tStartRefresh')  # time at next scr refresh
                polygon.setAutoDraw(True)
            if polygon.status == STARTED:
                QuestionMark.draw(win)
                # is it time to stop? (based on global clock, using actual start)
                if tThisFlipGlobal > polygon.tStartRefresh + 2.0+median_RT-frameTolerance:
                    # keep track of stop time/frame for later
                    polygon.tStop = t  # not accounting for scr refresh
                    polygon.frameNStop = frameN  # exact frame index
                    #win.timeOnFlip(polygon, 'tStopRefresh')  # time at next scr refresh
                    polygon.setAutoDraw(False)
                    win.flip()
                    continue_routine = False


        # Check whether one of the keys has been pressed: 
        these_keys = event.getKeys(keyList=['escape'])
        if these_keys:
                these_keys = these_keys[0]
                if these_keys == 'escape':
                    end_exp_now = True
                        
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


    return left_split, right_split