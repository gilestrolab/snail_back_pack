






















#data_temp_file <- "~/Documents/temp_010.csv"
#dtf <- read.csv(data_temp_file, header=F)
#colnames(dtf) <- c("t", "I", "temp")


temp11_12 <- "~/Documents/temp_011_012.csv"
temp_file <- read.csv(temp11_12, header=F)

heart12file <- "~/Documents/heart_012.csv"
heart12 <- read.csv(heart12file, header=F)

heart11file <- "~/Documents/heart_011.csv"
heart11 <- read.csv(heart11file, header=F)


heart11_df <- data.frame(heart11)
heart12_df <- data.frame(heart12)
temp_df <- data.frame(temp_file)
heart_df<- rbind(heart11_df, heart12_df)


colnames(heart12_df) <- c("t", "I")
colnames(temp_df) <- c("t", "temp")


#out_t <- seq(from=0, to=max(i_df$V2), by=1/5)
df_v1 <- approx(x=temp_df$t, y=temp_df$temp, xout=round(heart12_df$t), method='linear')
df_v2 <- data.frame(df_v1)
colnames(df_v2) <- c("t", "temp")
temp_interp_df <- na.omit(df_v2)
plot(temp_interp_df, type='l')






##############
t_T <- seq(from=0.001, to=1000, by=30)
T <- seq(from=25, to=30, length.out=length(t_T))
T_df <- data.frame(cbind(round(t_T), T))


t_I <- seq(from=0, to=1000, by=1/5)
beats <- sin(seq(from=0,to=40*2*pi,length.out=length(t_I)))
I_df <- data.frame(cbind(t_I, beats))


#~ out_t <- seq(from=0, to=max(I_df$t_I), by=1/5)
#~ df_v1 <- approx(x=T_df$V1, y=T_df$T, xout=out_t, method='linear')
ap <- approx(x=t_T, y=T, xout=I_df$t_I, method='linear')
df_v2 <- data.frame(df_v1)
colnames(df_v2) <- c("t", "T")
df <- na.omit(df_v2)
plot(df, type='l')











heart12file <- "~/Documents/heart_012.csv"
heart12 <- read.csv(heart12file, header=F)

heart12_df <- data.frame(heart12)


heart11file <- "~/Documents/heart_011.csv"
heart11 <- read.csv(heart11file, header=F)

heart11_df <- data.frame(heart11)












