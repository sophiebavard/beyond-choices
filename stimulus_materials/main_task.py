 #!/usr/bin/env python2
# -*- coding: utf-8 -*-

# ============================
# Importing Modules
# ============================
from __future__ import absolute_import, division
from psychopy import gui, visual, core, data, event, logging, parallel
import numpy as np
import pandas as pd
import random as rnd
import csv
import os
import sys

# import the trial function and the script were the choices are generated
import slider_SVO
import DG_2_0_Trial
import generate_allocations
import generate_observations
import display_trial
import estimate_allocation
import predict_trials
import time_perception

# =============================
# General Setup
# =============================
# Ensure that relative paths start from the same directory as this script
#_thisDir = os.path.dirname(os.path.abspath(__file__)).decode(sys.getfilesystemencoding())
_thisDir = os.path.dirname(os.path.abspath(__file__)).encode().decode(sys.getfilesystemencoding())
os.chdir(_thisDir)

# Store info about the experiment session
expName = 'Observing_DG'
expInfo = {u'participant': u'999', u'redOrBlue': 1} # red=0, blue=1
dlg = gui.DlgFromDict(dictionary=expInfo, title=expName)
if not dlg.OK:
    core.quit()  # user pressed cancel
expInfo['date'] = data.getDateStr()  # add a simple timestamp
expInfo['expName'] = expName

logFile = logging.LogFile(u'data' + os.sep + u'LogFile_' + expInfo['participant'] + u'.log', level=logging.INFO)
logging.console.setLevel(logging.WARNING)  # this outputs to the screen, not a file

endExpNow = False  # flag for 'escape' or other condition => quit the exp

# =============================================
# Setting up some Variables for the Experiment
# =============================================

plotSize = .15  # Change here AND in ExpTrial.py

# set up some variables
pool=3
trialCounter1 = 0
trialCounter2 = 0
trialCounter3 = 0
reward    = -99
rewardObs = -99
rewardTP  = -99


# if redOrBlue is zero participants color is red
if expInfo[u'redOrBlue'] == 0:
    me_color = [1, -1, -1]
    you_color = [-1, .064, 1]
    me_col_text = u'rote'
    you_col_text = u'blaue'
    ex_img_path = u'Assets' + os.sep + u'examplepic_me_red.png'

else: # if redOrBlue is one participants color is blue
    you_color = [1, -1, -1]
    me_color = [-1, .064, 1]
    me_col_text = u'blaue'
    you_col_text = u'rote'
    ex_img_path = u'Assets' + os.sep + u'examplepic_me_blue.png'

image_estim_path = u'Assets' + os.sep + u'pic_estimation.png'
image_predi_path = u'Assets' + os.sep + u'pic_prediction.png'

image_obs_path1 = u'Assets' + os.sep + u'pic_obs1.png'
image_obs_path2 = u'Assets' + os.sep + u'pic_obs2.png'
image_obs_path3 = u'Assets' + os.sep + u'pic_obs3.png'
image_obs_path4 = u'Assets' + os.sep + u'pic_obs4.png'

# left_right if the higher split is displayed left or right should be random
left_right = np.repeat([True, False], int(83))
rnd.shuffle(left_right)

# left_right if the higher split is displayed left or right should be random
first_second = np.repeat([True, False], int(83))
rnd.shuffle(first_second)

# =================================================================
# Start Code - component code to be run before the window creation
# =================================================================
# Setup the Window

win = visual.Window(
    size=(1920, 1080), fullscr=True, screen=1, allowGUI=False, allowStencil=False,
    monitor=u'testMonitor', color=[1, 1, 1], colorSpace='rgb', blendMode='avg', useFBO=True, waitBlanking=True)

# store frame rate of monitor if we can measure it
expInfo['frameRate'] = win.getActualFrameRate()

#save the basic participant infos
np.savetxt(u'data' + os.sep + u'Info_VP_' + expInfo['participant'] + u'.csv',
           (expInfo['redOrBlue'], expInfo['frameRate']), header='redOrBlue,frameRate', delimiter=',',
           fmt='%.6f', comments='')

# ============================
# Initializing Components
# ============================
# Initialize components for Routine "ForcedInstruct"
InstructClock = core.Clock()

InstructSVO = visual.TextStim(win=win, name='SVOInstruct',
                                text=u'Sie als Entscheidungsträger:in können Ihre Wahl registrieren, indem Sie einen Schieberegler verschieben,'
                                u'um die Zuordnung der Auszahlungen zwischen Ihnen und einer anderen Person zu ändern. Wenn Sie Ihre Wahl getroffen haben, '
                                u'drücken Sie auf die Schaltfläche "Senden", um zur nächsten Frage zu gelangen.\n\n'
                                u'Es gibt keine richtigen oder falschen Antworten, hier geht es nur um persönliche Vorlieben. Wie Sie sehen können, '
                                u'beeinflussen Ihre Entscheidungen sowohl den Geldbetrag, den Sie erhalten, als auch den Geldbetrag, den die andere Person erhält.\n\n'
                                u'< Weiter mit Linksklick >',
                                font='Arial', pos=(0, 0), height=0.06, wrapWidth=None, ori=0, color='Black',
                                colorSpace='rgb', opacity=1, depth=0.0)

