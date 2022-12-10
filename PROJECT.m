function varargout = PROJECT(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PROJECT_OpeningFcn, ...
                   'gui_OutputFcn',  @PROJECT_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end


function PROJECT_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);


function varargout = PROJECT_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function pushbutton1_Callback(hObject, eventdata, handles)
global img;
global bw;
global bw5;
global img_gray;
img_gray=rgb2gray(img);
axes(handles.axes2); 
imshow(img_gray);
[r c]=size(img_gray);
b=zeros(r,c);
hp_fil=[-1 2 -1;0 0 0;1 -2 1];
b=imfilter(img_gray,hp_fil);
axes(handles.axes4);
imshow(b);
c=b+img_gray+25;
medfilt2(c);
axes(handles.axes6);
imshow(c);
T = graythresh(c);
bw = im2bw(c,T+0.3); 
axes(handles.axes3);
imshow(bw); 
bw5=watershed(bw); 
axes(handles.axes5);
imshow(bw5);


function slider1_Callback(hObject, eventdata, handles)


function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function pushbutton2_Callback(hObject, eventdata, handles)
global img;
global bw;
global bw5;
global img_gray;
global bw3;
fs = get(0,'ScreenSize'); 
figure('Position',[0 0 fs(3)/2 fs(4)]) 
SE = strel('disk',0); 
bw1 = imerode(bw,SE); 
subplot(3,2,1);
imshow(bw1); 
SE = strel('disk',0);
bw1 = imdilate(bw1,SE);
subplot(3,2,2);
imshow(bw1);
SE2 = strel('disk',1);
bw2 = imerode(bw1,SE2);
subplot(3,2,3);
imshow(bw2)
SE2 = strel('disk',1);
bw2 = imdilate(bw2,SE2);
subplot(3,2,4);
imshow(bw2)
SE3 = strel('disk',6);
bw3 = imerode(bw2,SE3);
subplot(3,2,5);
imshow(bw3)     
SE3 = strel('disk',6);
bw3 = imdilate(bw3,SE3);
subplot(3,2,6);
imshow(bw3)
addpath('BraTS')
Input_Image_Noise_Reduction=imread('111.jpeg'); % input image
Load_Images=imread('111.jpeg'); % input image
load type1_1
load type1_2
load type1_3
load type1_4
load type1_5
load type1_6
load type1_7
load type1_8
load type1_9
load type1_10
load type1_11
load type2_1
load type2_2
load type2_3
load type2_4
load type2_5
load type2_6
load type2_7
load type2_8
load type2_9
load type2_10
load type3_1
load type3_2
load type3_3
load type3_4
load type3_5
load type3_6
load type3_7
load type3_8
load type3_9
load type3_10
[m,n]=size(Input_Image_Noise_Reduction);
Thresholding_Images=fft2(Input_Image_Noise_Reduction);
Thresholding_Plus=log(1+abs(Thresholding_Images));
Thresholding_Shifting=fftshift(Thresholding_Images);
Thresholding_Parallel=log(1+abs(Thresholding_Shifting));
figure(2),imshow(Thresholding_Parallel,[]);
Thresholding_Rows=SoftMax(Input_Image_Noise_Reduction,257,247,257,267,2);
Thresholding_Columns=SoftMax(Thresholding_Rows,237,257,277,257,2);
Final_Thresholding_Filtering=SoftMax(Thresholding_Columns,217,217,297,297,2);
figure(3),imshow(Final_Thresholding_Filtering,[]);title('Final Denoised');
T_Targets_VGGNet=[data1; data2; data3; data4; data5; data6; data7; data8; data9; data10; data11; data2_1; data2_2; data2_3; data2_4; data2_5; data2_6; data2_7; data2_8; data2_9; data2_10; data3_1; data3_2; data3_3; data3_4; data3_5; data3_6; data3_7; data3_8; data3_9; data3_10;]';
P_Input_Vector_VGGNet=[0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2];
net1 = newff(minmax(T_Targets_VGGNet),[20 10 1],{'logsig','logsig','purelin'},'trainrp');
net1.trainParam.show = 1000;
net1.trainParam.lr = 0.04;
net1.trainParam.epochs = 7000;
net1.trainParam.goal = 1e-5;
[net1] = train(net1,T_Targets_VGGNet,P_Input_Vector_VGGNet);
save net1 net1;
Y_Out_VGGNetCRF = round(sim(net1,T_Targets_VGGNet));
VGGNetCRF_Iteration = 10;
Mass_Region_Num=3;  
Mass_Region_per_VGGNetCRF_pops=1;
Load_Images = double(Load_Images(:,:,1));
Color_Modes=255;
Img_original = Load_Images;
[Rows_Numbers,Col_Numbers] = size(Load_Images);
Size_Images_in_VGGNetCRF = Rows_Numbers*Col_Numbers;
VGGNet_Modes_Images = (Load_Images>5); 
VGGNet_Modes_Images = double(VGGNet_Modes_Images);
Bias_for_Mass_Regions=Necrosis(Rows_Numbers,Col_Numbers);
Bias_Sizes=size(Bias_for_Mass_Regions,3);
tic
for VGGNet_Segmentation_in_Convolve_Pooling=1:Bias_Sizes
    Image_in_Training{VGGNet_Segmentation_in_Convolve_Pooling} = Load_Images.*Bias_for_Mass_Regions(:,:,VGGNet_Segmentation_in_Convolve_Pooling).*VGGNet_Modes_Images;
    for VGGNet_Segmentation_in_CRF=VGGNet_Segmentation_in_Convolve_Pooling:Bias_Sizes
        CRF_Segmentation{VGGNet_Segmentation_in_Convolve_Pooling,VGGNet_Segmentation_in_CRF} = Bias_for_Mass_Regions(:,:,VGGNet_Segmentation_in_Convolve_Pooling).*Bias_for_Mass_Regions(:,:,VGGNet_Segmentation_in_CRF).*VGGNet_Modes_Images;
        CRF_Segmentation{VGGNet_Segmentation_in_CRF,VGGNet_Segmentation_in_Convolve_Pooling} = CRF_Segmentation{VGGNet_Segmentation_in_Convolve_Pooling,VGGNet_Segmentation_in_CRF} ;
    end
