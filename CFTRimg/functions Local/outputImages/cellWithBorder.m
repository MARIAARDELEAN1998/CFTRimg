function [redCellImage, yelCellImage] = cellWithBorder(imageStruct, boundingBox_idx )
%CELL_WITH_BORDER create colour cell image with white line denoting the cell segmentation boundary

Ir					= im2double(imread(imageStruct.redPath));
boundingBox = imageStruct.boundingBox(boundingBox_idx,:);
binning			= imageStruct.binning;

		Ibw						= imbinarize(Ir,'adaptive');								% binarise Ir
		SE						= strel('disk',10*binning);								
		Iopen					= imopen(Ibw,SE);														% open
		Iclose				= imclose(Iopen,SE);												% close
		Iclear				= bwareaopen(Iclose,ceil(4800*binning));		% area opening (deselect small areas)
		Idilate				= imdilate(Iclear,strel('disk',4*binning));	% dilate
		D							= -bwdist(~Idilate);								% create distance map of cell selection
		FGM						= imextendedmin(D,10*binning);			% detects all FGMs (foreground markers) depending on global minima 
		D2						= imimposemin(D,FGM);								% "minima imposition" forces local minima to be in the FGMs (to prevent oversegmentation)
		L							= watershed(D2);										% watershed
		Iseg					= Idilate;													% duplicate Idilate  
		Iseg(L == 0)	= 0;																% 'burn' the watershed lines in the duplicated Idilate image
		Iseg					= imclearborder(Iseg);							% deselect all components touching the border
		cellMask      = imclearborder(boundingBoxToCroppedImage(Iseg,boundingBox,binning));
		cellPerim     = bwperim(cellMask);


redImage		= imadjust(Ir);
yelImage		= imadjust(im2double(imread(imageStruct.yelPath)));

[redImX,tmpRedMap] 	= gray2ind(redImage,256);
redMap      				= [tmpRedMap(:,1),zeros(256,1),zeros(256,1)];
redImage 						= ind2rgb(redImX,redMap);

redCropped     			= boundingBoxToCroppedColor(redImage,boundingBox,binning);

[yelImX,tmpYelMap] 	= gray2ind(yelImage,256);
yelMap 							= [tmpYelMap(:,1),tmpYelMap(:,1),zeros(256,1)];
yelImage 						= ind2rgb(yelImX,yelMap);
yelCropped 					= boundingBoxToCroppedColor(yelImage,boundingBox,binning);

edgeCellMask = edge(cellMask);

redCellImage = imoverlay(redCropped,edgeCellMask,'w');
yelCellImage = imoverlay(yelCropped,edgeCellMask,'w');		

end

