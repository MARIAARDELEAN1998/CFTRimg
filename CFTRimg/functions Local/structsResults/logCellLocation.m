function plateStruct = logCellLocation( plateStruct , plateIdx)
%LOG_CELL_LOCATION log the location of each cell
%		The plate index, image index and bounding box index are saved so that
%		the cells can be found later for image display

imageN = length(plateStruct.image);

for j=1:imageN
	
	imageStruct				= plateStruct.image(j);
	imageIdx					= j;
	cellLocation			= cell(imageStruct.cellN(end),4);
	cellLocation(:,1) = {plateStruct.experimentStr};
	cellLocation(:,2) = {plateIdx};
	cellLocation(:,3) = {imageIdx};
	
	for i=1:imageStruct.cellN(end)
		cellLocation(i,4) = {i};
	end

	imageStruct.cellLocation	= cellLocation;
	plateStruct.image(j)			= imageStruct;
end
end



