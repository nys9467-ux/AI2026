library(dplyr)

csv_path <- "C:/Users/Nys94/.gemini/antigravity/brain/d7380ecf-af3d-4a1b-bafa-c915003cc7a6/scratch/cleaned_data.csv"
df <- read.csv(csv_path)

df_regions <- df %>% filter(region != "전국")

cat("=== Annual Means and SDs (Regional Average) ===\n")
summary_stats <- df_regions %>%
  group_by(year) %>%
  summarise(
    mean_sat_rate = mean(sat_rate),
    sd_sat_rate = sd(sat_rate),
    mean_avg_score = mean(avg_score),
    sd_avg_score = sd(avg_score),
    mean_suicide = mean(suicide_계),
    sd_suicide = sd(suicide_계),
    .groups = "drop"
  )
print(summary_stats)

cat("\n=== National values (전국) ===\n")
print(df %>% filter(region == "전국") %>% select(year, sat_rate, avg_score, suicide_계, suicide_남자, suicide_여자))

cat("\n=== Top 3 & Bottom 3 Regions for Suicide Rate in 2024 ===\n")
df_2024 <- df_regions %>% filter(year == 2024)
cat("Top 3 suicide rates:\n")
print(df_2024 %>% arrange(desc(suicide_계)) %>% head(3) %>% select(region, suicide_계, avg_score))
cat("Bottom 3 suicide rates:\n")
print(df_2024 %>% arrange(suicide_계) %>% head(3) %>% select(region, suicide_계, avg_score))

cat("\n=== Top 3 & Bottom 3 Regions for Life Satisfaction in 2024 ===\n")
cat("Top 3 satisfaction scores:\n")
print(df_2024 %>% arrange(desc(avg_score)) %>% head(3) %>% select(region, suicide_계, avg_score))
cat("Bottom 3 satisfaction scores:\n")
print(df_2024 %>% arrange(avg_score) %>% head(3) %>% select(region, suicide_계, avg_score))
