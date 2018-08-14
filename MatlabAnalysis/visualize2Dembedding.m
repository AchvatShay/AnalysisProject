function visualize2Dembedding(generalProperty, ACC2D, BehaveData, embedding, outputPath, Method)


fid = fopen(fullfile(outputPath, [Method 'accuracy2D.txt']), 'w');
fprintf(fid, 'Accuracy of %s :\t\tmean = %f std = %f\n', Method, ACC2D.mean, ACC2D.std);
fclose(fid);

tryinginds = find(BehaveData.failure | BehaveData.success);
switch generalProperty.PelletPertubation
    case 'None'
        plotSF2D([],  embedding(:,1:2), BehaveData.failure(tryinginds), generalProperty.visualization_labelsFontSize, generalProperty.visualization_legendLocation);
        mysave(gcf, fullfile(outputPath, [ Method '2Dsucfail']));
        

    case 'Ommisions'
        if ~isfield(BehaveData, 'nopellet')
            warning('ommisions were not marked in BDA file!');
            plotSF2D([],  embedding(:,1:2), BehaveData.failure(tryinginds), generalProperty.visualization_labelsFontSize, generalProperty.visualization_legendLocation);
        else
            labsOmissions(BehaveData.nopellet==1) = 2;
            figure;a=gca;
            plot(a, embedding(BehaveData.nopellet(tryinginds)==1,1)  ,embedding(BehaveData.nopellet(tryinginds)==1,2),'ko', 'MarkerFaceColor','k');
            hold all;
            plotSF2D(a, embedding(BehaveData.nopellet(tryinginds)==0,1:2), BehaveData.failure(BehaveData.nopellet(tryinginds)==0), labelsFontSz);
            plotSF2D(a, embedding, BehaveData.failure(tryinginds), generalProperty.visualization_labelsFontSize);
            l=legend('Omission','Failure','Success', 'Location',generalProperty.visualization_legendLocation);
            set(l, 'FontSize',generalProperty.visualization_labelsFontSize);
        end
        mysave(gcf, fullfile(outputPath, [ Method '2Dsucfail']));
        
    case 'Taste'
        plotSF2D([],  embedding(:,1:2), BehaveData.failure(tryinginds), generalProperty.visualization_labelsFontSize, generalProperty.visualization_legendLocation);
        mysave(gcf, fullfile(outputPath, [ Method '2Dsucfail']));
        f=plot2Dtasting(BehaveData, tryinginds, embedding(:,1:2), generalProperty.visualization_labelsFontSize);
        if ~isempty(f)
            mysave(f(1), fullfile(outputPath, [ Method '2Dtaste']));
            mysave(f(2), fullfile(outputPath, [ Method '2Dtastesucfail']));
            
        end
        
end
