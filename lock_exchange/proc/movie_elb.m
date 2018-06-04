clear, close('all')
% Movie of transport and elevation
id='seamount'; % run id
nsub=2; % number to subsample for quiver
maxvel=.5; % maximum value for trasnport


%% Output files
filelist=dir(['../out/',id,'.0*']);

% Model grid
file=['../out/',filelist(1).name];
nc=netcdf.open(file,'NC_NOWRITE');
z=netcdf.getVar(nc,netcdf.inqVarID(nc,'z'));
h=netcdf.getVar(nc,netcdf.inqVarID(nc,'h'));
dx=netcdf.getVar(nc,netcdf.inqVarID(nc,'dx'));
dy=netcdf.getVar(nc,netcdf.inqVarID(nc,'dy'));
fsm=netcdf.getVar(nc,netcdf.inqVarID(nc,'fsm'));
th=netcdf.getVar(nc,netcdf.inqVarID(nc,'rot'));
netcdf.close(nc);
x=cumsum(dx)/1e3;
y=cumsum(dy,2)/1e3;

%% Read data
for m=2:length(filelist)
  file=['../out/',filelist(m).name];
  disp(file)
  nc=netcdf.open(file,'NC_NOWRITE');
  time=netcdf.getVar(nc,netcdf.inqVarID(nc,'time'));
  ele=netcdf.getVar(nc,netcdf.inqVarID(nc,'elb'));
  ele(fsm==0)=nan;
  u=netcdf.getVar(nc,netcdf.inqVarID(nc,'uab'));
  v=netcdf.getVar(nc,netcdf.inqVarID(nc,'vab'));
  u(fsm==0)=nan;
  v(fsm==0)=nan;
  tran=(u+1i*v);
  netcdf.close(nc);

  % figure
  clf
  pslice(x,y,double(ele));
  hold on
  xlabel('X-direction (km)')
  ylabel('Y-direction (km)')
  set(gca,'dataaspectratio',[1 1 1])
  tran=tran.*(cos(th)+1i*sin(th));
  fac=max(max(abs(tran)));
  if(fac==0), fac=eps; end
  psliceuv(x,y,tran/fac,nsub,10*fac/maxvel,'k');
  contour(x,y,h,[1000:1000:3000],'k');
  title(['day ',num2str(time)]);
  pause(1)
end
