# CSGC-algorithm

## Overview
The ​**Consensus Scoring of Genes in Cascade (CSGC)**​ algorithm identifies candidate genes involved in the DSS1-mediated autophagy-metastasis cascade. This document outlines the computational framework and scoring logic.

## Algorithm Workflow

### 1. Candidate Transcription Factors (TFs)
EMT-inducing TFs considered:
```plaintext
ZEB1/2, SNAI1/2, TWIST1, CTNNB1, FOXC1/2, TCF3, KLF8
```

### 2. Selection Criteria
#### A. Differential Expression
- Calculated using DESeq2 (RNA-seq data from TCGA-KIRC)
- Requirement: 
  - log₂FoldChange (FC) > 0 in ccRCC/metastatic ccRCC

#### B. Pathway Correlations
Three correlation requirements (Spearman's Coef):
1. Positive correlation with DSS1 expression
2. Positive correlation with EMT pathway activity 
   - (ssGSEA using MSigDB EMT gene set v2022.1)
3. Negative correlation with autophagy pathway activity
   - (ssGSEA using MSigDB autophagy gene set v2022.1)

### 3. Consensus Scoring Formula
## Formula Specification
### Core Equation
<img src="https://latex.codecogs.com/svg.image?CSGC_i&space;=&space;(FC_{i1}&space;&plus;&space;FC_{i2})&space;\times&space;\sum_{n}^{j_1}&space;(Coef_{i,j}&space;\times&space;Sign_{i,j})" title="CSGC Formula" width="500"/>

### Symbol Definitions
| Component     | Description                                  | Data Source               |
|---------------|----------------------------------------------|---------------------------|
| `FC_{i1}`     | Fold Change (Primary condition)              | DESeq2 (TCGA-KIRC RNA-seq)|
| `FC_{i2}`     | Fold Change (Metastasis condition)           | DESeq2 (TCGA-KIRC RNA-seq)|
| `Coef_{i,j}`  | Spearman correlation coefficient             | ssGSEA pathway activities |
| `Sign_{i,j}`  | Directional enforcement operator (1/-1)      | Hypothesis validation     |

---


## Implementation Notes
1. ​**Data Sources**
   - Transcriptome: TCGA-KIRC (DESeq2-normalized log2CPM)
   - Pathway gene sets: MSigDB v2022.1

2. ​**Analytical Recommendations**
   ```plaintext
   Preferred: Proteomics-based analysis (superior to transcriptome for pathway activity)
   Current Implementation: Transcriptome-based (DESeq2 + ssGSEA)
   ```

3. ​**Validation Requirements**
   - Experimental confirmation of TF-EMT relationships
   - Proteomic validation of autophagy-EMT crosstalk
   ```

## Repository Structure
```
├── data/               # TCGA-KIRC input files
├── scripts/            # DESeq2 and ssGSEA pipelines
├── results/            # CSGC scores and correlation outputs
└── docs/               # Methodology details
```

## Citation
Please cite this work when using the CSGC algorithm. 
