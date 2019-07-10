function outputQuenchTimelineToExcel( plateStructArray , saveLocationFolder, dateStr )
%OUTPUT_QUENCH_TIMELINE_TO_EXCEL
%   The 'xlswrite' function only works on Windows machines and the
%   'writetable' function only works on Mac machine. This function splits
%   so to work on both PC an unix machines.

plateN = length(plateStructArray);
rowN = 0;

maxTimePointN = 0;
for j=1:plateN
	wellN = length(plateStructArray(j).well);
	rowN = rowN + wellN;
	for i=1:wellN
		maxTimePointN = max(maxTimePointN,plateStructArray(j).well(i).timeline(end));
	end
end

% create table of full results
experiment			= cell(rowN,1);
plate						= cell(rowN,1);
condition				= cell(rowN,1);
test_control		= cell(rowN,1);
redMaskChange		= cell(rowN,1);
yelInsideOverT  = cell(rowN,maxTimePointN);

rowCounter = 1;
for j=1:plateN
	plateStruct = plateStructArray(j);
	
	tempExperimentStr	= plateStruct.experimentStr;
	tempPlateStr			= plateStruct.plateStr;
	
	wellN = length(plateStruct.well);
	for i=1:wellN
		timePointN											= plateStruct.well(i).timeline(end);
		experiment{rowCounter,1}				= tempExperimentStr;
		plate{rowCounter,1}							= tempPlateStr;
		condition{rowCounter,1}					= plateStruct.well(i).condition;
		test_control{rowCounter,1}			= plateStruct.well(i).test_control;
		redInsideNorm{rowCounter,1}			= plateStruct.well(i).redInsideNorm;
		redInside{rowCounter,1}					= plateStruct.well(i).redInside;
		yelInsideOverT(rowCounter,1:timePointN)	= num2cell(plateStruct.well(i).yelInsideOverT');
		rowCounter											= rowCounter + 1;
	end
end

fullResults = horzcat(experiment,plate,condition,test_control...
	,redInside,redInsideNorm,yelInsideOverT);

% organize table headers
timePointHeader = cell(1,maxTimePointN);
for i=1:maxTimePointN
	timePointHeader{1,i} = ['TimePoint_',num2str(i)];
end

fullHeader = horzcat({'experimentStr','plateStr','condition','test_control'...
	,'redInside','redInsideNorm'},timePointHeader);
fullCellArray = vertcat(fullHeader,fullResults);
fullTable			= cell2table(fullResults,'VariableNames',fullHeader);

if exist(saveLocationFolder,'dir') ~= 7
	mkdir(saveLocationFolder)
end

if ispc == true
	fullFileName = strcat('fullQuenchTimeline_',dateStr,'.xlsx');
	xlswrite(fullfile(saveLocationFolder,fullFileName),fullCellArray)
elseif isunix == true
	fullFileName = strcat('fullQuenchTimeline_',dateStr,'.csv');
	writetable(fullTable,fullfile(saveLocationFolder,fullFileName))
end

end
