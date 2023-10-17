function RMSE= Gaussians_Herbaceous(v, Temp, abs_D)

% Initialize arrays
l = length(Temp);
G1 = zeros(l,1);
G2 = zeros(l,1);
G3 = zeros(l,1);
G4 = zeros(l,1);
fit = zeros(l,1);
sq_err = zeros(l,1);

    for i = 1:length(Temp)
        G1(i) = v(3) / (v(1) * sqrt(2*pi)) * exp(-0.5 * ((Temp(i) - v(2)) / v(1))^2);
        G2(i) = v(6) / (v(4) * sqrt(2*pi)) * exp(-0.5 * ((Temp(i) - v(5)) / v(4))^2);
        G3(i) = v(9) / (v(7) * sqrt(2*pi)) * exp(-0.5 * ((Temp(i) - v(8)) / v(7))^2);
        G4(i) = v(12) / (v(10) * sqrt(2*pi)) * exp(-0.5 * ((Temp(i) - v(11)) / v(10))^2);
        fit(i) = G1(i) + G2(i) + G3(i) + G4(i);
        sq_err(i) = (fit(i) - abs_D(i))^2;
    end
RMSE = sqrt(mean(sq_err));
end




