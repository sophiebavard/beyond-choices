#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import absolute_import, division
from psychopy import gui, visual, core, data, event, logging, clock, colors, layout
from psychopy.constants import (NOT_STARTED, STARTED, PLAYING, PAUSED,
                                STOPPED, FINISHED, PRESSED, RELEASED, FOREVER)
import numpy as np
import math

#===========================================================
# The Trial Function
#===========================================================
def trial(win, image_estim_path, trial_elements):
        
    mouse = event.Mouse(win=win)
    mouse.mouseClock = core.Clock()
    mouse.setPos(newPos=(-0.25,-0.25)) # place the mouse on the slider
    
    slider = visual.Slider(win=win, name='slider',
        startValue=0.1, pos=(-7,0), size=(2,10), units='cm',
        labels=None, ticks=(0,1), granularity=0.0,
        style='slider', styleTweaks=(), opacity=0,
        labelColor='black', markerColor=trial_elements.me_color,
        lineColor='Grey', colorSpace='rgb',
        font='Open Sans', labelHeight=0.05,
        flip=False, ori=0.0, depth=0, readOnly=False)

    slider.marker.size = (slider.size[0], .5)

    circle_you = visual.RadialStim(
        win=win, name='circle_you', color=trial_elements.you_color,
        angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', ori= 00,
        pos=(7,0), size=(10,10), units='cm')

    circle_me = visual.RadialStim(
        win=win, name='circle_me', color=trial_elements.me_color,
        angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', ori= 30,
        pos=(7,0), size=(10,10), units='cm')

#    InstructAllocation = visual.TextStim(win=win, name='InstructAllocation',
#                                text=u'Was ist bevorzugte Aufteilung dieser Person?\n\n'
#                                     u'(Bitte benutze die Maus)'
#                                     u'\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n'
#                                     u'< Weiter mit Leertaste >',
#                                font='Arial', pos=(0, 0.1), height=0.06, color='Black',
#                                colorSpace='rgb', opacity=1)
#    InstructAllocation = visual.TextBox2(win=win, name='InstructAllocation',
#                                text=u'Was ist bevorzugte Aufteilung dieser Person?\n\n'
#                                     u'(Bitte benutze die Maus)'
#                                     u'\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n'
#                                     u'< Weiter mit Leertaste >',
#                                font='Arial', pos=(0, 0.1), letterHeight=0.06, color='Black',
#                                colorSpace='rgb', opacity=1, alignment='center')

    InstructAllocation = visual.ImageStim(win=win, name='PicEstim', image=image_estim_path, pos=(0, 0), size=2)

#    InstructAllocation = visual.ButtonStim(win, text=u'Was ist bevorzugte Aufteilung dieser Person?\n\n'
#                                     u'(Bitte benutze die Maus)'
#                                     u'\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n'
#                                     u'< Weiter mit Leertaste >', fillColor=None, font="Arial", bold=False,
#                                color="black", size=(1,1), pos=(0, 0.1), letterHeight=0.06)

    # Create some handy timers
    trialClock = core.Clock()
    globalClock = core.Clock()  # to track the time since experiment started
    routineTimer = core.CountdownTimer()  # to track time remaining of each (non-slip) routine 

    # ------Prepare to start Routine "trial"-------
    end_exp_now = False  # flag for 'escape' or other condition => quit the exp
    frameTolerance = 0.001  # how close to onset before 'same' frame
    continue_routine = True
    event.clearEvents()
    
    # update component parameters for each repeat
    slider.reset()
    # keep track of which components have finished
    trialComponents = [slider, circle_you, circle_me,InstructAllocation]
    for thisComponent in trialComponents:
        thisComponent.tStart = None
        thisComponent.tStop = None
        thisComponent.tStartRefresh = None
        thisComponent.tStopRefresh = None
        if hasattr(thisComponent, 'status'):
            thisComponent.status = NOT_STARTED
    # reset timers
    t = 0
    _timeToFirstFrame = win.getFutureFlipTime(clock="now")
    trialClock.reset(-_timeToFirstFrame)  # t0 is time of first possible flip
    frameN = -1
    
    #if continue_routine:
    #InstructAllocation.draw()
    
    # -------Run Routine "trial"-------
    while continue_routine:

        InstructAllocation.draw()
        logging.flush()
        
        # get current time
        t = trialClock.getTime()
        tThisFlip = win.getFutureFlipTime(clock=trialClock)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        
        # *slider* updates
        if slider.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            slider.frameNStart = frameN  # exact frame index
            slider.tStart = t  # local t and not account for scr refresh
            slider.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(slider, 'tStartRefresh')  # time at next scr refresh
            slider.setAutoDraw(True)
    
        # *circle_you* updates
        if circle_you.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            circle_you.frameNStart = frameN  # exact frame index
            circle_you.tStart = t  # local t and not account for scr refresh
            circle_you.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(circle_you, 'tStartRefresh')  # time at next scr refresh
            circle_you.setAutoDraw(True)
        
        # *circle_me* updates
        if circle_me.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            circle_me.frameNStart = frameN  # exact frame index
            circle_me.tStart = t  # local t and not account for scr refresh
            circle_me.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(circle_me, 'tStartRefresh')  # time at next scr refresh
            circle_me.setAutoDraw(True)

        if slider.markerPos:
            logging.flush()
            a =  (slider.markerPos * 360)
            circle_me.visibleWedge=(0.0,a)

        these_keys = event.getKeys(keyList=['space', 'escape'])
        if these_keys:
            these_keys = these_keys[0]
            # if escape was pressed quit experiment
            if these_keys == 'escape':
                end_exp_now = True
            # if a decision was made continue in the loop
            if these_keys in ['space']:
                thisRT = t
                win.flip()
                continue_routine = False
                            
        if not continue_routine:
            break

        # check for quit (the escape key)
        if end_exp_now or event.getKeys(keyList=["escape"]):
            core.quit()
            
        # check if all components have finished
        if not continue_routine:  # a component has requested a forced-end of Routine
            break
        continue_routine = False  # will revert to True if at least one component still running
        for thisComponent in trialComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continue_routine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continue_routine:  # don't flip if this routine is over or we'll get a blank screen
            logging.flush()
            win.flip()
            logging.flush()
            
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
    logging.flush()

    # -------Start Routine "ISI"-------
    while routineTimer.getTime() > 0:
        # check for quit (the Esc key)
        if end_exp_now or event.getKeys(keyList=["escape"]):
            core.quit()

    return float(slider.markerPos), thisRT


