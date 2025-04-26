install.packages("xgboost")

library(data.table)
library(dplyr)
library(caret)
library(xgboost)


library(data.table)

train <- fread("/Users/amitmakhija/Desktop/bank_full_train.csv")
test <- fread("/Users/amitmakhija/Desktop/bank_full_test.csv")


# Load files
library(data.table)
train <- fread("bank_full_train.csv")
test <- fread("bank_full_test.csv")

# Check it's loaded
head(train)
head(test)



# Prepare target variable
train$y <- ifelse(train$y == "yes", 1, 0)

# Combine train and test for consistent preprocessing
test$y <- NA   # temporarily add y column to test to match
combined <- rbind(train, test, fill = TRUE)

# Remove ID before modeling
combined_IDs <- combined$ID
combined[, ID := NULL]

# Encode categorical variables
cat_cols <- c("job", "marital", "education", "default", "housing", "loan", "contact", "month", "poutcome")

for (col in cat_cols) {
  combined[[col]] <- as.integer(as.factor(combined[[col]]))
}

# Split combined back into train and test
train_processed <- combined[!is.na(y)]
test_processed <- combined[is.na(y)]
test_processed$y <- NULL  # remove target from test

# Convert to matrices for XGBoost
dtrain <- xgb.DMatrix(data = as.matrix(train_processed[, !c("y"), with=FALSE]), label = train_processed$y)
dtest <- xgb.DMatrix(data = as.matrix(test_processed))

# Train XGBoost Model
params <- list(
  objective = "binary:logistic",
  eval_metric = "auc",
  max_depth = 6,
  eta = 0.1,
  subsample = 0.8,
  colsample_bytree = 0.8
)

model <- xgb.train(
  params = params,
  data = dtrain,
  nrounds = 100,
  verbose = 1
)

# Predict
test_preds <- predict(model, dtest)

# Prepare Submission
submission <- data.table(ID = combined_IDs[(nrow(train) + 1):length(combined_IDs)], y = test_preds)

# Save Submission
fwrite(submission, "/Users/amitmakhija/Desktop/banking_files/submission.csv", row.names = FALSE)

cat("\nSubmission file saved successfully!\n")