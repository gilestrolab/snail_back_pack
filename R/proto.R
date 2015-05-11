rm(list=ls())
library(seewave)
library(psd)
library(mFilter)
source("~/Documents/snail_back_pack/R/funs.R")
DATA_FILE <- "/home/alysia/Documents/snail_back_pack/R/ref_data_heart_snail.txt"
REF_FILE <- "/home/alysia/Documents/ref.csv"
SAMPLING_FREQUENCY <- 5 # in Hz





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



nDATA_FILE <- "/home/alysia/Documents/snail_back_pack/R/ref_data_heart_snail.txt"
nREF_FILE <- "/home/alysia/Documents/nref.csv"
SAMPLING_FREQUENCY <- 5 # in Hz





#######################################################
nref_df <- read.csv(nREF_FILE, comment.char="#")
nheterogeneous_df <- read.csv(nDATA_FILE, head=F)
colnames(nheterogeneous_df) <- c("t", "y")


# interpolation, generates df
nout_t <- seq(from=0, to=max(nheterogeneous_df$t), by= 1/SAMPLING_FREQUENCY)
ndf_v1 <- approx(x=nheterogeneous_df$t, y=nheterogeneous_df$y, xout=nout_t, method='linear')
ndf_v2 <- data.frame(ndf_v1)
colnames(ndf_v2) <- c("t", "y")
ndf <- na.omit(ndf_v2)


ndf$min <- floor(ndf$t /60) + 1
nmins_of_interest_df <- subset(ndf, ndf$min %in% nref_df$min)
nlist_of_mins <- split(nmins_of_interest_df, nmins_of_interest_df$min)







