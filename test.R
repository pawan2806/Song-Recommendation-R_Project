A <- matrix(
  c(1, 2, 3, 4, 5, 6, 7, 8, 9),
  nrow = 9,            
  ncol = 2,            
  byrow = FALSE         
)
for(var in 1:9) {
    A[var, 2] <- "gg"
}
cat("The 3x3 matrix:\n")
print(A)