library(readxl)

data_dir <- "c:/Users/Nys94/Desktop/gravity/data"
file1 <- file.path(data_dir, "삶의_만족도_시도__20260606195059.xlsx")
file2 <- file.path(data_dir, "인구십만명당_자살률_시도_시_군_구__20260606194913.xlsx")

cat("=== File 1: 삶의 만족도 시도 ===\n")
sheets1 <- excel_sheets(file1)
cat("Sheets:", paste(sheets1, collapse = ", "), "\n")
for (s in sheets1) {
  df <- read_excel(file1, sheet = s)
  cat("\nSheet:", s, "\n")
  cat("Dimensions:", dim(df)[1], "rows x", dim(df)[2], "cols\n")
  cat("First 10 rows:\n")
  print(head(df, 10))
  cat("\n" , rep("-", 40), "\n")
}

cat("\n=== File 2: 인구십만명당 자살률 시도 시 군 구 ===\n")
sheets2 <- excel_sheets(file2)
cat("Sheets:", paste(sheets2, collapse = ", "), "\n")
for (s in sheets2) {
  df <- read_excel(file2, sheet = s)
  cat("\nSheet:", s, "\n")
  cat("Dimensions:", dim(df)[1], "rows x", dim(df)[2], "cols\n")
  cat("First 10 rows:\n")
  print(head(df, 10))
  cat("\n" , rep("-", 40), "\n")
}
