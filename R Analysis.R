R Analysis
1. Installation
Install CRAN Packages

install.packages(c("openxlsx", "writexl"))

Install Bioconductor Packages

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install(c(
  "clusterProfiler",
  "org.Hs.eg.db",
  "enrichplot",
  "ReactomePA"
))

2. Load Required Libraries

library(clusterProfiler)
library(org.Hs.eg.db)
library(enrichplot)
library(ReactomePA)
library(openxlsx)
library(writexl)

3. Input Gene List

gene_symbols <- c(
  "NFKB1", "TNF", "CCL2", "IL2", "IFNA1",
  "CXCL10", "IL10", "CD4", "TLR4", "CXCL8",
  "IL1B", "IL18", "IL1A", "IL4", "IFNG",
  "IL6", "CSF2", "CD8A", "IL17A", "STAT3"
)

4. Convert SYMBOL → ENTREZ ID

gene_entrez <- bitr(
  gene_symbols,
  fromType = "SYMBOL",
  toType   = "ENTREZID",
  OrgDb    = org.Hs.eg.db
)

5. Enrichment Analysis
GO Enrichment

go_results <- enrichGO(
  gene          = gene_entrez$ENTREZID,
  OrgDb         = org.Hs.eg.db,
  keyType       = "ENTREZID",
  ont           = "ALL",
  pAdjustMethod = "BH",
  pvalueCutoff  = 0.05,
  qvalueCutoff  = 0.2
)

KEGG Pathway Enrichment

kegg_results <- enrichKEGG(
  gene         = gene_entrez$ENTREZID,
  organism     = "hsa",
  pvalueCutoff = 0.05
)

Reactome Pathway Enrichment

reactome_results <- enrichPathway(
  gene         = gene_entrez$ENTREZID,
  organism     = "human",
  pvalueCutoff = 0.05,
  readable     = TRUE
)

6. Export All Results to Excel

write.xlsx(
  list(
    GO_Enrichment       = as.data.frame(go_results),
    KEGG_Enrichment     = as.data.frame(kegg_results),
    Reactome_Enrichment = as.data.frame(reactome_results)
  ),
  file = "Enrichment_Results.xlsx"
)


