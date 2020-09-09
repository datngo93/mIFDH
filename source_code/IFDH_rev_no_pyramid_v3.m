%%=========================================================================
% Copyright © 2019, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% - Date       : 2019/04/28
% - Author     : Dat Ngo
% - Affiliation: SoC Design Lab. - Dong-A University
% - Design     : Image Fusion-based DeHazing
%==========================================================================

function [Jf] = IFDH_rev_no_pyramid_v3(img,K,gamma,k1,k2,k3,vweak,vstrong,Wweak,Wstrong)

%% Default parameters
switch nargin
    case 1
        K = 4; % number of artifically under-exposed images
        gamma = 2:K; % gamma parameters
        k1 = 1;
        k2 = 1;
        k3 = 1;
        vweak = 0.002;
        vstrong = 0.01;
        Wweak = 3;
        Wstrong = 1;
    case 2
        gamma = 2:K; % gamma parameters
        k1 = 1;
        k2 = 1;
        k3 = 1;
        vweak = 0.002;
        vstrong = 0.01;
        Wweak = 3;
        Wstrong = 1;
    case 3
        k1 = 1;
        k2 = 1;
        k3 = 1;
        vweak = 0.002;
        vstrong = 0.01;
        Wweak = 3;
        Wstrong = 1;
    case 4
        k2 = 1;
        k3 = 1;
        vweak = 0.002;
        vstrong = 0.01;
        Wweak = 3;
        Wstrong = 1;
    case 5
        k3 = 1;
        vweak = 0.002;
        vstrong = 0.01;
        Wweak = 3;
        Wstrong = 1;
    case 6
        vweak = 0.002;
        vstrong = 0.01;
        Wweak = 3;
        Wstrong = 1;
    case 7
        vstrong = 0.01;
        Wweak = 3;
        Wstrong = 1;
    case 8
        Wweak = 3;
        Wstrong = 1;
    case 9
        Wstrong = 1;
    otherwise
        % all parameters are provided
end

%% Input image checking
if diff(getrangefromclass(img))==255 % uint8
    imgf = double(img)/255;
else % double
    imgf = img;
end

[h,w,c] = size(imgf);

%% Artifically under-exposure
E = cell(K,1); % list of artificially under-exposed images
imgf = UM3(imgf,k1,k2,k3,vweak,vstrong,Wweak,Wstrong);
E{1} = imgf;
for i = 2:K
    E{i} = imgf.^gamma(i-1);
end

%% Calculate weights
W = cell(K,1);
for i = 1:K
    Ei_dcp = minFilt2(min(E{i},[],3));
    W{i} = 1-Ei_dcp;
end
% normalize weights
pz = 1/256; % prevent divide by zero
W = cellfun(@(x)x+pz,W,'UniformOutput',false);
W = cellfun(@(x,y)x./y,W,mat2cell(repmat(sum(cat(3,W{:}),3),[K,1]),repmat(h,[1,K]),w),'UniformOutput',false);

%% Fusion
Jf = zeros(h,w,c);
for i = 1:K
    Jf(:,:,1) = Jf(:,:,1)+E{i}(:,:,1).*W{i};
    Jf(:,:,2) = Jf(:,:,2)+E{i}(:,:,2).*W{i};
    Jf(:,:,3) = Jf(:,:,3)+E{i}(:,:,3).*W{i};
end
Jf(Jf<0) = 0;
Jf(Jf>1) = 1;

end
