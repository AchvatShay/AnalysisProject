function plotButtonPushed(src,event)
% loc=ginput3d(1);
global t;
t = src.UserData.t;


datacursormode on
dcm_obj = datacursormode(gcf);
% Set update function
set(dcm_obj,'UpdateFcn',@myupdatefcn)
% Wait while the user to click
% title('Click line to display a data tip, then press "Return"')
% pause 
% Export cursor to workspace
info_struct = getCursorInfo(dcm_obj);
% if isfield(info_struct, 'Position')
%   disp('Clicked positioin is')
%   disp(info_struct.Position)
% end
