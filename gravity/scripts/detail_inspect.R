library(readxl)

data_dir <- "c:/Users/Nys94/Desktop/gravity/data"
file1 <- file.path(data_dir, "삶의_만족도_시도__20260606195059.xlsx")
file2 <- file.path(data_dir, "인구십만명당_자살률_시도_시_군_구__20260606194913.xlsx")

df1 <- read_excel(file1, sheet = "데이터")
cat("File 1 - Top 3 rows:\n")
print(as.data.frame(df1[1:3, 1:15]))

df2 <- read_excel(file2, sheet = "데이터")
cat("\nFile 2 - Top 3 rows:\n")
print(as.data.frame(df2[1:3, 1:10]))
