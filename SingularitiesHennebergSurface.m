%% Local PH of Henneberg data set
% Bernadette Stolz
% 7.5.2019

% This code identifies points clode to singularities in the Henneberg surface data set

% we input the radii of the local annuli
topological_radius = 2;
inner_radius = 3*topological_radius/4;

% we specify the data set
data_set = 'henneberg_point_cloud';
point_cloud_filename = ['Data_Sets/' data_set '.mat'];
load(point_cloud_filename);
point_cloud = X';

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

h1 = figure
histogram(number_of_bars)
title('Number of bars in dimension 1 barcode','Fontsize',20)

h2 = figure
histogram(number_of_persistent_bars)
title('Number of persistent bars in dimension 1 barcode','Fontsize',20)

% We determine intersection and boundary points
intersection_points = number_of_persistent_bars>1
plane_points = number_of_persistent_bars==1
boundary_points= number_of_persistent_bars==0

points = point_cloud(intersection_points,:);


 h = figure
    scatter3(point_cloud(:,1),point_cloud(:,2),point_cloud(:,3)) %[1,0.8276,0]
    hold on
    scatter3(points(:,1),points(:,2),points(:,3),'r','filled') %[1,0,0]
    hold on
    scatter3(set_of_dim1_outliers(:,1),set_of_dim1_outliers(:,2),set_of_dim1_outliers(:,3),'cyan','filled') %[1,0,0]
     title(['Points with $>$2 persistent bars, $\delta =$ ',num2str(topological_radius)],'Interpreter','latex')
    legend('Data points','Points with 2 persistent bars','No Dim 1 homology'); 


points_on_singularity = point_cloud(number_of_persistent_bars>1,:);


% % We run persistent homology on the intersection points to check the
% % results
% 
% [starts_and_ends_dim0,starts_and_ends_dim1] = runRipser(points_on_singularity,'HennebergSingularities');
% 
% plot_barcodes('ripser/output/HennebergSingularitiesDim0.txt','Henneberg singularities dim 0')
% 
% plot_barcodes('ripser/output/HennebergSingularitiesDim1.txt','Henneberg singularities dim 1')


save('singularitiesHenneberg.mat','points_on_singularity')
singularity_indices = number_of_persistent_bars>1;
save('singularity_indicesHenneberg.mat','singularity_indices')


