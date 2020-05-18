%% Function for calling ripser and importing results into Matlab
% Bernadette Stolz
% 26.3.2019

%Input:     - point_cloud: nxm matrix listing m-dimensional coordinates of n
%               points in neighbourhood point cloud 
%           - point: point number in data set

%Output:    - starts_and_ends_dim0: 0-dimensional barcode of local neighbourhood from ripser 
%           - starts_and_ends_dim1: 1-dimensional barcode of local neighbourhood from ripser 


function [starts_and_ends_dim0,starts_and_ends_dim1] = runRipserparalell(point_cloud,point)

    [number_of_points,dimension] = size(point_cloud);
    filestring = [];
    
    for dim = 1:dimension
        
        if dim<dimension
            filestring = [filestring,'%f '];
        else
            filestring = [filestring,'%f\n'];
        end
        
    end
    
    filestring = char(filestring);

    c = clock;
    rng('shuffle');

    point_cloud_filename =  [num2str(round(c(6)*1000)) num2str(round(rand*1000)) num2str(point)]
    point_cloud_filename2 =  [num2str(point_cloud_filename) '.txt'];
    point_cloud_filename3 =  ['ripser/input/' num2str(point_cloud_filename) '.txt'];
    
    fileID = fopen(point_cloud_filename3,'w')
    fprintf(fileID,filestring,point_cloud');
    fclose(fileID);
    
    sprintf(['Ripser script opened file for point ' num2str(point)])

    savefilename=['ripser/output/',point_cloud_filename2];
    unixstring=['./ripser/ripser --format point-cloud --dim 1 ',point_cloud_filename3,' > ',savefilename];
    [status,cmdout] = unix(unixstring);

    unixstring = [];
    unixstring=['python -c ''import ReformatRipser; print ReformatRipser.formatFunction("', 'ripser/output/',point_cloud_filename, '")'''];
    [status,cmdout] = unix(unixstring);

    filename_dim0 = ['ripser/output/' num2str(point_cloud_filename) 'Dim0.txt'];
    starts_and_ends_dim0 = importdata(filename_dim0);
    
    sprintf(['Ripser script opened file dim 0 for point ' num2str(point)])
    
    filename_dim1 = ['ripser/output/' num2str(point_cloud_filename) 'Dim1.txt'];
    starts_and_ends_dim1 = importdata(filename_dim1);
    
    sprintf(['Ripser script opened file dim 1 for point ' num2str(point)])
    
    unixstring = [];
    unixstring=['rm ', 'ripser/output/',point_cloud_filename2];
    [status,cmdout] = unix(unixstring);
    
    unixstring = [];
    unixstring=['rm ', 'ripser/input/',point_cloud_filename2];
    [status,cmdout] = unix(unixstring);
    
    unixstring = [];
    unixstring=['rm ', filename_dim0];
    [status,cmdout] = unix(unixstring);
    
    unixstring = [];
    unixstring=['rm ', filename_dim1];
    [status,cmdout] = unix(unixstring);
    
    sprintf(['Ripser is done for point ' num2str(point)])
end