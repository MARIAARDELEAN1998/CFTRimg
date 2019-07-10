function outputResultsLocalSummaryToExcel( resultsLocal , saveLocationFolder, dateStr )
%OUTPUT_RESULTS_LOCAL_TO_EXCEL
%   The 'xlswrite' function only works on Windows machines and the
%   'writetable' function only works on Mac machine. This function splits
%   so to work on both PC an unix machines.
%
%		This function creates two csv files. The first gives all for every
%		cell. The second csv file gives a summary of the most relevant
%		statistics.

% DESCRIPTIVES 
totalCellN	= sum(vertcat(resultsLocal.cellN));
data_expN		= cell(totalCellN,3);
cellIdx			= 0;

for j=1:length(resultsLocal)
	cellN							= resultsLocal(j).cellN;
	totalCellCond(j)	= resultsLocal(j).cellN;
	yelMembraneNeg(j) = resultsLocal(j).yelMembraneNeg;
	yelEntireNeg(j)		= resultsLocal(j).yelEntireNeg;
	redEntireNeg(j)		= resultsLocal(j).redEntireNeg;
	deleteNeg(j)			= resultsLocal(j).deleteNeg;
	for i=1:cellN
		data_expN(cellIdx+i,1) = {resultsLocal(j).condition};														
		data_expN(cellIdx+i,2) = resultsLocal(j).cellLocation(i,1); % experiment str
		data_expN{cellIdx+i,3} = resultsLocal(j).logMemDens(i);			% logMemDens
	end
	cellIdx = cellIdx + cellN;
end

[G,conditionGroups,expGroups]	=	findgroups(data_expN(:,1),data_expN(:,2));
meanLogMemDens								= splitapply(@mean,vertcat(data_expN{:,3}),G);
groupN												= splitapply(@length,vertcat(data_expN{:,3}),G);
meanMemDens										= 10.^meanLogMemDens;
[condG,conditionNames]				= findgroups(conditionGroups);
[expG,expNames]								= findgroups(expGroups);
conditionN										= length(conditionNames);
expN													= length(expNames);

fullCond_MemDens_expN		= conditionNames;
mean_LogMemDens_expN		= splitapply(@mean,meanLogMemDens,condG);
mean_MemDens_expN				= mean_LogMemDens_expN;
STDEV_LogMemDens_expN		= splitapply(@std,meanLogMemDens,condG);
N_MemDens_expN					= splitapply(@length,meanLogMemDens,condG);
sem_LogMemDens_expN			= STDEV_LogMemDens_expN ./ sqrt(N_MemDens_expN);
ts											= tinv([0.025  0.975],expN-1);
CI_LL_LogMemDens_expN		= mean_LogMemDens_expN + ts(1)*sem_LogMemDens_expN;
CI_LL_MemDens_expN			= CI_LL_LogMemDens_expN;
CI_UL_LogMemDens_expN		= mean_LogMemDens_expN + ts(2)*sem_LogMemDens_expN;
CI_UL_MemDens_expN			= CI_UL_LogMemDens_expN;

titles      = {'condition', 'N', 'mean meanLogMemDens','lower CI','upper CI',...
							'cellN','deleteNeg','redEntireNeg','yelEntireNeg',...
							'yelMembraneNeg'};
results			=	horzcat(fullCond_MemDens_expN,num2cell(N_MemDens_expN),...
							num2cell(mean_MemDens_expN),num2cell(CI_LL_MemDens_expN),...
							num2cell(CI_UL_MemDens_expN),num2cell(totalCellCond'),...
							num2cell(deleteNeg'),num2cell(redEntireNeg'),...
							num2cell(yelEntireNeg'), num2cell(yelMembraneNeg'));
summary			= vertcat			 (titles,results);
 
if ispc == true
	fullFilePath = fullfile(saveLocationFolder,strcat('LocalSummary_',dateStr,'.xlsx'));
	xlswrite(fullFilePath,summary)
elseif isunix == true
	fullFilePath = fullfile(saveLocationFolder,strcat('LocalSummary_',dateStr,'.csv'));
	writetable(cell2table(summary),fullFilePath)
end

end

