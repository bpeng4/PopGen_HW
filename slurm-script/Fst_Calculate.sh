---
title: "HW2"
output: html_document
date: "2025-03-10"
name: Bo Peng

output:
  html_document:
    df_print: paged
  word_document: default
---


# A procedure to calculate $\theta$ values

### 3. Calculate the Fst value for each site and visualize the results


```{r, eval=FALSE}
library("data.table")
geno <- fread("largedata/snp_calls.txt", header=FALSE)
geno <- geno[, -27]
names(geno) <- c("chr", "pos", "ref", "alt", "quality", "depth", paste0("l",1:20))


for(i in 5:24){
  # replace slash and everything after it as nothing
  geno$newcol <- gsub("/.*", "", geno[,i] )
  # extract the line name
  nm <- names(geno)[i]
  # assign name for this allele
  names(geno)[ncol(geno)] <- paste0(nm, sep="_a1")
  
  geno$newcol <- gsub(".*/", "", geno[,i] )
  names(geno)[ncol(geno)] <- paste0(nm, sep="_a2")
}
```

---

# A procedure to calculate $\theta$ values

### 3. Calculate the Fst value for each site and visualize the results

#### Compute p1, p2, p

geno[geno == "."] <- NA
```{r, eval=FALSE}
geno$p <- apply(geno[, 25:64], 1, function(x) { sum(x==0)/(sum(x==1) + sum(x=0))})
geno$p <- geno$p/10

geno$p1 <- apply(geno[, 25:46], 1, function(x) {sum(as.numeric(as.character(x)))})
geno$p1 <- geno$p1/6

geno$p2 <- apply(geno[, 47:64], 1, function(x) {sum(as.numeric(as.character(x)))})
geno$p2 <- geno$p2/4
```

Then finally,

```{r, eval=FALSE}
geno$fst <- with(geno, ((p1-p)^2 + (p2-p)^2)/(2*p*(1-p)) )
```

Output the Fst results


```{r, eval=FALSE}
write.table(geno, "cache/fst.csv", sep=",", row.names = FALSE, quote=FALSE)
```

---
# A procedure to calculate $\theta$ values

### 3. Calculate the Fst value for each site and visualize the results

#### Visualize the results on my local computer

```{r, eval=FALSE}
fst <- read.csv("cache/fst.csv")

plot(fst$pos, fst$fst, xlab="Physical position", ylab="Fst value", main="")
```







