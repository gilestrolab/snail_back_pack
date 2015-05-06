source("~/Documents/snail_back_pack/R/data_frame_selection.R")

my_freq_fun <- function(y, fs){
	sp <- seewave::spec(y,f=fs)
	f <- seewave::fpeaks(sp, f=fs,nmax=1)
	
	return(f[1,1]*1000)
}

my_freq_fun_runmed <- function(y, fs,k){
	rmed <- runmed(y, k)
	ny <- y-rmed
	attr(ny,"k") <- NULL
	sp <- seewave::spec(ny,f=fs)
	f <- seewave::fpeaks(sp, f=fs,nmax=1)
	
	return(f[1,1]*1000)
}
#k=43 seems to work best

freq_fun_pwelch <- function(y, window, fs){
	pw <- pwelch(y, window, noverlap=50, fs)
	f <- seewave::fpeaks(pw$spec, f=fs,nmax=1)
	
	return(f[1,1]*1000)
}

freq_fun_pspec <- function(y, fs){
	pspec_test <- pspectrum(y, x.frqsamp=fs)
	f <- seewave::fpeaks(pspec_test$spec, f=fs,nmax=1)
	
	return(f[1,1]*1000)
}

freq_fun_pspec_bwfilter <- function(y, fs){
	bwf <- bwfilter(y,freq=4,drift=TRUE)
	pspec_test <- pspectrum(bwf$trend, x.frqsamp=5)
	f <- seewave::fpeaks(pspec_test$spec, f=fs,nmax=1)
	
	return(f[1,1]*1000)
}


apply_freq_meth <- function(chunks, FUN, fs, ...){
	sapply(chunks, function(d, fs, ... ){ 
		FUN(d$y, fs, ...)
	},fs,...)
}
