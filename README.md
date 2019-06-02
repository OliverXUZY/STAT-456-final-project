# STAT-456-Final-Project

This is the final project of my course STAT456. This course is about multivatiate analysis, although I have learned when I was a junior students in WHU, I still learned something from this course, and consolidate my previous knowledge(just like what STAT 601 did). I use R to load the data and python to proprecessing it (just for fun), then I use R to continue my whole analysis stuff.

## Main work
Applied statistical methods plays an essential role in many aspects, multivariate analysis is a eﬀective can extract more information from data and visualize and analyze it. In this paper, I describe multiple multivariate ways and use them on a horse colic dataset to ﬁnd out is any relationship between variables or observations and which aspects can have inﬂuence on horse’s outcome(treated surgery or not, died or alive). 

First I use some regression methods to deal with the missing values, and draw some plots to check the distribution of some continuous variables and visualize the relationship between variables.

Then, since there are many attributes in this dataset and there exists collinearity among attributes. I use PCA to reduce dimensionality and eliminate the eﬀects of collinearity, which help us better analyze the relationship between variables and observations.

Next, instead of consider interrelationship within a set of variables, I’m interested in the relationships between two sets of variables. Thus I use canonical correlation analysis to analyze the connection between horse’s dynamic physical variables and stable physical variables. 

Furthermore, I want to more concentrate on the purpose that obtain a low dimensional map of the data that can represent the relationship between observations. That brings in multidimensional scaling(MDS).This method has some advantages over PCA and CCA since it focus on the distance or dissimilarities among observations, which has more clear representation according to our goal. We still use the ﬁve continuous variables on physical condition of horse and we can divide our whole dataset into sub-groups. We can see these groups have diﬀerences on other categorical data (such as age young or adult). Then in order to check whether it is correct to divide dataset into sub-groups according to these ﬁve continuous variables, I use Kmeans clustering and sample cluster into sub-groups based on 5 continuous variables, which veriﬁed the eﬀectiveness of our previous methods. 

Finally, I’m still interested other categorical variables and how they can aﬀect a horse’s outcome(surgery or not, died or alive). I use correspondence analysis to analyze the relationship between categorical variables, I draw mosaic plot and CA plot to get my conclusions.

## Data
[**Horse Colic Data Set**](https://archive.ics.uci.edu/ml/datasets/Horse+Colic)
