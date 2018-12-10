import numpy as np
import pandas as pd
## data_version1 after combine train and etst data, then del column V3,V9,V14
data = pd.read_csv('data_version1.csv')
df = data
df = df.drop(columns = ['V15'])
df = df.drop(columns = ['V16'])
df = df.drop(columns = ['V17'])
df = df.drop(columns = ['V18'])
df = df.drop(columns = ['V21'])
df = df.drop(['V22'],axis = 1)
df = df.drop(['V25','V26','V27'],axis = 1)
df

#def func(x): return(sum(x == '?'))
#df.apply(func,axis = 0)
df.V1[0] = 1
df.columns = ["V1","V2","V3","V4","V5","V6","V7","V8","V9","V10","V11","V12","V13","V14","V15","V16"]
## see how much missing value
(df == '?').sum(axis = 0)
col_missing = df.apply(lambda x: sum(x == '?'),axis = 0)
(df=='?').sum(axis = 1)
row_missing = df.apply(lambda x: sum(x == '?'),axis = 1)

df = df.replace('?',np.nan)  ## replace ? with NA
df = df.replace('锘?',np.nan)

df.isna().sum(axis = 0)
df.isna().sum(axis = 1)


### if missing value is less than 52, then replace it with non_missing value
### if larger than 52, then regression
col_missing[col_missing<=52]  ## random choose a number
col_missing[col_missing>52]

##------------------------------------- less than 52
from sklearn.preprocessing import Imputer
imp = Imputer(missing_values = 'NaN',strategy='most_frequent',axis = 0 )
df.loc[:,['V1','V8','V10','V14']] = imp.fit_transform(df.loc[:,['V1','V8','V10','V14']])

df.V13 = df.V13.astype(float)
df.V13 = df.V13.apply(lambda x:x/10 if x > 10 else x)
imp2 = Imputer(missing_values = 'NaN',strategy='mean',axis = 0 )
df.loc[:,['V4','V12','V13']] = imp2.fit_transform(df.loc[:,['V4','V12','V13']])
##------------------------------------- larger than 52
X = df.loc[:,df.isna().sum(axis = 0) == 0]  ## total explanatory variables

from sklearn import linear_model
## linear regression
lm1 = linear_model.LinearRegression()
lm1.fit(X.loc[-df.V3.isna(),:],df.V3[-df.V3.isna()])
df.V3[df.V3.isna()] =  lm1.predict(X.loc[df.V3.isna(),:])

lm2 = linear_model.LinearRegression()
lm2.fit(X.loc[-df.V5.isna(),:],df.V5[-df.V5.isna()])
df.V5[df.V5.isna()] =  lm2.predict(X.loc[df.V5.isna(),:])
## logistic regression
lg1 = linear_model.LogisticRegression()
lg1.fit(X.loc[-df.V6.isna(),:],df.V6[-df.V6.isna()])
df.V6[df.V6.isna()] =  lg1.predict(X.loc[df.V6.isna(),:])

lg2 = linear_model.LogisticRegression()
lg2.fit(X.loc[-df.V7.isna(),:],df.V7[-df.V7.isna()])
df.V7[df.V7.isna()] =  lg2.predict(X.loc[df.V7.isna(),:])

lg3 = linear_model.LogisticRegression(multi_class = 'multinomial',solver ='newton-cg')
lg3.fit(X.loc[-df.V9.isna(),:],df.V9[-df.V9.isna()])
df.V9[df.V9.isna()] =  lg3.predict(X.loc[df.V9.isna(),:])

lg4 = linear_model.LogisticRegression(multi_class = 'multinomial',solver ='newton-cg')
lg4.fit(X.loc[-df.V11.isna(),:],df.V11[-df.V11.isna()])
df.V11[df.V11.isna()] =  lg4.predict(X.loc[df.V11.isna(),:])

df.to_csv('final_data2.csv',index = False)





















