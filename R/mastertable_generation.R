rm(list=ls())
library(data.table)
source("~/Documents/snail_back_pack/R/funs.R")
RESULT_DIR <-"~/Documents"
MASTER_FILE <- "~/Documents/snail_back_pack/experiments/snail_temperature_experiment/results/master_table.csv"




makedt_for_animal <- function(subdt, fs=5){

	heart_dt <- fread(subdt$heart_file)
	temp_dt <- fread(subdt$temp_file)
	
	out_t <- seq(from=floor(min(heart_dt$V1)), to=round(max(heart_dt$V1)), by= 1/fs)
	li_heart <- approx(x=heart_dt$V1, y=heart_dt$V2, xout=out_t, method='linear')
	li_temp <- approx(x=temp_dt$V1, y=temp_dt$V2, xout=out_t, method='linear')
	#map here
	out_dt <- data.table(t=li_heart$x, y=li_heart$y, temp=li_temp$y)
	fin_dt <- na.omit(out_dt)


	fin_dt
	
		}



master_table_v1 <- data.table(read.csv(MASTER_FILE, header=T, na.strings=" ", skip=1))
master_table_v2 <- na.omit(master_table_v1[1:16])
master_table_v2[, ID:= as.integer(as.character(ID))]

master_table_v2[, heart_file:= paste(RESULT_DIR,gsub("\\s", "", heart_file),sep="/")]
master_table_v2[, temp_file:= paste(RESULT_DIR,gsub("\\s", "", temp_file),sep="/")]
#FIXME
master_table_v2 <- master_table_v2[ID<23, ]
setkey(master_table_v2,ID)

#TO LOOK AT
main_dt <- master_table_v2[,makedt_for_animal(.SD),by="ID"]
tmin <- floor(main_dt$t /60) + 1
main_dt2 <-cbind(main_dt, data.table(tmin))
main_dt3 <- split(main_dt2, list(main_dt2$ID, main_dt2$tmin))

main_dt4 <- lapply(main_dt3, function(m){
	
	mean_temp <- mean(m$temp)
	sd_temp <- sd(m$temp)
	sd_mean <- cbind(mean_temp, sd_temp)
	main_temp <- cbind(m, sd_mean)
	main_temp
	
})

#TODO: lapply or something like
result21 <- main_dt2[ID== 21,list(
			freq = freq_fun_pspec_bwfilter(y,fs=5),
			temp = mean(temp),
			temp_sd = sd(temp))
			
			,by=c("ID","tmin")]
			
result21_runmed <- main_dt2[ID== 21,list(
			freq = freq_fun_pspec_runmed(y,fs=5, 43),
			temp = mean(temp),
			temp_sd = sd(temp))
			
			,by=c("ID","tmin")]

result21_runmed_bwfilter <- main_dt2[ID== 21,list(
			freq = freq_fun_pspec_bwfilter_runmed(y,fs=5, 43),
			temp = mean(temp),
			temp_sd = sd(temp))
			
			,by=c("ID","tmin")]

result21_bwfilter5 <- main_dt2[ID== 21,list(
			freq = freq_fun_pspec_bwfilter5(y,fs=5),
			temp = mean(temp),
			temp_sd = sd(temp))
			
			,by=c("ID","tmin")]

#testing

results_dt <- rbind(result9, result10, result11, result12, result13, result14, 
result15, result16, result17, result18, result19, result20, result21, result22)

results_half <- rbind(result11, result13, result15, result17, result19, result21)

results_9_14 <- rbind(result9, result10, result11, result12, result13, result14)


test_m <- mean(test$temp)
test_sd <- sd(test$temp)
ntest <- cbind(test, rep(test_m), rep(test_sd))

#TOFIX: some of the main_dt3 subtables don't have 300 values, remove?


meth_pspec_bwfilter = apply_freq_meth(chunks=main_dt3, 
freq_fun_pspec_bwfilter, fs=5) 



plot(freq ~ temp,resu)
> plot(freq ~ tmin,resu)
> plot(temp ~ tmin,resu)
> plot(temp ~ log10(tmin),resu)
> plot(temp ~ tmin,resu)
> plot(temp ~ tmin,resu[tmin>23850600])
tempplt<- plot(temp ~ tmin,resu[tmin>23862200],type='l')
freqplt<- plot(freq ~ tmin,resu[tmin>23862200], type='l')
tfplt<- plot(freq ~ temp,resu[temp>20])

