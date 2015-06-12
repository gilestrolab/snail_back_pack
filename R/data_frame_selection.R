rm(list=ls())
library(seewave)
library(psd)
library(mFilter)
library(ggplot2)
library(data.table)
library(plotly)
source("~/Documents/snail_back_pack/R/funs.R")
DATA_FILE <- "/home/alysia/Documents/snail_back_pack/R/ref_data_heart_snail.txt"
REF_FILE <- "/home/alysia/Documents/nref.csv"

SAMPLING_FREQ <- 5 # in Hz

DATA_FILE <- "/home/alysia/Documents/heart_021.csv"
REF_FILE <- "/home/alysia/Documents/snail_back_pack/experiments/snail_minute_slices/snail_21minute.csv"



#######################################################
ref_df <- read.csv(REF_FILE, comment.char="#")
heterogeneous_df <- read.csv(DATA_FILE, head=F)
colnames(heterogeneous_df) <- c("t", "y")


# interpolation, generates df
out_t <- seq(from=0, to=max(heterogeneous_df$t), by= 1/SAMPLING_FREQ)
df_v1 <- approx(x=heterogeneous_df$t, y=heterogeneous_df$y, xout=out_t, method='linear')
df_v2 <- data.frame(df_v1)
colnames(df_v2) <- c("t", "y")
df <- na.omit(df_v2)


df$min <- floor(df$t /60) + 1
mins_of_interest_df <- subset(df, df$min %in% ref_df$min)
list_of_mins <- split(mins_of_interest_df, mins_of_interest_df$min)

pdf("/tmp/bwftrend_plot.pdf",w=16,h=9)
lapply(list_of_mins, function(l){
	y <- l$y
	t0 <- l$t[1]
	title <- paste("Heart rate spectrum in Helix aspersa")
	freq_fun_pspec_bwfilter(y, fs=5, dev=T, main=title)
	})
dev.off()


pdf("plot.pdf",w=16,h=9)
lapply(list_of_mins, function(sdf){
		title <- sdf$min[1]
		plot(y ~ t,sdf, type='l', col="blue", lwd=2,main=title)
	})
dev.off()


#list of results from methods and ggplot generation
results <- list(

	#pspec = apply_freq_meth(chunk=list_of_mins, freq_fun_pspec, fs=5)
	pspec_bwfilter3 = apply_freq_meth(chunks=list_of_mins, freq_fun_pspec_bwfilter3, fs=5),
	pspec_bwfilter5 = apply_freq_meth(chunks=list_of_mins, freq_fun_pspec_bwfilter5, fs=5),
	pspec_bwfilter8 = apply_freq_meth(chunks=list_of_mins, freq_fun_pspec_bwfilter8, fs=5),
	pspec_runmed = apply_freq_meth(chunk=list_of_mins, freq_fun_pspec_runmed, fs=5, k=43)
	)

results <- list(
pspec_bwfilter = apply_freq_meth(chunks=list_of_mins, freq_fun_pspec_bwfilter, fs=5))

#ref_df <- cbind(ref_df, as.data.frame(results))


tmp_df <- data.frame( 
	method=rep(names(results),sapply(results,length)),
	fc=do.call('c',results),
	min=ref_df$min
	)


long_df <- merge(ref_df, tmp_df)


ymax <- max(c(long_df$fc,long_df$of))
xmax <- ymax

pdf("/tmp/pltpspec.pdf",w=16,h=9)
			
pltpspec <- ggplot(long_df,aes(y = fc, x =of,colour=method,shape=method)) +
	geom_point() + geom_smooth(method="lm", fill=NA) + 
	coord_cartesian(xlim = c(0, xmax+0.25), ylim = c(0, ymax+0.25)) +
	geom_abline(group=1, colour="grey") + 
	labs(x = "Reference frequency",
       y = "Generated frequency",
       title = "Calculated reference frequency vs algorithm generated frequency")
dev.off()

#by quality
plt <- ggplot(long_df,aes(y = fc, x =of,colour=method,shape=as.factor(q))) +
	geom_point() + geom_smooth(method="lm", fill=NA) + 
	coord_cartesian(xlim = c(0, xmax+0.25), ylim = c(0, ymax+0.25)) +
	geom_abline(group=1, colour="grey")


#subset
plt <- ggplot(subset(long_df, q >= 4),aes(y = fc, x =reof,colour=method,shape=method)) +
	geom_point() + geom_smooth(method="lm", fill=NA) + 
	coord_cartesian(xlim = c(0, xmax+0.25), ylim = c(0, ymax+0.25)) +
	geom_abline(group=1, colour="grey")


df_meth_list <- split(long_df, long_df$method)

#linear model info matrix
lm_mat <- sapply(df_meth_list, function(d){
	mod <- lm(fc~of, d)
	coefs <- coefficients(mod)
	rsqr <- summary(mod)$r.squared
	out <- c(coefs, rsqr)
	names(out) <- c("b", "a", "rsqr")
	return(out)
	})

#################
testx <- fft(test$y, inverse=FALSE)
test_sp1 <- spectrum(testx, method=c("pgram"))
test_sp2 <- spectrum(testx, method=c("pgram", "ar"))


#################

plot(freq1 ~ of, ref_df, pch=as.character(q), col=q)
mod <- lm(freq1 ~ of, ref_df)`

test <- list_of_mins[[1]]
plot(y ~ t,test, type='l')
test$low_comp <- runmed(test$y,k=51)
lines(low_comp ~ t,test, col="red")
test$high_comp <- test$y - test$low_comp
plot(high_comp ~ t,test, type='l')

##################

	#meth_first = apply_freq_meth(chunks=list_of_mins, my_freq_fun, fs=5),
	#meth_runmed43 = apply_freq_meth(chunks=list_of_mins, my_freq_fun_runmed, fs=5, k=43),
	#meth_runmed45 = apply_freq_meth(chunks=list_of_mins, my_freq_fun_runmed, fs=5, k=45),
	#meth_pspec = apply_freq_meth(chunks=list_of_mins, freq_fun_pspec, fs=5),

	#pwelch
	#meth_pwelch = apply_freq_meth(chunk=list_of_mins, freq_fun_pwelch, window=6, fs=5),
	#meth_pwelch_runmed = apply_freq_meth(chunk=list_of_mins, freq_fun_pwelch_runmed, window=6, fs=5, k=43),
	#meth_pwelch_bwfilter = apply_freq_meth(chunk=list_of_mins, freq_fun_pwelch_bwfilter, window=6, fs=5)

##################
# length of signal
n <- 10000
 
# the frequency to be kept
F <- 500
F0 <- 2 * F / n

# input signal
sig <- add_sin_sig(n, c(300,500,700,1100))

# filter specification
filter <- cheby1(6,2,c(F0-F0*.1,F0+F0*.1),type="pass")

# filtered signal
sig2 <- signal::filter(filter, x=sig)
