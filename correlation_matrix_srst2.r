# copyright (c) 2017 Mitsuhiko Sato. All Rights Reserved.
# Mitsuhiko Sato ( E-mail: mitsuhikoevolution@gmail.com )

arg1 = commandArgs(trailingOnly=TRUE)[1]

data=read.table(paste(arg1,".txt",sep=""), header=T, numerals="no.loss")

library(gplots)
pdf(paste(arg1,".pdf",sep=""), width=12,height=12)
par(bg="transparent")

#If you don't need lightblue histgram on color key, rm commentout on next line and comment out next next line. 


#heatmap.2(as.matrix(signif(data)),trace="none", labRow = colnames(data), key.title = NA, key.xlab = "correlatoin",margins = c(max(nchar(colnames(data)))/3, max(nchar(colnames(data)))/3 ), col = greenred(40))
my_col=colorRampPalette(c("blue","lightblue","white","white","white","yellow","red"))
heatmap.2(as.matrix(signif(data)),trace="none", labRow = colnames(data), key.title = NA, key.xlab = "correlation coefficient",margins = c(max(nchar(colnames(data)))/2, max(nchar(colnames(data)))/2 ), col = my_col(41))



dev.off()

