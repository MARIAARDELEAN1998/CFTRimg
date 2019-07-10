function resultsStructArray = populateResultsLocal( resultsStructArray ...
	,normStructArray,preNormStructArray)
%POPULATE_RESULTS_STURCT Move data from normalized temporary struct into
%final struct ready for plotting

resultsStructN	= length(resultsStructArray);
normStructN			= length(normStructArray);

for k=1:resultsStructN
	resultsStruct			= resultsStructArray(k);
	currentCondition	= resultsStruct.condition;
	currentNormCond		= resultsStruct.normCondition;
	count							= 1;
	for j=1:normStructN
		normStruct = normStructArray(j);
		if strcmp(currentNormCond,normStruct.normCondition)
			locationVec = strcmp(currentCondition,normStruct.condition);
			for i=1:length(locationVec)
				if locationVec(i) == 1
					resultsStruct.cellLocation(count,:)				= normStruct.cellLocation(i,:);
% 				resultsStruct.expStr(count)								= normStruct.cellLocation(i,1);
					resultsStruct.yelMembraneNorm(count)			= normStruct.yelMembraneNorm(i);
					resultsStruct.yelEntireNorm(count)				= normStruct.yelEntireNorm(i);
					resultsStruct.redEntireNorm(count)				= normStruct.redEntireNorm(i);
					resultsStruct.yelMembrane(count)					= normStruct.yelMembrane(i);
					resultsStruct.yelEntire(count)						= normStruct.yelEntire(i);
					resultsStruct.redEntire(count)						= normStruct.redEntire(i);			
					resultsStruct.yelMembraneAbsolute(count)	= normStruct.yelMembraneAbsolute(i);
					resultsStruct.yelEntireAbsolute(count)		= normStruct.yelEntireAbsolute(i);
					resultsStruct.redEntireAbsolute(count)		= normStruct.redEntireAbsolute(i);
					resultsStruct.logMemDens(count)						= normStruct.logMemDens(i);
					resultsStruct.memDens(count)							= normStruct.memDens(i);		
					count																			= count+1;
				end
			end		
		end	
	end
	resultsStructArray(k) = resultsStruct;
end
end