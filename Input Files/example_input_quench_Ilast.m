
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%	  QUENCH (IODIDE LAST)    %%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

saveWorkspaceHere       = fullfile(getDesktopDir(),'\CFTRimg\Results\resultsQuench\Ilast\quenchIlast_'); % create filepath for saving the workspace
saveQuenchResultsHere   = fullfile(getDesktopDir(),'\CFTRimg\Results\resultsQuench\Ilast');          
inputFolderN						= 1;																				% number of 'input folders' 
input										= createInputStruct_quench(inputFolderN);											% create empty structs

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% input folder 
input(1).timeStep								= 2;									% time between image collection (seconds)
input(1).timeline								= [10,13,33];					% [timpoint after first fluid addition (iodide) , timpoint after second fluid addition (FSK), last timepoint] 
input(1).experimentStr          = {'Plate_16840'};		% identifier experiment
input(1).plateStr								= {'Plate_16840'};		% identifier plate 
input(1).folderName							= 'quench_Ilast';			% name of folder in which Timepoint folders are located
input(1).baseFolder							= strcat(getDesktopDir(),'\CFTRimg\Data'); % filepath in which folders with Timepoint folders are located	
input(1).filePrefix							= 'quench_Ilast_';				% prefix file name before C02_s1_w1, C02_s1_w2, C02_s2_w1 etc (C02_s2_w1 -> well C02, site 2, wavelength 1) 																	% filename before B02_etc
input(1).condition							= {'WT 28','F508del 28'};
input(1).normCondition					= {'WT 28'};
input(1).condWells(1,1)					= {'B02'};
input(1).condWells(2,1)					= {'B03'};
input(1).condWellsControl(1,1)	= {'C02'};
input(1).condWellsControl(2,1)	= {'C03'};