Instruct = visual.TextStim(win=win, name='forcedInstruct',
                                text=u'Im ersten Teil dieses Experiments sollst du dich jeweils zwischen zwei Optionen entscheiden. Diese '
                                u'Optionen sind Aufteilungen von 3 € zwischen dir und einer anderen Person. Die Optionen sind in Form von Kreisen '
                                u'mit zwei Farben dargestellt.\n\n Der %s Anteil des Kreises ist der Betrag, welchen du bekommst, wenn diese Option ausgespielt '
                                u'wird. Der %s Anteil des Kreises hingegen ist der Betrag, welchen die andere Person erhält. Am Ende des Experiments '
                                u'wird eine deiner Entscheidungen per Zufall bestimmt und deine bevorzugte Aufteilung wird ausgezahlt.\n\n'
                                u'< Weiter mit Leertaste >' %(me_col_text, you_col_text),
                                font='Arial', pos=(0, 0), height=0.06, wrapWidth=None, ori=0, color='Black',
                                colorSpace='rgb', opacity=1, depth=0.0)

ExamplePic = visual.ImageStim(win=win, name='ExamplePic', image=ex_img_path, pos=(0, 0), size=1.5)

Instruct3 = visual.TextStim(win=win, name='forcedInstruct3',
                                text=u'Es folgen nun einige Entscheidungen als Training. Für die linke Option entscheidest du dich mit der Q-Taste. '
                                u'Für die rechte Option entscheidest du dich mit der P-Taste. Lege dazu beide Zeigefinger über die Tasten Q und P. '
                                u'Falls dir bis hierhin etwas unklar ist, melde dich ruhig kurz.\n\n'
                                u'< Weiter mit Leertaste >',
                                font='Arial', pos=(0, 0), height=0.06, wrapWidth=None, ori=0, color='Black',
                                colorSpace='rgb', opacity=1, depth=0.0)

# Initialize components for Routine "TrainingEnd"
TrainingEndText = visual.TextStim(win=win, name='TrainingEndText', text=u'Training beendet!\n\nFalls du noch Fragen hast, stelle sie bitte jetzt.\n\n'
                                    u'< Zum Starten Leertaste druecken >',
                                  font='Arial', pos=(0, 0), height=0.06, wrapWidth=None, ori=0, color='Black',
                                  colorSpace='rgb', opacity=1, depth=0.0)


# The elements for the trial are put into a class to enable the trials to be called from a separate file
class TrialElements:

    def __init__(self):
        pass

    me_color=me_color;
    you_color=you_color;

    # # Initialize components for Routine "Fixation"
    FixationClock = core.Clock()
    FixCross = visual.TextStim(win=win, name='FixCross', text='+', font='Arial', pos=(0, .05), height=0.15,
                               wrapWidth=None, ori=0, color='black', colorSpace='rgb', opacity=1, depth=0.0)

    FixCross2 = visual.TextStim(win=win, name='FixCross2', text='Beobachte!', font='Arial', pos=(0, .05), height=0.10,
                               wrapWidth=None, ori=0, color='black', colorSpace='rgb', opacity=1, depth=0.0)
    
    FixCross3 = visual.TextStim(win=win, name='FixCross3', text='Jetzt sollst du einige ihrer Entscheidungen vorhersagen.', font='Arial', pos=(0, .05), height=0.10,
                               wrapWidth=None, ori=0, color='black', colorSpace='rgb', opacity=1, depth=0.0)

    # Initialize components for Routine "Choice" with the two circles
    ChoiceClock = core.Clock()
    
    Pie_background_L = visual.RadialStim( win=win, name='Pie_background_L', color=you_color,
    angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', 
    ori= 0, pos=(-7,0),  size=(10,10), units='cm') 
    
    Pie_background_R = visual.RadialStim( win=win, name='Pie_background_R', color=you_color,
    angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', 
    ori= 0, pos=(7,0),  size=(10,10), units='cm') 
    
    Pie_me_L = visual.RadialStim(win=win, name='Pie_me_L', color= me_color,
    angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', ori= 0,
    pos=(-7,0), size=(10,10), units='cm') 
    
    Pie_me_R = visual.RadialStim(win=win, name='Pie_me_R', color= me_color,
    angularCycles = 0, radialCycles = 0, radialPhase = 0.5, colorSpace = 'rgb', ori= 0,
    pos=(7,0), size=(10,10), units='cm') 
    
     # Initialize components for Routine "ISI"
    ISIClock = core.Clock()
    blank = visual.TextStim(win=win, name='blank', text=' ', font='Arial', pos=(0, 0), height=0.1, wrapWidth=None,
                            ori=0, color='white', colorSpace='rgb', opacity=1, depth=0.0)
    
