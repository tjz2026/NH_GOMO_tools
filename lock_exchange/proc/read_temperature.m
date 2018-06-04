clear, close('all')
% Movie of a horizontal section
id='s'; % run in
field1='t'; %  name of the first netCDF variable
                %  (elb, rho, t, s, w, wr, clock, counter)
jsec = 3; % jsection index

%% Output files
filelist=dir(['../out/output/',id,'_*']);

% Model grid
file=[filelist(1).name];
% filename=[]
% for m=1:length(filelist)
%     filename = [filename,{filelist(m).name}];
% end
% filename = sort(filename)

[~, reindex] = sort( str2double( regexp( {filelist.name}, '\d+', 'match', 'once' )));
filelist = filelist(reindex) ;


%% Read data
for m=2:length(filelist)
    time = m*0.1;
    file=['../out/output/',filelist(m).name];
%       file = strcat('../out/output/',char(filename(m)))
%     disp(file)
%     nc=mexnc('open',file,'nowrite');
%     time=mexnc('varget',nc,'time',0,-1);
    % filed 1
%     switch field1
%         case {'elb'}
%             s=mexnc('varget',nc,field1,[0,0,0],[-1,-1,-1],1);
%             s(fsm==0)=nan;
%         case {'rho','t','s','w','wr','u','v'}
%             [s,xx,zz]=jsection(file,field1,1,jsec);
%     end
    % field2
    %switch field2
    %    case {'tran'}
    %        u=mexnc('varget',nc,'uab',[0 0 0],[-1 -1 -1],1);
    %        v=mexnc('varget',nc,'vab',[0 0 0],[-1 -1 -1],1);
    %        u(fsm==0)=nan;
    %        v(fsm==0)=nan;
    %        w=u+1i*v;
    %    case {'vel'}
    %        [w,xx,yy]=horiz_sectionvel(file,1,depth);
    %        clear('xx','yy')
    %end
%     mexnc('close',nc);

    % exclude boundary values
    %s([1,end],:)=nan;
    %s(:,[1,end])=nan;

    % figure
    s = ncread(file,'salinity');
    [nx,ny,nz]=size(s);
%     x=xx(1:nx-1,1:nz-1)/1000;
%     z=zz(1:nx-1,1:nz-1);
%     pslice(x,z,s); 
    ss= s(1:nx-1,3,1:nz-1);
    ss = reshape(ss,699,89);
    x =1:nx-1;
    z =1:nz-1;
    [z,x] = meshgrid(z,x);
    pslice(x,z,ss);
    shading interp;
    colormap('jet');
    %figure
    %contourf(x,z,T);colorbar
    %xlabel('X-direction (km)')
    %ylabel('Depth (m)')
%     hold on
%     set(gca,'dataaspectratio',[1 1 1])
%     w=w.*(cos(th)+1i*sin(th));
%     fac=max(max(abs(w)));
%     if(fac==0), fac=eps; end
% %     psliceuv(x,y,w/fac,nsub,10*fac/maxvel,'k');
% %     contour(x,y,h,[100,1000:1000:3000],'k');
    title(num2str(time));
    pause(0.5)
end
