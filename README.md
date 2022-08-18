These models try to predict players that will "breakout" or have great seasons. 
There are four fifferent models, one for each position (QB, RB, WR, TE) to determine who will "breakout" which is all defined differently. 

For QBs, it is defined as:
1. Increasing FPts/G by 25%
OR
2. Averaging at least 18 FPts/G.

For RBs, it is defined as:
1. Increasing FPts/G by 25%
OR
2. Averaging at least 18 FPts/G.

For WRs, it is defined as:
1. Increasing FPts/G by 25%
OR
2. Averaging at least 13 FPts/G.

For TEs, it is defined as:
1. Increasing FPts/G by 30%
OR
2. Averaging at least 14 FPts/G.


Find the predictions in the data folder for each player. 
The definition for each column:
name - name of the player predicted
fantasy_points - fantasy points from last season
prob_0 - probability of not meeting one of the thresholds above.
prob_1 - probability of meeting one of the thresholds above.
classification - 1 if probability of prob_1 is greater than 0.5, 0 if it is below 0.5 Can also be defined as 1, the model predicts the player will "breakout" 0 if not.
prob_pred_fpts - the fantasy points if the player increased their output from last season by 25% for QB/RB/WR or 30% for TE.
