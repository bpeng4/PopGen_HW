# A procedure to calculate $\theta$ values
### 3. Calculate the Fst value for each site and visualize the results

library("data.table")
geno <- fread("/work/agro932/bpeng4/PopGen_HW/largedata/snp_calls.txt", header=FALSE)
names(geno) <- c("chr", "pos", "ref", "alt", "quality", "depth", 
                 "SRR11119156", "SRR11119158", "SRR11119163", "SRR11119168", 
                        "SRR11119169", "SRR11119186", "SRR11119187", "SRR11119188", 
                        "SRR11119189", "SRR11119190")
setDT(geno)

for(i in 7:16){
  # Extract the column name
  nm <- names(geno)[i]
  
  # Create new columns for each allele
  geno[[paste0(nm, "_a1")]] <- gsub("/.*", "", geno[[i]])  # First allele
  geno[[paste0(nm, "_a2")]] <- gsub(".*/", "", geno[[i]])  # Second allele
}

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
