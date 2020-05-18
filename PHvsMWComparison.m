%% Local PH versus MW comparison
% Bernadette Stolz
% 28.8.2019

% We compare our singularities to Martin Watson

data_set = 'pointsCycloOctane';

point_cloud_filename = ['Data_Sets/' data_set '.mat'];
load(point_cloud_filename);

point_cloud = pointsCycloOctane;

singularity_threshold = 0.05; %d_t in Martin and Watson
min_allowable_local_points = 5; %only consider points whose local
                                %region includes at least this many points.

loop_index = 0;

for topological_radius = 0.2:0.05:1.5
    
    loop_index = loop_index + 1;

    %Local PH

    inner_radius = 5*topological_radius/8;

    [set_of_super_outliers, set_of_dim1_outliers, number_of_bars, number_of_persistent_bars] = getLocalAnnulusPHRipser(point_cloud,topological_radius, inner_radius, data_set);

    number_of_super_outliers_PH = size(set_of_super_outliers,1);
    number_of_dim1_outliers = size(set_of_dim1_outliers,1);

    singularity_indices_PH = find(number_of_persistent_bars>1);

    number_of_points_on_intersection_PH(loop_index) = size(singularity_indices_PH,1);

    filename_PH = ['Data_Sets/Comparison_Singularity_Sets/singularity_indicesCycloOctane_PH' num2str(topological_radius) '.mat'];
    
    save(filename_PH,'singularity_indices_PH')
    
    % Martin Watson
    
    ind_local=rangesearch(point_cloud,point_cloud,topological_radius);

    frac_2d_embedding=zeros(size(point_cloud,1),1);

    min_number_of_local_points=max(size(point_cloud));

    for j=1:length(frac_2d_embedding)
        data_local=point_cloud(ind_local{j},:);
        min_number_of_local_points=min(min_number_of_local_points,min(size(data_local)));
        if size(data_local,1)>=min_allowable_local_points
            local_mean=sum(data_local,1)/size(data_local,1);
            data_local=data_local-ones(size(data_local,1),1)*local_mean;
            singular_vals=svds(data_local,min(size(data_local)));   
            frac_2d_embedding(j)=sum(singular_vals(3:end).^2)/sum(singular_vals.^2);
        else
            frac_2d_embedding(j)=0;
        end
    end

    singularity_indices_MW=find(frac_2d_embedding>singularity_threshold);
    
    number_of_points_on_intersection_MW(loop_index) = size(singularity_indices_MW,1);
    
    filename_MW = ['Data_Sets/Comparison_Singularity_Sets/singularity_indicesCycloOctane_MW' num2str(topological_radius) '.mat']

    save(filename_MW,'singularity_indices_MW')
    
  
    clear singularity_indices_MW
    clear singularity_indices_PH
    
end


