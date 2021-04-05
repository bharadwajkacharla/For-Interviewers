#!pip install xgboost
#!pip install imblearn
#import imblearn
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error as MSE
import seaborn as sns
from sklearn.ensemble import GradientBoostingClassifier
from xgboost import XGBClassifier
from xgboost import plot_importance
from sklearn.model_selection import cross_val_score
from sklearn.metrics import accuracy_score
from sklearn import metrics
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import pickle

# Reading the file
filename = pd.read_csv('online_shoppers_intention.csv')

# Applying the encoding to the categorical columns
enc = LabelEncoder()
filename.loc[:,['Weekend', 'Revenue']] = \
filename.loc[:,['Weekend', 'Revenue']].apply(enc.fit_transform)

# Creating dummies for other categorical columns
filename=pd.get_dummies(data=filename, columns=['Month','OperatingSystems','Browser','Region','TrafficType','VisitorType'])

# Passing the cleaned dataset to a new variable
new_file = filename

# Seperating Features and assigning it to variable X
X = new_file.drop(['Revenue'],axis=1)

# Seperating Label column and assigning it to variable y
y = new_file.Revenue

# Set seed for reproducibility
SEED = 1
# Split dataset into 70% train and 30% test
X_train, X_test, y_train, y_test = \
train_test_split(X, y, test_size = 0.2, random_state = SEED)

##-------------Applying Gradient boosting before sampling data---------##

gb = GradientBoostingClassifier(max_depth=4,
                               n_estimators=200,
                               random_state=2)
# Fit gb to the training set
gb.fit(X_train, y_train)

# Predict test set labels
y_test_pred_gboost = gb.predict(X_test)

##-----------Applying Gradient boosting after Balancing the data---------------------##

# Instantiate gb
gb = GradientBoostingClassifier(max_depth=4,
                               n_estimators=200,
                               random_state=2)

# Fit gb to the training set
gb.fit(X_train_smote, y_train_smote)


# Predict test set labels
y_test_pred_gboost_smote = gb.predict(X_test)

# Saving model to disk
pickle.dump(gb, open('model1.pkl','wb'))

# Loading model to compare the results
model = pickle.load(open('model1.pkl','rb'))
#print(model.predict([[2, 9, 6]]))