bwf <- bwfilter(y,freq=10,drift=TRUE);plot(bwf$trend, type="l",col='red',lty=2,lwd=3);lines(y)
> bwf <- bwfilter(y,freq=10,nfix=2,drift=TRUE);plot(bwf$trend, ylim=c(325,350),type="l",col='red',lty=2,lwd=3);lines(y)
> bwf <- bwfilter(y,freq=10,nfix=3,drift=TRUE);plot(bwf$trend, type="l",col='red',lty=2,lwd=3);lines(y)
> bwf <- bwfilter(y,freq=10,nfix=2,drift=TRUE);plot(bwf$trend, type="l",col='red',lty=2,lwd=3);lines(y)

plot(y-bwf$trend)
> acf(y-bwf$trend,max)
max      max.col  
> acf(y-bwf$trend,lag.max=50)
> acf(y,lag.max=50)

y <- ts(y,f=fs)
pdf("/tmp/bwftrend_plot.pdf",w=16,h=9)
bwf <- bwfilter(y,freq=10,nfix=2,drift=TRUE);plot(bwf$trend, ylim=c(325,350), xlab="Time (seconds)"
, ylab="Light intensity (arbitrary units)", type="l",col='red',lty=2,lwd=3);lines(y)
title("Original signal with a butterworth filter applied")
dev.off()

pdf("/tmp/bwf_plot.pdf",w=16,h=9)
plot(y-bwf$trend, xlab="Time (seconds)", ylab="Light intensity (arbitrary units)")
title("Original signal with a butterworth filter applied")
dev.off()


rmed <- runmed(y, k=43)
ny <- y-rmed
nyb <- y - bwf$trend
attr(ny,"k") <- NULL

pdf("/tmp/rmed_plot.pdf",w=16,h=9)
plot(ny, type="l", xlab="Time (seconds)", ylab="Light intensity (arbitrary units)")
title("Original signal with a running median filter applied")
dev.off()

pdf("/tmp/rmedtrend_plot.pdf",w=16,h=9)
plot(rmed, type="l", xlab="Time (seconds)", ylab="Light intensity (arbitrary units)",col='red',lty=2,lwd=3);lines(y)
title("Original signal with a running median filter applied")
dev.off()

pdf("/tmp/rmedtrend_plot.pdf",w=16,h=9)
plot(rmed, type="l", xlab="Time (seconds)", ylab="Light intensity (arbitrary units)")
title("Original signal with a running median filter applied")
dev.off()


pdf("/tmp/bwfpspec_plot.pdf",w=16,h=9)
pspec_test <- pspectrum(bwf$trend)
plot(pspec_test, xlab="Frequency (Hz)", ylab="Spectrum", main="Power spectrum from band-pass filtered signal")
dev.off()

pdf("/tmp/rmedpspec_plot.pdf",w=16,h=9)
pspec_test <- pspectrum(ny)
plot(pspec_test, xlab="Frequency (Hz)", ylab="Spectrum", main="Power spectrum from running median filtered signal")
dev.off()

pdf("/tmp/rmedfpeaks_plot.pdf",w=16,h=9)
f <- seewave::fpeaks(pspec_test$spec, f=5,nmax=1, plot=T)
abline(v=(f[1,1]), col="red")
dev.off()


pdf("/tmp/bwffpeaks_plot.pdf",w=16,h=9)
pspec_test <- pspectrum(nyb)
f <- seewave::fpeaks(pspec_test$spec, f=5,nmax=1, plot=T)
abline(v=(f[1,1]), col="red")
dev.off()

######freq pdfs
pdf("/tmp/freqc_bwf3.pdf",w=16,h=9)
pltpspec
dev.off()

pltpspec <- ggplot(long_df,aes(y = fc, x =of,colour=method,shape=method)) +
	geom_point() + geom_smooth(method="lm", fill=NA) + 
	coord_cartesian(xlim = c(0, xmax+0.25), ylim = c(0, ymax+0.25)) +
	geom_abline(group=1, colour="grey") + 
	labs(x = "Reference frequency",
       y = "Generated frequency",
       title = "Calculated reference frequency vs algorithm generated frequency")

pdf("/tmp/bwffpeaks_plot.pdf",w=16,h=9)
f<-seewave::fpeaks(pspec_test$spec, f=5,nmax=1, plot=T, title=F)
abline(v=(f[1,1]), col="red")
 