trial_elements = TrialElements()

# Initialize components for Routine "Break"
BreakClock = core.Clock()
BreakMsg = visual.TextStim(win=win, name='BreakMsg',
                       text=u"15 Sekunden Pause!"
                       , font='Arial', pos=(0, 0), height=0.06, wrapWidth=None, ori=0, color='black',
                       colorSpace='rgb', opacity=1, depth=-1.0)
BreakEndMsg = visual.TextStim(win=win, name='BreakEndMsg', text=u"Pause...!\n\nDu kannst dich kurz entspannen.\n\nWenn du bereit bist fortzufahren, druecke die Leertaste.",
                          font='Arial', pos=(0, 0), height=0.06, wrapWidth=None, ori=0, color='black',
                          colorSpace='rgb', opacity=1, depth=-2.0)

StartingDispDict1 = visual.TextStim(win=win, name='StartingDispDict1', text=u'Im zweiten Teil des Experiments wirst du Entscheidungen beobachten, '
                        u'die andere Personen in diesem Experiment getroffen haben. Für jeden beobachtete Person siehst du entweder ihre Entscheidung '
                        u'und ihre Reaktionszeit, nur eine dieser beiden Informationen, oder keine der beiden. Von Zeit zu Zeit wirst du gebeten, '
                        u'die bevorzugte Aufteilung dieser Person zu schätzen und ihre nächste Entscheidung vorherzusagen.\n\n'
                        u'< Weiter mit Leertaste >',
                        font='Arial', pos=(0, 0), height=0.06, wrapWidth=None, ori=0, color='black',
                        colorSpace='rgb', opacity=1, depth=-2.0)

StartingDispDict2 = visual.TextStim(win=win, name='StartingDispDict2', text=u'Nachdem du die Entscheidungen jeder Person beobachtet hast, sollst du '
                        u'einige ihrer Entscheidungen vorhersagen. Lege dazu beide Zeigefinger über die Tasten Q und P. Falls dir bis hierhin etwas '
                        u'unklar ist, melde dich ruhig kurz.\n\n'
                        u'< Weiter mit Leertaste >',
                        font='Arial', pos=(0, 0), height=0.06, wrapWidth=None, ori=0, color='black',
                        colorSpace='rgb', opacity=1, depth=-2.0)

StartingDispDict3 = visual.TextStim(win=win, name='StartingDispDict3', text=u'Für den nächsten Teil sollst du die Maus UND die Tastatur benutzen.\n\n'
                        u'< Weiter mit Linksklick >',
                        font='Arial', pos=(0, 0), height=0.06, wrapWidth=None, ori=0, color='black',
                        colorSpace='rgb', opacity=1, depth=-2.0)
                          
StartingTimePerc = visual.TextStim(win=win, name='StartingTimePerc', text=u'Im dritten Teil des Experiments wirst du gebeten, '
                        u'eine Aufgabe zur Zeitwahrnehmung durchzuführen. Du wirst zwei Quadrate sehen, die nacheinander für unterschiedliche '
                        u'Zeiträume auf dem Bildschirm vor dir erscheinen. Dann wirst du gefragt, ob das zweite Quadrat im Vergleich zum ersten '
                        u'kürzer oder länger präsentiert wurde. \n\n'
                        u'Es folgen nun einige Entscheidungen als Training. Lege dazu beide Zeigefinger über die Tasten Q und P.\n\n'
                        u'Falls dir bis hier hin etwas unklar ist, melde dich ruhig kurz.\n\n'
                        u'< Weiter mit Leertaste >',
                        font='Arial', pos=(0, 0), height=0.06, wrapWidth=None, ori=0, color='black',
                        colorSpace='rgb', opacity=1, depth=-2.0)

# experiment ended message
FeedbackMsg = visual.TextStim(win=win, name = 'FeedbackMsg', text='default', font=u'Arial', pos=(0,0), height=0.06, 
                wrapWidth=None, ori = 0, color=u'black', colorSpace='rgb', opacity=1, depth=-1.0)


# ===========================
# Routine: SVO
# ===========================

nsub_SVO   = np.empty([0], dtype=int)
choice_SVO = np.empty([0], dtype=int)
rt_SVO     = np.empty([0], dtype=int) 
me_SVO     = np.empty([0], dtype=int)
other_SVO  = np.empty([0], dtype=int)

print('Start first SVO')

mouse = event.Mouse()
continueRoutine=True
while continueRoutine:
    InstructSVO.draw(win) 
    win.flip()
    if mouse.getPressed()[0]==1: # if the left mouse button is pressed
        mouse.clickReset()
        break
    # check for quit (the Esc key)
    if event.getKeys(keyList=['escape']):
        core.quit()

