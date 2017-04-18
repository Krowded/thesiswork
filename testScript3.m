%Get models
[roof1vert, roof1Face] = read_ply('roof2.ply');
[found1vert, found1face] = read_ply('foundation2.ply');
[roof2vert, roof2Face] = read_ply('roof1.ply');
[found2vert, found2face] = read_ply('foundation1.ply');

%SLICE ROOF AROUND SLOTS AND USE THAT FOR CURVE FITTING

%STORE A WALL CURVE FOR EACH STYLE AND APPLY TO WALL CORNERS

%Set normal (TODO)
normal = [-1,0,0];
up = [0, 1, 0];
side = [0, 0, 1];

%Get slots from foundation
roof1Slots = slotsFromRoofFoundationIntersection(roof1vert, found1vert, normal, up);
roof2Slots = slotsFromRoofFoundationIntersection(roof2vert, found2vert, normal, up);

%Calculate non-uniform scalign
S = scaleMatrixFromSlots(roof2Slots, roof1Slots, normal, up);
roof2Slots = applyTransformation(roof2Slots,S);

%Slot fitting
[regParams,Bfit,ErrorStats] = absor(roof2Slots',roof1Slots', 'doScale', 0, 'doTrans', 1);

%Apply complete transformation
M = regParams.M;
M = M*S;
roof2vert = applyTransformation(roof2vert, M);

%Get curve
curveFunction = getCurveUnderModel(roof2vert, side, up, normal);

%Fit foundation to curve
%NEED TO INTRODUCE MORE VERTICES IF TOO SIMPLE
found1vert = fitFoundationToCurve(found1vert, roof1Slots, curveFunction, side, up);

%Insert model
face = [found1face; roof2Face+size(found1vert,1)];
vert = [found1vert; roof2vert];

%Output
write_ply(vert,face,'test.ply','ascii');