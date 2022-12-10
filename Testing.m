function [Mass_Outs_Region, Type_Mass_Outs]=Testing(Masses, Sort_Types)
[Type_Mass_Outs IDX]=sort(Sort_Types);
if size(Masses,4) == 3
    for two_D_Images = 1 : length(Sort_Types)
        Mass_Outs_Region(:,:,:,two_D_Images) = Masses(:,:,:,IDX(two_D_Images));
    end
elseif size(Masses,4) ==1
    for two_D_Images = 1 : length(Sort_Types)
        Mass_Outs_Region(:,:,two_D_Images) = Masses(:,:,IDX(two_D_Images));
    end
else
    error('Error in Testing');
end