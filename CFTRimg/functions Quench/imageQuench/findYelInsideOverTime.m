function [ imageStruct ] = findYelInsideOverTime( imageStruct, normTimePoint)
%FIND_YEL_INSIDE_OVER_TIME Collect yellow fluorescence intensity data from
%each quench image giving time series data.
%   1. The red images from the start and finish are binarized to locate
%   cells. The binarized cell masks are combined to give a larger cell
%   area, accounting for the slight movement of cells over the time course
%   due to fluid additions.
%		2. Yellow intesity data are normalized.
%			* Normalized by the point just before the first fluid addition.

yelN					= imageStruct.timeline(end);
redImageStart	= im2double(imread(imageStruct.redPath{1})); 
redImageEnd		= im2double(imread(imageStruct.redPath{2}));
cellMaskStart = findCellMask(redImageStart);
cellMaskEnd		= findCellMask(redImageEnd);
cellMask			= cellMaskStart | cellMaskEnd;
tmpRedInside	= redImageEnd .* cellMask;
tmpRedOutside = redImageEnd .* ~cellMask;
redInside			= sum(tmpRedInside(:)) / sum(cellMask(:));
redOutside		= sum(tmpRedOutside(:)) / sum(~cellMask(:));
redSignal			= redInside - redOutside;
imageDimM			= size(redImageStart,1);
imageDimN			= size(redImageStart,2);
yelImage			= zeros(imageDimM,imageDimN,yelN,'double');
yelInside			= zeros(yelN,1);
yelOutside		= zeros(yelN,1);

for i=1:yelN
	yelImage(:,:,i) = im2double(imread(imageStruct.yelPath{i}));
	tmpYelIn        = yelImage(:,:,i) .* cellMask;
	tmpYelOut       = yelImage(:,:,i) .* ~cellMask;
	yelInside(i)    = sum(tmpYelIn(:)) / sum(cellMask(:));
	yelOutside(i)   = sum(tmpYelOut(:)) / sum(~cellMask(:));
end

yelSignal										= yelInside - yelOutside;
yelStandard									= yelSignal(normTimePoint);
imageStruct.yelInsideOverT  = yelSignal / yelStandard;
imageStruct.redInside				= redSignal; % for normalisation of G

end

