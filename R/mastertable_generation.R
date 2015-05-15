rm(list=ls())
RESULT_DIR <-"~/Documents"
MASTER_FILE <- "~/Documents/snail_back_pack/experiments/snail_temperature_experiment/results/master_table.csv"




makedt_for_animal <- function(subdt, fs=5){

	heart_dt <- fread(subdt$heart_file)
	temp_dt <- fread(subdt$temp_file)
	
	out_t <- seq(from=floor(min(heart_dt$V1)), to=round(max(heart_dt$V1)), by= 1/fs)
	li_heart <- approx(x=heart_dt$V1, y=heart_dt$V2, xout=out_t, method='linear')
	li_temp <- approx(x=temp_dt$V1, y=temp_dt$V2, xout=out_t, method='linear')
	#map here
	out_dt <- data.table(t=li_heart$x, l=li_heart$y, temp=li_temp$y)
	fin_dt <- na.omit(out_dt)


	fin_dt
	
		}


makedt_for_animal_interp <- function(subdt){

	heart_dt <- fread(subdt$heart_file)
	temp_dt <- fread(subdt$temp_file)

	interp_heart <- interp_fun(heart_dt, fs=5)
	interp_temp <- interp_fun(temp_dt, fs=5)
	li <- merge(interp_temp, interp_heart, by="t")
	return(li)
	}


master_table_v1 <- data.table(read.csv(MASTER_FILE, header=T, na.strings=" ", skip=1))
master_table_v2 <- na.omit(master_table_v1[1:16])
master_table_v2[, ID:= as.integer(as.character(ID))]

master_table_v2[, heart_file:= paste(RESULT_DIR,gsub("\\s", "", heart_file),sep="/")]
master_table_v2[, temp_file:= paste(RESULT_DIR,gsub("\\s", "", temp_file),sep="/")]
#FIXME
master_table_v2 <- master_table_v2[ID<13, ]
setkey(master_table_v2,ID)


test <- master_table_v2[,makedt_for_animal(.SD),by=ID]
test <- master_table_v2[,makedt_for_animal(.SD),by=c("ID","t_m")]


li <- list(test1, test2, test3)
test <- rbindlist(li, fill=T)

master_table_v2[test]






#Notes: combine function makedt fun into one, arguments into list/table/etc.  
