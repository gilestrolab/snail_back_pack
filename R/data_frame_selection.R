rm(list=ls())
DATA_FILE <- "/home/alysia/Documents/ref_data_heart_snail.txt"
SAMPLING_FREQUENCY <- 5 # in Hz


my_freq_fun <- function(y, fs, ...){
	sp <- seewave::spec(y,f=fs)
	f <- seewave::fpeaks(sp, f=fs,nmax=1)
	return(f[1,1])
}



#######################################################
ref_df <- read.csv("ref.csv", comment.char="#")
heterogeneous_df <- read.csv(DATA_FILE, head=F)
colnames(heterogeneous_df) <- c("t", "y")


# interpolation goes here
# it generates a ned df called `df`
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


freq_meth1 <- sapply(list_of_mins, function(sdf){
		sp <- seewave::spec(sdf$y,f=SAMPLING_FREQUENCY)
		f <- seewave::fpeaks(sp, f=SAMPLING_FREQUENCY,nmax=1)
	})


freqdf1 <- data.frame(freq_meth1)
freq1 <- sapply(freqdf1, "[", 1)
ref_df <- cbind(ref_df,freq1)


freq_meth2 <- sapply(list_of_mins, k=51, function(sdf, k){
		low_c <- runmed(sdf$y, k)
		sp <- seewave::spec(low_c,f=SAMPLING_FREQUENCY)
		f <- seewave::fpeaks(sp, f=SAMPLING_FREQUENCY,nmax=1)
		f*1000
	})

	
freqdf2 <- data.frame(freq_meth2)
freq2 <- sapply(freqdf2, "[", 1)
ref_df <- cbind(ref_df,freq2)


plot(freq1 ~ of, ref_df, pch=as.character(q), col=q)
mod <- lm(freq1 ~ of, ref_df

test <- list_of_mins[[1]]
plot(y ~ t,test, type='l')
test$low_comp <- runmed(test$y,k=51)
lines(low_comp ~ t,test, col="red")
test$high_comp <- test$y - test$low_comp
plot(high_comp ~ t,test, type='l')

#diff(list_of_mins[[1]]$t)
#table(diff(list_of_mins[[1]]$t))


#~ #split data frames
#~ df$min <- round(df$V1 /60)
#~ ldf <- split(df, df$min)
#~ for(d in ldf){
#~ h <- round(d$V1[1] / 3600,3)
#~ acf(d$V2, lag.max=100)
#~ }
#~ dev.off
#~ 
#~ 
#~ #chosen data frame sets (TODO: put dsets into csv file)
#~ dsets <- c(0.042, 0.158, 0.342, 1.008, 1.325, 1.342, 2.125, 2.142, 3.475, 4.458, 4.475, 4.792, 4.808, 6.175, 6.325, 6.458, 7.108, 7.442, 7.658, 8.125, 8.575, 9.598, 9.125, 9.542, 9.575, 9.592, 9.775, 9.908, 9.942, 10.592, 69.458)
#~ 
#~ for(d in ldf){
#~ h <- round(d$V1[1] / 3600,3)
#~ for(x in dsets){
#~ if (h == x) {
#~ print(d)
#~ }
#~ } 
#~ }
#~ 
#~ 
#~ #generate csv file with chosen data frames
#~ orig <- file("original.csv")
#~ sink(orig, append=TRUE)
#~ sink(orig, append=TRUE, type="message")
#~ 
#~ source("extract_dsets.R", echo=TRUE, max.deparse.length=10000)
#~ 
#~ sink()
#~ sink(type="message")
#~ 
#~ 
#~ #reads into terminal
#~ orig <- read.csv(file="original.csv", header=FALSE, sep="")
#~ df2 <- na.omit(orig)
#~ 
#~ 
#~ #deletes first column (old index position?) and renames the columns to compensate for the shift (most likely there is a more efficient way to do this)
#~ df2$V1 <- NULL
#~ names(df2)[1] <- "V1" #time(sec)
#~ names(df2)[2] <- "V2" #light intensity
#~ names(df2)[3] <- "V3" #time(min-round)

