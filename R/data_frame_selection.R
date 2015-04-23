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



results <- list(
	#meth_runmed51 = apply_freq_meth(chunks=list_of_mins, my_freq_fun_runmed, fs=5, k=51),
	meth_runmed12 = apply_freq_meth(chunks=list_of_mins, my_freq_fun_runmed, fs=5, k=12),
	#meth_runmed37 = apply_freq_meth(chunks=list_of_mins, my_freq_fun_runmed, fs=5, k=37),
	#meth_runmed43 = apply_freq_meth(chunks=list_of_mins, my_freq_fun_runmed, fs=5, k=43),
	meth_first = apply_freq_meth(chunks=list_of_mins, my_freq_fun, fs=5)
	)


#ref_df <- cbind(ref_df, as.data.frame(results))

tmp_df <- data.frame( 
	
	method=rep(names(results),sapply(results,length)),
	fc=do.call('c',results),
	min=ref_df$min
	
	)
	
long_df <- merge(ref_df, tmp_df)
	
	
ggplot(long_df,aes(y = fc, x =of,colour=method,shape=method)) +
geom_point() + geom_smooth(method="lm", fill=NA)




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
