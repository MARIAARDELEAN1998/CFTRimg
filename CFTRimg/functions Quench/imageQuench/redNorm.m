function [ plate ] = redNorm( plate )

for i = 1 : length(plate) % for each plate
	cond			= {};
	redInside = [];
	
		for j = 1 : length(plate(i).well)										% for each well
			cond(j)				= {plate(i).well(j).condition};              % make a list with all the conditions (mutants, drug treatments, etc)
			redInside(j)	= plate(i).well(j).redInside;                       %  make a list of the mCherry signal inside the cell selection (corrected for background)
		end

	 idxNormCond						= strcmp(cond, plate(i).normCondition);				% make an index of the normconditions  
	 redInsideNormCond			= sum(idxNormCond.*redInside)/sum(idxNormCond);		% calculate the average redInside for the normCondition on that plate
	 redInsideNorm					= redInside./redInsideNormCond;						% normalise the redInside for each well
		 
		for j = 1 : length(plate(i).well)											% for each well
			 plate(i).well(j).redInsideNorm			= redInsideNorm(j);		% store the normalised red inside
		end
		 
end
end