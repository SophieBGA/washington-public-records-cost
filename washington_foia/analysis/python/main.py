import numpy as np # linear algebra
import pandas as pd # data processing, CSV file I/O (e.g. pd.read_csv)
import os

for dirname, _, filenames in os.walk('~/Documents/projects/court_transparency/unprocessed_data'):
    for filename in filenames:
        print(os.path.join(dirname, filename))



train_data = pd.read_csv("~/Documents/projects/court_transparency/unprocessed_data/jlarc_centralized_counties.csv")
print(train_data.columns)

test_data = pd.read_excel("~/Documents/projects/court_transparency/unprocessed_data/co-est2021-pop-17.xlsx", skiprows=3)
test_data.columns = ['county', 'pop_base', 'pop_2020', 'population']
print(test_data.columns)
print(test_data.head())



from sklearn.ensemble import RandomForestClassifier

y = train_data["total_requests"]

features = ["county", "population"]
X = pd.get_dummies(train_data[features])
X_test = pd.get_dummies(test_data[features])

model = RandomForestClassifier(n_estimators=100, max_depth=5, random_state=1)
model.fit(X, y)
predictions = model.predict(X_test)

output = pd.DataFrame({'county': test_data.county, 'total_requests': predictions})
output.to_csv('submission.csv', index=False)
print("Your submission was successfully saved!")

