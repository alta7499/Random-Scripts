#WD, prefix and source file must be change accordingly
setwd("~/result")
prefix="25pop.SEA-EA"
source("plotting_funcs.R")

#Phylogenetic Tree
for(i in 0:10){
png(paste("Tree",i,".png"), width=2400, height=2000, res=300)
plot_tree(cex=0.8,paste0(prefix,".",i))
title(paste(i,"Migration"))
dev.off()
}

#Residual Plot, MergedPopulation.poporder is a file containing list of population
for(i in 0:10){
png(paste("Residual",i,".png"), width=2400, height=2000, res=300)
plot_resid(stem=paste0(prefix,".",i),pop_order="pop.order")
dev.off()
}

