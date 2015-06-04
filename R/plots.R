





















py <- plotly()

model <- lm(fc ~ reof + factor(method), data=long_df)
grid <- with(long_df, expand.grid(
  reof = seq(min(reof), max(reof), length = 3),
  method = levels(factor(method))
))

grid$fc <- stats::predict(model, newdata=grid)

viz2 <- qplot(reof, fc, data=long_df, colour=factor(method)) + 
geom_line(data=grid)
out <- py$ggplotly(viz2, kwargs=list(filename="gg-line-scatter", fileopt="overwrite"))
plotly_url <- out$response$url



py <- plotly()

model <- lm(mpg ~ wt + factor(cyl), data=mtcars)
grid <- with(mtcars, expand.grid(
  wt = seq(min(wt), max(wt), length = 20),
  cyl = levels(factor(cyl))
))

grid$mpg <- stats::predict(model, newdata=grid)

viz2 <- qplot(wt, mpg, data=mtcars, colour=factor(cyl)) +
            geom_line(data=grid)
out <- py$ggplotly(viz2, kwargs=list(filename="gg-line-scatter", fileopt="overwrite"))
plotly_url <- out$response$url




pltpspec <- ggplot(long_df,aes(y = fc, x =reof,colour=method,shape=method)) +
	geom_point() + geom_smooth(method="lm", fill=NA) + 
	coord_cartesian(xlim = c(0, xmax+0.25), ylim = c(0, ymax+0.25)) +
	geom_abline(group=1, colour="grey")
















