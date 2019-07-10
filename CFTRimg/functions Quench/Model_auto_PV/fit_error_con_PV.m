
function [error] = fit_error_con_PV(F)

	global data_x data_y dt; % use global variables defined in fit_main
	Vm              = F(1);
	G               = F(2);
	G_trans         = F(3);
	TAU_trans       = F(4);
	pred            = fit_transient_con_PV(Vm,G,G_trans,TAU_trans,dt); 
	
	for i=1:length(data_x)
			x           = pred(:,1)==data_x(i);
			y           = sum(pred.*x);
			model_y(i,1)= y(2);
	end
	error           = sum((model_y-data_y).^2);
end
