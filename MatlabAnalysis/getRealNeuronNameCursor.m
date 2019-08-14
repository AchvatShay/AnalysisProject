function txt = getRealNeuronNameCursor(empt,event_obj)
    % Customizes text of data tips
    neurons_names_real = get(get(get(get(event_obj,'Target'),'Parent'), 'Parent'), 'UserData');
    pos = get(event_obj,'Position');
    txt = {['Neuron_name: ',num2str(neurons_names_real(pos(2)))],...
              ['time: ',num2str(pos(1))],...
              ['order: ',num2str(pos(2))]};
end