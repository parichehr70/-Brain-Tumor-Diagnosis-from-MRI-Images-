function Find_Necrosis = Necrosis(Necrosis_Height,Necrosis_Width)
for i =1:Necrosis_Height
    Neurons_Pops(i,:) = -1:2/(Necrosis_Width-1):1;
end
for i =1:Necrosis_Width
    Core_temp = -1:2/(Necrosis_Height-1):1;
    Core_y_Out(:,i) = Core_temp';
end
Convolve_Pooling_DSNN = zeros(Necrosis_Height,Necrosis_Width,10);
Convolve_Pooling_DSNN(:,:,1) = 1;
Convolve_Pooling_DSNN(:,:,2) = Neurons_Pops;
Convolve_Pooling_DSNN(:,:,3) = (3.*Neurons_Pops.*Neurons_Pops - 1)./2;
Convolve_Pooling_DSNN(:,:,4) = (5.*Neurons_Pops.*Neurons_Pops.*Neurons_Pops - 3.*Neurons_Pops)./2;
Convolve_Pooling_DSNN(:,:,5) = Core_y_Out;
Convolve_Pooling_DSNN(:,:,6) = Neurons_Pops.*Core_y_Out;
Convolve_Pooling_DSNN(:,:,7) = Core_y_Out.*(3.*Neurons_Pops.*Neurons_Pops -1)./2;
Convolve_Pooling_DSNN(:,:,8) = (3.*Core_y_Out.*Core_y_Out -1)./2;
Convolve_Pooling_DSNN(:,:,9) = (3.*Core_y_Out.*Core_y_Out -1).*Neurons_Pops./2;
Convolve_Pooling_DSNN(:,:,10) = (5.*Core_y_Out.*Core_y_Out.*Core_y_Out -3.*Core_y_Out)./2;
Find_Necrosis = Convolve_Pooling_DSNN;
for softmax_QAIS_Iteration_to_Better_Segmentation=1:10
    QAISDSNN_Segmentations=Convolve_Pooling_DSNN(:,:,softmax_QAIS_Iteration_to_Better_Segmentation).^2;
    Sum_sqrt_QAISDSNN = sqrt(sum(QAISDSNN_Segmentations(:)));
    Find_Necrosis(:,:,softmax_QAIS_Iteration_to_Better_Segmentation)=Convolve_Pooling_DSNN(:,:,softmax_QAIS_Iteration_to_Better_Segmentation)/Sum_sqrt_QAISDSNN;
end