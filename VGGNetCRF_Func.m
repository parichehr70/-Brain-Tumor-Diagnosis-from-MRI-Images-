function [Necrosis_Area, Core_Area, Edema_Area]=  VGGNetCRF_Func(Input_Data,VGGNetCRF_Modes,Convolve,Pooling,CRFs,Softmax,Region_Mass_Numbers,Local_Segmentation,Global_Segmentation, CRFs_Iteration, VGGNet_Iteration)
for n = 1:CRFs_Iteration
    CRFs = CRF_Funcs(Input_Data, Convolve, Softmax, Pooling);
    for k=1:VGGNet_Iteration
        N_class=size(Pooling,3);
        Evaluates=zeros(size(Pooling));
        for Evaluations=1:N_class
            Distance_Hausdorff(:,:,Evaluations) = (Input_Data-CRFs(Evaluations)*Softmax).^2;
        end
        Pooling = Pooling_Settings(Distance_Hausdorff,VGGNetCRF_Modes);        
    end
end
Core_Area = Core_Recognition(Input_Data, VGGNetCRF_Modes, CRFs, Pooling, Region_Mass_Numbers,Local_Segmentation,Global_Segmentation);
Necrosis_Area=Pooling;
Edema_Area=CRFs;

function Biases_Core =Core_Recognition(Input_Images, Quantum_Part, Convolve_Core, Pooling_Core, CRF_Core,Softmax_Core,Global_Segmentation_Core)
Core_Zeros = zeros(size(Input_Images));
temp_Cores=Core_Zeros;
N_Class_Cores=size(Pooling_Core,3);
for Find_Cores=1:N_Class_Cores
    Core_Zeros=Core_Zeros+Convolve_Core(Find_Cores)^2*Pooling_Core(:,:,Find_Cores).^Quantum_Part;
    temp_Cores=temp_Cores+Convolve_Core(Find_Cores)*Pooling_Core(:,:,Find_Cores).^Quantum_Part;
end
N_Biases_Cores=size(CRF_Core,3);
Vector_Cores=zeros(N_Biases_Cores,1);
for ii=1:N_Biases_Cores
    Mask_Global_Segmentation_Core=Global_Segmentation_Core{ii}.*temp_Cores;
    Vector_Cores(ii)=sum(Mask_Global_Segmentation_Core(:));
    for jj=ii:N_Biases_Cores
        Mask_Local_Segmentation_Core = Softmax_Core{ii,jj}.*Core_Zeros;
        Inner_Cores(ii,jj)=sum(Mask_Local_Segmentation_Core(:));
        Inner_Cores(jj,ii)=Inner_Cores(ii,jj);
    end
end
clear PC1;
clear PC2;
clear B;
clear ImgG_PC;
Weights_Updates_Core=inv(Inner_Cores)*Vector_Cores;
Biases_Core=zeros(size(Input_Images));
for Find_Cores=1:N_Biases_Cores
    Biases_Core=Biases_Core+Weights_Updates_Core(Find_Cores)*CRF_Core(:,:,Find_Cores);
end

function CRF_new  =CRF_Funcs(Input_Image_for_CRF, Weight_CRF,Bias_CRF, CRF_Segmenting)
N_Class_with_CRF=size(CRF_Segmenting,3);
for nn=1:N_Class_with_CRF
    CRF_Bias_Results=Bias_CRF.*Input_Image_for_CRF.*CRF_Segmenting(:,:,nn);
    CRFs_Distances=(Bias_CRF.^2) .*CRF_Segmenting(:,:,nn);
    CRF_Necrosis = sum(CRF_Bias_Results(:).*Weight_CRF(:));
    CRF_Edema_Core = sum(CRFs_Distances(:).*Weight_CRF(:));
    CRF_new(nn)=CRF_Necrosis/(CRF_Edema_Core+(CRF_Edema_Core==0));
end
clear N;
clear D;

function Pooling_Layers = Pooling_Settings(Random_Pooling, Max_Pooling)
N_class=size(Random_Pooling,3);
if Max_Pooling >1
    Pooling_epsilon=0.000000000001;
    Random_Pooling=Random_Pooling+Pooling_epsilon; 
    Pools = 1/(Max_Pooling-1);
    Function_Initialize = 1./(Random_Pooling.^Pools);
    Pooling_Sum = sum(Function_Initialize,3);
    for kk=1:N_class
        Pooling_Layers(:,:,kk) = Function_Initialize(:,:,kk)./Pooling_Sum;
    end
elseif Max_Pooling==1
    [e_min,N_min] = min(Random_Pooling,[], 3);  
    for kk=1:N_class
        Pooling_Layers(:,:,kk) = (N_min == kk);
    end
else
    error('Error in Training');
end
