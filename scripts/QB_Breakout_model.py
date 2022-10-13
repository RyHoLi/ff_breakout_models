import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.model_selection import GridSearchCV
from xgboost import XGBClassifier
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import accuracy_score, confusion_matrix, roc_auc_score, roc_curve, auc
from sklearn import metrics
import numpy as np
import matplotlib.pyplot as plt

model_data_df = pd.read_csv('C:/Users/Ryan/Documents/nfl_models/breakout_players/data/qb_breakout_data.csv')

# predictors are all fields except for player_id, name, pred_season, pred_fantasy_points, pct_increase, breakout
df_predictors = model_data_df.iloc[:, np.r_[2:8, 9:26]]
df_predictors = df_predictors[df_predictors['season'] < 2021]

# predicting breakout
df_target = model_data_df[model_data_df['season'] < 2021]['breakout']

# not sure if this is necessary, but wanted to scale all of the predictors on a similar scale
scaler = MinMaxScaler(feature_range=(0,1))
df_predictors2 = scaler.fit_transform(df_predictors)

X_train, X_test, y_train, y_test = train_test_split(df_predictors2, df_target, test_size = 0.2, random_state=42)

model = XGBClassifier()
model = model.fit(X_train, y_train)

# make predictions for test data
y_pred = model.predict(X_test)
predictions = [round(value) for value in y_pred]

accuracy = accuracy_score(y_test, predictions)
print("Accuracy: %.2f%%" % (accuracy * 100.0))
# 93.64%

precision = metrics.precision_score(y_test, predictions)
print("Precision: %.2f%%" % (precision * 100.0))
# 60%

# Sensitivity (Recall)
sensitivity_recall = metrics.recall_score(y_test, predictions)
print("Sensitivity: %.2f%%" % (sensitivity_recall * 100.0))
# 25%

# Specificity
specificity = metrics.recall_score(y_test, predictions, pos_label=0)
print("Specificity: %.2f%%" % (specificity * 100.0))
# 98.76%

# Confusion Matrix
confusion_matrix = metrics.confusion_matrix(y_test, predictions)
cm_display = metrics.ConfusionMatrixDisplay(confusion_matrix = confusion_matrix, display_labels = [False, True])
cm_display.plot()
plt.show()

# ROC Curve
# Compute ROC curve and ROC area for each class
probs= model.predict_proba(X_test)
preds = probs[:,1]
fpr, tpr, threshold = metrics.roc_curve(y_test, preds)
roc_auc = metrics.auc(fpr, tpr)

plt.title('Receiver Operating Characteristic')
plt.plot(fpr, tpr, 'b', label = 'AUC = %0.2f' % roc_auc)
plt.legend(loc = 'lower right')
plt.plot([0, 1], [0, 1],'r--')
plt.xlim([0, 1])
plt.ylim([0, 1])
plt.ylabel('True Positive Rate')
plt.xlabel('False Positive Rate')
plt.show()


# predict on player data from last season
predict_set = model_data_df[model_data_df['season'] == 2021]
predict_set2 = predict_set.iloc[:, np.r_[2:8, 9:26]]

predict_set3 = scaler.fit_transform(predict_set2)

predictions = pd.DataFrame(model.predict(predict_set3), columns=['classification'])
prob_predictions = pd.DataFrame(model.predict_proba(predict_set3), columns=['prob_0', 'prob_1'])


labels = pd.DataFrame(model_data_df[model_data_df['season'] == 2021][['name', 'fantasy_points']])
final_df = pd.concat([labels.reset_index(drop=True), prob_predictions.reset_index(drop=True), predictions], axis=1)
final_df['prob_pred_fpts'] = final_df['fantasy_points'] * 1.25

final_df.sort_values(by=['prob_1', 'prob_pred_fpts'], ascending=False).to_csv('C:/Users/Ryan/Documents/nfl_models/breakout_players/data//qb_breakout_predictions.csv', index=False)