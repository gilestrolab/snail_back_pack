rm(list=ls())
RESULT_DIR <-"~/Documents"
MASTER_FILE <- "~/Documents/snail_back_pack/experiments/snail_temperature_experiment/results/master_table.csv"













makedt_for_animal <- function(subdt){

	heart_dt <- fread(subdt$heart_file)
	temp_dt <- fread(subdt$temp_file)
	##interpolation goes here
	
	heart_dt
	
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

master_table_v2[test]
