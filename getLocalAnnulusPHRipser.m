%% Neighbourhood Persistence Code
% Bernadette Stolz
% 26.3.2019

%
%Input:     - point_cloud: nxm matrix listing m-dimensional coordinates of n
%               points in point cloud
%           - outer_radius: r_out of local annulus used for local PH
%               computation
%           - inner_radius: r_in of local annulus used for local PH
%               computation
%           - data_set: Name of data set used (used for data specific paths)

%Output:    - set_of_super_outliers: set of points with less than 2 data
%               points within their annular neighbourhood
%           - set_of_dim1_outliers: set of points with no local dimension 1
%               homology (boundary points)
%           - number_of_bars: vector listing the number of bars
%               in the local PH dimension 1 barcodes for every point in the
%               point cloud
%           - number_of_persistent_bars: vector listing the number of persistent bars
%               in the local PH dimension 1 barcodes for every point in the
%               point cloud

%%

function [set_of_super_outliers, set_of_dim1_outliers, number_of_bars, number_of_persistent_bars] = getLocalAnnulusPHRipser(point_cloud,outer_radius, inner_radius, data_set)

    persistence_threshold = abs(outer_radius- inner_radius);

    [number_of_points,point_cloud_dimension] = size(point_cloud);
    
    set_of_super_outliers = [];
    set_of_dim1_outliers = [];
    set_of_dim1_outliers_rows = [];
    number_of_bars = zeros(number_of_points,1);
    number_of_persistent_bars = zeros(number_of_points,1);
    
    % We get every points' neighbour points within the specified radius
    
        [points_within_radius,distances] = rangesearch(point_cloud,point_cloud,...
            outer_radius,'Distance','euclidean');
        
        
        [points_within_inner_radius,inner_distances] = rangesearch(point_cloud,point_cloud,...
            inner_radius,'Distance','euclidean');

    parfor point = 1:number_of_points
        

        number_of_neighbours = length(points_within_radius{point});

        if number_of_neighbours < 2 %We want at least two points in neighbourhood (point itself plus another), irrelevant in most cases as we can choose the radii such that we avoid super outliers

            set_of_super_outliers = [set_of_super_outliers;point_cloud(point,:)];
            
            sprintf(['There is a superoutlier for point ', num2str(point)])

        else
            
            % We loop over every non super_outlier point and compute the local Vietoris-Rips
            % complex
                
            row_indices = points_within_radius{point};
            
            row_indices_inner_radius = points_within_inner_radius{point};
            
            rows_in_annulus = setdiff(row_indices,row_indices_inner_radius);

            delta_point_cloud = point_cloud(rows_in_annulus,:);
          
            [starts_and_ends_dim0,starts_and_ends_dim1] = runRipserparalell(delta_point_cloud,point); %We run ripser on the local neighbourhood

            if isempty(starts_and_ends_dim1) == 1 %we determine boundary points
                
                set_of_dim1_outliers = [set_of_dim1_outliers;point_cloud(point,:)];
                set_of_dim1_outliers_rows = [set_of_dim1_outliers_rows;point];
                
            else
                
                number_of_bars(point) = size(starts_and_ends_dim1,1);
                persistence = zeros(1,size(starts_and_ends_dim1,1));
                
                for i = 1:size(starts_and_ends_dim1,1)
                    
                    persistence(i) = starts_and_ends_dim1(i,2)-starts_and_ends_dim1(i,1)
                    
                    if persistence(i) > persistence_threshold %we determine the number of persistent bars in the local barcode
                        
                        number_of_persistent_bars(point) = number_of_persistent_bars(point) + 1;
                        
                    end
                    
                end
                

                filename1 = ['Local_Barcodes/' data_set '/Dim1_Point' num2str(point) '.txt']; %we save the local barcode

                [fileID,message] = fopen(filename1,'w');
                fprintf(fileID,'%f %f\n',starts_and_ends_dim1')
                fclose(fileID);


                delta_point_cloud = []
                row_indices = []

            end
    
        end


    end

end




