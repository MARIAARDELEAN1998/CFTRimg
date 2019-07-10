function outputResultsLocalTableToExcel( resultsLocal , saveLocationFolder, dateStr )
%OUTPUT_RESULTS_LOCAL_TO_EXCEL
%   The 'xlswrite' function only works on Windows machines and the
%   'writetable' function only works on Mac machine. This function splits
%   so to work on both PC an unix machines.
%
%		This function creates two csv files. The first gives all for every
%		cell. The second csv file gives a summary of the most relevant
%		statistics.

% TABLE RESULTS PER PLATE 
data_expN		= cell(sum(vertcat(resultsLocal.cellN)),3);
cellIdx			= 0;
for j=1:length(resultsLocal)
	cellN							= resultsLocal(j).cellN;
	totalCellCond(j)	= resultsLocal(j).cellN;
	for i=1:cellN
		data_expN(cellIdx+i,1) = {resultsLocal(j).condition}; 						% condition
		data_expN(cellIdx+i,2) = resultsLocal(j).cellLocation(i,1);				% experiment str
		data_expN{cellIdx+i,3} = resultsLocal(j).logMemDens(i);						% logMemDens
		data_expN{cellIdx+i,4} = resultsLocal(j).redEntireNorm(i);				% norm redInside
		data_expN{cellIdx+i,5} = resultsLocal(j).redEntire(i);						% norm redInside
	end
	cellIdx = cellIdx + cellN;
end
condition								=  data_expN(:,1);
experimentStr						=  data_expN(:,2);
logMemDens							=  cell2mat(data_expN(:,3));
redEntireNorm						=  cell2mat(data_expN(:,4));
redEntire								=  cell2mat(data_expN(:,5));
T1											= table(experimentStr,condition,logMemDens,redEntireNorm, redEntire);
[G, condition, experimentStr]			= findgroups(T1.condition,T1.experimentStr);
meanLogMemDens					= splitapply(@mean,T1.logMemDens,G);
meanredEntireNorm				= splitapply(@mean,T1.redEntireNorm,G);
meanredEntire 					= splitapply(@mean,T1.redEntire,G);
TL											= table(experimentStr,condition,meanLogMemDens,meanredEntireNorm,meanredEntire);
 
if ispc == true
	fullFilePath = fullfile(saveLocationFolder,strcat('LocalTable_',dateStr,'.xlsx'));
	writetable(TL, fullFilePath)
elseif isunix == true
	fullFilePath = fullfile(saveLocationFolder,strcat('LocalTable_',dateStr,'.csv'));
	writetable(TL,fullFilePath)
end

end

