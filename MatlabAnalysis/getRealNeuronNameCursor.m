function txt = getRealNeuronNameCursor(empt,event_obj)
    % Customizes text of data tips
    neurons_names_real = get(get(event_obj,'Target'),'UserData');
    
    
    pos = get(event_obj,'Position');
    
    if (isempty(neurons_names_real))
        txt = {['X: ',num2str(pos(1))],...
              ['Y: ',num2str(pos(2))]};
    else
        name = neurons_names_real(pos(2) == neurons_names_real(:, 2), 1);
        txt = {['Neuron_name: ',num2str(name)],...
              ['X: ',num2str(pos(1))],...
              ['Y: ',num2str(pos(2))]};
    end
end