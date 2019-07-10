function [ croppedImage ] = boundingBoxToCroppedColor( fullImage ...
	, boundingBox , binning )
%BOUNDING_BOX_TO_CROPPED_COLOR
	
extra = 20*binning;

xmin = ceil(boundingBox(1)) - extra;
xmax = floor(boundingBox(1)) + boundingBox(3) + extra;
ymin = ceil(boundingBox(2)) - extra;
ymax = floor(boundingBox(2)) + boundingBox(4) + extra;

xmin(xmin<1)=1;
xmax(xmax<1)=1;
ymin(ymin<1)=1;
ymax(ymax<1)=1;

xmin(xmin>2160*binning)=2160*binning;
xmax(xmax>2160*binning)=2160*binning;
ymin(ymin>2160*binning)=2160*binning;
ymax(ymax>2160*binning)=2160*binning;

croppedImage = fullImage(ymin:ymax,xmin:xmax,:);


end