# set up the trial handler to look after randomisation of conditions (psychopy function)
SVOtrials = data.TrialHandler(nReps=1, method='sequential', extraInfo=expInfo, originPath=-1,
                                    trialList=data.importConditions('svoTrials.csv'), seed=None, name='SVOtrials')

trial_SVO1 = 0

for thisSVOtrial in SVOtrials:
    
    trial_SVO1 = trial_SVO1+1
    
    # abbreviate parameter names
    me_labels = list(thisSVOtrial['points_me'].split((' ')))
    other_labels = list(thisSVOtrial['points_other'].split((' ')))
    
    # append data to vectors so that they can be saved later
    thisChoice_SVO, thisRT_SVO, thisMe, thisOther = slider_SVO.trial(win, trial_SVO1, trial_elements, me_labels, other_labels)
    nsub_SVO = np.append(nsub_SVO, int(expInfo['participant']))
    choice_SVO = np.append(choice_SVO, thisChoice_SVO)
    rt_SVO = np.append(rt_SVO, thisRT_SVO)
    me_SVO = np.append(me_SVO, thisMe)
    other_SVO = np.append(other_SVO, thisOther)
    logging.flush()

#----------Save SVO1 data -------------
#------------------------------------

ExpData = np.stack((nsub_SVO, choice_SVO, rt_SVO, me_SVO, other_SVO), axis = 1)
myHeader = 'subject_number, Choice, RT, for_me, for_other'
np.savetxt(u'data'+ os.sep + u'SVO1_Data_' + expInfo['participant'] + u'.csv', ExpData, header = myHeader, delimiter = ',', fmt = '%.6f', comments = '')
logging.flush()


# ================================================================
# Routine: Forced Choice Instructions and calculate Expl_choices
# ================================================================
# ------Prepare to start Routine "ForcedInstruct"-------
page = 0
continueRoutine = True
event.clearEvents(eventType='keyboard')
t = 0
InstructClock.reset()  # clock

# -------Start Routine "ForcedInstruct"-------
print('experiment started')
Instruct.draw(win)
win.flip()

# generate the trials while the person is reading the instructions
print ('calculating exp trials')
data_generated = generate_allocations.create_expl_trials(expInfo['participant'])
print('done')

nExpTrials = len(data_generated)

print ('calculating observation trials')
data_obs_generated = generate_observations.create_obs_trials(expInfo['participant'])
print('done')

#------------------------------------
# Instructions DG
#------------------------------------

while continueRoutine:
    
    t = InstructClock.getTime()

    theseKeys = event.getKeys(keyList=['space'])
    # Start checking the keys after 5 seconds
    if 5.0 <= t and len(theseKeys) > 0:  # at least one key was pressed
        if page == 0:
            ExamplePic.draw(win)
            print('example pic')
            win.flip()

            page += 1
        elif page == 1:
            Instruct3.draw(win)
            win.flip()
            page += 1

        else:
            continueRoutine = False

    if not continueRoutine:  # a component has requested a forced-end of Routine
       break

    # check for quit (the Esc key)
    if event.getKeys(keyList=['escape']):
        core.quit()

# ===========================
# Routine: Training
# ===========================
# training splits are hard coded here
trainingSplits = [(.875, .205, True),
                    (.555,.7, True),
                    (.5, .75,True),
                    (.322, 1, False) ]

print('Start Training')
for split_1, split_2, this_left_right in trainingSplits:
    DG_2_0_Trial.trial(win, trialCounter1, trial_elements, split_1, split_2, training=True, left_right=this_left_right)
    logging.flush()

# ============================
# Routine: End Training
# ============================
TrainingEndText.draw(win)
win.flip()

while True:
    theseKeys = event.getKeys(keyList=['space'])
    
    if len (theseKeys) > 0:
        training = False
        break
    if event.getKeys(keyList=['escape']):
        core.quit()

# select the reward trial
rewardTrial = np.random.randint(1, nExpTrials)
print('DG reward Trial selected: %i' %rewardTrial)

# ===========================
# Loop: generate_allocations
# ===========================

print('Starting generate_allocations')

# Arrays to save the answers to
DG2_0_Chosen = np.empty([0], dtype=int)
DG2_0_RT = np.empty([0], dtype=float)
left_splits = np.empty([0], dtype=float)
right_splits = np.empty([0], dtype=float)

# set up the trial handler to look after randomisation of conditions (psychopy function)
GeneratedTrials = data.TrialHandler(nReps=1, method='random', extraInfo=expInfo, originPath=-1,
                                    trialList=data.importConditions('GeneratedTrials.csv'), seed=None, name='GeneratedTrials')

