function PostAnalysisRunner
addpath('../');

xmlfile = 'XmlFail.xml';

folderAnimal_experiment_BDA = 'E:\Data\Shahar\M27\11_11_18';

outputPath = 'E:\Data\Shahar\J\Den6\PostAnalysisNewBy-Suc-Cat23';
mkdir(outputPath);

listExperiments = dir (folderAnimal_experiment_BDA);
bdaCount = 1;
if ~isempty(listExperiments)
    for i = 1: length(listFiles)
        testBDA = listFiles(i).name;
        if contains(testBDA, 'BDA')
            BdaTpaList(bdaCount).BDA = [bda_tpa_folder '\' testBDA]; 

            for k = 1: length(listFiles)
                if contains(listFiles(k).name, 'TPA')
                    testTPA = strrep(listFiles(k).name,'TPA','BDA');
                    if (strcmp(testTPA, testBDA))
                        BdaTpaList(bdaCount).TPA = [bda_tpa_folder '\' listFiles(k).name]; 
                        bdaCount = bdaCount + 1;
                    end
                end
            end
        end
    end
end


    Matlist{1} = 'E:\Results9_9_17\Den6Analysis\2_22_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
    Matlist{2} = 'E:\Results9_9_17\Den6Analysis\2_27_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
    Matlist{3} = 'E:\Results9_9_17\Den6Analysis\2_23_17_1_1stAndThird\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
    Matlist{4} = 'E:\Results9_9_17\Den6Analysis\3_1_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
    Matlist{5} = 'E:\Results9_9_17\Den6Analysis\4_2_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
    Matlist{6} = 'E:\Results9_9_17\Den6Analysis\2_21_17\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
    Matlist{7} = 'E:\Data\Results\Den6Analysis\8_13_17_1\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
    Matlist{8} = 'E:\Data\Results\Den7Analysis\8_10_17_1 (1)\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';
    Matlist{9} = 'E:\Data\Results\Den7Analysis\8_13_17_1 (1)\Analysis\svmAccuracy\acc_res_folds10lin_success_failure.mat';

    runAverageAnalysis(outputPath, xmlfile,BdaTpaList, Matlist, 'svmAccuracy');
end
