function [w,jd,z]=ts(cdf,var,sta,z);
% TS Reads a scalar variable at a particular station from TSEPIC.CDF files.
% Returns data from all sigma layers, or intepolates to specified depths.
% 
% USAGE:
%   1.  [u,jd,z]=ts(cdf,var,sta);  to return a matrix containing time,depth
%                                 information for variable "var" at station 
%                                 sta for all sigma levels. 
% 
%   2.  [u,jd]=ts(cdf,var,sta,depths);  
%                                 to return a matrix containing time,depth
%                                 information for variable "var" at station 
%                                 sta for depths specified in vector "depths". 
%
%       Example: [t,jd]=ts('tsepic.cdf','temp',2,[-2 -10 -24]); 
%              Returns a matrix containing temperature at Station 2 at 
%              2, 10 and 24 m below surface.  jd is the julian day vector.
%
[t]=mcvgt(cdf,'time');
version=mcagt(cdf,'global','TSCDF_VERSION');
nt=length(t);
%
[stations]=mcvgt(cdf,'stations');
nsta=length(stations);
%
[sigma]=mcvgt(cdf,'sigma');
nsigma=length(sigma);
sigma(nsigma+1)=-1;
%  salt,temp exists at center of two sigma surfaces, so average z level
sigma=0.5*(sigma(1:nsigma)+sigma(2:nsigma+1));
if(sta>nsta),
  disp('invalid station');
  return
end
%
corner=[0 0 0 sta-1];
edges=[nt, nsigma, 1, 1];
u=mcvgt(cdf,var,corner,edges);
w=u;
[m,n]=size(w);
% if w is 2d, we need to fliplr, since data is stored with
%  depth increasing upward in tsepic.cdf
%  (in tsepic.cdf, index 0 = sea bed!)
if(m~=1),
  if(~isstr(version)),
     w=fliplr(w);
  end
end
depth=mcvgt(cdf,'depth');
depth=depth(sta)*sigma;
if(nargin>3),
  m=length(z);
  if(min(z)<min(depth)), disp('requested level below data!'),return,end
  if(max(z)>max(depth)), disp('requested level above data!'),return,end
  for k=1:m,
    lev2=max(find(depth>z(k)));
    lev1=lev2+1;
    frac=(z(k)-depth(lev1))/(depth(lev2)-depth(lev1));
    wmod(:,k)=w(:,lev1)+frac*(w(:,lev2)-w(:,lev1));
  end
  w=wmod;
else
  z=depth;
end
%
base_date=zeros(1,6);
base_date(1:3)=mcagt(cdf,'global','base_date');
jd0=julian(base_date);
jd=jd0+t/(3600*24);
