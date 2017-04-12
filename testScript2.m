[vert, face] = read_ply('frontwall.ply');

normal = [-1,0,0];
normals = calculateNormals(vert,face);
faceIndicesToCheck = getPerpendicularFaceIndices(normals, normal);
[faceChains, chainLengths] = getChainsOfFaces(face, faceIndicesToCheck);

i = 1;
write_ply(vert,face(faceChains(sum(chainLengths(1:i))+1:sum(chainLengths(1:i))+chainLengths(i+1)),:),'test.ply','ascii');