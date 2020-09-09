%%=========================================================================
% Copyright © 2019, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% - Date       : 2019/05/21
% - Author     : Dat Ngo
% - Affiliation: SoC Design Lab. - Dong-A University
% - Design     : Unsharp Masking 3
%==========================================================================

function [oimgf] = UM3(imgf,k1,k2,k3,vweak,vstrong,Wweak,Wstrong)

% Default parameters
switch nargin
    case 1
        k1 = 1;
        k2 = 1;
        k3 = 1;
        vweak = 0.002;
        vstrong = 0.01;
        Wweak = 3;
        Wstrong = 1;
    case 2
        k2 = 1;
        k3 = 1;
        vweak = 0.002;
        vstrong = 0.01;
        Wweak = 3;
        Wstrong = 1;
    case 3
        k3 = 1;
        vweak = 0.002;
        vstrong = 0.01;
        Wweak = 3;
        Wstrong = 1;
    case 4
        vweak = 0.002;
        vstrong = 0.01;
        Wweak = 3;
        Wstrong = 1;
    case 5
        vstrong = 0.01;
        Wweak = 3;
        Wstrong = 1;
    case 6
        Wweak = 3;
        Wstrong = 1;
    case 7
        Wstrong = 1;
    otherwise
        % all parameters are provided
end

[h,w,c] = size(imgf);
ycbcr = zeros(h,w,c);
ycbcr(:,:,1) = 0.183*imgf(:,:,1)+0.614*imgf(:,:,2)+0.062*imgf(:,:,3)+16/255;
ycbcr(:,:,2) = -0.101*imgf(:,:,1)-0.338*imgf(:,:,2)+0.439*imgf(:,:,3)+128/255;
ycbcr(:,:,3) = 0.439*imgf(:,:,1)-0.399*imgf(:,:,2)-0.040*imgf(:,:,3)+128/255;
imgfGray = ycbcr(:,:,1);

% high-freq. information
lx = k1*[-1,2,-1]/4;
ly = k2*[-1;2;-1]/4;
gzx = imfilter(imgfGray,lx,'symmetric');
gzy = imfilter(imgfGray,ly,'symmetric');

% Method 3: use variance to generate weight
r = 1; % winsize = 3 (fixed)
N = boxfilter(ones(h,w),r);
meanI = boxfilter(imgfGray,r)./N;
meanII = boxfilter(imgfGray.*imgfGray,r)./N;
varI = k3*(meanII-meanI.*meanI);

while (vweak>=vstrong) % vweak must be less than vstrong
    vweak = vweak/2;
end
while (Wweak<=Wstrong) % Wweak must be larger than Wstrong
    Wweak = Wweak/2;
end
W2 = ones(h,w)*Wweak;
W2((varI>=vweak)&(varI<=vstrong)) = ((Wweak-Wstrong)/(vweak-vstrong)).*varI((varI>=vweak)&(varI<=vstrong))+((Wstrong*vweak-Wweak*vstrong)/(vweak-vstrong));
W2(varI>vstrong) = Wstrong;
ye = imgfGray+W2.*(gzx+gzy);
ye(ye<0) = 0; ye(ye>1) = 1; % saturation arithmetic
oimgf = zeros(h,w,c);
oimgf(:,:,1) = 1.164*(ye-16/255)+1.793*(ycbcr(:,:,3)-128/255);
oimgf(:,:,2) = 1.164*(ye-16/255)-0.534*(ycbcr(:,:,3)-128/255)-0.213*(ycbcr(:,:,2)-128/255);
oimgf(:,:,3) = 1.164*(ye-16/255)+2.115*(ycbcr(:,:,2)-128/255);

end
