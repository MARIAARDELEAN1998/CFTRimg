function resultsStructArray = createResultsLocalStruct( normStructArray )
%CREATE_RESULTS_LOCAL_STRUCT Initialize empty results struct
%		Create struct to store all data after it has been normalized. The data
%		is now sorted by condition rather than by experiment.
normStructN = length(normStructArray);
% create cell array of {condition norm normCondition) across all experiments
fullConditions		= cell(0,1);

for j=1:normStructN
	normStruct				= normStructArray(j);
	tmpConditionN			= length(normStruct.condition);
	clear							tmpFullCondition
	tmpFullConditions = normStruct.condition;
	for i=1:tmpConditionN
		tmpFullConditions(i) = strcat(normStruct.condition(i),{' norm '},normStruct.normCondition);
	end
	fullConditions	= unique(vertcat(fullConditions,tmpFullConditions));
end

fullConditions			= fullConditions';
fullConditionN			= length(fullConditions);
fullConditionsSplit = cell(fullConditionN,2);

for i=1:fullConditionN
	newStr										= split(fullConditions{i},' norm ');
	fullConditionsSplit{i,1}	= char(newStr(1));
	fullConditionsSplit{i,2}	= char(newStr(2));
end

resultsTemplate = struct(...
			'condition',''...
			,'normCondition',''...
			,'cellLocation',{{}}...
			,'yelMembrane',[]...
			,'yelEntire',[]...
			,'redEntire',[]...
			,'yelMembraneNorm',[]...
			,'yelEntireNorm',[]...
			,'redEntireNorm',[]...
			,'yelMembraneAbsolute',[]...
			,'yelEntireAbsolute',[]...
			,'redEntireAbsolute',[]...
			,'memDens',[]...
			,'logMemDens',[]...
			,'cellN',[]...
			,'yelMembraneNeg',[] ...
			,'yelEntireNeg',[] ...
			,'redEntireNeg',[] ...
			,'deleteNeg',[]);
		
% find out how many cells per condition/normCondition across all
% experiments
cellsPerFullConditionExp	= zeros(fullConditionN);
expPerFullConditionExp		= zeros(fullConditionN);
for j=1:fullConditionN
	currentCond = fullConditionsSplit{j,1};
	currentNormCond = fullConditionsSplit{j,2};
	for i=1:normStructN
		compareCond = strcmp(currentCond,normStructArray(i).condition) & ...
		strcmp(currentNormCond,normStructArray(i).normCondition);
		cellsPerFullConditionExp(j) = cellsPerFullConditionExp(j) + sum(compareCond);
		if sum(compareCond) > 0
			expPerFullConditionExp(j)		= expPerFullConditionExp(j) + 1;
		end
	end
end

% find out how many cells per per condition were deleted because they had
% negative values
 yelMembraneNeg	= [];
 yelEntireNeg		= [];
 redEntireNeg		= [];
 deleteNeg			= [];
 imageCond			= [];

	 for j = 1: length(normStructArray) %for every plate
		 yelMembraneNeg	= vertcat(yelMembraneNeg, normStructArray(j).yelMembraneNeg);% pile up values of all plates
		 yelEntireNeg		= vertcat(yelEntireNeg, normStructArray(j).yelEntireNeg);
		 redEntireNeg		= vertcat(redEntireNeg, normStructArray(j).redEntireNeg);
		 deleteNeg			= vertcat(deleteNeg, normStructArray(j).deleteNeg);
		 imageCond			= vertcat(imageCond, normStructArray(j).imageCond);
	 end
 
 imageCondUnique	= unique(imageCond);										% unique conditions
 
		for i = 1:length(imageCondUnique)														% for all unique conditions
			idx										= ~cellfun(@isempty,(strfind(imageCond,imageCondUnique(i)))); %index unique conditions
			yelMembraneNegSum(i)	= sum(yelMembraneNeg(idx));		%select and sum up appropriate values
			yelEntireNegSum(i)		= sum(yelEntireNeg(idx));
			redEntireNegSum(i)		= sum(redEntireNeg(idx));
			deleteNegSum(i)				= sum(deleteNeg(idx));
		end

	
% fill results structs with empty arrays
for i=1:fullConditionN
	resultsStruct											= resultsTemplate;
	resultsStruct.condition						= fullConditionsSplit{i,1};
	resultsStruct.normCondition				= fullConditionsSplit{i,2};
	cellN															= cellsPerFullConditionExp(i);
	resultsStruct.cellN								= cellN;
	resultsStruct.cellLocation				= cell(cellN,4);
	resultsStruct.yelMembrane					= zeros(cellN,1);
	resultsStruct.yelEntire						= zeros(cellN,1);
	resultsStruct.redEntire						= zeros(cellN,1);
	resultsStruct.yelMembraneNorm			= zeros(cellN,1);
	resultsStruct.yelEntireNorm				= zeros(cellN,1);
	resultsStruct.redEntireNorm				= zeros(cellN,1);
	resultsStruct.yelMembraneAbsolute = zeros(cellN,1);
	resultsStruct.yelEntireAbsolute		= zeros(cellN,1);
	resultsStruct.redEntireAbsolute		= zeros(cellN,1);
	resultsStruct.memDens							= zeros(cellN,1);
	resultsStruct.logMemDens					= zeros(cellN,1);
 	resultsStruct.yelMembraneNeg			= yelMembraneNegSum(i);
 	resultsStruct.yelEntireNeg				= yelEntireNegSum(i);
 	resultsStruct.redEntireNeg				= redEntireNegSum(i);
 	resultsStruct.deleteNeg						= deleteNegSum(i);
	resultsStructArray(i)							= resultsStruct;
end

end
