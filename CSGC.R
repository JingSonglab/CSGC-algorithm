####
#
# This script is to run Consensus Scoring of Genes in Cascade (CSGC) algorithm
#
#  Objects in the CSGC_run.Rdata
#
#  DEdata: the differential expression analysis of genes between primary tumors and normal kidney tissues using DESeq2 based on TCGA-KIRC dataset
#  DEdata2: the differential expression analysis of genes between tumors with distant metastasis and tumors without distant metastasis using DESeq2 based on TCGA-KIRC dataset
#  corrdata: Spearman correlation between candidate TFs and gene signatures (EMT, autophagy) or DSS1 calculated using psych package.
#  signdata: the expected correlation direction between candidate TFs and gene signatures (EMT, autophagy) or DSS1, based on the hypothesis of TFs in the cascade
###

#1. load the objects into R environment
load("CSGC_run.Rdata")

#2. define the function and run CSGC algorithm
CSGCalgorithm = function(DEdata, DEdata2, corrdata, signdata){
  score = NULL
  candgene = NULL
  logFC2 = logFC = NULL
  for (i in 1:ncol(corrdata)){
    emtgene = colnames(corrdata)[i]
    candgene = c(candgene,emtgene)
    logFCi = DEdata$log2FoldChange[which(DEdata$symbol == emtgene)]
    logFCi2 = DEdata2$log2FoldChange[which(DEdata2$symbol == emtgene)]
    logFC = c(logFC, logFCi); logFC2 =  c(logFC2, logFCi2)
    res = 0
    for (j in 1:nrow(corrdata)){
      casgene = rownames(corrdata)[j]
      coefij = corrdata[j,i]
      signij = signdata$sign[j]
      res0 = coefij * signij
      res = res + res0
    }
    scorei = 2^(logFCi2 + logFCi) *  res
    score = c(score, scorei)
  }
  outdata = data.frame(gene = candgene, FC1 = logFC, FC2 = logFC2, CSGCscore = score)
  outdata
}
CSGCscore = CSGCalgorithm(DEdata, DEdata2, corrdata, signdata)
CSGCscore

#3. plot the calculated CSGC scores for candidate genes
#order the genes in the plot that presented in the article figure 4a
CSGCscore$gene = factor(CSGCscore$gene,levels=c("ZEB1","ZEB2","SNAI1","SNAI2","TWIST1",
                                                              "CTNNB1","FOXC2","FOXC1","TCF3","KLF8"))
library(ggplot2)
g = ggplot(CSGCscore, aes(x=gene, y = CSGCscore,fill=gene)) 
g = g + geom_bar(stat = "identity") 
g = g + geom_text(aes(label=round(CSGCscore,3)), hjust = 0.5, vjust=1,  col="black", size = 5)
g = g + theme_bw() +theme(panel.border = element_blank()) + theme(legend.position="none")
g = g + theme(axis.ticks = element_blank()) 
g


###The End
