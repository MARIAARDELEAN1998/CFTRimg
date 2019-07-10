function  plateStructArray = createPlateStruct_quench( inputStructArray )
%CREATE_PLATE_STRUCT_QUENCH create empty structs for each plate as listed
%in 'inputStruct.plateStr'

plateNames		= unique(horzcat(inputStructArray.plateStr));
plateTemplate = struct(...
			'plateStr',[]...
			,'experimentStr',[]...
			,'normCondition',[]...
			,'well',{{}});

for i=1:length(plateNames);
	plateStructArray(i)						= plateTemplate;
	plateStructArray(i).plateStr	= plateNames{i};
end

for j=1:length(plateNames);
	for i=1:length(inputStructArray);
		if strcmp(inputStructArray(i).plateStr{1},plateStructArray(j).plateStr)
			plateStructArray(j).experimentStr = inputStructArray(i).experimentStr{1};
			plateStructArray(j).normCondition = inputStructArray(i).normCondition{1};
		end
	end
end

end

