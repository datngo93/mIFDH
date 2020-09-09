%%=========================================================================
% Copyright © 2019, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% - Date       : 2019/04/28
% - Author     : Dat Ngo
% - Affiliation: SoC Design Lab. - Dong-A University
% - Design     : Symmetric padding
%==========================================================================

function inpad = sympad(in,sv)

[~,~,c] = size(in);
switch c
    case 1 % grayscale image
        inpad = sympad2(in,sv);
    case 3 % rgb image
        inpad(:,:,1) = sympad2(in(:,:,1),sv);
        inpad(:,:,2) = sympad2(in(:,:,2),sv);
        inpad(:,:,3) = sympad2(in(:,:,3),sv);
    otherwise
end

end
