# Student Dropout Analysis — R Script
# ITC355 Assignment 1: Solving Problems Faced by University Students
# Descriptive, Predictive & Prescriptive Analytics using R

# ---- Install & Load Required Packages ----
install.packages(c("ggplot2", "randomForest", "pROC", "caret", "dplyr", "cluster", "fpc"))
library(ggplot2)
library(randomForest)
library(pROC)
library(caret)
library(dplyr)
library(cluster)
library(fpc)


# ============================================================
# 1. Descriptive Analytics — K-means Clustering (GPA & Attendance)
# ============================================================
# Load the CSV data
student_data <- read.csv("../data/student_performance.csv")

# Select relevant features for clustering
student_data_for_clustering <- student_data[, c("GPA", "Attendance")]

# Perform K-means clustering
set.seed(123)
kmeans_result <- kmeans(student_data_for_clustering, centers = 3)

# Add the cluster assignments to the original data
student_data$Cluster <- as.factor(kmeans_result$cluster)

# Plot the clustering results
ggplot(student_data, aes(x = GPA, y = Attendance, color = Cluster)) +
  geom_point(size = 4) +
  labs(title = "K-means Clustering of Students", x = "GPA", y = "Attendance") +
  theme_minimal()


# ============================================================
# 2. Descriptive Analytics — Churn Analysis Visualization
# ============================================================
# Load churn analysis data
churn_data <- read.csv("../data/churn_analysis.csv")

# Create a bar chart for churn analysis
churn_plot <- ggplot(churn_data, aes(x = Dropout, fill = Dropout)) +
  geom_bar() +
  labs(title = "Student Dropout Analysis", x = "Dropout Status", y = "Count") +
  scale_fill_manual(values = c("green", "red")) +
  theme_minimal()

# Display the churn plot
print(churn_plot)


# ============================================================
# 3. Predictive Analytics — Random Forest Model & Feature Importance
# ============================================================
# Load the dataset for the random forest model
rf_data <- read.csv("../data/feature_importance.csv")

# Build a random forest model to predict 'Churn' (Dropout)
rf_model <- randomForest(Churn ~ GPA + Attendance + FinancialAid, data = rf_data, importance = TRUE)

# Print model summary
print(rf_model)

# Plot feature importance
importance(rf_model)
varImpPlot(rf_model, main = "Feature Importance for Predicting Student Dropout")


# ============================================================
# 4. Predictive Analytics — Confusion Matrix & ROC Curve
# ============================================================
# Assuming we have a trained model and predicted values
predictions <- predict(rf_model, rf_data)
conf_matrix <- confusionMatrix(predictions, rf_data$Churn)

# Print confusion matrix
print(conf_matrix)

# ROC curve
roc_curve <- roc(rf_data$Churn, as.numeric(predictions), plot = TRUE, main = "ROC Curve for Predicting Dropout")


# ============================================================
# 5. Prescriptive Analytics — Retention Strategy Visualization (Gantt Chart)
# ============================================================
# Sample data for Gantt chart
gantt_data <- data.frame(
  Task = c("Provide Tutoring", "Offer Financial Aid", "Provide Counseling", "Engage in Social Activities"),
  Start = as.Date(c("2025-04-01", "2025-04-15", "2025-05-01", "2025-06-01")),
  End = as.Date(c("2025-04-30", "2025-05-15", "2025-06-01", "2025-06-30"))
)

# Plot Gantt chart
ggplot(gantt_data, aes(x = Start, xend = End, y = Task, yend = Task)) +
  geom_segment(size = 8, color = "skyblue") +
  labs(title = "Retention Strategy Timeline", x = "Date", y = "Task") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
