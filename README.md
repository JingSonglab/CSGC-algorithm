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
For each candidate TF (TFi):

<p align="center">
  <img src="https://latex.codecogs.com/svg.image?CSGC(TF_i)&space;=&space;\sum_{j=1}^{n}&space;\left(&space;\frac{FC(TF_i)}{\max(FC)}&space;\times&space;Coef_j(TF_i)&space;\times&space;Sign_j&space;\right)&space;" title="Scoring Formula" />
</p>

**Variables:**
- `j`: Elements of DSS1-related cascade (DSS1, autophagy, EMT)
- `Sign_j`: Logical operator (1 if expected correlation direction observed, -1 otherwise)

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
