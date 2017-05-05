clear

%Set up the problem
v_0 = 10;
D = 1;
t_err = 0.01;

%Derived parameter
t_0 = D/v_0;

%Number of measurements
N = 100000; printInteger(N,'NumberOfMeasurements.tex');

%Generate gaussian distribution of t, width t_err
t = t_0 + randn(N,1) * t_err;

%The "measured velocities"
v = D./t;
[nvOne hvOne] = hist(v,sqrt(rows(v)));
O = [hvOne' nvOne'];
save 'fauxVelocityDistribution.dat' O

%Statistical properties of the "velocity" distribution
v_bar = mean(v)
v_err = std(v) / sqrt(N)

printSIErr( v_bar, v_err ,2,0, 'm/s', 'oneShotFauxVelocity.tex');

printSIErr(D/mean(t), D/mean(t)^2*std(t)/sqrt(N) ,2,0, 'm/s', 'oneShotTimedVelocity.tex');


%%%%%%%%% BOOTSTRAPPING FOLLOWS %%%%%%%%%

%memory allocation
BSN = 10000;  printInteger(BSN, 'NumberOfBootstraps.tex');
vBoot = zeros(BSN,1);
tBoot = zeros(BSN,1);

%Bootstrap loop
for ctr = 1:BSN
	Bv = bootstrapData(v);
	Bt = bootstrapData(t);

	vBoot(ctr) = mean(Bv);
	tBoot(ctr) = mean(Bt);
end


[nv hv] = hist(vBoot, sqrt(rows(vBoot)));
O = [hv' nv'];
save 'bootstrappedDerivedVelocity.dat' O

printSIErr( mean(vBoot), std(vBoot),2,0, 'm/s', 'bootstrapFauxVelocity.tex');

printSIErr(D/mean(tBoot), D/mean(tBoot)^2*std(tBoot) ,2,0, 'm/s', 'bootstrapTimedVelocity.tex');

[nt ht] = hist(D./tBoot, sqrt(rows(tBoot)));
O = [ht' nt'];
save 'bootstrappedTimedVelocity.dat' O

plot(hv,nv, ht,nt)

