

DATA_FILE <- "~/Documents/result9.csv"  #####change file name here
SAMPLING_FREQUENCY <- 5 # in Hz


heart_dt <- fread("~/Documents/heart_011.csv")
temp_dt <- fread("~/Documents/temp_011_012.csv")
	
#####interpolation
heterogeneous_df <- read.csv(DATA_FILE, head=F)
colnames(heterogeneous_df) <- c("t", "y", "temp")
df_y <- approx(x=heterogeneous_df$t, y=heterogeneous_df$y, xout=heterogeneous_df$t, method='linear')
df_temp <- approx(x=heterogeneous_df$t, y=heterogeneous_df$temp, xout=heterogeneous_df$t, method='linear')

	out_dt <- data.table(t=df_y$x, y=df_y$y, temp=df_temp$y)
	fin_dt <- na.omit(out_dt)
df_v2 <- data.frame(fin_dt)

df <- na.omit(df_v2)


######pdf generation
df$min <- round(df$t /60)
ldf <- split(df, df$min)
pdf("heartsignal_11.pdf",w=16,h=9)  #####change pdf name here
par(mfrow=c(2,1))
for(d in ldf){
h <- round(d$t[1] / 3600,3)
temp <- mean(d$temp)
title <- paste0("Starts at h = ", h, " Temperature = ", temp)
print(title)
plot(y ~ t, d, type='l', main=title)

}
dev.off()



#####interpolation

colnames(heterogeneous_df) <- c("t", "y")
df_v1 <- approx(x=heterogeneous_df$t, y=heterogeneous_df$y, xout=heterogeneous_df$t, method='linear')
df_v2 <- data.frame(df_v1)
colnames(df_v2) <- c("t", "y")
ldf <- na.omit(df_v2)


######pdf generation
df$min <- round(df$t /60)
ldf <- split(df, df$min)

heterogeneous_df <- read.csv(DATA_FILE, head=F)
colnames(df_v2) <- c("ID", "t", "y", "y")
ldf <- na.omit(df_v2)

pdf("heartsignal_21.pdf",w=16,h=9)  #####change pdf name here
par(mfrow=c(2,1))
for(d in ldf){
h <- round(d$t[1] / 3600,3)
temp <- mean(dt$temp)
title <- paste0("Starts at h = ", h, "Temperature = ", temp)
print(title)
plot(y ~ t, d, type='l', main=title)

}
dev.off()



write.table(test_dt, file = "result9.csv",row.names=FALSE, na="",col.names=FALSE, sep=",")




















heart_dt <- fread("~/Documents/heart_021.csv")
temp_dt <- fread("~/Documents/temp_021_022.csv")


out_t <- seq(from=floor(min(heart_dt$V1)), to=round(max(heart_dt$V1)), by= 1/fs)
	li_heart <- approx(x=heart_dt$V1, y=heart_dt$V2, xout=out_t, method='linear')
	li_temp <- approx(x=temp_dt$V1, y=temp_dt$V2, xout=out_t, method='linear')
	#map here
	out_dt <- data.table(t=li_heart$x, y=li_heart$y, temp=li_temp$y)
	fin_dt <- na.omit(out_dt)

	fin_dt
	

fin_dt <- na.omit(out_dt)
df_v2 <- data.frame(fin_dt)

df <- na.omit(df_v2)


######pdf generation
df$min <- round(df$t /60)
ldf <- split(df, df$min)
pdf("heartsignal_21.pdf",w=16,h=9)  #####change pdf name here
par(mfrow=c(2,1))
for(d in ldf){
h <- round(d$t[1] / 3600,3)
temp <- mean(d$temp)
title <- paste0("Starts at h = ", h, ", Temperature = ", temp)
print(title)
plot(y ~ t, d, type='l', main=title)

}
dev.off()