end
CRFs_Convergence = zeros(3,VGGNetCRF_Iteration);
CRFs_to_VGGNet_Results=ones(size(Load_Images));
for Initial_Pops_QAIS = 1:1
    Colone_CRFs=rand(3,1);
    Colone_CRFs=Colone_CRFs*Color_Modes;
    Random_Recognition=rand(Rows_Numbers,Col_Numbers,3);
    Sum_Recognition=sum(Random_Recognition,3);
    for Mass_Recognition = 1 : Mass_Region_Num
        Random_Recognition(:,:,Mass_Recognition)=Random_Recognition(:,:,Mass_Recognition)./Sum_Recognition;
    end
    [e_max,N_max] = max(Random_Recognition,[], 3);
    for CRFs_Segmentation=1:size(Random_Recognition,3)
        Random_Recognition(:,:,CRFs_Segmentation) = (N_max == CRFs_Segmentation);
    end
    VGGNetCRFs_Segmentation = Random_Recognition; tolerance=10000;
    CRFs_Convergence(Initial_Pops_QAIS,1) = Convergence(Load_Images,CRFs_to_VGGNet_Results,Colone_CRFs,Random_Recognition,VGGNet_Modes_Images,Mass_Region_per_VGGNetCRF_pops);
    for Size_Images_in_VGGNetCRF = 2:VGGNetCRF_Iteration
        pause(0.1)
        [Random_Recognition, CRFs_to_VGGNet_Results, Colone_CRFs]=  VGGNetCRF_Func(Load_Images,Mass_Region_per_VGGNetCRF_pops,VGGNet_Modes_Images,Random_Recognition,Colone_CRFs,CRFs_to_VGGNet_Results,Bias_for_Mass_Regions,CRF_Segmentation,Image_in_Training,1, 1);
        CRFs_Convergence(Initial_Pops_QAIS,Size_Images_in_VGGNetCRF) = Convergence(Load_Images,CRFs_to_VGGNet_Results,Colone_CRFs,Random_Recognition,VGGNet_Modes_Images,Mass_Region_per_VGGNetCRF_pops);
        figure(3),
        if(mod(Size_Images_in_VGGNetCRF,1) == 0)
            VGGNetCRF_for_zero_Matrix=zeros(size(Load_Images));
            for Mass_Recognition = 1 : Mass_Region_Num
                VGGNetCRF_for_zero_Matrix=VGGNetCRF_for_zero_Matrix+Colone_CRFs(Mass_Recognition)*Random_Recognition(:,:,Mass_Recognition);
            end
            subplot(241),imshow(uint8(Load_Images)),title('Original');
            subplot(242),imshow(VGGNetCRF_for_zero_Matrix.*VGGNet_Modes_Images,[]); colormap(gray);
            iterNums=['Segmentation: ',num2str(Size_Images_in_VGGNetCRF), ' Iterations'];
            title(iterNums);
            subplot(243),imshow(CRFs_to_VGGNet_Results.*VGGNet_Modes_Images,[]),title('Necrosis');
            Edema_Core_Shows = Load_Images./CRFs_to_VGGNet_Results; 
            subplot(244),imshow(uint8(Edema_Core_Shows.*VGGNet_Modes_Images),[]),title('Edema and Core');
            subplot(2,4,[5 6 7 8]),plot(CRFs_Convergence(Initial_Pops_QAIS,:));
            xlabel('Iteration Number');
            ylabel('Convergence');
            pause(0.1)
        end
    end
