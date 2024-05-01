#!/usr/bin/env python2

#===========================================================
# Importing Modules
#===========================================================
from __future__ import absolute_import, division
from psychopy import gui, visual, core, data, event, logging, clock, colors, layout
from psychopy.constants import (NOT_STARTED, STARTED, PLAYING, PAUSED,
                                STOPPED, FINISHED, PRESSED, RELEASED, FOREVER)
import numpy as np
import math

#===========================================================
# Setup
#===========================================================

endExpNow = False  # flag for 'escape' or other condition => quit the exp
frameTolerance = 0.001  # how close to onset before 'same' frame

#===========================================================
# The Trial Function
#===========================================================
def trial(win, trial_SVO, trial_elements, me_labels, other_labels):

    # Initialize components for Routine "trial"
    trialClock = core.Clock()
    slider = visual.Slider(win=win, name='slider',
        startValue=None, size=(1.0, 0.1), pos=(0, 0), units=None,
        labels=me_labels, ticks=(1,2,3,4,5,6,7,8,9), granularity=1.0,
        style='rating', styleTweaks=(), opacity=None,
        labelColor='Black', markerColor='Black', lineColor=[-1.0000, -1.0000, -1.0000], colorSpace='rgb',
        font='Arial', labelHeight=0.05,
        flip=True, ori=0.0, depth=0, readOnly=False)
    slider.marker.size=(0.05,0.0875)

    sliderfake = visual.Slider(win=win, name='sliderfake',
        startValue=None, size=(1.0, 0.1), pos=(0, 0), units=None,
        labels=other_labels, ticks=(1,2,3,4,5,6,7,8,9), granularity=1.0,
        style='rating', styleTweaks=(), opacity=None,
        labelColor='Black', markerColor='None', lineColor='None', colorSpace='rgb',
        font='Arial', labelHeight=0.05,
        flip=False, ori=0.0, depth=0, readOnly=True)

    InstructSVO = visual.TextStim(win=win, name='InstructSVO',
                                text=u'Wählen Sie eine Aufteilung.\n\n'
                                     u'%s/15\n\n\n\n'
                                     u'Sie\n\n\n\n\n\n\n\n'
                                     u'Jemand\n\n\n\n' %(trial_SVO),
                                font='Arial', pos=(0, 0.08), height=0.06, color='Black',
                                colorSpace='rgb', opacity=1)

    image = visual.ButtonStim(win, text="Senden", fillColor="lightgrey", font="Arial", bold=False,
                                color="black", size=(0.15, 0.1), pos=[0, -0.6], letterHeight=0.045)
    mouse = event.Mouse(win=win)
    mouse.mouseClock = core.Clock()

    # setup some python lists for storing info about the mouse
    mouse.x = []
    mouse.y = []
    mouse.leftButton = []
    mouse.midButton = []
    mouse.rightButton = []
    mouse.time = []
    mouse.clicked_name = []
    gotValidClick = False  # until a click is received

    # Create some handy timers
    globalClock = core.Clock()  # to track the time since experiment started
    routineTimer = core.CountdownTimer()  # to track time remaining of each (non-slip) routine 

    # ------Prepare to start Routine "trial"-------
    end_exp_now = False
    continueRoutine = True
    event.clearEvents()
    # update component parameters for each repeat
    slider.reset()
    sliderfake.reset()
    # keep track of which components have finished
    trialComponents = [slider,sliderfake,image,mouse]
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

    # -------Run Routine "trial"-------
    while continueRoutine:
        
        InstructSVO.draw()
        
        # get current time
        t = trialClock.getTime()
        tThisFlip = win.getFutureFlipTime(clock=trialClock)
        tThisFlipGlobal = win.getFutureFlipTime(clock=None)
        frameN = frameN + 1  # number of completed frames (so 0 is the first frame)
        # update/draw components on each frame
        
        # *slider* updates
        if slider.status == NOT_STARTED and tThisFlip >= 0.0-frameTolerance:
            # keep track of start time/frame for later
            slider.frameNStart = frameN  # exact frame index
            slider.tStart = t  # local t and not account for scr refresh
            slider.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(slider, 'tStartRefresh')  # time at next scr refresh
            sliderfake.setAutoDraw(True)
            slider.setAutoDraw(True)
        
        # Check slider for response to end routine
#        if slider.getRating() is not None and slider.status == STARTED:
#            continueRoutine = False

        # *image* updates
        if image.status == NOT_STARTED and slider.rating:
            # keep track of start time/frame for later
            image.frameNStart = frameN  # exact frame index
            image.tStart = t  # local t and not account for scr refresh
            image.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(image, 'tStartRefresh')  # time at next scr refresh
            image.setAutoDraw(True)
        # *mouse* updates
        if mouse.status == NOT_STARTED and slider.rating:
            # keep track of start time/frame for later
            mouse.frameNStart = frameN  # exact frame index
            mouse.tStart = t  # local t and not account for scr refresh
            mouse.tStartRefresh = tThisFlipGlobal  # on global time
            win.timeOnFlip(mouse, 'tStartRefresh')  # time at next scr refresh
            mouse.status = STARTED
            mouse.mouseClock.reset()
            prevButtonState = mouse.getPressed()  # if button is down already this ISN'T a new click
        if mouse.status == STARTED:  # only update if started and not finished!
            buttons = mouse.getPressed()
            if buttons != prevButtonState:  # button state changed?
                prevButtonState = buttons
                if sum(buttons) > 0:  # state changed to a new click
                    # check if the mouse was inside our 'clickable' objects
                    gotValidClick = False
                    try:
                        iter(image)
                        clickableList = image
                    except:
                        clickableList = [image]
                    for obj in clickableList:
                        if obj.contains(mouse):
                            gotValidClick = True
                            mouse.clicked_name.append(obj.name)
                    x, y = mouse.getPos()
                    mouse.x.append(x)
                    mouse.y.append(y)
                    buttons = mouse.getPressed()
                    mouse.leftButton.append(buttons[0])
                    mouse.midButton.append(buttons[1])
                    mouse.rightButton.append(buttons[2])
                    mouse.time.append(mouse.mouseClock.getTime())
                    if gotValidClick:
                        win.flip()
                        continueRoutine = False  # abort routine on response
        
        # check for quit (typically the Esc key)
        if endExpNow or event.getKeys(keyList=["escape"]):
            core.quit()
        
        # check if all components have finished
        if not continueRoutine:  # a component has requested a forced-end of Routine
            break
        continueRoutine = False  # will revert to True if at least one component still running
        for thisComponent in trialComponents:
            if hasattr(thisComponent, "status") and thisComponent.status != FINISHED:
                continueRoutine = True
                break  # at least one component has not yet finished
        
        # refresh the screen
        if continueRoutine:  # don't flip if this routine is over or we'll get a blank screen
            win.flip()
        
    # -------Ending Routine "trial"-------
    for thisComponent in trialComponents:
        if hasattr(thisComponent, "setAutoDraw"):
            thisComponent.setAutoDraw(False)

    thisChoice_SVO = slider.getRating()
    thisRT_SVO = slider.getRT()
    thisMe = slider.labels[int(slider.getRating())-1]
    thisOther = sliderfake.labels[int(slider.getRating())-1]

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


    return thisChoice_SVO, thisRT_SVO, float(thisMe), float(thisOther)