function [output] = fit_transient_con_PV(Vm,G,G_trans,TAU_trans,dt)

time            = (0:dt:42)';
		
% Preallocation
Cl_in					= zeros(length(time),1);
I_in					=	zeros(length(time),1);
K_in					= zeros(length(time),1);
Vm						= vertcat(Vm,zeros(length(time)-1,1));
E_K						= zeros(length(time),1);
E_Cl					= zeros(length(time),1);
E_I						= zeros(length(time),1);
I_Cl					= zeros(length(time),1);
I_I						= zeros(length(time),1);
I_K						= zeros(length(time),1);
P_Ir					= zeros(length(time),1);
P_Clr					= zeros(length(time),1);
P_r						= zeros(length(time),1);
P_r_exp				= zeros(length(time),1);
rate_I_entry	= zeros(length(time),1);


%% STARTING SYSTEM %%
% Binding affinity of I- and Cl- to YFP (mM), Galietta et al 2001
    Ki              = 1.9;
    Kcl             = 85;
% Concentration inside and outside the cell (mM)
    K_in(1)         = 100;
    K_out(1)        = 4.7;
    I_out(1)        = 100;
    I_in(1)         = 1.0000e-4;
    Cl_out(1)       = 117.1;
    Cl_in(1)        = 152/(10^(Vm(1)/-62));        % [Cl-]in at eq with 152 mM [Cl-]out, i.e. [Cl-]out in I- free solution
% Proportion of YFP anion-bound (Ir, Clr) and unbound (r)
    P_Ir(1)         = I_in(1)/(Ki*(1+Cl_in(1)/Kcl)+I_in(1));
    P_Clr(1)        = Cl_in(1)/(Kcl*(1+I_in(1)/Ki)+Cl_in(1));
    P_r(1)          = 1-P_Ir(1)-P_Clr(1);
    P_r_exp(1)      = (1-P_Ir(1)-P_Clr(1))/P_r(1);        %normalised to t0
% conductance (nS)
    P_I_Cl_ratio  	= 0.83;                      % Gi=0.83*Gcl Lindsdell,2001
    G_CFTR_I				= P_I_Cl_ratio*G;
    G_K_leak				= 2.5;
%		G_trans_Cl			= 0;
% equilibrium potentials (mV)
    E_K(1)          =  62*(log10(K_out(1)/K_in(1)));
    E_Cl(1)         = -62*(log10(Cl_out(1)/Cl_in(1)));
    E_I(1)          = -62*(log10(I_out(1)/I_in(1)));
% charachteristics HEK cells (L, cm^2, uF)
    HEK_VOL         = 4/3*pi*((8.9*10^-6)^3)*10^3; % 8.9 um is average HEK radius from our images - see Cato cell size summary file
    HEK_SURF        = 1.5*4*pi*((8.9*10^-6)^2)*10^4;%Gentet et al, 2000: surface 50% higher because of fillipodia
    C_HEK           = 1*HEK_SURF;
% other parameters
    F               = 96500;    % Faraday constant (C/mol)
    T               = 310;      % Temperature (Kelvin)
    R               = 8.31;     % J*(deg*mol)^-1
    z_K             = 1; 
    z_I             = -1;
    z_Cl            = -1;
    G_trans_Cl(1)   = G_trans*exp(-time(1)/TAU_trans);
    G_trans_I(1)    = G_trans*P_I_Cl_ratio*exp(-time(1)/TAU_trans);
% current carried by Cl-, K+ and I-(pA)
    I_Cl(1)         =  (G/140)*Vm(1)*(Cl_in(1)-Cl_out(1)*exp(-z_Cl*F*0.001*Vm(1)/(R*T)))...
                   /(1-exp(-z_Cl*F*0.001*Vm(1)/(R*T)))+(G_trans_Cl/140)*Vm(1)*...
                   (Cl_in(1)-Cl_out(1)*exp(-z_Cl*F*0.001*Vm(1)/(R*T)))...
                   /(1-exp(-z_Cl*F*0.001*Vm(1)/(R*T)));
    I_I(1)         =  (G_CFTR_I/140)*Vm(1)*(I_in(1)-I_out(1)*exp(-z_I*F*0.001*Vm(1)/(R*T)))...
                   /(1-exp(-z_I*F*0.001*Vm(1)/(R*T)))+(G_trans_I(1)/140)*Vm(1)*...
                   (I_in(1)-I_out(1)*exp(-z_I*F*0.001*Vm(1)/(R*T)))...
                   /(1-exp(-z_I*F*0.001*Vm(1)/(R*T)));
    I_K(1)         =  (G_K_leak/140)*Vm(1)*(K_in(1)-K_out(1)*exp(-z_K*F*0.001*Vm(1)/(R*T)))...
                   /(1-exp(-z_K*F*0.001*Vm(1)/(R*T))); % Gk = 2.5 ns Rapedius06
                 
