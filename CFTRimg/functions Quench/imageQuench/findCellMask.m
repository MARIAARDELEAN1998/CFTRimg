function  cellMask  = findCellMask( redImage )
%FIND_CELL_MASK Binarize quench image to create mask over cells, and dilate
%this area.

adjusted	= imadjust(redImage);
thresh		= 0.8*graythresh(adjusted); 
Ibw				= imbinarize(adjusted,thresh);
se				= strel('disk',1);
tmp				= Ibw;

for i=1:4
	tmp = imdilate(tmp,se);
end

cellMask = tmp;
end



