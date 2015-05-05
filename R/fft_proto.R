rm(list=ls())

set.seed(1)
beats <- sin(seq(from=0,to=40*2*pi,length.out=300))

low_fs_noise <- sin(seq(from=0,to=3*2*pi,length.out=300))  * 3

white_noise <- rnorm(300, 0, .2)

fake_ts <- low_fs_noise + beats + white_noise

plot(fake_ts, t='l')

#oce::pwelch 
plot(psd::pspectrum(fake_ts))
 
pwelch(testy, window=10, noverlap=5)
