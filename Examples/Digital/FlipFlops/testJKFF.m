function testJKFF()
clear all;
global simout
global epsilon
global DEBUGLEVEL
global mi
mi = 0.000;
simout = [];
DEBUGLEVEL = 0;           % simulator debug level
epsilon = 1e-6;

tVec1 = [0, 0.9, 2.1, 3, 4, 4.9, 6, 7, 8, 9, 10, 11, 12];
yVec1 = [0,   1,   0, 0, 0,   0, 0, 0, 1, 1,  1,  1,  0];
tVec2 = [0, 1, 1.4, 3, 4.5, 4.9, 6, 7, 8, 9, 10, 11, 12];
yVec2 = [0, 0,   1, 1,   0    1, 1, 1, 1, 1   1,  1,  0];
tVec3 = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
yVec3 = [0, 1, 0, 1, 0, 1, 0, 1, 0, 1,  0,  1,  0];
tEnd = 50;
mdebug = false;
rOut = 0.0;

N1 = coordinator("N1");

Vectorgen1 = devs(vectorgen("Vectorgen1", tVec1, yVec1, [0, 1], mdebug));
Vectorgen2 = devs(vectorgen("Vectorgen2", tVec2, yVec2, [0, 1], mdebug));
Vectorgen3 = devs(vectorgen("Vectorgen3", tVec3, yVec3, [0, 1], mdebug));
D = jkflipflopCM("JKFF", [0, 1], mdebug);
Gen1out = devs(toworkspace("Gen1out", "gen1Out", 0, [0, rOut]));
Gen2out = devs(toworkspace("Gen2out", "gen2Out", 0, [0, rOut]));
Gen3out = devs(toworkspace("Gen3out", "gen3Out", 0, [0, rOut]));
Doutq = devs(toworkspace("Doutq", "doutq", 0, [0, rOut]));
Doutqn = devs(toworkspace("Doutqn", "doutqn", 0, [0, rOut]));

N1.add_model(Vectorgen1);
N1.add_model(Vectorgen2);
N1.add_model(Vectorgen3);
N1.add_model(D);
N1.add_model(Gen3out);
N1.add_model(Gen1out);
N1.add_model(Gen2out);
N1.add_model(Doutq);
N1.add_model(Doutqn);

N1.add_coupling("Vectorgen1","out","JKFF","j");
N1.add_coupling("Vectorgen2","out","JKFF","k");
N1.add_coupling("Vectorgen3","out","JKFF","c");

N1.add_coupling("Vectorgen1","out","Gen1out","in");
N1.add_coupling("Vectorgen2","out","Gen2out","in");
N1.add_coupling("Vectorgen3","out","Gen3out","in");
N1.add_coupling("JKFF","Q","Doutq","in");
N1.add_coupling("JKFF","Qn","Doutqn","in");

root = rootcoordinator("root",0,tEnd,N1,0);
root.sim();

figure("name", "testJKFlipFlop", "NumberTitle", "off", "Position", [1 1 450 500]);
subplot(5,1,1)
stairs(simout.gen1Out.t,simout.gen1Out.y,'-*');
title("j");
xlim([0,tEnd])
ylim([0,1.3])

subplot(5,1,2)
stairs(simout.gen2Out.t,simout.gen2Out.y,'-*');
title("k");
xlim([0,tEnd])
ylim([0,1.3])

subplot(5,1,3)
stairs(simout.gen3Out.t,simout.gen3Out.y,'-*');
title("c");
xlim([0,tEnd])
ylim([0,1.3])

subplot(5,1,4)
stairs(simout.doutq.t,simout.doutq.y,'-*');
title("q");
xlim([0,tEnd])
ylim([0,1.3])

subplot(5,1,5)
stairs(simout.doutqn.t,simout.doutqn.y,'-*');
title("qn");
xlim([0,tEnd])
ylim([0,1.3])
