%%=========================================================================
% Copyright © 2018, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% • Date       : 2018/08/06
% • Author     : Dat Ngo
% • Affiliation: SoC Design Lab. - Dong-A University
% • Design     : 2-D Minimum Filter
%                sv2: filtering window size.
%                slidingOp: sliding option, "sliding" or "distinct". 
%                "sliding" option uses symmetric boundary padding. 
%                "distinct" option pads image with Inf.
%==========================================================================

function [minImg] = minFilt2(inImg,sv2,slidingOp)

% Default parameters
switch nargin
    case 3
        % All arguments were provided, do nothing
    case 2
        slidingOp = 'sliding';
    case 1
        sv2 = 3;
        slidingOp = 'sliding';
    otherwise
        warning('Please check input arguments!');
        return;
end

[~,~,c] = size(inImg);
padsize = floor((sv2-1)/2);

% Resolve border effect in 'distinct' mode
switch slidingOp
    case 'sliding'
        paddedImg = sympad(inImg,sv2);
    case 'distinct'
        paddedImg = padarray(inImg,[padsize,padsize],Inf);
        [ph,pw,pc] = size(paddedImg);
        deltaH = ceil(ph/sv2)*sv2-ph;
        deltaW = ceil(pw/sv2)*sv2-pw;
        for index = 1:pc
            paddedImg = [[paddedImg,Inf(ph,deltaW)];Inf(deltaH,pw+deltaW)];
        end
    otherwise
        warning('Wrong input value!');
        return;
end

switch c
    case 1 % grayscale image
        temp = colfilt(paddedImg,[sv2,sv2],slidingOp,@customMin);
        switch slidingOp
            case 'sliding'
                minImg = temp((sv2+1)/2:end-(sv2-1)/2,(sv2+1)/2:end-(sv2-1)/2);
            case 'distinct'
                temp = temp(1:ph,1:pw);
                minImg = temp((sv2+1)/2:end-(sv2-1)/2,(sv2+1)/2:end-(sv2-1)/2);
            otherwise
                warning('Wrong input value!');
                return;
        end
    case 3 % RGB image
        temp = zeros(size(paddedImg));
        temp(:,:,1) = colfilt(paddedImg(:,:,1),[sv2,sv2],slidingOp,@customMin);
        temp(:,:,2) = colfilt(paddedImg(:,:,2),[sv2,sv2],slidingOp,@customMin);
        temp(:,:,3) = colfilt(paddedImg(:,:,3),[sv2,sv2],slidingOp,@customMin);
        switch slidingOp
            case 'sliding'
                minImg = temp((sv2+1)/2:end-(sv2-1)/2,(sv2+1)/2:end-(sv2-1)/2,:);
            case 'distinct'
                temp = temp(1:ph,1:pw,:);
                minImg = temp((sv2+1)/2:end-(sv2-1)/2,(sv2+1)/2:end-(sv2-1)/2,:);
            otherwise
                warning('Wrong input value!');
                return;
        end
    otherwise
        warning('Invalid input image!');
        return;
end

    % Customized min function
    function [out] = customMin(in)
        switch slidingOp
            case 'sliding'
                out = min(in);
            case 'distinct'
                out = repmat(min(in),[size(in,1),1]);
            otherwise
                warning('Invalid input value!');
                return;
        end
    end

end
