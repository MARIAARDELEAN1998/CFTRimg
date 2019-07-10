function [ tmpRedPathArray,tmpYelPathArray ] = ...
	constructPathName_quench( plateStruct,wells,wellIdx,redTimePoints...
	,tmpRedPathArray,tmpYelPathArray )
%CONSTRUCT_PATH_NAME_QUENCH final process of making quenching path name
%   Combine all sections of quenching path name strings

% red
for i=1:2
	fileFolder = fullfile(plateStruct.baseFolder...
	,plateStruct.folderName...
	,strcat('TimePoint_',redTimePoints{i}));
	filename = strcat(plateStruct.filePrefix,wells{wellIdx},'_w2.TIF');			
	tmpRedPathArray{wellIdx,i} = fullfile(fileFolder,filename);
end

% yellow
timePointN = plateStruct.timeline(end);
for i=1:timePointN
	fileFolder = fullfile(plateStruct.baseFolder...
	,plateStruct.folderName...
	,['TimePoint_',char(string(i))]);
	filename = strcat(plateStruct.filePrefix,wells{wellIdx},'_w1.TIF');
	tmpYelPathArray{wellIdx,i} = fullfile(fileFolder,filename);
end

end

