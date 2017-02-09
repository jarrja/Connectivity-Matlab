function [ Coh,rCoh,iCoh,laggedCoh,aLaggedCoh,MSCoh ] = eeg_coherence( f1,f2,Fs )


sxy = cpsd(f1,f2,[],[],[],Fs);
sxx = pwelch(f1,[],[],[],Fs);
syy = pwelch(f2,[],[],[],Fs);

Coh = (sxy)./sqrt((sxx.*syy));
MSCoh = (abs(sxy).^2)./(sxx.*syy);

rCoh = real(Coh);
iCoh = imag(Coh);
%Computing Lagged Coherence
laggedCoh = (imag(sxy).^2)./(sxx.*syy-real(sxy).^2);

%Computing Adjusted Lagged Coherence
aLaggedCoh = (laggedCoh./(abs(laggedCoh))).*atanh(abs(laggedCoh));

aLaggedCoh(isnan(aLaggedCoh)) = 0;
laggedCoh(isnan(laggedCoh)) = 0;
MSCoh(isnan(MSCoh)) = 0;

end

