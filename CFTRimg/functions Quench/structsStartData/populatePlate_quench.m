function [ plateStructArray ] = populatePlate_quench( ...
	inputStructArray,plateStructArray)
%FIND_IMAGE_PATHS construct image paths from inputted data
%   Cycles through all experiments. For each experiment, the appropriate
%   plates are selected. The path names are then constructed in
%   'findImagePathsLocal' and 'findImagePathsQuench'. Using these arrays of
%   path names, a struct is created for each image (or well for quenching
%   experiments).

inputFolderN	= length(inputStructArray);
plateN				= length(plateStructArray);

% find the largest number of quench time points across all plates, to
% initialize arrays
maxQuenchTimePointN = 0;

for i=1:inputFolderN
	inputStruct					= inputStructArray(i);
	maxQuenchTimePointN = max(maxQuenchTimePointN,inputStruct.timeline(end));
end

plateNames	= unique(horzcat(inputStructArray.plateStr));
for j=1:plateN
	currentPlate				= plateNames{j};
	conditionArray			= cell(0);
	normConditionArray	= cell(0);
	test_controlArray		= cell(0);
	timelineArray				= zeros(0,3);
	timeStepArray				= zeros(0);
	redPathArray				= cell(0,2);
	yelPathArray				= cell(0,maxQuenchTimePointN);
	
	for i=1:inputFolderN
		inputStruct							= inputStructArray(i);
		comparePlate						= strcmp(inputStruct.plateStr,currentPlate);
		currentTimeline					= inputStruct.timeline;
		currentTimeStep					= inputStruct.timeStep;
		beforeArrayLengthQuench	= size(redPathArray,1);
		
		if sum(comparePlate == 1)
			[conditionArray,test_controlArray...
				,redPathArray,yelPathArray] = ...
			findImagePaths_quench(inputStruct,conditionArray,...
			test_controlArray,redPathArray,yelPathArray);
		end
	
		afterArrayLengthQuench	= size(redPathArray,1);
		if afterArrayLengthQuench - beforeArrayLengthQuench > 0
			for idx=beforeArrayLengthQuench+1:afterArrayLengthQuench
				timelineArray(idx,:) = currentTimeline;
			end
			timeStepArray(beforeArrayLengthQuench+1:afterArrayLengthQuench) = ...
				currentTimeStep;
		end
		
	end
	
	plateStructArray(j).well = ...
		createWellStruct(conditionArray,...
		test_controlArray,timelineArray,timeStepArray...
		,redPathArray,yelPathArray);
end

end