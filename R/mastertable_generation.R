rm(list=ls())
library(data.table)
RESULT_DIR <-"~/Documents"
MASTER_FILE <- "~/Documents/snail_back_pack/experiments/snail_temperature_experiment/results/master_table.csv"




makedt_for_animal <- function(subdt, fs=5){

	heart_dt <- fread(subdt$heart_file)
	temp_dt <- fread(subdt$temp_file)
	
	out_t <- seq(from=floor(min(heart_dt$V1)), to=round(max(heart_dt$V1)), by= 1/fs)
	li_heart <- approx(x=heart_dt$V1, y=heart_dt$V2, xout=out_t, method='linear')
	li_temp <- approx(x=temp_dt$V1, y=temp_dt$V2, xout=out_t, method='linear')
	#map here
	out_dt <- data.table(t=li_heart$x, y=li_heart$y, temp=li_temp$y)
	fin_dt <- na.omit(out_dt)


	fin_dt
	
		}



master_table_v1 <- data.table(read.csv(MASTER_FILE, header=T, na.strings=" ", skip=1))
master_table_v2 <- na.omit(master_table_v1[1:16])
master_table_v2[, ID:= as.integer(as.character(ID))]

master_table_v2[, heart_file:= paste(RESULT_DIR,gsub("\\s", "", heart_file),sep="/")]
master_table_v2[, temp_file:= paste(RESULT_DIR,gsub("\\s", "", temp_file),sep="/")]
#FIXME
master_table_v2 <- master_table_v2[ID<23, ]
setkey(master_table_v2,ID)

#TO LOOK AT
main_dt <- master_table_v2[,makedt_for_animal(.SD),by="ID"]
tmin <- floor(main_dt$t /60) + 1
main_dt2 <-cbind(main_dt, data.table(tmin))
main_dt3 <- split(main_dt2, list(main_dt2$ID, main_dt2$tmin))

main_dt4 <- lapply(main_dt3, function(m){
	
	mean_temp <- mean(m$temp)
	sd_temp <- sd(m$temp)
	sd_mean <- cbind(mean_temp, sd_temp)
	main_temp <- cbind(m, sd_mean)
	main_temp
	
})


resu <- main_dt2[ID== 22,list(
			freq = freq_fun_pspec_bwfilter(y,fs=5),
			temp = mean(temp))
			
			,by=c("ID","tmin")]
#testing



test_m <- mean(test$temp)
test_sd <- sd(test$temp)
ntest <- cbind(test, rep(test_m), rep(test_sd))

#TOFIX: some of the main_dt3 subtables don't have 300 values, remove?


meth_pspec_bwfilter = apply_freq_meth(chunks=main_dt3, 
freq_fun_pspec_bwfilter, fs=5) 



plot(freq ~ temp,resu)
> plot(freq ~ tmin,resu)
> plot(temp ~ tmin,resu)
> plot(temp ~ log10(tmin),resu)
> plot(temp ~ tmin,resu)
> plot(temp ~ tmin,resu[tmin>23850600])
tempplt<- plot(temp ~ tmin,resu[tmin>23862200],type='l')
freqplt<- plot(freq ~ tmin,resu[tmin>23862200], type='l')
tfplt<- plot(freq ~ temp,resu[temp>20])




