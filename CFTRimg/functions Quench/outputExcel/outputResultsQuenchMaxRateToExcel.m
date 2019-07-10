function outputResultsQuenchMaxRateToExcel( plate , saveLocationPath, dateStr)
% GET MEAN MAX GRADIENT PER CONDITION PER PLATE WITH DATES + PER WELL (up
% to four repeats per condition)

date_F									= {}; date_DMSO         = {};
condition1_F            = {}; condition2_F      = {}; condition3_F      = {}; condition4_F      = {}; % up to four repeats per condition
condition1_DMSO         = {}; condition2_DMSO   = {}; condition3_DMSO		= {}; condition4_DMSO   = {};
F_mean                  = []; DMSO_mean					= [];
F_meanMaxGradNorm       = []; DMSO_meanMaxGradNorm 	= [];
F_meanRedInsideNorm     = []; DMSO_meanRedInsideNorm= [];
F_maxGrad								= []; DMSO_maxGrad      = [];

for i = 1:length(plate)
    for j = 1 : length(plate(i).well)
        cond(j)					= {plate(i).well(j).condition};
        F_DMSO(j)				= {plate(i).well(j).test_control};
        maxGrad(j)			= plate(i).well(j).maxGrad;
        redInsideNorm(j)= plate(i).well(j).redInsideNorm;
        maxGradNorm(j)	= maxGrad(j)/redInsideNorm(j);
    end
 idx_F						= find(strcmp(F_DMSO, 'test'));
 idx_DMSO					= find(strcmp(F_DMSO, 'control'));	
 cond_F						= cond(idx_F)';
 maxGrad_F				= maxGrad(idx_F)';
 redInsideNorm_F	= redInsideNorm(idx_F)';
 maxGradNorm_F    = maxGradNorm(idx_F)';
 cond_DMSO				= cond(idx_DMSO)';
 maxGrad_DMSO			= maxGrad(idx_DMSO)';
 redInsideNorm_DMSO		= redInsideNorm(idx_DMSO)';
 maxGradNorm_DMSO = maxGradNorm(idx_DMSO)';
 cond_F_u         = unique(cond_F);
 cond_DMSO_u			= unique(cond_DMSO);
 
     for k = 1 : length(cond_F_u)
         idx_F_u										= find(strcmp(cond_F, cond_F_u(k)));
         A													= cell(1,5);
         A(1:length(idx_F_u))       = num2cell(maxGrad_F(idx_F_u))';
         F_maxGrad_k                = A;
         F_maxGrad									= vertcat(F_maxGrad,F_maxGrad_k);
         F_maxGrad_mean							= mean(maxGrad_F(idx_F_u));
         F_mean											= vertcat(F_mean, F_maxGrad_mean);
         F_meanRedInsideNorm        = vertcat(F_meanRedInsideNorm, num2cell(mean((redInsideNorm_F(idx_F_u)))));
         F_meanMaxGradNorm          = vertcat(F_meanMaxGradNorm, num2cell(mean((maxGradNorm_F(idx_F_u)))));       
         condition3_F								= vertcat(condition3_F,cellstr(strcat(char(cond_F_u(k)))));
         condition2_F								= vertcat(condition2_F,{plate(i).plateStr});
         condition4_F								= vertcat(condition4_F,'FSK');
         condition1_F								= vertcat(condition1_F,cellstr(strcat(char(cond_F_u(k)),'_FSK_',{plate(i).plateStr})));
     end
		 
     for k = 1 : length(cond_DMSO_u)
         idx_DMSO_u									= find(strcmp(cond_DMSO, cond_DMSO_u(k)));
         A													= cell(1,5);
         A(1:length(idx_DMSO_u))    = num2cell(maxGrad_DMSO(idx_DMSO_u))';
         DMSO_maxGrad_k					    = A;
         DMSO_maxGrad								= vertcat(DMSO_maxGrad,DMSO_maxGrad_k);
         DMSO_maxGrad_mean		      = mean(maxGrad_DMSO(idx_DMSO_u));
         DMSO_mean									= vertcat(DMSO_mean, DMSO_maxGrad_mean);
         DMSO_meanRedInsideNorm     = vertcat(DMSO_meanRedInsideNorm, num2cell(mean((redInsideNorm_DMSO(idx_DMSO_u)))));
         DMSO_meanMaxGradNorm       = vertcat(DMSO_meanMaxGradNorm, num2cell(mean((maxGradNorm_DMSO(idx_DMSO_u)))));       
         condition3_DMSO 			    	= vertcat(condition3_DMSO,cellstr(strcat(char(cond_DMSO_u(k)))));
         condition2_DMSO						= vertcat(condition2_DMSO,{plate(i).plateStr});
         condition4_DMSO						= vertcat(condition4_DMSO,'DMSO');
         condition1_DMSO						= vertcat(condition1_DMSO,cellstr(strcat(char(cond_DMSO_u(k)),'_DMSO_',{plate(i).plateStr})));
     end
end

titles      = {'condition+plateStr','plateStr','condition','FSK_DMSO','mean redInsideNorm','mean maxGradNorm',...
               'mean maxGrad', 'maxGrad1',  'maxGrad2', 'maxGrad3', 'maxGrad4', 'maxGrad5'};
F						= horzcat(condition1_F,condition2_F,condition3_F,condition4_F,...
							(F_meanRedInsideNorm),(F_meanMaxGradNorm),num2cell(F_mean),F_maxGrad);
DMSO				= horzcat(condition1_DMSO,condition2_DMSO,condition3_DMSO,condition4_DMSO,...
              (DMSO_meanRedInsideNorm),(DMSO_meanMaxGradNorm),num2cell(DMSO_mean),DMSO_maxGrad);
F_DMSO      = vertcat(titles,F,DMSO);

fullFileName    = strcat('QuenchMaxRate_',dateStr,'.csv');    

if ispc == true
	xlswrite        (fullfile(saveLocationPath,fullFileName),F_DMSO);
elseif isunix == true
	writetable      (cell2table(F_DMSO),fullfile(saveLocationPath,fullFileName))
end               

end