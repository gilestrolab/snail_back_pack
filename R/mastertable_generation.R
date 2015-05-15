






pre_temp_1112 <- fread("~/Documents/temp_011_012.csv", sep=",", header=F, data.table=F)

li_11 <- fread("~/Documents/heart_011.csv", sep=",", header=F, data.table=F)















master_table_v1 <- data.table(read.csv("~/Documents/snail_back_pack/experiments/snail_temperature_experiment/results/master_table.csv", header=T, na.strings=" ", skip=1))
master_table_v2 <- na.omit(master_table_v1[1:16])


heart_table <- sapply(master_table_v2$heart_file, fread("~/Documents/", sep=",", header=F, data.table=F))
heart_table <- sapply(master_table_v2$heart_file, function(s){
	fread("~/Documents/"s, sep=",", header=F, data.table=F)
})

DF1 <- NULL
for(file in filecol){
	
	newfile <- gsub("\\s", "", file)
	files <- read.csv(newfile, sep=",", header=F)
	DF1 <- rbind(DF1, files)
}

filecol <- data.table(gsub("\\s", "", master_table_v2$heart_file))


heart_table <- sapply(filecol, read.csv)


files <- list.files(pattern="heart")

DF2 <- NULL
for (f in files) {
   heart_data <- read.csv(f, header=F, sep=",")
   DF2 <- rbind(DF2, data.frame(heart_data))
}

