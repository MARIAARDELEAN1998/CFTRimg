tic
clc
clear
close all 
addpath(genpath(strcat(getDesktopDir(),'\Prins et al 2019 MATLAB code')))		% add folder with code to path
example_input_quench_Ilast;														% the name of your input file

% STRUCTURING DATA
tic
plate		= createPlateStruct_quench(input);		% creates an empty struct for each plate
plate		= populatePlate_quench(input,plate);	% collects the path names for each image and creates a struct for each image
disp		('Completed setting up data structures')

% QUENCHING ANALYSIS 
for j=1:length(plate)
	for i=1:length(plate(j).well)
 		plate(j).well(i) = findRedMaskChange(plate(j).well(i));
		plate(j).well(i) = findYelInsideOverTime(plate(j).well(i), plate(j).well(i).timeline(2)-1); 
  	plate(j).well(i) = calculateMaxGrad(plate(j).well(i), plate(j).well(i).timeline(2)-1);			
	end
end
plate					= redNorm(plate);                             % Calculate normalized mCh inside per plate, and normalise redInside values
disp			('Fluorescence over time determined')

% CURVE FITTING (iodide last)
Qtrace				= calculateMeanQtrace(plate);						% Calculate mean Quench trace per plate
output_fit		= curveFittingPlate(input, Qtrace); % curvefitting average quenching trace per condition per plate
disp					('Curve fitting completed')

% SAVE RESULTS TO EXCEL
dateStr															= datestr(now,'yyyy_mm_dd_HHMM'); 
save																(strcat(saveWorkspaceHere,dateStr))
outputQuenchTimelineToExcel					(plate,saveQuenchResultsHere, dateStr)
if ispc == true
	fullFileName = strcat('fullQuenchFitting_',dateStr,'.xlsx');
	xlswrite(fullfile(saveQuenchResultsHere,fullFileName),output_fit)
elseif isunix == true
	fullFileName = strcat('fullQuenchFitting_',dateStr,'.csv');
	writetable(cell2table(output_fit),fullfile(saveQuenchResultsHere,fullFileName))
end
disp			('Analysis completed')
toc
