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

# Calculate overall allele frequency (p)
geno$p <- apply(geno[, 17:36], 1, function(x) {
  x <- as.numeric(as.character(x))  # Ensure numeric conversion
  sum(x == 0) / length(x)           # Frequency of allele 0
})

# Calculate allele frequencies for two subpopulations
geno$p1 <- apply(geno[, 17:26], 1, function(x) {
  x <- as.numeric(as.character(x))
  sum(x) / length(x)  # Frequency of allele 1
})

geno$p2 <- apply(geno[, 27:36], 1, function(x) {
  x <- as.numeric(as.character(x))
  sum(x) / length(x)  # Frequency of allele 1
})

# Compute Fst using a standard formula
geno$fst <- with(geno, ((p1 - p)^2 + (p2 - p)^2) / ((p1 * (1 - p1) + p2 * (1 - p2)) / 2))

# Replace NaN or infinite values (in case of division by zero)
geno$fst[is.na(geno$fst) | is.infinite(geno$fst)] <- 0


#Output the Fst results

write.table(geno, "/work/agro932/bpeng4/PopGen_HW/cache/fst.csv", sep=",", row.names = FALSE, quote=FALSE)

#### Visualize the results
fst <- read.csv("/work/agro932/bpeng4/PopGen_HW/cache/fst.csv")

plot(fst$pos, fst$fst, xlab="Physical position", ylab="Fst value", main="")
