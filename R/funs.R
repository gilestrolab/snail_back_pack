#interpolation FIXME
interp_fun <- function(y, fs, ...){

	out_t <- seq(from=floor(min(y$V1)), to=round(max(y$V1)), by= 1/fs)
	df_v1 <- approx(x=y$V1, y=y$V2, xout=out_t, method='linear')
	df_v2 <- data.frame(df_v1)
	colnames(df_v2) <- c("t", "V2")
	fin_df <- na.omit(df_v2)

	return(as.data.frame(fin_df))
}

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

freq_fun_pwelch <- function(y, window, fs, ...){
	pw <- pwelch(y, window, noverlap=20, fs=fs)
	f <- seewave::fpeaks(pw$spec, f=fs,nmax=1)
	
	return(f[1,1]*1000)
}

freq_fun_pspec <- function(y, fs){ 
	pspec_test <- pspectrum(y, x.frqsamp=fs)
	f <- seewave::fpeaks(pspec_test$spec, f=5,nmax=1)
	
	return(f[1,1]*1000)
}
	
freq_fun_pspec_runmed <- function(y, fs, k){
	rmed <- runmed(y, k)
	ny <- y-rmed
	attr(ny,"k") <- NULL
	pspec_test <- pspectrum(ny, x.frqsamp=fs)
	f <- seewave::fpeaks(pspec_test$spec, f=fs,nmax=1)
	if(any(is.na(f))){
		return(.0 + NA)
		}
	return(f[1,1]*1000)
}

#generates original spectra and filtered spectra
freq_fun_bwfilter <- function(y, fs, dev=TRUE,...){
	bwf <- bwfilter(y,freq=3,drift=TRUE)
	
	if(dev == T){
		plot(y,type="l",...)
		plot(bwf$trend, type="l")
	}
	return(f[1,1]*1000)
}

#generates, original spectra, power spectrum, and fpeaks
freq_fun_pspec_bwfilter3 <- function(y, fs, dev=TRUE,...){
	y <- ts(y,f=fs)
	bwf <- bwfilter(y,freq=3,drift=TRUE) 
	pspec_test <- pspectrum(bwf$trend)
	f <- seewave::fpeaks(pspec_test$spec, f=fs,nmax=1, plot=F, title=F)
	if(any(is.na(f))){
		return(.0 + NA)
		}
		
	if(dev == T){
	
		plot(y,type="l",xlab="Time (seconds)", ylab="Light intensity (arbitrary units)",...)
		plot(pspec_test,...)
		#title(round((f[1,1]*1000), digits=3), "Hz")
		abline(v=(f[1,1]), col="red")
	}
	
	
	return(f[1,1]*1000)
}

freq_fun_pspec_bwfilter5 <- function(y, fs, dev=TRUE,...){
	y <- ts(y,f=fs)
	bwf <- bwfilter(y,freq=5,drift=TRUE) 
	pspec_test <- pspectrum(bwf$trend)
	f <- seewave::fpeaks(pspec_test$spec, f=fs,nmax=1, plot=F, title=F)
	if(any(is.na(f))){
		return(.0 + NA)
		}
		
	if(dev == T){
	
		plot(y,type="l",xlab="Time (seconds)", ylab="Light intensity (arbitrary units)",...)
		plot(pspec_test,...)
		#title(round((f[1,1]*1000), digits=3), "Hz")
		abline(v=(f[1,1]), col="red")
	}
	
	
	return(f[1,1]*1000)
}

freq_fun_pspec_bwfilter8 <- function(y, fs, dev=TRUE,...){
	y <- ts(y,f=fs)
	bwf <- bwfilter(y,freq=8,drift=TRUE) 
	pspec_test <- pspectrum(bwf$trend)
	f <- seewave::fpeaks(pspec_test$spec, f=fs,nmax=1, plot=F, title=F)
	if(any(is.na(f))){
		return(.0 + NA)
		}
		
	if(dev == T){
	
		plot(y,type="l",xlab="Time (seconds)", ylab="Light intensity (arbitrary units)",...)
		plot(pspec_test,...)
		#title(round((f[1,1]*1000), digits=3), "Hz")
		abline(v=(f[1,1]), col="red")
	}
	
	
	return(f[1,1]*1000)
}

freq_fun_pspec_bwfilter_runmed <- function(y, fs, k, dev=TRUE,...){
	rmed <- runmed(y, k)
	ny <- y-rmed
	attr(ny,"k") <- NULL
	bwf <- bwfilter(ny,freq=3,drift=TRUE)
	pspec_test <- pspectrum(bwf$trend, x.frqsamp=fs)
	f <- seewave::fpeaks(pspec_test$spec, f=fs,nmax=1, plot=T, title=F)
	if(any(is.na(f))){
		return(.0 + NA)
		}
	
	return(f[1,1]*1000)
}

#freq_fun_pspec_iirfilter_pspec<- function(y, fs, k, dev=TRUE,...){

	#pspec_test <- pspectrum(bwf$trend, x.frqsamp=fs)
	#f <- seewave::fpeaks(pspec_test$spec, f=fs,nmax=1, plot=T, title=F)
	#if(any(is.na(f))){
	#	return(.0 + NA)
	#	}
	
	#return(f[1,1]*1000)
#}



#f1 <- iir(sines, fl = 0.5, fh = 1.5, type = "BP", proto = "BU")
#lines(f1, col = "blue")






apply_freq_meth <- function(chunks, FUN, fs, ...){
	sapply(chunks, function(d, fs, ... ){ 
		FUN(d$y, fs, ...)
	},fs,...)
}

apply_meth <- function(chunks, FUN, fs, ...){
	sapply(chunks, function(d, fs, ... ){ 
		FUN(y, fs, ...)
	},fs,...)
}
