function outputModelTimelineToExcel (plateStructArray , saveLocationFolder...
	,desiredTimePoints)

plateN = length(plateStructArray);

% find max number of timePoints
% and a list of the unique conditions
uniqueConditions = cell(0,1);
maxTimePointN = 0;
totalConditionN = 0;
uniqueCounter = 1;
for j=1:plateN
	wellN = length(plateStructArray(j).well);
	fullConditions = cell(wellN,1);
	for i=1:wellN
		maxTimePointN = max(maxTimePointN,plateStructArray(j).well(i).timeline(end));
		fullConditions{i,1} = [plateStructArray(j).plateStr,' '...
			plateStructArray(j).well(i).conditionStr...
			,' ',plateStructArray(j).well(i).test_control];
	end
	conditionN = length(unique(fullConditions));
	totalConditionN = totalConditionN + conditionN;
	
	uniqueConditions(uniqueCounter:uniqueCounter + conditionN - 1,1) = ...
		unique(fullConditions);
	
	uniqueCounter = uniqueCounter + conditionN;
end

% create table of full results
experiment							= cell(totalConditionN,1);
plate										= cell(totalConditionN,1);
condition								= cell(totalConditionN,1);
test_control						= cell(totalConditionN,1);
meanWellN								= cell(totalConditionN,1);
tempMeanYelInsideOverT	= cell(totalConditionN,1);
meanYelInsideOverT			= cell(totalConditionN,maxTimePointN);

for k=1:totalConditionN
	meanWellN{k,1} = 0;
	currentUniqueCondition = uniqueConditions{k,1};
	tempMeanYelInsideOverT{k,1} = zeros(1,maxTimePointN);
	for j=1:plateN
		wellN = length(plateStructArray(j).well);
		for i=1:wellN
			tempCondition = [plateStructArray(j).plateStr,' '...
			plateStructArray(j).well(i).conditionStr...
			,' ',plateStructArray(j).well(i).test_control];
			currentTimePointN = length(plateStructArray(j).well(1).yelInsideOverT);
			if strcmp(currentUniqueCondition,tempCondition)
				tempMeanYelInsideOverT{k,1}(1:currentTimePointN) = tempMeanYelInsideOverT{k,1}(1:currentTimePointN) + plateStructArray(j).well(i).yelInsideOverT';
				meanWellN{k,1} = meanWellN{k,1} + 1;
				
				experiment{k,1}		= plateStructArray(j).experimentStr;
				plate{k,1}				= plateStructArray(j).plateStr;
				condition{k,1}		= plateStructArray(j).well(i).conditionStr;
				test_control{k,1} = plateStructArray(j).well(i).test_control;
				
			end
		end
	end
	tempMeanYelInsideOverT{k,1} = tempMeanYelInsideOverT{k,1} / meanWellN{k,1};
	meanYelInsideOverT(k,:) = num2cell(tempMeanYelInsideOverT{k,1});
end

meanYelInsideOverT  = meanYelInsideOverT(:,desiredTimePoints);

fullResults = horzcat(experiment,plate,condition,test_control...
	,meanWellN,meanYelInsideOverT);

% organize table headers
timePointHeader = cell(1,maxTimePointN - 13);
timePointHeader{1,1} = 'TimePoint_12';
for i=15:maxTimePointN
	timePointHeader{1,i - 13} = ['TimePoint_',num2str(i)];
end
fullHeader = horzcat({'experiment','plate','condition','test_control'...
	,'meanWellN'},timePointHeader);

fullCellArray = vertcat(fullHeader,fullResults);
fullTable = cell2table(fullResults,'VariableNames',fullHeader);

dateFormat = 'yyyy_mm_dd_HHMM';
dateStr = datestr(now,dateFormat); 

if exist(saveLocationFolder,'dir') ~= 7
	mkdir(saveLocationFolder)
end

if ispc == true
	fullFileName = strcat('meanTimeline_',dateStr,'.xlsx');
	xlswrite(fullfile(saveLocationFolder,fullFileName),fullCellArray)
elseif isunix == true
	fullFileName = strcat('meanTimeline_',dateStr,'.csv');
	writetable(fullTable,fullfile(saveLocationFolder,fullFileName))
end

disp('Finished writing mean timeline to file')

% conditionN = length(plateStructArray);
% rowN  = conditionN * 2;
% 
% timepointN = size(plateStructArray(1).yelInsideOverTTest,2);
% 
% desiredPoints = zeros(1,timepointN);
% desiredPoints(12) = 1;
% desiredPoints(15:end) = 1;
% desiredPoints = logical(desiredPoints);
% desiredPointsN = sum(desiredPoints);
% 
% condition = cell(rowN,1);
% test_control = cell(rowN,1);
% yelInside = zeros(rowN,desiredPointsN);
% 
% counter = 1;
% for i=1:conditionN
% 	
% 	resultsStruct = plateStructArray(i);
% 
% 	yelTest					= resultsStruct.yelInsideOverTTest;
% 	yelControl			= resultsStruct.yelInsideOverTControl;
% 
% 	meanYelTest         = mean(yelTest,1);
% 	meanYelControl      = mean(yelControl,1);
% 	
% 	meanYelTest = meanYelTest(desiredPoints);
% 	meanYelControl = meanYelControl(desiredPoints);
% 	
% 	yelInside(counter,:) = meanYelTest;
% 	yelInside(counter+1,:) = meanYelControl;
% 	
% 	condition{counter} = resultsStruct.condition;
% 	condition{counter+1} = resultsStruct.condition;
% 	
% 	test_control{counter} = 'test';
% 	test_control{counter+1} = 'control';
% 	
% 	counter = counter + 2;
% 
% end
% 
% header{1} = 'condition';
% header{2} = 'test or control';
% header{3} = 'TimePoint_12';
% for i=1:timepointN-14
% 	header{i+3} = strcat('TimePoint_',num2str(i+14));
% end
% 
% data = horzcat(condition,test_control,num2cell(yelInside));
% 
% T = cell2table(vertcat(header,data));
% 
% 	writetable(T,saveLocationPath,'WriteVariableNames',false)
	
end

