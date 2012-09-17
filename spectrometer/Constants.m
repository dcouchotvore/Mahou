%on a mac, this should be placed in  ~/Documents/MATLAB
%in windows, this should be .../Documents and Settings/MATLAB

%use this for the path to where the data analysis functions are placed
%addpath ~/Developer/data_analysis

global CONSTANTS
CONSTANTS.c_SI = 2.9979e8;
CONSTANTS.c = 2.9979e10;
CONSTANTS.c_cm = CONSTANTS.c;
CONSTANTS.c_cmfs = 2.9979e-5;
CONSTANTS.wavenumbersToInvFs = CONSTANTS.c*1e-15;
CONSTANTS.wavenumbersToInvPs=CONSTANTS.c*1e-12;
CONSTANTS.wavenumbersToInvSec = CONSTANTS.c;
CONSTANTS.invFsToWavenumbers=1/CONSTANTS.wavenumbersToInvFs;
CONSTANTS.invPsToWavenumbers=1/CONSTANTS.wavenumbersToInvPs;
CONSTANTS.invSecToWavenumbers = 1/CONSTANTS.wavenumbersToInvSec;
CONSTANTS.fringeToFs = 632.8e-7/CONSTANTS.c_cmfs; %FIXME!!!
CONSTANTS.fringeToPs = CONSTANTS.fringeToFs/1000;
CONSTANTS.q = 1.6e-19; %charge coulombs
CONSTANTS.h = 6.626e-34; %plancks
CONSTANTS.hbar = 1.054571596e-34;
CONSTANTS.epsilon_0 = 8.8541878e-12; %F/m
CONSTANTS.mu_0 = 1.2566470e-6; %H/m
CONSTANTS.debyeToCm = 3.33564e-30; %Cm (coulomb meters)
CONSTANTS.N_A = 6.022e23; 
CONSTANTS.k_B = 1.38e-12; %J K-1
CONSTANTS.amuToKg= 1.660538e-27; %kg
CONSTANTS.fsToMm = CONSTANTS.c_SI*1e3/1e15;
CONSTANTS.fsToMm2Pass = CONSTANTS.fsToMm/2; %for converting fs to delay stage position

