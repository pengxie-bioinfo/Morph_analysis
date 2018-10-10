library(networkD3)
library(gdata)
library(tidyverse)
library(dplyr)
setwd("~/Documents/Research/Morph_analysis/")
sankey <- function(df1, df2){
  lab <- intersect(rownames(df1), rownames(df2))
  df1 <- df1[lab, 1]
  df2 <- df2[lab, 1]
  udf1 <- unique(df1) %>% sort()
  udf2 <- unique(df2) %>% sort()
  
  df <- data.frame(F_cluster=df1, R_cluster=df2, row.names=lab)
  df["F_cluster"] <- df1
  df["R_cluster"] <- df2
  
  links <- c()
  for(ftype in udf1){
    for(rtype in udf2){
      ct <- sum(df$F_cluster==ftype & df$R_cluster==rtype)
      if(ct>0){
        links <- c(links, ftype, rtype, ct)
      }
    }
  }
  links <- matrix(links, ncol=3, byrow=T) %>% data.frame()
  colnames(links) <- c("source", "target", "value")
  links$value <- as.character(links$value) %>% as.numeric()
  
  nodes=data.frame(name=c(as.character(links$source), as.character(links$target)) %>% unique())
  
  links$IDsource=match(links$source, nodes$name)-1 
  links$IDtarget=match(links$target, nodes$name)-1
  
  # Make the Network
  sankeyNetwork(Links = links, Nodes = nodes,
                Source = "IDsource", Target = "IDtarget",
                Value = "value", NodeID = "name", 
                sinksRight=FALSE, fontSize = 14)
}

fcl <- read.xls("Table/F_cluster.xlsx")
fcl <- data.frame(F_cluster=paste("F", fcl$Louvain+1, sep="_"), row.names = fcl$X)

rcl <- read.xls("Table/R_cluster.xlsx")
rcl <- data.frame(R_cluster=paste("R", rcl$cluster, sep="_"), row.names = rcl$X)

ctp <- read.xls("Table/Global_features.xlsx")
ctp <- data.frame(Type=ctp$Type, row.names = ctp$X)

sankey(fcl, rcl)
sankey(fcl, ctp)
sankey(rcl, ctp)
