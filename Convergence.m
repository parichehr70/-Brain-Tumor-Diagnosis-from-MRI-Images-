function Get_Convergence = Convergence(Image_Input,Biases,Colonal,Mass_Region_Num,VGGNet_Main,CRF_Main)
Number_Mass_Region = size(Mass_Region_Num,3);
Get_Convergence = 0;
for Convergence_Pareto = 1 : Number_Mass_Region
    Colonal_Segmenting=Colonal(Convergence_Pareto)*ones(size(Image_Input));
    Get_Convergence = Get_Convergence + sum(sum((Image_Input.*VGGNet_Main - Biases.*Colonal_Segmenting.*VGGNet_Main).^2.*Mass_Region_Num(:,:,Convergence_Pareto).^CRF_Main));
end