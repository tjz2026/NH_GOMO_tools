clear, close('all')
% Shows a vertical section of a 3-D field along j-index
% Original y-sigma coordinates are interpolated into y-z
file='../out/seamount.0004.nc'; % path and name of the netCDF file
jsec=31; % j-index along which the section is taken

%% Read data
nc=mexnc('open',file,'nowrite');
h=mexnc('varget',nc,'h',[jsec 0],[-1 -1],1);
mexnc('close',nc);
[T,x,z]=jsection(file,'t',1,jsec);
[S,x,z]=jsection(file,'s',1,jsec);
[V,x,z]=jsection(file,'v',1,jsec);
[U,x,z]=jsection(file,'u',1,jsec);

%% Figure
[nx,nz]=size(x);
x=x(1:nx-1,1:nz-1)/1000;
z=z(1:nx-1,1:nz-1);

figure
contourf(x,z,T);colorbar
xlabel('X-direction (km)')
ylabel('Depth (m)')

figure
contourf(x,z,S);colorbar
xlabel('X-direction (km)')
ylabel('Depth (m)')

figure
contourf(x,z,U);colorbar
xlabel('X-direction (km)')
ylabel('Depth (m)')

figure
contourf(x,z,V);colorbar
xlabel('X-direction (km)')
ylabel('Depth (m)')
