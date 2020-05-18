%% Radius Robustness Figure
% Bernadette Stolz
% 28.8.2019

data_set = 'pointsCycloOctane';

point_cloud_filename = ['Data_Sets/' data_set '.mat'];
load(point_cloud_filename);

point_cloud = pointsCycloOctane;


% We introduce reference data sets

filename_PH = ['Data_Sets/Comparison_Singularity_Sets/singularity_indicesCycloOctane_PH0.4.mat'];
    
load(filename_PH)

PH_Reference_points = pointsCycloOctane(singularity_indices_PH,:);

filename_MW = ['Data_Sets/Comparison_Singularity_Sets/singularity_indicesCycloOctane_MW0.2.mat'];
    
load(filename_MW)

MW_Reference_points = pointsCycloOctane(singularity_indices_MW,:);

loop_index = 0;

% For every topological radius we compute the Hausdorff distance between
% the reference data set and the set of singularities found by local PH and
% Martin-Watson respectively

for topological_radius = 0.2:0.05:1.5
    
    loop_index = loop_index + 1;

    filename_PH = ['Data_Sets/Comparison_Singularity_Sets/singularity_indicesCycloOctane_PH' num2str(topological_radius) '.mat'];
    
    load(filename_PH)
    
    number_of_points_on_intersection_PH(loop_index) = size(singularity_indices_PH,1);
    
    if topological_radius > 0.4
    
        PH_points = pointsCycloOctane(singularity_indices_PH,:);

        [hd_PH D_PH] = HausdorffDist(PH_points,PH_Reference_points);

        PH_Hausdorff_distance(loop_index) = hd_PH;
        
    else
        
        PH_Hausdorff_distance(loop_index) = 0;
        
    end

    filename_MW = ['Data_Sets/Comparison_Singularity_Sets/singularity_indicesCycloOctane_MW' num2str(topological_radius) '.mat'];

    load(filename_MW)
  
    number_of_points_on_intersection_MW(loop_index) = size(singularity_indices_MW,1);
    
    MW_points = pointsCycloOctane(singularity_indices_MW,:);
    
    [hd_MW D_MW] = HausdorffDist(MW_points,MW_Reference_points);
    
    MW_Hausdorff_distance(loop_index) = hd_MW;
  
    
    clear singularity_indices_MW
    clear singularity_indices_PH
    clear MW_points
    clear PH_points
  
end


h5 = figure
plot([0.4:0.05:1.5],PH_Hausdorff_distance(5:end),'Linewidth',2)
hold on
plot([0.2:0.05:1.5],MW_Hausdorff_distance,'Linewidth',2)
ylabel('Hausdorff distance to reference points','Fontsize',20)
xlabel('Neighbourhood radius','Fontsize',20)
title('Radius robustness','Fontsize',25)
xlim([0.2,1.5])
legend('Local PCoH', 'Local PCA','Fontsize',18)
saveas(h5,'RadiusRobustnessHausdorff')
