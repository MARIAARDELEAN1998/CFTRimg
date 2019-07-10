function [ output_fit ] = curveFittingPlate( input, Qtrace )

		global			data_x data_y dt; % set global variables
		dt					= .0002;       % set time interval (s) 
		data_x			= [0 3:2:39]';
		
		output_fit	=  {'label','plateStr','condition','FSK/DMSO','redInside','redInsideNorm', 'y_0', 'y_3', 'y_5', 'y_7', 'y_9', 'y_11', 'y_13', 'y_15', 'y_17', 'y_19', 'y_21', 'y_23', 'y_25', 'y_27', 'y_29', 'y_31', 'y_33', 'y_35', 'y_37', 'y_39', ...
			              'error ratio (free/fixed)', 'G_free', 'G_free_norm', 'Vm_free', 'G_trans_free', 'TAU_trans_free', 'Error_free', ...
								   'pred_y_free_0', 'pred_y_free_3', 'pred_y_free_5', 'pred_y_free_7', 'pred_y_free_9', 'pred_y_free_11', 'pred_y_free_13', ...
									 'pred_y_free_15', 'pred_y_free_17', 'pred_y_free_19', 'pred_y_free_21', 'pred_y_free_23', 'pred_y_free_25', 'pred_y_free_27', ...
									 'pred_y_free_29', 'pred_y_free_31', 'pred_y_free_33', 'pred_y_free_35', 'pred_y_free_37', 'pred_y_free_39', ...
									 'G_fixed', 'G_fixed_norm', 'Vm_fixed', 'G_trans_fixed', 'TAU_trans_fixed', 'Error_fixed', ...
									 'pred_y_fixed_0', 'pred_y_fixed_3', 'pred_y_fixed_5', 'pred_y_fixed_7', 'pred_y_fixed_9', 'pred_y_fixed_11', 'pred_y_fixed_13', ...
									 'pred_y_fixed_15', 'pred_y_fixed_17', 'pred_y_fixed_19', 'pred_y_fixed_21', 'pred_y_fixed_23', 'pred_y_fixed_25', 'pred_y_fixed_27', ...
									 'pred_y_fixed_29', 'pred_y_fixed_31', 'pred_y_fixed_33', 'pred_y_fixed_35', 'pred_y_fixed_37', 'pred_y_fixed_39'};
				
		for i = 1 : size(Qtrace,1);
		redInside				= cell2mat(Qtrace(i,5));
		redInsideNorm		= cell2mat(Qtrace(i,6));
		data						= cell2mat(Qtrace(i,7:size(Qtrace,2)))';
		data_y					= vertcat(data(input(1).timeline(2)-1), data(input(1).timeline(2)+2:input(1).timeline(3)));			% define y values for fitting
				
		% FREE
		x_init    = [-90,5,14.8,5]';						% [Vm, G, G_trans, TAU_trans ]  (initial parameters)
		lb				= [-90,0,2,1]';							  % Lower bound
		ub				= [-30,300,20,15]';				  	% Upper bound
		A					= [-5 1 0 0];									% ?
		b					= 450;												% ?
		Aeq				= [];													% ?
		beq				= [];													% ?
		y				  = fmincon(@fit_error_con_PV,x_init,A,b,Aeq,beq,lb,ub); % FITTING (including lb and ub)

		Vm_free						= y(1);
		G_free						= y(2);
		G_trans_free			= y(3); 
		TAU_trans_free		= y(4);
		Error_free				= fit_error_con_PV(y);
		pred							= fit_transient_con_PV(Vm_free,G_free,G_trans_free,TAU_trans_free,dt); 
				for k = 1:length(data_x)											% for each timepoint in data
						x							= pred(:,1) == data_x(k);		% select matching timepoint in model
						y_mod					= sum(pred.*x);						  % get y for matching timepoint in model
						model_y(k,1)	= y_mod(2);
				end
		y_pred_free				= model_y;	

		% FIXED
		lb				= [-90,0,14.8,5];             % update lb and ub so G_trans and TAU_trans are fixed
		ub				= [-30,300,14.8,5];     
		y					= fmincon(@fit_error_con_PV,x_init,A,b,Aeq,beq,lb,ub); 

		Vm_fixed					= y(1);
		G_fixed						= y(2);
		G_trans_fixed			= y(3); 
		TAU_trans_fixed		= y(4);
		Error_fixed				= fit_error_con_PV(y);

		pred	= fit_transient_con_PV(Vm_fixed,G_fixed, G_trans_fixed,TAU_trans_fixed,dt); 
			for k = 1:length(data_x)											% for each timepoint in data
					x							= pred(:,1) == data_x(k);		% select matching timepoint in model
					y_mod					= sum(pred.*x);						  % get y for matching timepoint in model
					model_y(k,1)	= y_mod(2);
			end
		y_pred_fixed				= model_y;	
		
		output_fit_i				= horzcat(Qtrace(i,1),Qtrace(i,2),Qtrace(i,3),Qtrace(i,4),...
													num2cell(redInside),num2cell(redInsideNorm),num2cell(data_y'),Error_free/Error_fixed, ...
													G_free,G_free/redInsideNorm, Vm_free,G_trans_free,TAU_trans_free,Error_free, num2cell(y_pred_free'),...
												  G_fixed,G_fixed/redInsideNorm,Vm_fixed,G_trans_fixed,TAU_trans_fixed,Error_fixed, num2cell(y_pred_fixed'));
		output_fit					= vertcat(output_fit,output_fit_i);

		end
end

