bootstrapBias.pdf: bootstrapBias.lyx initialDistributions.eps histogrammedBootstraps.eps
	lyx --export pdf2 $<

initialDistributions.eps: initialDistributions.gpl fauxVelocityDistribution.dat timesDistribution.dat
	gnuplot $<

histogrammedBootstraps.eps: histogrammedBootstraps.gpl bootstrappedDerivedVelocity.dat bootstrappedTimedVelocity.dat
	gnuplot $< 

fauxVelocityDistribution.dat timesDistribution.dat bootstrappedDerivedVelocity.dat bootstrappedTimedVelocity.dat: bootstrapBias.m *.m
	octave $<
