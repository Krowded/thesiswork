%Returns a curve function representing the curve under the vertices as seen 
%from the z direction
function curve = getCurveUnderModel(vertices, xdirection, ydirection, zdirection)
    %Change basis
    B = [xdirection', ydirection', zdirection'];
    vertices = changeBasis(vertices, B);
    
    %Sort by 'x'
    flatVertices = sortrows(vertices(:,1:2), 1);
    
    %Remove points with the same x value
    i = 1;
    while i < size(flatVertices,1)
        thisX = flatVertices(i,1);
        nextX = flatVertices(i+1,1);

        %If very close to each other, remove the bigger one
        if abs(thisX - nextX) < 0.001
            thisY = flatVertices(i,2);
            nextY = flatVertices(i+1,2);
            flatVertices(i,2) = min( [thisY, nextY] );
            flatVertices(i+1,:) = [];
            continue;
        end
        i = i + 1;
    end
    
    %Get x and y
    x = flatVertices(:,1);
    y = flatVertices(:,2);
       
    %Calculate curve function
    curve = @(xq) interp1(x, y, xq);
end