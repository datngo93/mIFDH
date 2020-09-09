%%=========================================================================
% Copyright © 2019, SoC Design Lab., Dong-A University. All Right Reserved.
%==========================================================================
% - Date       : 2019/04/28
% - Author     : Dat Ngo
% - Affiliation: SoC Design Lab. - Dong-A University
% - Design     : Symmetric padding for 2-D array
%==========================================================================

function inpad = sympad2(in,sv)

[y,x] = size(in);
ypad = y+(sv-1);
xpad = x+(sv-1);
inpad = zeros(ypad,xpad);
inpad((sv+1)/2:end-(sv-1)/2,(sv+1)/2:end-(sv-1)/2) = in;

upmask = false(ypad,xpad);
upmask((sv+1)/2+1:sv,:) = true;
uppad = reshape(inpad(upmask),[(sv-1)/2,xpad]);
uppad = uppad(end:-1:1,:);

lowmask = false(ypad,xpad);
lowmask(end-(sv-1):end-(sv-1)/2-1,:) = true;
lowpad = reshape(inpad(lowmask),[(sv-1)/2,xpad]);
lowpad = lowpad(end:-1:1,:);

inpad(1:(sv+1)/2-1,:) = uppad;
inpad(end-(sv-1)/2+1:end,:) = lowpad;

leftmask = false(ypad,xpad);
leftmask(:,(sv+1)/2+1:sv) = true;
leftpad = reshape(inpad(leftmask),[ypad,(sv-1)/2]);
leftpad = leftpad(:,end:-1:1);

rightmask = false(ypad,xpad);
rightmask(:,end-(sv-1):end-(sv-1)/2-1) = true;
rightpad = reshape(inpad(rightmask),[ypad,(sv-1)/2]);
rightpad = rightpad(:,end:-1:1);

inpad(:,1:(sv+1)/2-1) = leftpad;
inpad(:,end-(sv-1)/2+1:end) = rightpad;

end
