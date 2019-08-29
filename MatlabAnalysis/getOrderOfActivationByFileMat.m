function getOrderOfActivationByFileMat(outputPath, generalProperty, imagingData, BehaveData)        
    masterResults = load(generalProperty.orderActivationFileLocation);
    getOrderOfActivationByMaster(outputPath, generalProperty, imagingData, BehaveData, masterResults);
end