% Use this file first to visually determine a reasonable initial guess for
% all 15 parameters, then paste findings into Woody_model.m and run

% Import data from excel into MATLAB
[Temp] = readmatrix('Lignin_TGA_data.xlsx','Range','A:A'); %(C)
[Wt] = readmatrix('Lignin_TGA_data.xlsx','Range','B:B'); %(mg)
[Wt_per] = readmatrix('Lignin_TGA_data.xlsx','Range','C:C'); %(%)
[Deriv] = readmatrix('Lignin_TGA_data.xlsx','Range','D:D'); %(%/C)
abs_D = abs(Deriv);

% Initial guess of parameters
s0 = 10.4715;
m0 = 290.773;
a0 = 10.81441;
s1 = 20; %sigma of Guassian 1, width of distribution
m1 = 320.11; %mu of Guassian 1, middle of distribution
a1 = 20.2562; %scale of Guassian 1, height of distribution
s2 = 5.57045;
m2 = 350.04;
a2 = 15.8889;
s3 = 30.7094;
m3 = 420.901;
a3 = 13.0202;
s4 = 20.4715;
m4 = 470.773;
a4 = 10.81441;

% Initialize arrays
l = length(Temp);
G0 = zeros(1,1);
G1 = zeros(l,1);
G2 = zeros(l,1);
G3 = zeros(l,1);
G4 = zeros(l,1);
fit = zeros(l,1);
sq_err = zeros(l,1);

v = [s0; m0; a0; s1; m1; a1; s2; m2; a1; s3; m3; a3; s4; m4; a4];
for i = 1:length(Temp)
    G0(i) = a0 / (s0 * sqrt(2*pi)) * exp(-0.5 * ((Temp(i) - m0) / s0)^2);
    G1(i) = a1 / (s1 * sqrt(2*pi)) * exp(-0.5 * ((Temp(i) - m1) / s1)^2);
    G2(i) = a2 / (s2 * sqrt(2*pi)) * exp(-0.5 * ((Temp(i) - m2) / s2)^2);
    G3(i) = a3 / (s3 * sqrt(2*pi)) * exp(-0.5 * ((Temp(i) - m3) / s3)^2);
    G4(i) = a4 / (s4 * sqrt(2*pi)) * exp(-0.5 * ((Temp(i) - m4) / s4)^2);
    fit(i) = G0(i) + G1(i) + G2(i) + G3(i) + G4(i);
    sq_err(i) = (fit(i) - abs_D(i))^2;
end
RMSE = sqrt(mean(sq_err));

% Plot curves
plot(Temp, abs_D, 'Color', 'm', 'LineWidth', 2)
hold on
plot(Temp, G0, 'Color', 'c', 'LineWidth', 2)
plot(Temp, G1, 'Color', 'r', 'LineWidth', 2)
plot(Temp, G2, 'Color', 'b', 'LineWidth', 2)
plot(Temp, G3, 'Color', 'g', 'LineWidth', 2)
plot(Temp, G4, 'Color', 'y', 'LineWidth', 2)
plot(Temp, fit, 'LineStyle', '--', 'Color', 'k', 'LineWidth', 2)
xlabel('Temperature (°C)')
ylabel('Derivative (wt. %/°C)')

legend('Experimental','Hemicellulose','Cellulose 1', 'Cellulose 2','Lignin 1','Lignin 2','Fit')
legend('boxoff')
axis([150,600,0,2.5])
title('Initial Parameter Guess')
set(gcf,'color','white')

