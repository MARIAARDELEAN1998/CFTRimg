function [ meanQtrace ] = calculateMeanQtrace( plate )

FSK				= [];
DMSO			= [];
for i = 1 : length(plate) % for each plate
	
cond						= {};
F_DMSO					= {};	
Qtrace					= [];
redInside				= [];		
redInsideNorm		= [];		

		for j = 1 : length(plate(i).well) 
			cond(j)				= {plate(i).well(j).condition};	% make a list with all the conditions (mutants, drug treatments, etc)
			F_DMSO(j)			= {plate(i).well(j).test_control};	% make a list with FSK / DMSO(control)
			Qtrace(j,:)	  = plate(i).well(j).yelInsideOverT;	% list all the Quenching traces
			redInside(j)	= plate(i).well(j).redInside;	% make a list of the mCherry signal inside the cell selection (corrected for backgroun)
			redInsideNorm(j)= plate(i).well(j).redInsideNorm;	% make a list of the normalised mCherry signal inside the cell selection (corrected for backgroun)
		end
		
		idx_F							= strcmp(F_DMSO, 'test');
		if sum(idx_F)>0 % if there are entries in the 'test' condition in the input file
			cond_F						= cond(idx_F);
			Qtrace_F					= Qtrace(idx_F,:);
			redInside_F				= redInside(idx_F);
			redInsideNorm_F		= redInsideNorm(idx_F);
			cond_F_u					= unique(cond_F);													% list of the unique condtions in FSK		 
			F_meanQtrace			= [];
			F_redInside				= [];
			F_redInsideNorm		= [];		 
		
		  for k = 1 : length(cond_F_u)																							% for each unique condition in FSK
				 idx_F_u							= find(strcmp(cond_F, cond_F_u(k)));							% index unique condition k for FSK
				 F_redInside					= vertcat(F_redInside,mean(redInside_F(idx_F_u)));  % add average redInsideNorm for condition k on each plate to a matrix (FSK)
				 F_redInsideNorm			= vertcat(F_redInsideNorm,mean(redInsideNorm_F(idx_F_u)));  
				 
				 if size(Qtrace_F(idx_F_u,:),1) > 1
				  F_meanQtrace				= vertcat(F_meanQtrace, mean(Qtrace_F(idx_F_u,:)));	% add average Qtrace for condition k (FSK) on plate to  matrix
				 else
					F_meanQtrace				= vertcat(F_meanQtrace, Qtrace_F(idx_F_u,:)); 
				 end
			end	 
		else 
		end
		
		idx_DMSO						= strcmp(F_DMSO, 'control');
		if sum(idx_DMSO)>0 % if there are entries in the 'test' condition in the input file
		cond_DMSO						= cond(idx_DMSO);
		Qtrace_DMSO					= Qtrace(idx_DMSO,:);
		redInside_DMSO			= redInside(idx_DMSO);
		redInsideNorm_DMSO	= redInsideNorm(idx_DMSO);
		cond_DMSO_u					= unique(cond_DMSO);													% list of the unique condtions in DMSO		 
		DMSO_meanQtrace			= [];
	  DMSO_redInside			= [];
		DMSO_redInsideNorm	= [];
			 for k = 1 : length(cond_DMSO_u)																								% for each unique condition in DMSO
				 idx_DMSO_u						= find(strcmp(cond_DMSO, cond_DMSO_u(k)));							% index unique condition k for DMSO
				 DMSO_redInside				= vertcat(DMSO_redInside,mean(redInside_DMSO(idx_DMSO_u)));	% add average redInsideNorm for condition k on each plate to a matrix (DMSO)
				 DMSO_redInsideNorm		= vertcat(DMSO_redInsideNorm,mean(redInsideNorm_DMSO(idx_DMSO_u)));
				 if size(Qtrace_DMSO(idx_DMSO_u,:),1) > 1
				 DMSO_meanQtrace			= vertcat(DMSO_meanQtrace, mean(Qtrace_DMSO(idx_DMSO_u,:)));	% add average Qtrace for condition k (DMSO) on plate to  matrix
				 else
				 DMSO_meanQtrace			= vertcat(DMSO_meanQtrace, Qtrace_DMSO(idx_DMSO_u,:));
				 end
			 end
		else
		end
		
		if sum(idx_DMSO)>0 % if there are entries in the 'test' condition in the input file
			DMSO_cond1			= cellstr(strcat(char(cond_DMSO_u),'_DMSO_',{plate(i).plateStr}));		% combine PlateStr (data), condition, and DMSO/FSK condition in one string
			DMSO_cond3			= cellstr(cond_DMSO_u)';
			DMSO_cond2			= repmat({plate(i).plateStr},length(cond_DMSO_u),1);
			DMSO_cond4			= repmat({'DMSO'},length(cond_DMSO_u),1);
			DMSO_i					= horzcat(DMSO_cond1,DMSO_cond2,DMSO_cond3,DMSO_cond4,...
											num2cell(DMSO_redInside),num2cell(DMSO_redInsideNorm),num2cell(DMSO_meanQtrace));		% combine combination / date / FSK/DMSO information with the mean Quench trace on that plate
			DMSO					= vertcat(DMSO,DMSO_i);																											% add a the labels + mean Quench trace to a cell array
		else
		end
		
		if sum(idx_F)>0 % if there are entries in the 'test' condition in the input file
			FSK_cond1			= cellstr(strcat(char(cond_F_u),'_FSK_',{plate(i).plateStr}));
			FSK_cond3			= cellstr(cond_F_u)';
			FSK_cond2			= repmat({plate(i).plateStr},length(cond_F_u),1);
			FSK_cond4			= repmat({'FSK'},length(cond_F_u),1);
 			FSK_i					= horzcat(FSK_cond1,FSK_cond2,FSK_cond3,FSK_cond4,...
											num2cell(F_redInside),num2cell(F_redInsideNorm),num2cell(F_meanQtrace));
			FSK						= vertcat(FSK,FSK_i);
		else 
		end
			
			meanQtrace		= vertcat(FSK,DMSO);
end
 meanQtrace			= vertcat(FSK,DMSO);
end