%% TIMECOURSE %%

for t = 2:length(time)
% New concentrations inside the cell (mM)
    Cl_in(t,1)      = Cl_in(t-1)+((time(t)-time(t-1))...
                    *I_Cl(t-1)/F/HEK_VOL)*10^-9;
    I_in(t,1)       = I_in(t-1)+((time(t)-time(t-1))...
                    *I_I(t-1)/F/HEK_VOL)*10^-9;
    K_in(t,1)       = K_in(t-1)-((time(t)-time(t-1))...
                    *I_K(t-1)/F/HEK_VOL)*10^-9;
% New Vm (mV)
    Vm(t,1)         = Vm(t-1) +((time(t)-time(t-1))...
                    *-(I_Cl(t-1)+I_I(t-1)+I_K(t-1))/C_HEK)*10^-3; %changed to +
% New equilibrium potentials (mV)
    E_K(t,1)        =  62*(log10(K_out/K_in(t)));
    E_Cl(t,1)       = -62*(log10(Cl_out/Cl_in(t)));
    E_I(t,1)        = -62*(log10(I_out/I_in(t)));
% New transient conductances (nS)    
    G_trans_Cl      = G_trans*exp(-time(t)/TAU_trans);
    G_trans_I       = G_trans*P_I_Cl_ratio*exp(-time(t)/TAU_trans);
% New current carried by Cl-, K+ and I-(pA)
    I_Cl(t,1)      = (G/140)*Vm(t)*(Cl_in(t)-Cl_out...
                    *exp(-z_Cl*F*0.001*Vm(t)/(R*T)))...
                   /(1-exp(-z_Cl*F*0.001*Vm(t)/(R*T)))+(G_trans_Cl/140)...
                   *Vm(t)*(Cl_in(t)-Cl_out*exp(-z_Cl*F*0.001*Vm(t)/(R*T)))...
                   /(1-exp(-z_Cl*F*0.001*Vm(t)/(R*T)));
    I_I(t,1)       = (G_CFTR_I/140)*Vm(t)*(I_in(t)-I_out...
                    *exp(-z_I*F*0.001*Vm(t)/(R*T)))...
                   /(1-exp(-z_I*F*0.001*Vm(t)/(R*T)))+(G_trans_I/140)*Vm(t)*...
                   (I_in(t)-I_out*exp(-z_I*F*0.001*Vm(t)/(R*T)))...
                   /(1-exp(-z_I*F*0.001*Vm(t)/(R*T)));
    I_K(t,1)       =  (G_K_leak/140)*Vm(t)*(K_in(t)-K_out...
                    *exp(-z_K*F*0.001*Vm(t)/(R*T)))...
                   /(1-exp(-z_K*F*0.001*Vm(t)/(R*T))); % Gk = 2.5 ns Rapedius06
% Proportion of YFP
    P_Ir(t,1)       = I_in(t)/(Ki*(1+Cl_in(t)/Kcl)+I_in(t));
    P_Clr(t,1)      = Cl_in(t)/(Kcl*(1+I_in(t)/Ki)+Cl_in(t));
    P_r(t,1)        = 1-P_Ir(t)-P_Clr(t);
    P_r_exp(t,1)    = (1-P_Ir(t)-P_Clr(t))/P_r(1);   %normalized to t0
% Rate of iodide entry (d[I-]/dt)
    rate_I_entry(t,1)           = (I_in(t)-I_in(t-1))/(time(t)-time(t-1));
end

output = [time P_r_exp];