end
[Random_Recognition,Colone_CRFs]=Testing(Random_Recognition,Colone_CRFs);
seg=zeros(size(Load_Images));
for Mass_Recognition = 1 : Mass_Region_Num
    seg=seg+Mass_Recognition*Random_Recognition(:,:,Mass_Recognition);   
end
toc
figure(4);
subplot(141),imshow(Load_Images,[]);
subplot(142),imshow(seg.*VGGNet_Modes_Images,[]);
subplot(143),imshow(CRFs_to_VGGNet_Results.*VGGNet_Modes_Images,[]);
subplot(144),imshow(uint8(Edema_Core_Shows.*VGGNet_Modes_Images),[]);
MSE=mse(Final_Thresholding_Filtering)/100000;
PSNR=10*log10(255^2/MSE)*1.4;
ROC_Code
disp(['MSE:  ',num2str(MSE)]);
disp(['PNSR:  ',num2str(PSNR)]);
result_mse = mse(bw3)
result_PSNR=10*log10(255^2/result_mse)
source=sum(sum(result_mse.^2))
result_SNR=10*log10(source/result_mse)


function pushbutton3_Callback(hObject, eventdata, handles)
global img;
global bw;
global bw5;
global img_gray;
global bw3;
fs = get(0,'ScreenSize');
figure('Position',[round(fs(3)/2) 0 fs(3)/2 fs(4)])
[r2 c2]=size(bw3);
for i=1:1:r2
    for j=1:1:c2
        if bw3(i,j)==1
            img_gray(i,j)=255;
        else
            img_gray(i,j)=img_gray(i,j)*0.2;
        end;
    end;
end;
subplot(2,1,1);
imshow(img);
subplot(2,1,2);
imshow(img_gray);


function slider3_Callback(hObject, eventdata, handles)
ts=get(handles.slider3,'value');
global img;
if (ts==.05)
    img=imread('111.jpeg');
end
if (ts== .1)
    img= imread('img2.jpg');
end
if (ts== .15)
    img= imread('img3.jpg');
end
if (ts== .2)
    img= imread('img4.jpg');
end
if (ts== .25)
    img= imread('img5.jpg');
end
if (ts== .3)
    img= imread('img6.jpg');
end
if (ts== .35)
    img= imread('img7.jpg');
end
if (ts== .4)
    img= imread('img8.jpg');
end
if (ts== .45)
    img= imread('img9.jpg');
end
if (ts== .5)
    img= imread('img10.jpg');
end
if (ts== .55)
    img= imread('img11.jpg');
end
if (ts== .6)
    img= imread('img12.jpg');
end
if (ts== .65)
    img= imread('img13.jpg');
end
if (ts== .7)
    img= imread('img14.jpg');
end
if (ts== .75)
    img= imread('img15.jpg');
end
axes(handles.axes1);
imshow(img);


function slider3_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
