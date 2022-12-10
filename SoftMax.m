function Parallels=SoftMax(Parallel_Noises,Wave_Mode,Swing_Mode,Parallel_Wave_Mode,Parallel_Swing_Mode,Energies)
[Centers,Parallels]=size(Parallel_Noises);
Parallel_Read=fft2(Parallel_Noises);
Parallel_Shift=fftshift(Parallel_Read);
for Beta_Balancing=1:Centers
    for Lambda_Balancing=1:Parallels
        Omega_Points_Rows=((Beta_Balancing-Wave_Mode)^2+(Lambda_Balancing-Swing_Mode)^2)^(1/2);
        Omega_Points_Cols=((Beta_Balancing-Parallel_Wave_Mode)^2+(Lambda_Balancing-Parallel_Swing_Mode)^2)^(1/2);
        Omega_Balancing=Energies;
        I_CRFs(Beta_Balancing,Lambda_Balancing)=1/(1+(Omega_Balancing*Omega_Balancing/(Omega_Points_Rows*Omega_Points_Cols))^2);
    end
end
N_Shift_Nums=Parallel_Shift.*I_CRFs;
Total_Shifting_Noise_Reduction=ifft2(N_Shift_Nums);
Parallels=abs(Total_Shifting_Noise_Reduction);