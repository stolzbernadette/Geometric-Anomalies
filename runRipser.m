%% Function for calling ripser and importing results into Matlab
% Bernadette Stolz
% 26.3.2019

%Input:     - point_cloud: nxm matrix listing m-dimensional coordinates of n
%               points in neighbourhood point cloud 
%           - point_cloud_name: Name of data set to be analysed

%Output:    - starts_and_ends_dim0: 0-dimensional barcode of local neighbourhood from ripser 
%           - starts_and_ends_dim1: 1-dimensional barcode of local neighbourhood from ripser 


function [starts_and_ends_dim0,starts_and_ends_dim1] = runRipser(point_cloud,point_cloud_name)

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

    point_cloud_filename =  point_cloud_name;
    point_cloud_filename2 =  [point_cloud_filename '.txt'];
    point_cloud_filename3 =  ['ripser/input/' num2str(point_cloud_filename) '.txt'];
    
    fileID = fopen(point_cloud_filename3,'w')
    fprintf(fileID,filestring,point_cloud');
    fclose(fileID);
    
    sprintf('Ripser script opened file')

    savefilename=['ripser/output/',point_cloud_filename2];
    unixstring=['./ripser/ripser --format point-cloud --dim 1 ',point_cloud_filename3,' > ',savefilename];
    [status,cmdout] = unix(unixstring);
    
    sprintf('Ripser is done')

    unixstring = [];
    unixstring=['python -c ''import ReformatRipser; print ReformatRipser.formatFunction("', 'ripser/output/',point_cloud_filename, '")'''];
    [status,cmdout] = unix(unixstring);
    
    sprintf('Reformatting of Ripser output is done')

    filename_dim0 = ['ripser/output/' num2str(point_cloud_filename) 'Dim0.txt'];
    starts_and_ends_dim0 = importdata(filename_dim0);
    
    sprintf('File dim 0 is done')
    
    filename_dim1 = ['ripser/output/' num2str(point_cloud_filename) 'Dim1.txt'];
    starts_and_ends_dim1 = importdata(filename_dim1);
    
    sprintf('File dim 1 is done')
    
    unixstring = [];
    unixstring=['rm ', 'ripser/output/',point_cloud_filename2];
    [status,cmdout] = unix(unixstring);
    
    unixstring = [];
    unixstring=['rm ', 'ripser/input/',point_cloud_filename2];
    [status,cmdout] = unix(unixstring);
    
    
    sprintf('Ripser files are deleted, code is done')
    
end




    
    