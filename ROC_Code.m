function y_ROC=ROC_Code(varargin)
args=cell(varargin);
nu=numel(args);
if isempty(nu)
    error('Warning: almost the data matrix is required')
elseif nu>4
    error('Warning: Max four input data are required')
end
default.values = {[165 1;140 1;154 1;139 1;134 1;154 1;120 1;133 1;150 1;...
146 1;150 1;114 1;128 1;150 1;112 1;128 1;122 1;129 1;145 1;117 1;140 1;...
149 1;116 1;147 1;150 1;149 1;129 1;157 1;144 1;123 1;107 1;129 1;152 1;...
164 1;134 1;145 1;148 1;151 1;160 1;138 1;159 1;169 1;137 1;151 1;141 1;...
145 1;135 1;135 1;153 1;125 1;159 1;148 1;142 1;130 1;111 1;140 1;136 1;...
142 1;139 1;137 1;187 1;154 1;175 1;149 1;148 1;157 1;159 1;143 1;124 1;...
141 1;114 1;143 1;110 1;135 1;145 1;132 1;125 1;149 1;146 1;138 1;151 1;...
147 1;154 1;147 1;158 1;156 1;156 1;128 1;151 1;138 1;193 1;131 1;127 1;...
129 1;120 1;159 1;147 1;159 1;156 1;143 1;149 1;160 1;126 1;136 1;150 1;...
136 1;150 1;150 1;145 1;140 1;134 1;140 1;138 1;144 1;140 1;140 1;159 0;...
136 0;149 0;156 0;191 0;169 0;194 0;182 0;163 0;152 0;145 0;176 0;122 0;...
141 0;172 0;162 0;165 0;184 0;239 0;178 0;178 0;155 0;185 0;154 0;164 0;...
140 0;207 0;214 0;165 0;183 0;218 0;142 0;171 0;168 0;181 0;162 0;166 0;...
150 0;205 0;163 0;160 0;150 0;],0,0.05,1};
default.values(1:nu) = args;
[x threshold alpha Logical_Data] = deal(default.values{:});
if isvector(x)
    error('Warning: X must be a matrix')
end
if ~all(isfinite(x(:))) || ~all(isnumeric(x(:)))
    error('Warning: all X values must be numeric and finite')
end
x(:,2)=logical(x(:,2));
if all(x(:,2)==0)
    error('Warning: there are only healthy subjects!')
end
if all(x(:,2)==1)
    error('Warning: there are only unhealthy subjects!')
end
if nu>=2
    if isempty(threshold)
        threshold=0;
    else
        if ~isscalar(threshold) || ~isnumeric(threshold) || ~isfinite(threshold)
            error('Warning: it is required a numeric, finite and scalar THRESHOLD value.');
        end
        if threshold ~= 0 && threshold <3
            error('Warning: Threshold must be 0 if you want to use all unique points or >=2.')
        end
    end
    if nu>=3
        if isempty(alpha)
            alpha=0.05;
        else
            if ~isscalar(alpha) || ~isnumeric(alpha) || ~isfinite(alpha)
                error('Warning: it is required a numeric, finite and scalar ALPHA value.');
            end
            if alpha <= 0 || alpha >= 1 
                error('Warning: ALPHA must be comprised between 0 and 1.')
            end
        end
    end
    if nu==4
        Logical_Data=logical(Logical_Data);
    end
end
clear args default nu
Training_Repeat_Matrix=repmat('-',1,100);
Num_False_Tracking=length(x(x(:,2)==1));
Num_True_Tracking=length(x(x(:,2)==0));
Sort_Image_Tracking=sortrows(x,1);
if threshold==0
    Find_Unique_Value_Sort_Image_Tracking=unique(Sort_Image_Tracking(:,1));
else
    GM=linspace(0,1,threshold+1); GM(1)=[];
    Find_Unique_Value_Sort_Image_Tracking=quantile(unique(Sort_Image_Tracking(:,1)),GM)';
