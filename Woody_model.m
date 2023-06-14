clear

%Insert after choosing initial parameters using initial guess
% Initial guess of parameters
s1 = 20; %sigma of Guassian 1, width of distribution
m1 = 310.11; %mu of Guassian 1, middle of distribution
a1 = 30.2562; %scale of Guassian 1, height of distribution
s2 = 5.57045;
m2 = 340.04;
a2 = 30.8889;
s3 = 30.7094;
m3 = 400.901;
a3 = 13.0202;
s4 = 5.4715;
m4 = 470.773;
a4 = 10.81441;

% Import data from excel into MATLAB
% Insert your own file path & file name here
[Temp] = readmatrix('Lignin_TGA_data.xlsx','Range','A:A'); %(C)
[Wt] = readmatrix('Lignin_TGA_data.xlsx','Range','B:B'); %(mg)
[Wt_per] = readmatrix('Lignin_TGA_data.xlsx','Range','C:C'); %(%)
[Deriv] = readmatrix('Lignin_TGA_data.xlsx','Range','D:D'); %(%/C)
abs_D = abs(Deriv);

% Minimizing the error to find optimal solution
v_0 = [s1; m1; a1; s2; m2; a1; s3; m3; a3; s4; m4; a4];
ub = [inf; inf; inf; inf; inf; inf; inf; inf; inf; inf; inf; inf];
lb = [-inf; -inf; -inf; -inf; -inf; -inf; -inf; -inf; -inf; -inf; -inf; -inf];
f = @(v)Gaussians_Woody(v,Temp,abs_D);
[p,RMSE] = fmincon(f, v_0, [], [],[],[],lb,ub);

% Area Under Curves
IG1 = p(3) / (p(1) * sqrt(2*pi)) * sqrt(pi / (1 /(2 * p(1)^2)));
IG2 = p(6) / (p(4) * sqrt(2*pi)) * sqrt(pi / (1 /(2 * p(4)^2)));
IG3 = p(9) / (p(7) * sqrt(2*pi)) * sqrt(pi / (1 /(2 * p(7)^2)));
IG4 = p(12) / (p(10) * sqrt(2*pi)) * sqrt(pi / (1 /(2 * p(10)^2)));
Total_area = IG1 + IG2 + IG3 + IG4;

% Calculated Lignin Weight Percent
Lignin = IG3 + IG4;
HC = IG1 + IG2;

fprintf('The lignin in the sample is %.1f wt. percent . \n',Lignin)
fprintf('The holocellulose in the sample is %.1f wt. percent. \n',HC)

% Gaussians to plot
G1 = p(3) / (p(1) * sqrt(2*pi)) * exp(-0.5 * ((Temp - p(2)) / p(1)).^2);
G2 = p(6) / (p(4) * sqrt(2*pi)) * exp(-0.5 * ((Temp - p(5)) / p(4)).^2);
G3 = p(9) / (p(7) * sqrt(2*pi)) * exp(-0.5 * ((Temp - p(8)) / p(7)).^2);
G4 = p(12) / (p(10) * sqrt(2*pi)) * exp(-0.5 * ((Temp - p(11)) / p(10)).^2);
fit = G1 + G2 + G3 + G4;
error= (fit - abs_D);
sq_err= (fit - abs_D).^2;

% Plot curves
plot(Temp, abs_D, 'Color', '#31a354', 'LineWidth', 2, 'LineStyle', '-')
hold on
plot(Temp, G1, 'Color', '#d73027', 'LineWidth', 2, 'LineStyle', '-')
plot(Temp, G2, 'Color', '#fd8d3c', 'LineWidth', 2, 'LineStyle', '-')
plot(Temp, G3, 'Color', '#43a2ca', 'LineWidth', 2, 'LineStyle', '-')
plot(Temp, G4, 'Color', '#54278f', 'LineWidth', 2, 'LineStyle', '-')
plot(Temp, fit, 'LineStyle', '--', 'Color', 'k', 'LineWidth', 2)
xlabel('Temperature (°C)')
ylabel('Derivative (wt. %/°C)')


legend('boxoff')
axis([200,600,0,2.5])
set(gcf,'color','white')
legend('Experimental','Holocellulose 1', 'Holocellulose 2','Lignin 1',...
    'Lignin 2','Fit')
