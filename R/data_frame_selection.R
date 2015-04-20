DATA_FILE <- "/home/quentin/Desktop/ref_data_heart_snail.txt"
SAMPLING_FREQUENCY <- 5 # in Hz


my_freq_fun <- function(y, fs){
	#do something with y
	return(1)
}



#######################################################
ref_df <- read.csv("ref_file.csv", comment.char="#")
heterogeneous_df <- read.csv(DATA_FILE, head=F)
colnames(heterogeneous_df) <- c("t", "y")

# interpolation goes here
# it generates a ned df called `df`


df$min <- floor(df$t /60) + 1
mins_of_interest_df <- subset(df, df$min %in% ref_df$min)
list_of_mins <- split(mins_of_interest_df, mins_of_interest_df$min)


pdf("/tmp/plot.pdf",w=16,h=9)
lapply(list_of_mins, function(sdf){
		title <- sdf$min[1]
		plot(y ~ t,sdf, type='l', col="blue", lwd=2,main=title)
	})
dev.off()


freq_meth1 <- sapply(list_of_mins, function(sdf){
		my_freq_fun_meth1(sdf$y,fs=SAMPLING_FREQUENCY)
	})
	
freq_meth2 <- sapply(list_of_mins, function(sdf){
		my_freq_fun_meth2(sdf$y,fs=SAMPLING_FREQUENCY)
	})
	
ref_df <- cbind(ref_df,freq)

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