end
Find_Unique_Value_Sort_Image_Tracking(end+1)=Find_Unique_Value_Sort_Image_Tracking(end)+1;
Unique_Value_Count=length(Find_Unique_Value_Sort_Image_Tracking);
Array_Allocation_in_Image_Cells=zeros(Unique_Value_Count,2); Likelihood=Array_Allocation_in_Image_Cells; Efficieny=zeros(Unique_Value_Count,1);
Mean_Value_CNN_False=mean(x(x(:,2)==1),1);
Mean_Value_CNN_True=mean(x(x(:,2)==0),1);
for GM=1:Unique_Value_Count
    if Mean_Value_CNN_True<Mean_Value_CNN_False
        TP=length(x(x(:,2)==1 & x(:,1)>Find_Unique_Value_Sort_Image_Tracking(GM)));
        FP=length(x(x(:,2)==0 & x(:,1)>Find_Unique_Value_Sort_Image_Tracking(GM)));
        FN=length(x(x(:,2)==1 & x(:,1)<=Find_Unique_Value_Sort_Image_Tracking(GM)));
        TN=length(x(x(:,2)==0 & x(:,1)<=Find_Unique_Value_Sort_Image_Tracking(GM)));
    else
        TP=length(x(x(:,2)==1 & x(:,1)<Find_Unique_Value_Sort_Image_Tracking(GM)));
        FP=length(x(x(:,2)==0 & x(:,1)<Find_Unique_Value_Sort_Image_Tracking(GM)));
        FN=length(x(x(:,2)==1 & x(:,1)>=Find_Unique_Value_Sort_Image_Tracking(GM)));
        TN=length(x(x(:,2)==0 & x(:,1)>=Find_Unique_Value_Sort_Image_Tracking(GM)));
    end
    M=[TP FP;FN TN];
    Array_Allocation_in_Image_Cells(GM,:)=diag(M)'./sum(M); 
    Likelihood(GM,:)=[Array_Allocation_in_Image_Cells(GM,1)/(1-Array_Allocation_in_Image_Cells(GM,2)) (1-Array_Allocation_in_Image_Cells(GM,1))/Array_Allocation_in_Image_Cells(GM,2)];
    Efficieny(GM)=trace(M)/sum(M(:));
end
Likelihood(isnan(Likelihood))=Inf;

x_ROC=1-Array_Allocation_in_Image_Cells(:,2); yroc=Array_Allocation_in_Image_Cells(:,1);
if Mean_Value_CNN_True>Mean_Value_CNN_False
    x_ROC=flipud(x_ROC); yroc=flipud(yroc);
end

st=[1 mean(x_ROC) 1]; L=[0 0 0]; U=[Inf 1 Inf];
fo_ = fitoptions('method','NonlinearLeastSquares','Lower',L,'Upper',U,'Startpoint',st);
ft_ = fittype('1-1/((1+(x/C)^B)^E)',...
     'dependent',{'y'},'independent',{'x'},...
     'coefficients',{'B', 'C', 'E'});
cfit = fit(x_ROC,yroc,ft_,fo_);
xfit=linspace(0,1,500);
yfit=feval(cfit,xfit);
Area=trapz(xfit,yfit); 
Area2=Area^2; Q1=Area/(2-Area); Q2=2*Area2/(1+Area);
V=(Area*(1-Area)+(Num_False_Tracking-1)*(Q1-Area2)+(Num_True_Tracking-1)*(Q2-Area2))/(Num_False_Tracking*Num_True_Tracking);
Call_Team_Matching=realsqrt(V);
ci=Area+[-1 1].*(realsqrt(2)*erfcinv(alpha)*Call_Team_Matching);
if ci(1)<0; ci(1)=0; end
if ci(2)>1; ci(2)=1; end
m=zeros(1,4);
Standardized_Area=(Area-0.5)/Call_Team_Matching;
T_Value=1-0.5*erfc(-Standardized_Area/realsqrt(2));
if Logical_Data
    if Area==1
        str='Perfect test';
    elseif Area>=0.90 && Area<1
        str='Excellent test';
    elseif Area>=0.80 && Area<0.90
        str='Good test';
    elseif Area>=0.70 && Area<0.80
        str='Fair test';
    elseif Area>=0.60 && Area<0.70
        str='Poor test';
    elseif Area>=0.50 && Area<0.60
        str='Fail test';
    else
        str='Failed test - less than chance';
    end
    disp('ROC analysis')
    disp(' ')
    disp(Training_Repeat_Matrix)
    str2=['AUC\t\t\t     Precision\t\t\t\t' num2str((1-alpha)*100) '%%    Recall\t\t\tComment\n'];
    fprintf(str2)
    disp(Training_Repeat_Matrix)
    fprintf('%0.5f\t\t\t%0.5f\t\t\t%0.5f\t\t%0.5f\t\t\t%s\n',Area,Call_Team_Matching,ci,str)
    disp(Training_Repeat_Matrix)
    fprintf('Standardized AUC\t\t1-tail p-value\n')
    if T_Value<1e-4
        fprintf('%0.4f\t\t\t\t%0.4e',Standardized_Area,T_Value)
    else
        fprintf('%0.4f\t\t\t\t%0.4f',Standardized_Area,T_Value)
    end
    if T_Value<=alpha
        fprintf('\t\tThe area is statistically greater than 0.5\n')
    else
        fprintf('\t\tThe area is not statistically greater than 0.5\n')
    end
    disp(' ')
    H=figure;
    hold on
    plot([0 1],[0 1],'k');
    plot(xfit,yfit,'marker','none','linestyle','-','color','r','linewidth',2);
    H1=plot(x_ROC,yroc,'bo');
    set(H1,'markersize',6,'markeredgecolor','b','markerfacecolor','b')
    hold off
    xlabel('False positive rate (1-Specificity)')
    ylabel('True positive rate (Sensitivity)')
    title(sprintf('ROC curve (AUC=%0.4f)',Area))
    axis square
end
