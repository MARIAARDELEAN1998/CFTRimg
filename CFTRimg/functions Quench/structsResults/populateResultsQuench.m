function resultsStructArray = populateResultsQuench( resultsStructArray...
	,plate)
% populates empty resultsStructArray with actual results (max rate of
% iodide entry and the timepoint at which the influx is highest)

conditionN	= length(resultsStructArray);
plateN			= length(plate);

for k=1:conditionN
			countTest					= 1;
		 	countControl			= 1;
	for j=1:plateN
		for i=1:length(plate(j).well);
			timePointN			= length(plate(j).well(i).yelInsideOverT);
			condPlate				= plate(j).well(i).condition;
			condStructArray = resultsStructArray(k).condition;
			if strcmp(condPlate,condStructArray)
				switch plate(j).well(i).test_control
					case 'test'
						resultsStructArray(k).maxGradTest(countTest)							= plate(j).well(i).maxGrad;
						resultsStructArray(k).maxGradTestNorm(countTest)					= plate(j).well(i).maxGrad/plate(j).well(i).redInsideNorm;
						resultsStructArray(k).redInsideTestNorm(countTest)				= plate(j).well(i).redInsideNorm;
						resultsStructArray(k).redInsideTest(countTest)						= plate(j).well(i).redInside;
						resultsStructArray(k).maxGradTestLoc(countTest)						= plate(j).well(i).maxGradLoc;
						for t=1:timePointN
							resultsStructArray(k).yelInsideOverTTest(countTest,t)		= plate(j).well(i).yelInsideOverT(t);
						end
						countTest																= countTest + 1;
					case 'control'
						resultsStructArray(k).maxGradControl(countControl)						= plate(j).well(i).maxGrad;
						resultsStructArray(k).maxGradControlNorm(countControl)				= plate(j).well(i).maxGrad/plate(j).well(i).redInsideNorm;
						resultsStructArray(k).redInsideControlNorm(countControl)			= plate(j).well(i).redInsideNorm;
						resultsStructArray(k).redInsideControl(countControl)					= plate(j).well(i).redInside;
						resultsStructArray(k).maxGradControlLoc(countControl)					= plate(j).well(i).maxGradLoc;
						for t=1:timePointN
							resultsStructArray(k).yelInsideOverTControl(countControl,t)	= plate(j).well(i).yelInsideOverT(t);
						end
						countControl																= countControl + 1;
 
				end
				end
			end
		end
	end
% 	resultsStructArray(k) = res;
end


