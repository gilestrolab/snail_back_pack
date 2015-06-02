

DATA_FILE <- "~/Documents/heart_021.csv"  #####change file name here
SAMPLING_FREQUENCY <- 5 # in Hz


#####interpolation
heterogeneous_df <- read.csv(DATA_FILE, head=F)
colnames(heterogeneous_df) <- c("t", "y")
df_v1 <- approx(x=heterogeneous_df$t, y=heterogeneous_df$y, xout=heterogeneous_df$t, method='linear')
df_v2 <- data.frame(df_v1)
colnames(df_v2) <- c("t", "y")
df <- na.omit(df_v2)


######pdf generation
df$min <- round(df$t /60)
ldf <- split(df, df$min)
pdf("heartsignal_21.pdf",w=16,h=9)  #####change pdf name here
par(mfrow=c(2,1))
for(d in ldf){
h <- round(d$t[1] / 3600,3)
title <- paste0("Starts at h = ", h)
print(title)
plot(y ~ t, d, type='l', main=title)

}
dev.off()
