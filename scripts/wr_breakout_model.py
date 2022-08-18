import pandas as pd
from sklearn.model_selection import train_test_split
from xgboost import XGBClassifier
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import accuracy_score
import numpy as np

model_data_df = pd.read_csv('C:/Users/Ryan/Documents/nfl_models/breakout_players/data/wr_breakout_data.csv')

df_predictors = model_data_df.iloc[:, np.r_[2:8, 9:33]]
df_predictors = df_predictors[df_predictors['season'] < 2021]

df_target = model_data_df[model_data_df['season'] < 2021]['breakout']

scaler = MinMaxScaler(feature_range=(0,1))

df_predictors2 = scaler.fit_transform(df_predictors)

X_train, X_test, y_train, y_test = train_test_split(df_predictors2, df_target, test_size = 0.2, random_state=42)

model = XGBClassifier()
model.fit(X_train, y_train)

# make predictions for test data
y_pred = model.predict(X_test)
predictions = [round(value) for value in y_pred]

accuracy = accuracy_score(y_test, predictions)
print("Accuracy: %.2f%%" % (accuracy * 100.0))
# 88.81%

predict_set = model_data_df[model_data_df['season'] == 2021]
predict_set2 = predict_set.iloc[:, np.r_[2:8, 9:33]]

predict_set3 = scaler.fit_transform(predict_set2)

predictions = pd.DataFrame(model.predict(predict_set3), columns = ['classification'])
prob_predictions = pd.DataFrame(model.predict_proba(predict_set3), columns = ['prob_0', 'prob_1'])


labels = pd.DataFrame(model_data_df[model_data_df['season'] == 2021]['name'])

final_df = pd.concat([labels.reset_index(drop=True), prob_predictions.reset_index(drop=True), predictions.reset_index(drop=True)], axis=1)

final_df.to_csv('C:/Users/Ryan/Documents/nfl_models/breakout_players/data/wr_breakout_predictions.csv', index=False)