function output_txt = myupdatefcn(~,event_obj)
global t;
  % ~            Currently not used (empty)
  % event_obj    Object containing event data structure
  % output_txt   Data cursor text
  pos = get(event_obj, 'Position');
  datx = event_obj.Target.XData;
  daty = event_obj.Target.YData;
  datz = event_obj.Target.ZData;
  ind(1) = findClosestDouble(datx, pos(1));
  ind(2) = findClosestDouble(daty, pos(2));
  ind(3) = findClosestDouble(datz, pos(3));
  output_txt = {['t: ' num2str(t(floor(median(ind))))]};
  title('');
end