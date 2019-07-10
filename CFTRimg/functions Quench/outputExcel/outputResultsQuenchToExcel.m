function outputResultsQuenchToExcel( resultsStructArray , saveLocationPath, dateStr )

conditionN										= length(resultsStructArray);
influx_rate										= zeros(1,conditionN);
influx_rate_std								= zeros(1,conditionN);
influx_rateNorm2red						= zeros(1,conditionN);
influx_rateNorm2red_std				= zeros(1,conditionN);
Quench_N											= zeros(1,conditionN);
influx_rate_DMSONorm2red			= zeros(1,conditionN);
influx_rate_DMSONorm2red_std	= zeros(1,conditionN);
Quench_DMSO_N									= zeros(1,conditionN);
influx_rate_t									= zeros(1,conditionN);
influx_rate_t_std							= zeros(1,conditionN);
influx_rate_DMSO_t						= zeros(1,conditionN);
influx_rate_DMSO_t_std				= zeros(1,conditionN);

for i = 1:length(resultsStructArray)
    %FORSKOLIN
    Quench_N(i)								= length(resultsStructArray(i).maxGradTest);
    influx_rate(i)						= mean(resultsStructArray(i).maxGradTest);
    influx_rate_std(i)				= std(resultsStructArray(i).maxGradTest);
		influx_rateNorm2red(i)		= mean(resultsStructArray(i).maxGradTestNorm);
    influx_rateNorm2red_std(i) = std(resultsStructArray(i).maxGradTestNorm);
    influx_rate_t(i)					= mean(resultsStructArray(i).maxGradTestLoc);
    influx_rate_t_std(i)			= std(resultsStructArray(i).maxGradTestLoc);
    %DMSO CONTROL
    Quench_DMSO_N(i)						= length(resultsStructArray(i).maxGradControl);
    influx_rate_DMSO(i)         = mean(resultsStructArray(i).maxGradControl);
    influx_rate_DMSO_std(i)			= std(resultsStructArray(i).maxGradControl);
		influx_rate_DMSONorm2red(i)= mean(resultsStructArray(i).maxGradControlNorm);
    influx_rate_DMSONorm2red_std(i)= std(resultsStructArray(i).maxGradControlNorm);
    influx_rate_DMSO_t(i)				= mean(resultsStructArray(i).maxGradControlLoc);
    influx_rate_DMSO_t_std(i)		= std(resultsStructArray(i).maxGradControlLoc);
end

	condition_quench  = vertcat(cellstr('condition'),cellstr({resultsStructArray.condition}'));
	N_quench_F        = vertcat(cellstr('N test'),num2cell([Quench_N]'));
	max_rate_F        = vertcat((horzcat(cellstr('mean maxGradTest'), ...
										cellstr('std maxGradTest'))),num2cell([influx_rate; influx_rate_std]'));
	max_rate_FNorm2red = vertcat((horzcat(cellstr('mean maxGradTestNorm'), ...
										cellstr(' std maxGradTestNorm'))),num2cell([influx_rateNorm2red; influx_rateNorm2red_std]'));
	max_rate_F_tp     = vertcat((horzcat(cellstr('mean maxGradTestLoc'), ...
										cellstr('std maxGradTestLoc'))),num2cell([influx_rate_t; influx_rate_t_std]'));
	N_quench_DMSO     = vertcat(cellstr('N control'),num2cell([Quench_DMSO_N]'));
	max_rate_DMSO     = vertcat((horzcat(cellstr('mean maxGradControl'), ...
										cellstr('std maxGradControl'))),num2cell([influx_rate_DMSO; influx_rate_DMSO_std]'));
	max_rate_DMSONorm2red = vertcat((horzcat(cellstr('mean maxGradControlNorm'), ...
										cellstr('std maxGradControlNorm'))),num2cell([influx_rate_DMSONorm2red; influx_rate_DMSONorm2red_std]'));
	max_rate_DMSO_tp  = vertcat((horzcat(cellstr('mean maxGradControlLoc'), ...
										cellstr('std maxGradControlLoc'))),num2cell([influx_rate_DMSO_t; influx_rate_DMSO_t_std]'));
										
	results			= horzcat(condition_quench,N_quench_F,max_rate_F,max_rate_FNorm2red, max_rate_F_tp,...
								N_quench_DMSO,max_rate_DMSO,max_rate_DMSONorm2red, max_rate_DMSO_tp);

fullFileName    = strcat('QuenchSummary_',dateStr,'.csv');    

if ispc == true
	xlswrite        (fullfile(saveLocationPath,fullFileName),results);
elseif isunix == true
	writetable      (cell2table(results),fullfile(saveLocationPath,fullFileName))
end               

end