# Term Deposit Subscription Prediction - Banking Campaign

This project uses machine learning (XGBoost) to predict whether a customer will subscribe to a term deposit based on previous marketing campaign data.

## Project Structure

- `bank_full_train.csv` : Training data provided.
- `bank_full_test.csv` : Test data provided.
- `Amit_Makhija_P5_part2.csv` : Final submission file as per project guidelines.
- `R_scripts/` : (Optional) Folder containing R scripts used to generate submission (not mandatory to submit).
- `README.md` : Project overview and instructions.

## How to Reproduce

1. Load the datasets using `data.table::fread()`.
2. Preprocess the data:
   - Map target `y` from "yes"/"no" to 1/0.
   - Feature engineering (`contacted_before`, `log(duration)`).
   - Encode categorical variables.
3. Train an XGBoost model with early stopping using validation AUC.
4. Predict on the test set.
5. Create the final submission CSV:
   - Only one column named `y`.
   - In the same order as the test data.
   - File named: `Amit_Makhija_P5_part2.csv`.

## Important Notes

- Submission must contain only the prediction column `y`.
- File name must strictly follow the format: `firstName_LastName_P5_part2.csv`.
- No R scripts are submitted to LMS as per project instructions.

## Author

Amit Makhija