for thisGeneratedTrial in GeneratedTrials:
    # abbreviate parameter names
    split_1 = thisGeneratedTrial['split_1']
    split_2 = thisGeneratedTrial['split_2']

    # =============================
    # Routines: DG Trials
    # =============================
    
    # append data to vectors so that they can be saved later
    thisChoice, thisRT, left_split, right_split = DG_2_0_Trial.trial(win, trialCounter1, trial_elements, split_1, split_2, training, left_right = left_right[trialCounter1])
    DG2_0_Chosen = np.append(DG2_0_Chosen, thisChoice)
    DG2_0_RT = np.append(DG2_0_RT, thisRT)
    left_splits = np.append(left_splits,left_split)
    right_splits = np.append(right_splits, right_split)

    logging.flush()
    trialCounter1 += 1
    
    # compute the reward if reward trial
    if trialCounter1 == rewardTrial: 
            if thisChoice == 1:
                reward = right_split * 3
                #reward_int = round(reward,1)
                reward_txt = str(reward) 
                reward_other = str(3-reward) 
            else:
                reward = left_split * 3
                #reward_int = round(reward,1)
                reward_txt = str(reward) 
                reward_other = str(3-reward) 

#----------Save DG data -------------
#------------------------------------

print('Reward DG: %s €' %reward_txt)

sub = np.repeat([int(expInfo['participant'])],[nExpTrials])
ExpData = np.stack((sub, DG2_0_Chosen, DG2_0_RT, left_splits, right_splits), axis = 1)
myHeader = 'subject_number, Choice, RT, left_split, right_split'
np.savetxt(u'data'+ os.sep + u'DG_Data_' + expInfo['participant'] + u'.csv', ExpData, header = myHeader, delimiter = ',', fmt = '%.6f', comments = '')
logging.flush()

# ===========================
# Loop: display_dictators
# ===========================

# select the reward trial
rewardTrialObs = np.random.choice(range(4, 193, 4),1)
print('Obs reward Trial selected: %i' %rewardTrialObs)

mouse = event.Mouse()
dispObsInstruct = True
while dispObsInstruct:
    StartingDispDict1.draw(win) 
    win.flip()
    logging.flush()
    if event.getKeys(keyList=['space']):
        break
    # check for quit (the Esc key)
    if event.getKeys(keyList=['escape']):
        core.quit()
dispObsInstruct = True
while dispObsInstruct:
    StartingDispDict2.draw(win) 
    win.flip()
    logging.flush()
    if event.getKeys(keyList=['space']):
        break
    # check for quit (the Esc key)
    if event.getKeys(keyList=['escape']):
        core.quit()
dispObsInstruct = True
while dispObsInstruct:
    StartingDispDict3.draw(win)
    win.flip()
    logging.flush()
    if mouse.getPressed()[0]==1: # if the left mouse button is pressed
        mouse.clickReset()
        break
    # check for quit (the Esc key)
    if event.getKeys(keyList=['escape']):
        core.quit()

print('Starting display_dictators')

# Arrays to save the answers to
# estimation
subObs          = np.empty([0], dtype=int)
condObs         = np.empty([0], dtype=int)
dictator_number = np.empty([0], dtype=int)
dictator_PA     = np.empty([0], dtype=float)
estimation      = np.empty([0], dtype=float)
estimation_RT   = np.empty([0], dtype=float)
accuracyObs     = np.empty([0], dtype=float)
# prediction
subPred         = np.empty([0], dtype=int)
condPred        = np.empty([0], dtype=int)
D_subPred       = np.empty([0], dtype=int)
D_choicePred    = np.empty([0], dtype=int)
D_resptimePred  = np.empty([0], dtype=float)
left_splitPred  = np.empty([0], dtype=float)
right_splitPred = np.empty([0], dtype=float)
ChoicePred      = np.empty([0], dtype=int)
RTPred          = np.empty([0], dtype=float)

# set up the trial handler to look after randomisation of conditions (psychopy function)
DictatorTrials = data.TrialHandler(nReps=1, method='sequential', extraInfo=expInfo, originPath=-1,
                                    trialList=data.importConditions('GeneratedTrialsObs.csv'), seed=None, name='DictatorTrials')#GeneratedTrialsObs

for thisGeneratedTrial in DictatorTrials:
    # abbreviate parameter names
    Nsub = thisGeneratedTrial['sub']
    PA = thisGeneratedTrial['PA']
    D_choice = thisGeneratedTrial['Choice']
    D_resptime = thisGeneratedTrial['RT']
    split_1 = thisGeneratedTrial['left_split']
    split_2 = thisGeneratedTrial['right_split']
    cond = thisGeneratedTrial['cond']
    
    # Instructions for observation trials
    
    if cond==1:
        InstructObs =  visual.ImageStim(win=win, name='PicObs', image=image_obs_path1, pos=(0, 0), size=2)
