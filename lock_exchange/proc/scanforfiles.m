
itrs=[];
allfiles=dir(['../out/output/' 's_*.nc']);
if isempty(allfiles)
 allfiles=dir([fname '.*.meta']);
 ioff=0;
else
 ioff=8;
end

for k=1:size(allfiles,1);
 hh=allfiles(k).name;
 itrs = [itrs;{hh}];
%  itrs(k)=str2num( hh );
end
itrs=sort(itrs);