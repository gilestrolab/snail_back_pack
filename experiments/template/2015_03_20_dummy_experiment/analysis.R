library("data.table")
df <- fread("20150313_johnDoe.txt") 

#todo INTERPOLATION/RESAMPLING here

df$min <- round(df$t /60)
ldf <- split(df, df$min)

pdf("visual.pdf",w=16,h=9)
par(mfrow=c(2,1))
for(d in ldf){
	h <- round(d$t[1] / 3600,3)
	title <- paste0("Starts at h = ", h)
	print(title)
	plot(y ~ t, d, type='l', main=title)
	acf(d$y, lag.max=100)
}
dev.off()
