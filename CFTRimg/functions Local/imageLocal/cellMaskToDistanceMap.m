function [ distanceMap ] = cellMaskToDistanceMap( cellMask )
%CELL_MASK_TO_DISTANCE_MAP

positiveDistanceMap = (ceil(bwdist(~cellMask)) - 1) .* cellMask;
negativeDistanceMap = ceil(bwdist(cellMask));
distanceMap = positiveDistanceMap - negativeDistanceMap;

end

