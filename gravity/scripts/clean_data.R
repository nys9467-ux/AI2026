library(readxl)
library(dplyr)
library(tidyr)
library(stringr)

data_dir <- "c:/Users/Nys94/Desktop/gravity/data"
file1 <- file.path(data_dir, "삶의_만족도_시도__20260606195059.xlsx")
file2 <- file.path(data_dir, "인구십만명당_자살률_시도_시_군_구__20260606194913.xlsx")

# --- 1. Clean Life Satisfaction Data ---
df1 <- read_excel(file1, sheet = "데이터")

# Row 1 has sub-headers: 계, 매우 만족, 약간 만족, 보통, 약간 불만족, 매우 불만족
col_categories <- as.character(df1[1, ])
# Columns 1 to 3 are headers, columns 4 to 33 are data
# Years are 2020, 2021, 2022, 2023, 2024
years1 <- rep(2020:2024, each = 6)
names(df1)[1:3] <- c("region", "group1", "group2")

# Rename columns to Year_Category
for (i in 4:33) {
  year <- years1[i - 3]
  cat_name <- col_categories[i]
  names(df1)[i] <- paste0("Y", year, "_", cat_name)
}

# Clean data rows
df1_clean <- df1[-1, ] %>% 
  fill(region) %>% 
  fill(group1) %>% 
  filter(group1 == "전체" & group2 == "계") %>% 
  select(-group1, -group2)

# Convert all data columns to numeric
df1_clean <- df1_clean %>% 
  mutate(across(starts_with("Y2"), as.numeric))

# Clean Region Names
std_region <- function(x) {
  x <- str_trim(x)
  case_when(
    x == "전국" ~ "전국",
    x == "서울특별시" ~ "서울",
    x == "부산광역시" ~ "부산",
    x == "대구광역시" ~ "대구",
    x == "인천광역시" ~ "인천",
    x == "광주광역시" ~ "광주",
    x == "대전광역시" ~ "대전",
    x == "울산광역시" ~ "울산",
    x == "세종특별자치시" ~ "세종",
    x == "경기도" ~ "경기",
    x == "강원특별자치도" ~ "강원",
    x == "충청북도" ~ "충북",
    x == "충청남도" ~ "충남",
    x %in% c("전북특별자치도", "전라북도") ~ "전북",
    x == "전라남도" ~ "전남",
    x == "경상북도" ~ "경북",
    x == "경상남도" ~ "경남",
    x %in% c("제주특별자치도", "제주도") ~ "제주",
    TRUE ~ x
  )
}

df1_clean <- df1_clean %>% 
  mutate(region = std_region(region))

cat("--- Cleaned Life Satisfaction Data (First 5 rows) ---\n")
print(head(df1_clean, 5))

# --- 2. Clean Suicide Rate Data ---
df2 <- read_excel(file2, sheet = "데이터")
col_categories2 <- as.character(df2[1, ])
names(df2)[1] <- "region"
years2 <- rep(2020:2024, each = 3)

for (i in 2:16) {
  year <- years2[i - 1]
  cat_name <- col_categories2[i]
  names(df2)[i] <- paste0("Y", year, "_suicide_", cat_name)
}

df2_clean <- df2[-1, ] %>% 
  mutate(region = std_region(region)) %>% 
  mutate(across(starts_with("Y2"), as.numeric))

cat("\n--- Cleaned Suicide Rate Data (First 5 rows) ---\n")
print(head(df2_clean, 5))

# --- 3. Save to workspace for correlation script ---
# We can create a long format dataframe that combines both for easy plotting and correlation
# For each region and year, we want:
# - Region, Year
# - Satisfaction rate (매우 만족 + 약간 만족)
# - Average Satisfaction Score (weighted)
# - Dissatisfaction rate (매우 불만족 + 약간 불만족)
# - Suicide rate (Total, Male, Female)

# Pivot Satisfaction Data to Long
df1_long <- df1_clean %>% 
  pivot_longer(
    cols = starts_with("Y2"),
    names_to = c("year", "category"),
    names_pattern = "Y(\\d{4})_(.*)",
    values_to = "pct"
  ) %>% 
  mutate(year = as.integer(year))

# Calculate satisfaction index per year/region
df1_summary <- df1_long %>% 
  group_by(region, year) %>% 
  summarise(
    sat_rate = sum(pct[category %in% c("매우 만족", "약간 만족")], na.rm = TRUE),
    unsat_rate = sum(pct[category %in% c("매우 불만족", "약간 불만족")], na.rm = TRUE),
    # Weighted average: 매우 만족 = 5, 약간 만족 = 4, 보통 = 3, 약간 불만족 = 2, 매우 불만족 = 1
    avg_score = (
      sum(pct[category == "매우 만족"] * 5, na.rm = TRUE) +
      sum(pct[category == "약간 만족"] * 4, na.rm = TRUE) +
      sum(pct[category == "보통"] * 3, na.rm = TRUE) +
      sum(pct[category == "약간 불만족"] * 2, na.rm = TRUE) +
      sum(pct[category == "매우 불만족"] * 1, na.rm = TRUE)
    ) / 100,
    .groups = "drop"
  )

# Pivot Suicide Data to Long
df2_long <- df2_clean %>% 
  pivot_longer(
    cols = starts_with("Y2"),
    names_to = c("year", "gender"),
    names_pattern = "Y(\\d{4})_suicide_(.*)",
    values_to = "suicide_rate"
  ) %>% 
  mutate(year = as.integer(year))

df2_summary <- df2_long %>% 
  pivot_wider(
    names_from = gender,
    names_prefix = "suicide_",
    values_from = suicide_rate
  )

# Merge
merged_df <- inner_join(df1_summary, df2_summary, by = c("region", "year"))

cat("\n--- Merged Data (First 10 rows) ---\n")
print(head(merged_df, 10))

# Save the cleaned data to CSV in the scratch directory
write.csv(merged_df, "C:/Users/Nys94/.gemini/antigravity/brain/d7380ecf-af3d-4a1b-bafa-c915003cc7a6/scratch/cleaned_data.csv", row.names = FALSE)
