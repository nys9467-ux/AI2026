library(dplyr)
library(ggplot2)
library(tidyr)

# Load data
csv_path <- "C:/Users/Nys94/.gemini/antigravity/brain/d7380ecf-af3d-4a1b-bafa-c915003cc7a6/scratch/cleaned_data.csv"
df <- read.csv(csv_path)

# Filter out "전국" (National) for regional correlation analysis
df_regions <- df %>% filter(region != "전국")
df_national <- df %>% filter(region == "전국")

cat("=== 1. Overall Correlation (excluding '전국') ===\n")
# Pearson correlation
cor_avg_suicide <- cor.test(df_regions$avg_score, df_regions$suicide_계)
print(cor_avg_suicide)

cor_sat_suicide <- cor.test(df_regions$sat_rate, df_regions$suicide_계)
cat("\nCorrelation between Satisfaction Rate & Suicide Rate:\n")
print(cor_sat_suicide)

cor_unsat_suicide <- cor.test(df_regions$unsat_rate, df_regions$suicide_계)
cat("\nCorrelation between Unsatisfaction Rate & Suicide Rate:\n")
print(cor_unsat_suicide)

cat("\n=== 2. Correlation by Year ===\n")
by_year_cor <- df_regions %>%
  group_by(year) %>%
  summarise(
    n = n(),
    cor_avg_score = cor(avg_score, suicide_계),
    p_val_avg = cor.test(avg_score, suicide_계)$p.value,
    cor_sat_rate = cor(sat_rate, suicide_계),
    p_val_sat = cor.test(sat_rate, suicide_계)$p.value,
    cor_unsat_rate = cor(unsat_rate, suicide_계),
    p_val_unsat = cor.test(unsat_rate, suicide_계)$p.value,
    .groups = "drop"
  )
print(by_year_cor)

cat("\n=== 3. Correlation by Gender ===\n")
cor_male <- cor.test(df_regions$avg_score, df_regions$suicide_남자)
cor_female <- cor.test(df_regions$avg_score, df_regions$suicide_여자)
cat("\nMale Suicide Rate vs Satisfaction Score:\n")
print(cor_male)
cat("\nFemale Suicide Rate vs Satisfaction Score:\n")
print(cor_female)

# --- 4. Plot Generation ---
# Set up Korean font for Windows
windowsFonts(Malgun = windowsFont("Malgun Gothic"))

artifact_dir <- "C:/Users/Nys94/.gemini/antigravity/brain/d7380ecf-af3d-4a1b-bafa-c915003cc7a6"

# Plot 1: Scatter Plot of Avg Score vs Suicide Rate (with Trendline)
p1 <- ggplot(df_regions, aes(x = avg_score, y = suicide_계)) +
  geom_point(aes(color = as.factor(year)), size = 3, alpha = 0.8) +
  geom_smooth(method = "lm", col = "#E74C3C", fill = "#FADBD8", size = 1.2) +
  labs(
    title = "삶의 만족도 평균 점수 vs 자살률 상관관계 (2020-2024)",
    subtitle = paste("전체 상관계수(r) =", round(cor_avg_suicide$estimate, 3), 
                     " (p =", format.pval(cor_avg_suicide$p.value, digits = 3), ")"),
    x = "삶의 만족도 평균 점수 (5점 만점)",
    y = "인구 10만 명당 자살률 (명)",
    color = "연도"
  ) +
  theme_minimal(base_family = "Malgun") +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(size = 11, hjust = 0.5, color = "gray30"),
    axis.title = element_text(size = 11),
    legend.position = "right"
  )

ggsave(file.path(artifact_dir, "plot_sat_vs_suicide.png"), plot = p1, width = 7, height = 5, dpi = 300)

# Plot 2: Suicide rate and satisfaction trends (National)
# We need to scale them to plot together or plot side-by-side
df_national_long <- df_national %>%
  select(year, avg_score, suicide_계) %>%
  pivot_longer(cols = c(avg_score, suicide_계), names_to = "metric", values_to = "value")

p2 <- ggplot(df_national, aes(x = year)) +
  geom_line(aes(y = suicide_계, group = 1, color = "자살률 (우축)"), size = 1.2) +
  geom_point(aes(y = suicide_계, color = "자살률 (우축)"), size = 3) +
  geom_line(aes(y = avg_score * 10, group = 1, color = "삶의 만족도 점수 x 10 (좌축)"), size = 1.2) +
  geom_point(aes(y = avg_score * 10, color = "삶의 만족도 점수 x 10 (좌축)"), size = 3) +
  scale_y_continuous(
    name = "삶의 만족도 지수 (환산)",
    sec.axis = sec_axis(~., name = "자살률 (명 / 10만명)")
  ) +
  labs(
    title = "전국 삶의 만족도 및 자살률 추이 (2020-2024)",
    x = "연도",
    color = "지표"
  ) +
  scale_color_manual(values = c("자살률 (우축)" = "#E74C3C", "삶의 만족도 점수 x 10 (좌축)" = "#3498DB")) +
  theme_minimal(base_family = "Malgun") +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    legend.position = "bottom"
  )

ggsave(file.path(artifact_dir, "plot_national_trends.png"), plot = p2, width = 7, height = 5, dpi = 300)

# Plot 3: Regional comparison for the latest year (2024)
df_2024 <- df_regions %>% filter(year == 2024)
cor_2024 <- cor.test(df_2024$avg_score, df_2024$suicide_계)

p3 <- ggplot(df_2024, aes(x = avg_score, y = suicide_계, label = region)) +
  geom_point(color = "#2ECC71", size = 4, alpha = 0.8) +
  geom_text(vjust = -0.7, hjust = 0.5, family = "Malgun", fontface = "bold", size = 3.5) +
  geom_smooth(method = "lm", col = "#34495E", linetype = "dashed", se = FALSE) +
  labs(
    title = "2024년 시도별 삶의 만족도 점수와 자살률 분포",
    subtitle = paste("2024년 상관계수(r) =", round(cor_2024$estimate, 3), 
                     " (p =", format.pval(cor_2024$p.value, digits = 3), ")"),
    x = "삶의 만족도 평균 점수 (5점 만점)",
    y = "인구 10만 명당 자살률 (명)"
  ) +
  theme_minimal(base_family = "Malgun") +
  theme(
    plot.title = element_text(face = "bold", size = 14, hjust = 0.5),
    plot.subtitle = element_text(size = 11, hjust = 0.5, color = "gray30")
  )

ggsave(file.path(artifact_dir, "plot_2024_regional.png"), plot = p3, width = 7, height = 5, dpi = 300)

cat("\nAnalysis and plots generated successfully!\n")