#        InstructObs = visual.TextStim(win=win, name='InstructObs', text=u'Jetzt wirst du eine neue Person beobachten.\n\n'
#                                u'Du wirst die Entscheidungen der Person beobachten.\n\n'
#                                u'Du wirst die Reaktionszeit der Person beobachten.\n\n'
#                                u'< Weiter mit Leertaste >',
#                                font='Arial', pos=(0, 0), height=0.06, wrapWidth=None, ori=0, color='Black',
#                                colorSpace='rgb', opacity=1, depth=0.0)
    elif cond==2:
        InstructObs =  visual.ImageStim(win=win, name='PicObs', image=image_obs_path2, pos=(0, 0), size=2)
#        InstructObs = visual.TextStim(win=win, name='InstructObs', text=u'Jetzt wirst du eine neue Person beobachten.\n\n'
#                                u'Du wirst die Entscheidungen der Person beobachten.\n\n'
#                                u'Du wirst die Reaktionszeit der Person NICHT beobachten.\n\n'
#                                u'< Weiter mit Leertaste >',
#                                font='Arial', pos=(0, 0), height=0.06, wrapWidth=None, ori=0, color='Black',
#                                colorSpace='rgb', opacity=1, depth=0.0)
    elif cond==3:
        InstructObs =  visual.ImageStim(win=win, name='PicObs', image=image_obs_path3, pos=(0, 0), size=2)
#        InstructObs = visual.TextStim(win=win, name='InstructObs', text=u'Jetzt wirst du eine neue Person beobachten.\n\n'
#                                u'Du wirst die Entscheidungen der Person NICHT beobachten.\n\n'
#                                u'Du wirst die Reaktionszeit der Person beobachten.\n\n'
#                                u'< Weiter mit Leertaste >',
#                                font='Arial', pos=(0, 0), height=0.06, wrapWidth=None, ori=0, color='Black',
#                                colorSpace='rgb', opacity=1, depth=0.0)
    else:
        InstructObs =  visual.ImageStim(win=win, name='PicObs', image=image_obs_path4, pos=(0, 0), size=2)
#        InstructObs = visual.TextStim(win=win, name='InstructObs', text=u'Jetzt wirst du eine neue Person beobachten.\n\n'
#                                u'Du wirst die Entscheidungen der Person NICHT beobachten.\n\n'
#                                u'Du wirst die Reaktionszeit der Person NICHT beobachten.\n\n'
#                                u'< Weiter mit Leertaste >',
#                                font='Arial', pos=(0, 0), height=0.06, wrapWidth=None, ori=0, color='Black',
#                                colorSpace='rgb', opacity=1, depth=0.0)

