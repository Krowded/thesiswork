%MAKE THIS WORK
%CHECK IF FACES AWAY OR TOWARDS MIDDLE POINT (CALCULATE APPROXIMATE MID POINT, PROBABLY THROUGH HEIGHT SEGMENTS)



V = m.vertices;
F = m.faces;

[V, F] = upsample(V,F, 'Iterations', 5);

normals = calculateNormals(V, F);


y = [0; 1; 0];
x = [1; 0; 0];
z = [0; 0; 1];
minY = min(V*y);
maxY = max(V*y);

midX = (max(V*x) + min(V*x))/2;
midZ = (max(V*z) + min(V*z))/2;
midV = [midX*ones(size(V,1),1) V*y midZ*ones(size(V,1),1)];

scale = 100/(maxY - minY);
invscale = 1/scale;


V0 = V;
for i = 1:size(V,1)
    v = V(i,:);
%     vec = normals(i,:) - (normals(i,:)*y)*y';
    vec = normals(i,:);
    vec(2) = 0;
    if norm(vec) < 0.01
        continue;
    end
       
    vec = normalize(vec);
    
    height = (v*y - minY)*scale;
    v = v + invscale*foundationCurves(1).curveFunction(height)*vec;
    V0(i,:) = v;
end