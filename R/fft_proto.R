rm(list=ls())

set.seed(1)
beats <- sin(seq(from=0,to=40*2*pi,length.out=300))

low_fs_noise <- sin(seq(from=0,to=3*2*pi,length.out=300))  * 3

white_noise <- rnorm(300, 0, .2)

fake_ts <- low_fs_noise + beats + white_noise

plot(fake_ts, t='l')

#oce::pwelch 
plot(psd::pspectrum(fake_ts))
 
pw_test <- pwelch(fake_ts, window=4.7, noverlap=50, fs=5)
f <- seewave::fpeaks(pw_test$spec, f=5,nmax=2)
f*1000

pspec_test <- pspectrum(fake_ts, x.frqsamp=5)
f <- seewave::fpeaks(pspec_test$spec, f=fs,nmax=1)
f*1000

pspec_test <- pspectrum(bwf_test$trend, x.frqsamp=5)
f <- seewave::fpeaks(pspec_test$spec, f=fs,nmax=1)
f*1000

bwf_test <- bwfilter(fake_ts,freq=4,drift=TRUE)

pspec_test <- pspectrum(bwf_test$trend, x.frqsamp=5)
f <- seewave::fpeaks(pspec_test$spec, f=fs,nmax=1)
f*1000
