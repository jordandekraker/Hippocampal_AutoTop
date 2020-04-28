% tries to make the A-P and P-D laplace gradients closer to orthogonal by
% extending their bondary conditions to the point that they meet (i.e.
% ensuring all edges of the rectangle touch)

SRLM3d = zeros(sz);
SRLM3d(lbl==2) = 1;

bad = find(isnan(Laplace_AP) | isnan(Laplace_PD) | isnan(Laplace_IO) | isnan(idxgm));
Laplace_AP(bad) = []; Laplace_PD(bad) = []; Laplace_IO(bad) = []; idxgm(bad) = [];

edges = boundary(Laplace_AP,Laplace_PD,0.8);

edges3d = zeros(sz); edges3d(idxgm(edges)) = 1;
APsource3d = zeros(sz); APsource3d(sourceAP) = 1;
APsink3d = zeros(sz); APsink3d(sinkAP) = 1;
PDsource3d = zeros(sz); PDsource3d(sourcePD) = 1;
PDsink3d = zeros(sz); PDsink3d(sinkPD) = 1;
idxgm3d = zeros(sz); idxgm3d(idxgm) = 1;

hl=ones(3,3,3);
edges3d = (imdilate(edges3d==1,hl) & lbl==0) |APsource3d|APsink3d|PDsource3d|PDsink3d;

for n = 1:5 % AP/PD boundaries will push eachother back and forth for n iterations, ensuring they contact each other
    PDsource3d = imdilate(PDsource3d==1,hl) & edges3d;
    PDsink3d = imdilate(PDsink3d==1,hl) & edges3d;
    APsource3d = imdilate(APsource3d==1,hl) & edges3d;
    APsink3d = imdilate(APsink3d==1,hl) & edges3d;
end

sourceAP = find(APsource3d==1);
sinkAP = find(APsink3d==1);
sourcePD = find(PDsource3d==1);
sinkPD = find(PDsink3d==1);