function output_txt = myupdatefcnAligned(~,event_obj)
    % Customizes text of data tips
    pos = get(event_obj,'Position');
    scat_obj = get(event_obj, 'Target');
    roi_names = get(scat_obj, 'UserData');

    output_txt = {['X: ',num2str(pos(1))],...
           ['Y: ',num2str(pos(2))],...
           ['Roi"s: ', roi_names]};

end