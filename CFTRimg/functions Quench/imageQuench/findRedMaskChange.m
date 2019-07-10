function [ imageStruct ] = findRedMaskChange( imageStruct )
%FIND_RED_MASK_CHANGE Calculate the proportion of pixels in the cellMask
% that doesn't overlap between start end end
%   The results is saved to the imageQuench struct under attribute
%   'redMaskChange'.

redImageStart			= im2double(imread(imageStruct.redPath{1})); 
redImageEnd				= im2double(imread(imageStruct.redPath{2}));
cellMaskStart			= findCellMask(redImageStart);
cellMaskEnd				= findCellMask(redImageEnd);
cellMask					= cellMaskStart | cellMaskEnd;
cellMaskChange		= ~(cellMaskStart == cellMaskEnd);
imageStruct.redMaskChange = sum(cellMaskChange(:))/sum(cellMask(:));

end