# ===============================
# Routines: Observational Trials
# ===============================

    logging.flush()
    trialCounter2 += 1
    
    # instructions for next participant
    if trialCounter2 == 1 or (trialCounter2-1)%12==0:
        aa = True
        while aa:
            InstructObs.draw(win) 
            win.flip()
            logging.flush()
            if event.getKeys(keyList=['space']):
                break

    # first estimation (before learning)
    if trialCounter2%12 == 1:
            thisEstimation, thisEstimationRT = estimate_allocation.trial(win, image_estim_path, trial_elements)
            # variables to save
            subObs = np.append(subObs, int(expInfo['participant']))
            condObs = np.append(condObs, cond)
            dictator_number = np.append(dictator_number, Nsub)
            dictator_PA = np.append(dictator_PA, PA)
            estimation = np.append(estimation, thisEstimation)
            estimation_RT = np.append(estimation_RT, thisEstimationRT)
            accuracyObs = np.append(accuracyObs, 1-np.absolute(thisEstimation-PA))
            logging.flush()

    # append data to vectors so that they can be saved later
    left_split, right_split = display_trial.obstrial(win, trialCounter2, trial_elements, D_choice, D_resptime, split_1, split_2,cond)
    logging.flush()
    
    # estimate allocation every 4 trials
    if trialCounter2%4 == 0:
        thisEstimation, thisEstimationRT = estimate_allocation.trial(win, image_estim_path, trial_elements)
        # variables to save
        subObs = np.append(subObs, int(expInfo['participant']))
        condObs = np.append(condObs, cond)
        dictator_number = np.append(dictator_number, Nsub)
        dictator_PA = np.append(dictator_PA, PA)
        estimation = np.append(estimation, thisEstimation)
        estimation_RT = np.append(estimation_RT, thisEstimationRT)
        accuracyObs = np.append(accuracyObs, 1-np.absolute(thisEstimation-PA))
        logging.flush()
        
        # compute the reward if reward trial
        if trialCounter2 == rewardTrialObs: 
            rewardObs = 3 * (1 - np.absolute(thisEstimation-PA))
            rewardObs_txt = str(rewardObs)
            logging.flush()

    # predict trials after each dictator
    if trialCounter2%12 == 0:
        
        # display warning
        routineTimer = core.CountdownTimer()
        logging.flush()
        routineTimer.reset()
        logging.flush()
        routineTimer.addTime(-4)
        logging.flush()
        trial_elements.FixCross3.draw(win)
        logging.flush()
        win.flip()
        logging.flush()
        while routineTimer.getTime() > 0:
            # check for quit (the Esc key)
            if event.getKeys(keyList=["escape"]):
                core.quit()
        
        # predict choices
        thissubPred, thisD_choicePred, thisD_resptimePred, thisleft_splitPred, thisright_splitPred, thisChoicePred, thisRTPred = predict_trials.trial(win, image_predi_path, trialCounter2, trial_elements, Nsub)
        # variables to save
        subPred = np.append(subPred, np.repeat([int(expInfo['participant'])],4))
        condPred = np.append(condPred, np.repeat(cond,4))
        D_subPred = np.append(D_subPred, thissubPred)
        D_choicePred = np.append(D_choicePred, thisD_choicePred)
        D_resptimePred = np.append(D_resptimePred, thisD_resptimePred)
        left_splitPred = np.append(left_splitPred, thisleft_splitPred)
        right_splitPred = np.append(right_splitPred, thisright_splitPred)
        ChoicePred = np.append(ChoicePred, thisChoicePred)
        RTPred = np.append(RTPred, thisRTPred)
        logging.flush()

    #---------------------------------------------
    #----------Save observation data -------------
    #---------------------------------------------

    ExpObsData = np.stack((subObs, condObs, dictator_number, dictator_PA, estimation, estimation_RT, accuracyObs), axis = 1)
    myHeader = 'subject_number, condition, dictator_number, dictator_PA, estimated_PA, estimation_RT, accuracy'
    np.savetxt(u'data'+ os.sep + u'EstimationData_' + expInfo['participant'] + u'.csv', ExpObsData, header = myHeader, delimiter = ',', fmt = '%.6f', comments = '')
    logging.flush()

    #---------------------------------------------
    #----------Save prediction data --------------
    #---------------------------------------------

    ExpPredData = np.stack((subPred, condPred, D_subPred, D_choicePred, D_resptimePred, left_splitPred, right_splitPred, ChoicePred, RTPred), axis = 1)
    myHeader = 'subject_number, condition, dictator_number, dictator_Choice, dictator_RT, left_split, right_split, subject_choice, subject_RT'
    np.savetxt(u'data'+ os.sep + u'PredictionData_' + expInfo['participant'] + u'.csv', ExpPredData, header = myHeader, delimiter = ',', fmt = '%.6f', comments = '')
    logging.flush()

print('Reward obs: %s €' %rewardObs_txt)

aa = True
while aa:
    StartingTimePerc.draw() 
    win.flip()
    if event.getKeys(keyList=['space']):
        break
    # check for quit (the Esc key)
    if event.getKeys(keyList=['escape']):
        core.quit()

# ===========================
# Routine: Training
# ===========================
# training time perception trials are hard coded here
trainingTP = [(250.0,750.0, True),
            (750.0,1000.0, True),
            (250.0,500.0,False),
            (2000.0,2750.0, False) ]

for interval_1, interval_2, this_first_second in trainingTP:
    time_perception.timetrial(win, trialCounter3, trial_elements, interval_1, interval_2, first_second = this_first_second)
    logging.flush()
    
# ============================
# Routine: End Training
# ============================
TrainingEndText.draw(win)
win.flip()

while True:
    theseKeys = event.getKeys(keyList=['space'])
    
    if len (theseKeys) > 0:
        training = False
        break
    if event.getKeys(keyList=['escape']):
        core.quit()


# select the reward trial
rewardTrialTP = np.random.randint(1, 84)
print('Time Perception reward Trial selected: %i' %rewardTrialTP)

print('Starting time_perception')

# Arrays to save the answers to
TimeChoice   = np.empty([0], dtype=int)
TimeRT       = np.empty([0], dtype=float)
firstTime    = np.empty([0], dtype=float)
secondTime   = np.empty([0], dtype=float)
TimeAccuracy = np.empty([0], dtype=int)

# set up the trial handler to look after randomisation of conditions (psychopy function)

TimePerception = data.TrialHandler(nReps=6, method='random', extraInfo=expInfo, originPath=-1,
                                    trialList=data.importConditions('TimePerception.csv'), seed=None, name='TimePerception')

for thisGeneratedTrial in TimePerception:

    # abbreviate parameter names
    interval_1 = thisGeneratedTrial['interval_1']
    interval_2 = thisGeneratedTrial['interval_2']

