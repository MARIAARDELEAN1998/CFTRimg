function labelAndSaveCells( resultsStructArray ,plateStructArray ...
	,saveLocation, proportion)
%LABEL_AND_SAVE_CELLS save each cell image (red and yel) to file labelled with rho value

resultsStructN = length(resultsStructArray);

for j=1:resultsStructN
	resultsStruct = resultsStructArray(j);
	cellN = ceil(length(resultsStruct.cellLocation)*proportion);
	folderStr = strcat({resultsStruct.condition},{' norm '},{resultsStruct.normCondition});
	folderStr = folderStr{1};
	mkdir(fullfile(saveLocation,folderStr))
	
	for i=1:cellN
		plateIdx	= resultsStruct.cellLocation{i,2};
		imageIdx	= resultsStruct.cellLocation{i,3};
		bBoxIdx		= resultsStruct.cellLocation{i,4};
		rhoVal		= resultsStruct.memDens(i);

		[redCellImage, yelCellImage] = ...
		cellWithBorder(plateStructArray(plateIdx).image(imageIdx),bBoxIdx);

		textStr = sprintf('rho = %0.3f',rhoVal);
		
		redTextImage = insertText(redCellImage,[1 1],textStr,'textcolor','white','boxcolor','black','FontSize',10);
		yelTextImage = insertText(yelCellImage,[1 1],textStr,'textcolor','white','boxcolor','black','FontSize',10);
		
		redFilename = sprintf('red-%d_%d_%d.jpg',plateIdx,imageIdx,bBoxIdx);
		yelFilename = sprintf('yel-%d-%d-%d.jpg',plateIdx,imageIdx,bBoxIdx);
		
		imwrite( redTextImage, fullfile(saveLocation,folderStr,redFilename) , 'jpg' )
		imwrite( yelTextImage, fullfile(saveLocation,folderStr,yelFilename) , 'jpg' )
		
	end
end
end