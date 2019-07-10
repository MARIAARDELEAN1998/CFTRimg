
% High-content assay for precision medicine discovery in cystic fibrosis.
% Stella Prins1, Emily Langron1, Cato Hastings2, Emily Hill1, Andra Stefan3, Lewis D. Griffin2 and Paola Vergani1*
% 
% 1 Department of Neuroscience, Physiology and Pharmacology
% 2 CoMPLEX
% 3 Natural Sciences
% 
% University College London
% Gower Street
% WC1E 6BT London UK
% 
% Correspondence to: p.vergani@ucl.ac.uk


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%				LOCALISATION				%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

saveWorkspaceHere				= fullfile(getDesktopDir(),'\Prins et al 2019 MATLAB code\Results\ResultsLocal\local_workspace_'); % filepath for saving the workspace
saveLocalResultsFolder	= fullfile(getDesktopDir(),'Prins et al 2019 MATLAB code\Results\ResultsLocal'); %  filepath to location for saving excel files with the results
inputFolderN						= 1;																													% number of 'input folders' 
input										= createInputStruct_local(inputFolderN);											% create empty structs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% input folder 1 
input(1).pixelBinning			= 1/2;											% pixel binning (1/2 for 2x2 bining, 1 for no binning)
input(1).siteN						= 2;												% number of image sites per well (in this study, images at 9 sites per well were taken, but in this example we only use 2 sites per well)
input(1).objective				= 60;												% microscope objective (60x)
input(1).experimentStr		= {'04-12-17 Plate_15771'};	% identifier experiment
input(1).plateStr					= {'04-12-17 Plate_15771'};	% identifier plate 
input(1).folderName				= 'local';									% name of folder in which Timepoint folders are located
input(1).baseFolder				= strcat(getDesktopDir(),'\Prins et al 2019 MATLAB code\Data'); % filepath in which folders with Timepoint folders are located	
input(1).filePrefix				= 'local_';									% prefix file name before C02_s1_w1, C02_s1_w2, C02_s2_w1 etc (C02_s2_w1 -> well C02, site 2, wavelength 1) 
input(1).condition				= {'WT 28°C','F508del 28°C', 'F508del + 10 µM VX-809 28°C'}; % conditions
input(1).normCondition		= {'WT 28°C'};							% WT on the plate (for calculating the normalised RedInside)
input(1).condWells(1,1:8)	= {'C02','C03','C04','C05','C06','C07','C08','C09'}; % wells that correspond to the first conditionStr ('WT 28°C') listed
input(1).condWells(2,1:8)	= {'D02','D03','D04','D05','D06','D07','D08','D09'}; % wells that correspond to the second conditionStr ('F508del 28°C') listed
input(1).condWells(3,1:8)	= {'E02','E03','E04','E05','E06','E07','E08','E09'}; % wells that correspond to the third conditionStr ('F508del + 10 µM VX-809 28°C') listed

% EXAMPLE INPUT
% input folder 2
% input(2).pixelBinning			= 1/2;		% pixel binning (1/2 for 2x2 bining, 1 for no binning)
																			% the images in the example dataset were 2x2 binned
% input(2).siteN						= N;			% number (N) of image sites per well			
% input(2).objective				= 60; 		% magnification microscope objective (60 for 60x, 20 for 20x), 
																			% in this study a 60x objective was used for membrane density measurements
% input(2).experimentStr		= {''};   % identifier experiment
% input(2).plateStr					= {''};		% identifier plate
% input(2).folderName       = '';			% name of folder in which Timepoint folders are located
% input(2).baseFolder				= '';			% filepath in which folders with Timepoint folders are located	
% input(2).filePrefix				= '';			% prefix file name before C02_s1_w1, C02_s1_w2, C02_s2_w1 etc (C02_s2_w1 -> well C02, site 2, wavelength 1)
% input(2).conditionStr			= {'1','2','3',...,X};														% conditions
% input(2).normConditionStr	= {'WT'};																					% condition used for normalisation
% input(2).condWells(1,1:n) = {'well_1','well_2','well_3',..., 'well_n'};			% wells that correspond to the first conditionStr listed
% input(2).condWells(2,1:n) = {'well_1','well_2','well_3',..., 'well_n'};			% wells that correspond to the second conditionStr listed
% input(2).condWells(3,1:n) = {'well_1','well_2','well_3',..., 'well_n'};			% wells that correspond to the third conditionStr listed
% ...
% input(2).condWells(X,1:n) = {'well_1','well2','well_3',..., 'well_n'};			% wells that correspond to the nth conditionStr listed
%
%
% input folder N
% input(N).pixelBinning			= 1/2;
% input(N).siteN						= 9;				
% input(N).objective				= 60; 		
% input(N).experimentStr		= {''};
% input(N).plateStr					= {''};
% input(N).folderName       = '';	
% input(N).baseFolder				= '';
% input(N).filePrefix				= '';
% input(N).conditionStr			= {'1','2','3',...,X};
% input(N).normConditionStr	= {'WT'};																					
% input(N).condWells(1,1:n) = {'well_1','well_2','well_3',..., 'well_n'};
% input(N).condWells(2,1:n) = {'well_1','well_2','well_3',..., 'well_n'};
% input(N).condWells(3,1:n) = {'well_1','well_2','well_3',..., 'well_n'};
% ...
% input(N).condWells(X,1:n) = {'well_1','well2','well_3',..., 'well_n'};
