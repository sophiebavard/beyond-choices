# Beyond Choices
[![DOI](https://zenodo.org/badge/697825838.svg)](https://zenodo.org/doi/10.5281/zenodo.10852803)

This is the repository storing the data and code used to generate behavioural analyses for the paper:   
>__Beyond choices: humans can infer social preferences from decision speed alone__   
Sophie Bavard, Erik Stuchlý, Arkady Konovalov, Sebastian Gluth   
[https://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.3002686](https://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.3002686)

## Data availability
All raw data matrices are provided in .mat and .csv formats. 

>[!NOTE]
>Variable and column names are described below, please contact me if any question arises. The preregistration document is publically available on OSF: https://doi.org/10.17605/OSF.IO/TZ4DQ

## Behavioral analyses   
Run the *behavioral_analyses_obsDG.m* script to produce *data_fig.mat*.   
The script loads the raw matrix *data_observeDG.mat* and extracts the variables of interest for the figures.

## Model fitting & model simulations
Participants' choices were modeled using likelihood maximization. Run the *model_fitting_RL.m* or *model_fitting_BO.m* scripts to produce *data_fitting_RL1.mat*, *data_fitting_RL2.mat* or *data_fitting_BO.mat*.     
The script loads the raw matrix *data_modelling.mat*, runs model fitting and simulations using the functions *function_fit_simu.m* and *wfpt.m*, and saves fitted variables in the dedicated files.

## Generate the figures   
Run the "*Figure...*" scripts to generate the figures.   
The scripts load the files *data_fig.mat*, *data_playDG16.mat*, *data_fitting_RL1.mat*, *data_fitting_RL2.mat* or *data_fitting_BO.mat*.

## Functions   
File *function_fit_simu.m* contains the algorithms used to fit and simulate the data for all models presented in the main text.   
File *wfpt.m* is the first passage time for Wiener diffusion model. Approximation based on Navarro & Fuss (2009).   
Files *SurfaceCurvePlot.m*, *SurfaceCurvePlot_model2.m*, *scatterCorrColorSpear.m*, *violinplotSB.m*  were created and used for visual purposes. Created by Sophie Bavard, 2023.

## Data: playing the Dictator Game
```
data_playDG16
data_playDG46
```
  
* COLUMN 1  = participant's number
* COLUMN 2  = choice (-1 left, 1 right)
* COLUMN 3  = RT in seconds
* COLUMN 4  = proportion of won points for left option
* COLUMN 5  = proportion of won points for right option
  
## Data: observing the Dictator Game
```
data_observeDG
```

### Estimation data
```
dataEsti
```
* COLUMN 1  = participant's number
* COLUMN 2  = condition (1 = both, 2 = ch, 3 = RT, 4 = none)
* COLUMN 3  = estimation number
* COLUMN 4  = dictator's number
* COLUMN 5  = dictator's preferred allocation
* COLUMN 6  = estimated allocation
* COLUMN 7  = response time
* COLUMN 8  = estimation accuracy

### Prediction data
```
dataPred
```
* COLUMN 1  = participant's number
* COLUMN 2  = condition (1 = both, 2 = ch, 3 = RT, 4 = none)
* COLUMN 3  = dictator's number
* COLUMN 4  = dictator's choice (-1 = left, 1 = right)
* COLUMN 5  = dictator's response time
* COLUMN 6  = left split
* COLUMN 7  = right split
* COLUMN 8  = participant's choice (-1 = left, 1 = right)
* COLUMN 9  = participant's response time
* COLUMN 10 = participant's last PA estimation
* COLUMN 11 = short/long trial (0=short, 1=long)
* COLUMN 12 = observer's choice for own trial (choose for self, not prediction)
* COLUMN 13 = observer's RT for own trial (choose for self, not prediction)
* COLUMN 14 = observer's similarity with dictator

### Time Perception data
```
dataTP
```
* COLUMN 1  = participant's number
* COLUMN 2  = choice (-1 = second shorter, 1 = second longer)
* COLUMN 3  = response time
* COLUMN 4  = first duration
* COLUMN 5  = second duration
* COLUMN 6  = accuracy
  
## Data: modelling

* COLUMN 1  = participant number
* COLUMN 2  = dictator number
* COLUMN 3  = trial number
* COLUMN 4  = proportion of won points for left option
* COLUMN 5  = proportion of won points for right option
* COLUMN 6  = choice (1 left, 2 right)
* COLUMN 7  = RT in seconds
* COLUMN 8  = participant's choice (1 left, 2 right)
* COLUMN 9  = dictator true pref
* COLUMN 10 = estimated pref
* COLUMN 11 = condition (1 = both, 2 = ch only, 3 = rt only, 4 = none)
* COLUMN 12 = phase (1=estimation, 2=prediction)
