function [ imageStruct ] = calculateMaxGrad( imageStruct, startPoint )
%CALCULATE_CONC_IODINE Find the point in the time series, where the
%influx of iodine is at its maximum.
%   Log both the value of maximum influx and the time point at which it
%   occurs.

timeline							= imageStruct.timeline;
timePointN						= timeline(end);
timeStep							= imageStruct.timeStep;
yelInside							= imageStruct.yelInsideOverT;
concIodine						= 1.9 * ((1-yelInside)./yelInside); % (pKa of YFP(H148Q/I152L) is 1.9 mM, see Gallieta et al., 2001, https://www.ncbi.nlm.nih.gov/pubmed/11423120)
gradIodine						= zeros(timePointN-1,1);

for i=1:length(gradIodine)
	gradIodine(i) = (concIodine(i+1) - concIodine(i)) / timeStep; % mM s^(-1)
end

imageStruct.maxGrad		 = max(gradIodine(startPoint:end));
location							 = (1:length(gradIodine))' .*(gradIodine==max(gradIodine(startPoint:end)));
imageStruct.maxGradLoc = max(location);

end

