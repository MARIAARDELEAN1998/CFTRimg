function [ imageStruct ] = imgProcess(imageStruct)

% MAKE A BINARY MASK BASED ON THE mCHERRY CHANNEL
binning				= imageStruct.binning;
objective 		= imageStruct.objective;
bin_object_adj= binning*objective/60;
Ir 						= im2double(imread(imageStruct.redPath));		% load mCherry image
Iy						= im2double(imread(imageStruct.yelPath));		% load YFP image 
Ibw						= imbinarize(Ir,'adaptive');								% binarise	
SE						= strel('disk',round(10*bin_object_adj));								
Iopen					= imopen(Ibw,SE);														% open
Iclose				= imclose(Iopen,SE);												% close
Iclear				= bwareaopen(Iclose,ceil(4800*bin_object_adj*bin_object_adj));		% area opening (deselect small areas)
Idilate				= imdilate(Iclear,strel('disk',round(4*bin_object_adj)));	% dilate

% SEGMENT IMAGE
% (https://blogs.mathworks.com/steve/2013/11/19/watershed-transform-question-from-tech-support/)
D							= -bwdist(~Idilate);								% create distance map of cell selection
FGM						= imextendedmin(D,round(10*bin_object_adj));			% detects all FGMs (foreground markers) depending on global minima 
D2						= imimposemin(D,FGM);								% "minima imposition" forces local minima to be in the FGMs (to prevent oversegmentation)
L							= watershed(D2);										% watershed
Iseg					= Idilate;													% duplicate Idilate  
Iseg(L == 0)	= 0;																% 'burn' the watershed lines in the duplicated Idilate image
Iseg					= imclearborder(Iseg);							% deselect all components touching the border

% CALCULATE BACKGROUND
SE_BG         = strel('disk',round(60*bin_object_adj));
BG            = ~imclose((imdilate(Iopen,SE_BG)),SE_BG);  % select background
if sum(BG(:)) == 0;                                       % if no background gets selected, don't select cells
  imageStruct.cellN(1)=0;
else
IyBG											= sum(Iy(:) .* BG(:)) / sum(BG(:));
IrBG											= sum(Ir(:) .* BG(:)) / sum(BG(:));
imageStruct.yelBackground = IyBG;
imageStruct.redBackground = IrBG;

%  IbwPerim			  = bwperim(Iseg);
%  overlay				= imoverlay(imadjust(Ir), IbwPerim|FGM, [.3 1 .3]);
%  figure;				imshow(overlay)
%  figure;				imshow(imoverlay(imadjust(Iy),bwperim(BG)))

% SELECT CELLS
counter			= 1;
properties	= regionprops(Iseg,'BoundingBox','Area', 'Perimeter','MajorAxisLength');
for i=1:length(properties)
	if properties(i).Area > round(1000*bin_object_adj*bin_object_adj) ... 
	&  properties(i).Area < round(50000*bin_object_adj*bin_object_adj)...
	&	properties(i).Area/properties(i).Perimeter > round(25*bin_object_adj)...
	& properties(i).MajorAxisLength < round(300*bin_object_adj);
	imageStruct.boundingBox(counter,:) = properties(i).BoundingBox;
	counter = counter + 1;
	end
end
imageStruct.cellN(1,1) = counter-1;

% MAKE DISTANCE MAPS AND CALCULATE METRICS
cellN								= imageStruct.cellN(end);
if cellN>0
	for i=1:cellN
	boundingBox		= imageStruct.boundingBox(i,:);
	cellMask			= boundingBoxToCroppedImage(Iseg,boundingBox,binning);
 	cellMask			= imclearborder(cellMask);
	distancemap		= cellMaskToDistanceMap(cellMask);
	membraneMask	= distancemap >= 0 & distancemap < round(10*bin_object_adj);
	interiorMask	= cellMask & ~membraneMask;
	outsideMask		= ~cellMask;
	
	redCropped		= boundingBoxToCroppedImage(Ir,boundingBox,binning);
	yelCropped		= boundingBoxToCroppedImage(Iy,boundingBox,binning);
	redCropAdj		= redCropped-IrBG; 
	yelCropAdj		= yelCropped-IyBG; 
	
	redEntireAbs  = cellMask			.* redCropped;
	yelEntireAbs	= cellMask			.* yelCropped;
	yelMemAbs			= membraneMask  .* yelCropped;
	redEntire			= cellMask			.* redCropAdj;
	redOutside		= outsideMask		.* redCropAdj;
	yelMembrane		= membraneMask	.* yelCropAdj;
	yelEntire			= cellMask			.* yelCropAdj;
	yelOutside		= outsideMask		.* yelCropAdj;
	yelInterior		= interiorMask	.* yelCropAdj;
	
	entirePixelCount		= sum(cellMask(:));
	membranePixelCount	= sum(membraneMask(:));
	outsidePixelCount		= sum(outsideMask(:));
	
	imageStruct.yelEntireAbsolute(i,1)		= sum(yelEntireAbs(:)) / entirePixelCount;;
	imageStruct.yelMembraneAbsolute(i,1)	= sum(yelMemAbs(:))/ outsidePixelCount; 
	imageStruct.redEntireAbsolute(i,1)		= sum(redEntireAbs(:))  / membranePixelCount;
	imageStruct.yelEntire(i,1)						= sum(yelEntire(:)) / entirePixelCount;
	imageStruct.yelOutside(i,1)						= sum(yelOutside(:)) / outsidePixelCount;
	imageStruct.yelMembrane(i,1)					= sum(yelMembrane(:)) / membranePixelCount;
	imageStruct.redEntire(i,1)						= sum(redEntire(:)) / entirePixelCount;
	imageStruct.redOutside(i,1)						= sum(redOutside(:)) / outsidePixelCount;
	end

% Delete cells with Negative value for redEntire, yelEntire, and
% yelMembrane after background correction...
imageStruct.yelEntireNeg		= sum(imageStruct.yelEntire		< 0);
imageStruct.yelMembraneNeg	= sum(imageStruct.yelMembrane	< 0);
imageStruct.redEntireNeg		= sum(imageStruct.redEntire		< 0);
yelEntireCompare						= imageStruct.yelEntire				< 0;
yelMembraneCompare					= imageStruct.yelMembrane			< 0;
redEntireCompare						= imageStruct.redEntire				< 0;
toDelete										= yelEntireCompare | yelMembraneCompare | redEntireCompare;
imageStruct.deleteNeg				= sum(toDelete);
imageStruct.cellN(2)				= cellN - sum(toDelete);

imageStruct.yelEntireAbsolute(toDelete)		=[];
imageStruct.yelMembraneAbsolute(toDelete)	=[];
imageStruct.redEntireAbsolute(toDelete)		=[];
imageStruct.yelEntire(toDelete)						=[];				
imageStruct.yelOutside(toDelete)					=[];				
imageStruct.yelMembrane(toDelete)					=[];
imageStruct.redEntire(toDelete)						=[];
imageStruct.redOutside(toDelete)					=[];
imageStruct.boundingBox(toDelete,:)				=[];

end
end