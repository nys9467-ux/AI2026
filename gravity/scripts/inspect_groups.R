library(readxl)
library(dplyr)
library(tidyr)

data_dir <- "c:/Users/Nys94/Desktop/gravity/data"
file1 <- file.path(data_dir, "삶의_만족도_시도__20260606195059.xlsx")
file2 <- file.path(data_dir, "인구십만명당_자살률_시도_시_군_구__20260606194913.xlsx")

df1 <- read_excel(file1, sheet = "데이터")
# Fill NA in first column
df1_clean <- df1 %>% 
  fill(`행정구역별(1)`)

cat("File 1 unique 특성별(1):\n")
print(unique(df1_clean$`특성별(1)`))

cat("\nFile 1 unique regions (행정구역별(1)):\n")
print(unique(df1_clean$`행정구역별(1)`))

df2 <- read_excel(file2, sheet = "데이터")
cat("\nFile 2 unique regions (행정구역별(1)):\n")
print(unique(df2$`행정구역별(1)`))
