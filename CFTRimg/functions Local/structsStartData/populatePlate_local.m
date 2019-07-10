function [ plateStructArray ] = populatePlate_local( ...
	inputStructArray, plateStructArray)
%POPULATE_PLATE_LOCAL construct image paths from inputted data
%   Cycles through all input folders. For each folder, the appropriate
%   plates are selected. The path names are then constructed in
%   'findImagePathsLocal' and 'findImagePathsQuench'. Using these arrays of
%   path names, a struct is created for each image (or well for quenching
%   experiments).

inputN	= length(inputStructArray);
plateN	= length(plateStructArray);

plateNames	= unique(horzcat(inputStructArray.plateStr));
for j=1:plateN
	
	currentPlate				= plateNames{j};
	conditionArray			= cell(0);
	binningArray				= zeros(0);
	objectiveArray			= zeros(0);
	redPathArray				= cell(0);
	yelPathArray				= cell(0);
	
	for i=1:inputN
		inputStruct		= inputStructArray(i);
		comparePlate	= strcmp(inputStruct.plateStr,currentPlate);
		
		if sum(comparePlate == 1)

			[conditionArray,binningArray,objectiveArray, redPathArray,yelPathArray] = ...
				findImagePaths_local(inputStruct,conditionArray,binningArray...
			,objectiveArray, redPathArray,yelPathArray);
		
		end
	end
	
	plateStructArray(j).image = ...
		createImageStruct(conditionArray,binningArray,objectiveArray...
		,redPathArray,yelPathArray);
	
end
end