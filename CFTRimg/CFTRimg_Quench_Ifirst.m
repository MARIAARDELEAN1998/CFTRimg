tic
clc
clear
close all 
addpath(genpath(strcat(getDesktopDir(),'\Prins et al 2019 MATLAB code')))		% add folder with code to path
example_input_quench_Ifirst;																												% the name of your input file

% STRUCTURING DATA
plate		= createPlateStruct_quench(input);		% creates an empty struct for each plate
plate		= populatePlate_quench(input,plate);	% collects the path names for each image and creates a struct for each image
disp('Completed setting up data structures')

% QUENCHING ANALYSIS IODIDE FIRST
for j=1:length(plate)
	for i=1:length(plate(j).well)
 		plate(j).well(i) = findRedMaskChange(plate(j).well(i));
		plate(j).well(i) = findYelInsideOverTime(plate(j).well(i), plate(j).well(i).timeline(1)-1);   % normalised to the timepoint before iodide addition
		plate(j).well(i) = calculateMaxGrad(plate(j).well(i), plate(j).well(i).timeline(2)+1);				% max rate iodide influx after addition of FSK/DMSO 
	end
end
plate								= redNorm(plate);																		% Calculate normalized mCh inside per plate, and normalise redInside values
disp					('Completed quenching analysis')

% SAVE RESULTS
dateStr															= datestr(now,'yyyy_mm_dd_HHMM'); 
save																(strcat(saveWorkspaceHere,dateStr))
outputQuenchTimelineToExcel         (plate,saveQuenchResultsHere,dateStr) 
disp        ('Finished writing results to excel files')
toc