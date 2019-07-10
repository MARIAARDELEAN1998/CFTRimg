function resultsStructArray = createResultsQuenchStruct( plateStructArray )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

plateN = length(plateStructArray);

% create cell array of mutations across all plates
conditions = cell(0,1);
for i=1:plateN
	conditions			= unique(horzcat(conditions,{plateStructArray(i).well.condition}));
end

conditionN = length(conditions);

resultsTemplate = struct(...
			'condition',''...
			,'maxGradTest',[]...
			,'maxGradTestNorm',[]...
			,'maxGradControl',[]...
		  ,'maxGradControlNorm',[]...
			,'maxGradTestLoc',[]...
			,'maxGradControlLoc',[]...
			,'yelInsideOverTTest',[]...
			,'yelInsideOverTControl',[]...
			,'redInsideControlNorm',[]...
			,'redInsideTestNorm',[]...
			,'redInsideControl',[]...
			,'redInsideTest',[]);
		
		
% find out how many wells per condition across all plates
wellsPerConditionPlateTest		= zeros(plateN,conditionN);
wellsPerConditionPlateControl = zeros(plateN,conditionN);

for k=1:conditionN
	currentCondition = conditions{k};
	for j=1:plateN
		wellN = length(plateStructArray(j).well);
		for i=1:wellN
			if strcmp(plateStructArray(j).well(i).condition,currentCondition)
				switch plateStructArray(j).well(i).test_control
					case 'test'
						wellsPerConditionPlateTest(j,k) = ...
						wellsPerConditionPlateTest(j,k) + 1;
					case 'control'
						wellsPerConditionPlateControl(j,k) = ...
						wellsPerConditionPlateControl(j,k) + 1;
				end
			end
		end
	end
end

% find the largest number of quench time points across all plates, to
% initialize arrays
maxTimePointN = 0;
for j=1:plateN
	expStruct = plateStructArray(j);
	wellN = length(expStruct.well);
	for i=1:wellN
		timePointN = size(expStruct.well(i).yelPath,2);
		maxTimePointN = max(maxTimePointN,timePointN);
	end
end
		
for i=1:conditionN
	
	resultsStructArray(i)												= resultsTemplate;
	resultsStructArray(i).condition							= conditions{i};
	wellTestN																		= sum(wellsPerConditionPlateTest(:,i));
	wellControlN																= sum(wellsPerConditionPlateControl(:,i));
	resultsStructArray(i).maxGradTest						= zeros(wellTestN,1);
	resultsStructArray(i).maxGradTestNorm				= zeros(wellTestN,1);
	resultsStructArray(i).maxGradTestLoc				= zeros(wellTestN,1);
	resultsStructArray(i).yelInsideOverTTest		= zeros(wellTestN,maxTimePointN);
	resultsStructArray(i).maxGradControl				= zeros(wellControlN,1);
	resultsStructArray(i).maxGradControlNorm		= zeros(wellControlN,1);
	resultsStructArray(i).maxGradControlLoc			= zeros(wellControlN,1);
	resultsStructArray(i).yelInsideOverTControl = zeros(wellControlN,maxTimePointN);
	resultsStructArray(i).redInsideControlNorm	= zeros(wellControlN,1);
	resultsStructArray(i).redInsideTestNorm			= zeros(wellTestN,1);
	resultsStructArray(i).redInsideControl			= zeros(wellControlN,1);
	resultsStructArray(i).redInsideTest					= zeros(wellTestN,1);
end

end

