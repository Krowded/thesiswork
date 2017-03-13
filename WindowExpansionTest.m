[vertices, faces] = read_ply('frontwall.ply');

% Adding new point above old window:

%   Front of window:  
%   52 -81.7300   62.1171   77.4820
%   54 -81.7300   32.1171   77.4820
%   30 -81.7109   32.1171   52.4820
%   31 -81.7109   62.1171   52.4820
 
 newpointfront = [-81.7300, 70, 64.9820];

%  Back of window:  
%   51 -76.7300   62.1171   77.4820
%   53 -76.7300   32.1171   77.4820
%   27 -76.7109   62.1171   52.4820
%   28 -76.7109   32.1171   52.4820
 
 newpointback = [-76.7300, 70, 64.9820];
 
 % Add to list of vertices
 vertices(55,:) = newpointfront;
 vertices(56,:) = newpointback;
 
 %Insert front
    %Between front and back
    faces(47,1) = 55;
    %Insert between 52 and 31, add face
     faces(117,:) = faces(92,:);
     faces(92,2) = 55;
     faces(117,3) = 55; 
 
%Insert back
    %Between front and back
    faces(46,3) = 56;
    %Insert between 51 and 27, add face
     faces(118,:) = faces(72,:);
     faces(72,1) = 56;
     faces(118,3) = 56; 

%Add common faces
  faces(119,:) = [56, 55, 31];
  faces(120,:) = [55, 56, 51];

%Save modified model to file
write_ply(vertices, faces, 'test2.ply', 'ascii');