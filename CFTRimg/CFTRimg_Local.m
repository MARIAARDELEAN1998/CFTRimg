tic
clc
clear
close all 
addpath(genpath(strcat(getDesktopDir(),'\CFTRimg')));	% add folder with code to path
example_input_local;																	% the name of your input file

% SET UP DATA STRUCTURES
plate		= createPlateStruct_local(input);			% creates an empty struct for each plate,
plate		= populatePlate_local(input,plate);		% moves appropriate input information into plate struct
plateN	= length(plate);											% and creates a struct for each image
disp		('Completed setting up data structures')
SaveImages = questdlg('After the analysis, do you want to save cropped images of segmented cells and their rho values?');

% IMAGE PROCESSING
for j = 1:plateN
	imageN = length(plate(j).image);
		for i = 1:imageN
			plate(j).image(i) = imgProcess(plate(j).image(i));	% segmentation and selection
		end
	plate(j) = logCellLocation(plate(j),j);
end
disp		('Image analysis completed')

% CREATE RESULT STRUCTS
preNormPlate				= createNormalizeStruct(plate); % move key values into temporary a structure for normalizing
normPlate						= normalizeResultsWT(preNormPlate);
resultsLocalStruct	= createResultsLocalStruct(normPlate);% move normalized results into a structure
resultsLocal				= populateResultsLocal(resultsLocalStruct,normPlate,preNormPlate);

% SAVE RESULTS 
dateStr														 = datestr(now,'yyyy_mm_dd_HHMM');
outputResultsLocalToExcel					(resultsLocal,saveLocalResultsFolder, dateStr) 
outputResultsLocalSummaryToExcel	(resultsLocal,saveLocalResultsFolder, dateStr) 
outputResultsLocalTableToExcel		(resultsLocal,saveLocalResultsFolder, dateStr) 
save															(strcat(saveWorkspaceHere, dateStr))
disp					('Results have been saved')
toc

% OUTPUT CELLS TO FILE (segmentation indicated by white line)
switch SaveImages
    case 'Yes'
			prop = .05; % only the first 5% of the cells will be saved, prop = 1 to save all cells, this will take a while though.
			if isToolboxAvailable('Computer Vision System Toolbox','error')	
				fprintf('Saving cell images...\n');
				saveLocation			= strcat(saveLocalResultsFolder,'\cellImages');
					if ~exist(saveLocation, 'dir') 				% create the Results folder if it doesn't exist already.
						mkdir(saveLocation);
					end
				labelAndSaveCells (resultsLocal,plate,saveLocation,prop);	
				disp	 ('Cell images have been saved')
			else end
    case 'No'
end