# =============================
# Routines: Time Perception
# =============================
    # append data to vectors so that they can be saved later
    thisTimeChoice, thisTimeRT, first_interval, second_interval = time_perception.timetrial(win, trialCounter3, trial_elements, interval_1, interval_2, first_second = first_second[trialCounter3])
    
    if (second_interval > first_interval and int(thisTimeChoice)==1) or (second_interval < first_interval and int(thisTimeChoice)==-1):
        thisTimeAccuracy = 1
    else:
        thisTimeAccuracy = 0
        
    TimeChoice   = np.append(TimeChoice, thisTimeChoice)
    TimeRT       = np.append(TimeRT, thisTimeRT)
    firstTime    = np.append(firstTime, first_interval)
    secondTime   = np.append(secondTime, second_interval)
    TimeAccuracy = np.append(TimeAccuracy, thisTimeAccuracy)
    
    logging.flush()
    trialCounter3 += 1
    
    # compute the reward if reward trial
    if trialCounter3 == rewardTrialTP: 
        rewardTP = 3 * thisTimeAccuracy
        rewardTP_txt = str(rewardTP)
    
    # defines the break trials
    if trialCounter3 == int(45):
        continueRoutine = True
        while continueRoutine and BreakClock.getTime() > 0:
            BreakEndMsg.draw(win)
            win.flip()
            if event.getKeys(keyList=['space']):
                break

            # check for quit (the Esc key)
            if endExpNow or event.getKeys(keyList=['escape']):
                core.quit()

#-------------------------------------------------
#----------Save Time Perception data -------------
#-------------------------------------------------

print('Reward TP: %s €' %rewardTP_txt)

subTime = np.repeat([int(expInfo['participant'])],[len(TimeChoice)])
ExpTimeData = np.stack((subTime, TimeChoice, TimeRT, firstTime, secondTime, TimeAccuracy), axis = 1)
myHeader = 'subject_number, Choice_Interval, RT, first_interval, second_interval, correct'
np.savetxt(u'data'+ os.sep + u'TimePerceptionData_' + expInfo['participant'] + u'.csv', ExpTimeData, header = myHeader, delimiter = ',', fmt = '%.6f', comments = '')
logging.flush()

# ===========================
# Routine: SVO
# ===========================

nsub_SVO   = np.empty([0], dtype=int)
choice_SVO = np.empty([0], dtype=int)
rt_SVO     = np.empty([0], dtype=int)
me_SVO     = np.empty([0], dtype=int)
other_SVO  = np.empty([0], dtype=int)

print('Start second SVO')

mouse = event.Mouse()
continueRoutine=True
while continueRoutine:
    InstructSVO.draw(win) 
    win.flip()
    if mouse.getPressed()[0]==1: # if the left mouse button is pressed
        mouse.clickReset()
        break
    # check for quit (the Esc key)
    if event.getKeys(keyList=['escape']):
        core.quit()

# set up the trial handler to look after randomisation of conditions (psychopy function)
SVOtrials = data.TrialHandler(nReps=1, method='sequential', extraInfo=expInfo, originPath=-1,
                                    trialList=data.importConditions('svoTrials.csv'), seed=None, name='SVOtrials')

trial_SVO2 = 0

for thisSVOtrial in SVOtrials:
    
    trial_SVO2 = trial_SVO2+1
    
    # abbreviate parameter names
    me_labels = list(thisSVOtrial['points_me'].split((' ')))
    other_labels = list(thisSVOtrial['points_other'].split((' ')))
    
    # append data to vectors so that they can be saved later
    thisChoice_SVO, thisRT_SVO, thisMe, thisOther = slider_SVO.trial(win, trial_SVO2, trial_elements, me_labels, other_labels)
    nsub_SVO = np.append(nsub_SVO, int(expInfo['participant']))
    choice_SVO = np.append(choice_SVO, thisChoice_SVO)
    rt_SVO = np.append(rt_SVO, thisRT_SVO)
    me_SVO = np.append(me_SVO, thisMe)
    other_SVO = np.append(other_SVO, thisOther)
    logging.flush()

#----------Save SVO2 data -------------
#------------------------------------

ExpData = np.stack((nsub_SVO, choice_SVO, rt_SVO, me_SVO, other_SVO), axis = 1)
myHeader = 'subject_number, Choice, RT, for_me, for_other'
np.savetxt(u'data'+ os.sep + u'SVO2_Data_' + expInfo['participant'] + u'.csv', ExpData, header = myHeader, delimiter = ',', fmt = '%.6f', comments = '')
logging.flush()


#--- End of EXP------------------------

reward_final = reward + rewardObs + rewardTP
reward_final_txt = str(reward_final)

print ('Experiment Ended')
FeedbackMsg.setText(u'Das Experiment ist nun beendet! Bitte bleibe noch kurz auf deinem Platz sitzen und melde dich bei der Versuchsleitung. Gewinn für dich: %s €' %(reward_final_txt))
FeedbackMsg.draw(win)
win.flip()

# print reward me and other in the console
print('DG: %s €' %reward_txt)
print('OBS: %s €' %rewardObs_txt)
print('TP: %s €' %rewardTP_txt)

# end experiment with space
while True:
    if event.getKeys(keyList=['space']):
        break
        win.close()
