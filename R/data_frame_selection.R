rm(list=ls())
DATA_FILE <- "/home/alysia/Documents/ref_data_heart_snail.txt"
REF_FILE <- "/home/alysia/Documents/ref.csv"
SAMPLING_FREQUENCY <- 5 # in Hz


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
#k=11 seems to work best





apply_freq_meth <- function(chunks, FUN, fs, ...){
	sapply(chunks, function(d, fs, ... ){ 
		FUN(d$y, fs, ...)
	},fs,...)
}


#######################################################
ref_df <- read.csv(REF_FILE, comment.char="#")
heterogeneous_df <- read.csv(DATA_FILE, head=F)
colnames(heterogeneous_df) <- c("t", "y")


# interpolation, generates df
out_t <- seq(from=0, to=max(heterogeneous_df$t), by= 1/SAMPLING_FREQUENCY)
df_v1 <- approx(x=heterogeneous_df$t, y=heterogeneous_df$y, xout=out_t, method='linear')
df_v2 <- data.frame(df_v1)
colnames(df_v2) <- c("t", "y")
df <- na.omit(df_v2)


df$min <- floor(df$t /60) + 1
mins_of_interest_df <- subset(df, df$min %in% ref_df$min)
list_of_mins <- split(mins_of_interest_df, mins_of_interest_df$min)


pdf("plot.pdf",w=16,h=9)
lapply(list_of_mins, function(sdf){
		title <- sdf$min[1]
		plot(y ~ t,sdf, type='l', col="blue", lwd=2,main=title)
	})
dev.off()


#list of results from methods and ggplot generation
results <- list(
	meth_first = apply_freq_meth(chunks=list_of_mins, my_freq_fun, fs=5),
	meth_runmed51 = apply_freq_meth(chunks=list_of_mins, my_freq_fun_runmed, fs=5, k=51),
	meth_runmed11 = apply_freq_meth(chunks=list_of_mins, my_freq_fun_runmed, fs=5, k=11)
	)
	


#ref_df <- cbind(ref_df, as.data.frame(results))


tmp_df <- data.frame( 
	method=rep(names(results),sapply(results,length)),
	fc=do.call('c',results),
	min=ref_df$min
	)
	

long_df <- merge(ref_df, tmp_df)
	

ymax <- max(long_df$fc)
xmax <- max(long_df$of)
	
	
plt <- ggplot(long_df,aes(y = fc, x =of,colour=method,shape=method)) +
geom_point() + geom_smooth(method="lm", fill=NA) + 
coord_cartesian(xlim = c(0, xmax+0.25), ylim = c(0, ymax+0.25)) +
geom_abline(group=1, colour="grey")


x=seq(from=0, to=xmax, by=1)
y <- x


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

plot(freq1 ~ of, ref_df, pch=as.character(q), col=q)
mod <- lm(freq1 ~ of, ref_df)

test <- list_of_mins[[1]]
plot(y ~ t,test, type='l')
test$low_comp <- runmed(test$y,k=51)
lines(low_comp ~ t,test, col="red")
test$high_comp <- test$y - test$low_comp
plot(high_comp ~ t,test, type='l')

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
