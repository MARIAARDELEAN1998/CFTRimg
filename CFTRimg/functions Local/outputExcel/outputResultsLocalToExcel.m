function outputResultsLocalToExcel( resultsStructArray , saveLocationFolder, dateStr )
%OUTPUT_RESULTS_LOCAL_TO_EXCEL
%   The 'xlswrite' function only works on Windows machines and the
%   'writetable' function only works on Mac machine. This function splits
%   so to work on both PC an unix machines.
%
%		This function creates two csv files. The first gives all for every
%		cell. The second csv file gives a summary of the most relevant
%		statistics.

conditionN = length(resultsStructArray);

% create table of full results

totalCellN = 0;
for i=1:conditionN
	resultsStruct = resultsStructArray(i);
	totalCellN = totalCellN + resultsStruct.cellN;
end

expStr							= cell(totalCellN,1);
plateIdx						= cell(totalCellN,1);
condition						= cell(totalCellN,1);
normCondition				= cell(totalCellN,1);
yelMembrane					= cell(totalCellN,1);
yelEntire						= cell(totalCellN,1);
redEntire						= cell(totalCellN,1);
yelMembraneNorm			= cell(totalCellN,1);
yelEntireNorm				= cell(totalCellN,1);
redEntireNorm				= cell(totalCellN,1);
memDens							= cell(totalCellN,1);
logMemDens					= cell(totalCellN,1);

cntr = 1;
for j=1:conditionN
	resultsStruct = resultsStructArray(j);
	cellN = resultsStruct.cellN;
	
	expStr(cntr:cntr+cellN-1) = resultsStruct.cellLocation(:,1);
	plateIdx(cntr:cntr+cellN-1) = resultsStruct.cellLocation(:,2);
	condition(cntr:cntr+cellN-1) = {resultsStruct.condition};
	normCondition(cntr:cntr+cellN-1) = {resultsStruct.normCondition};
	yelMembrane(cntr:cntr+cellN-1) = num2cell(resultsStruct.yelMembrane(:));
	yelEntire(cntr:cntr+cellN-1) = num2cell(resultsStruct.yelEntire(:));
	redEntire(cntr:cntr+cellN-1) = num2cell(resultsStruct.redEntire(:));
	yelMembraneNorm(cntr:cntr+cellN-1) = num2cell(resultsStruct.yelMembraneNorm(:));
	yelEntireNorm(cntr:cntr+cellN-1) = num2cell(resultsStruct.yelEntireNorm(:));
	redEntireNorm(cntr:cntr+cellN-1) = num2cell(resultsStruct.redEntireNorm(:));
	memDens(cntr:cntr+cellN-1) = num2cell(resultsStruct.memDens(:));
	logMemDens(cntr:cntr+cellN-1) = num2cell(resultsStruct.logMemDens(:));
	
	cntr = cntr + cellN;
end

fullResults = horzcat(expStr,plateIdx,condition,normCondition,yelMembrane...
	,yelEntire,redEntire,yelMembraneNorm,yelEntireNorm...
	,redEntireNorm,memDens,logMemDens);
fullHeader = {'experimentStr', 'plateIdx', 'condition', 'normCondition'...
	, 'yelMembrane', 'yelEntire', 'redEntire', 'yelMembraneNorm'...
	, 'yelEntireNorm', 'redEntireNorm', 'memDens', 'logMemDens'};

fullCellArray = vertcat(fullHeader,fullResults);
fullTable = cell2table(fullResults,'VariableNames',fullHeader);

if exist(saveLocationFolder,'dir') ~= 7
	mkdir(saveLocationFolder)
end

if ispc == true
	fullFileName = strcat('fullLocalResults_',dateStr,'.xlsx');
	xlswrite(fullfile(saveLocationFolder,fullFileName),fullCellArray)
elseif isunix == true
	fullFileName = strcat('fullLocalResults_',dateStr,'.csv');
	writetable(fullTable,fullfile(saveLocationFolder,fullFileName))
end

end

