% Local PH of cyclooctane data set
% Bernadette Stolz
% 26.3.2019


% This code identifies points clode to singularities in the cyclo-octanr data set

% we input the radii of the local annuli
topological_radius = 0.4;
inner_radius = 5*topological_radius/8;

data_set = 'pointsCycloOctane'; % we specify the data set
point_cloud_filename = ['Data_Sets/' data_set '.mat'];
load(point_cloud_filename);
point_cloud = pointsCycloOctane;

% We compute the local persistent homology of the data points
[set_of_super_outliers, set_of_dim1_outliers, number_of_bars, number_of_persistent_bars] = getLocalAnnulusPHRipser(point_cloud,topological_radius, inner_radius, data_set);


% We separate points with no dimension 1 persistent homology from the data
% set (= points close to a boundary)
number_of_super_outliers_PH = size(set_of_super_outliers,1);
number_of_dim1_outliers = size(set_of_dim1_outliers,1);

if number_of_super_outliers_PH > 0

    [super_outlier_free_point_cloud,ib] = setdiff(point_cloud,set_of_super_outliers,'rows');

    [C,sorted_index] = sort(ib);

    super_outlier_free_point_cloud = super_outlier_free_point_cloud(sorted_index,:);

else

    super_outlier_free_point_cloud = point_cloud;

end

if number_of_dim1_outliers > 0

    [outlier_free_point_cloud,ia] = setdiff(super_outlier_free_point_cloud,set_of_dim1_outliers,'rows');

    [B,sorted_index] = sort(ia);

    outlier_free_point_cloud = outlier_free_point_cloud(sorted_index,:);

else

    outlier_free_point_cloud = super_outlier_free_point_cloud;

end

% We look at the number of bars in the local barcodes
h = figure
histogram(number_of_bars)
title('Number of bars in dimension 1 barcode','Fontsize',20)

g = figure
histogram(number_of_persistent_bars)
title('Number of persistent bars in dimension 1 barcode','Fontsize',20)


points_on_singularity = point_cloud(number_of_persistent_bars>1,:);
save('singularitiesCycloOctane.mat','points_on_singularity')


% We run persistent homology on the intersection points in R^24 for an initial
% results check

[starts_and_ends_dim0,starts_and_ends_dim1] = runRipser(points_on_singularity,'CycloOctaneSingularities');

plot_barcodes('ripser/output/CycloOctaneSingularitiesDim0.txt','Cyclo-octane singularities dim 0')
plot_barcodes('ripser/output/CycloOctaneSingularitiesDim1.txt','Cyclo-octane singularities dim 1')


singularity_indices = number_of_persistent_bars>1;
save('singularity_indicesCycloOctane.mat','singularity_indices')


% We visualise the results
load('CycloOctane_isomap_k5.mat')

k = figure
scatter3(CycloOctane_Y.coords{3}(1,:),CycloOctane_Y.coords{3}(2,:),CycloOctane_Y.coords{3}(3,:))
hold on
scatter3(CycloOctane_Y.coords{3}(1,singularity_indices),CycloOctane_Y.coords{3}(2,singularity_indices),CycloOctane_Y.coords{3}(3,singularity_indices),'r','filled')
title(['Points with $>$2 persistent bars, $\delta =$ ',num2str(topological_radius)],'Interpreter','latex')
legend('Data points','Points with 2 persistent bars'); 



