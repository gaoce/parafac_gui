function eemOut = normEEM(eemSample, eemWater)

% mean EEM for water
meanXDI =  mean(eemWater.X,1) ;

% subtract water eem from all the samples
eemSample.X = bsxfun(@minus, eemSample.X, meanXDI);

eemOut = EEMCut(eemSample, 10, 10, 10, 10, '');

eemOut.X(eemOut.X < 0) = 0;
eemOut.Sample = eemSample.Sample;

end