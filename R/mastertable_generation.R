



















master_table_v1 <- data.table(read.csv("~/Documents/snail_back_pack/experiments/snail_temperature_experiment/results/master_table.csv", header=T, na.strings=" "))
master_table_v2 <- na.omit(master_table_v1[1:16])





pre_temp_1112 <- fread("~/Documents/temp_011_012.csv", sep=",", header=F, data.table=F)

li_11 <- fread("~/Documents/heart_011.csv", sep=",", header=F, data.table=F)
li_12 <- fread("~/Documents/heart_012.csv", sep=",", header=F, data.table=F)




s5_list <- list(li_11, li_12)
s5_bound <- rbindlist(s5_list, use.names=T, fill=T)

df$min <- floor(df$t /60) + 1
mins_of_interest_df <- subset(df, df$min %in% ref_df$min)
list_of_mins <- split(mins_of_interest_df, mins_of_interest_df$min)



apply_freq_meth(chunk=heterogeneous_df, interp_fun, fs=5)


heart_table <- sapply(master_table_v2$heart_file, fread("~/Documents/", sep=",", header=F, data.table=F))



#Error in fread("~/Documents/", sep = ",", header = F, data.table = F) : 
#Opened file ok, obtained its size on disk (0.0MB), but couldn't memory map it. This is a 64bit machine so this is surprising. Please report to datatable-help.
