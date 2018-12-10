data = read.table("data.txt")
test = read.table("test.txt")
mydata = rbind(data,test)
####
##------------------------ import data
data = read.csv("original_data.csv")


####
FUNC = function(vec)  return(sum(vec == "?"))

apply(mydata,1,FUNC)

mydata1 = mydata[-which(apply(mydata, 1, FUNC) >= 6),]

as.vector(apply(mydata1,1,FUNC))

apply(mydata1,2,FUNC)


##------------------------  preprocessing
data$V3 = NULL
unique(data$V8)
data$V9 = NULL
data$V14 = NULL

rm(list = ls())
df = read.csv("final_data2.csv")
##--------------------------- visualization
## qqplot
layout(matrix(seq(6),2,2))
qqnorm(df$V3,main = "Rectal temperature");qqline(df$V3)
qqnorm(df$V4,main = "Pulse");qqline(df$V4)
qqnorm(df$V5,main = "Respiratory rate");qqline(df$V5)
qqnorm(df$V12,main = "Packed cell volume");qqline(df$V12)
qqnorm(df$V13,main = "Packed cell volume");qqline(df$V13)

layout(1)

## bivariate boxplot
library(MVA)
index = union(order(df[,4],decreasing = T)[1:8],order(df[,5],decreasing = T)[1:8])

index
bvbox(cbind(df$V4,df$V5),method="nonrobust",cex = 1,pch = 16,
      xlab = "pulse",ylab = "respiratory") 
text(df[,4][index],df[,5][index],index,cex=1, pos=1)

##------------------------ scatterplot matrix
require(SciViews)
library("KernSmooth") 
### box and regression line
panel.box <- function(x, ...)
{
  usr <- par("usr"); on.exit(par(usr))
  par(usr = c(usr[3:4],0, 2 ))
  #par(usr = c(min(x)-1.5*IQR(x),max(x)+1.5*IQR(x), 0,2 ))
  boxplot(x,horizontal = TRUE, add=TRUE)
}

pairs(df[,c(3,4,5,12)],panel =function(x,y,...){
                       points(x,y,...)
                       abline(lm(y~x),col = 'red')
                       },
      cex = 1.5,pch = 16, col = "light blue",
      diag.panel = panel.box, cex.labels = 2,font.labels = 2)

####
panel.hist_line = function(x,...)
{
  usr = par("usr"); on.exit(par(usr))
  par(usr = c(usr[1:2],0,1.5))
  h = hist(x,plot = FALSE)
  breaks = h$breaks;nB = length(breaks)
  y = h$counts;y = y/max(y)
  rect(breaks[-nB],0,breaks[-1],y,col = "cyan")
}
panel_cor = function(x,y,digits = 2,prefix = "",cex.cor,...)
{
  usr = par("usr"); on.exit(par(usr))
  par(usr = c(0,1,0,1))
  r = abs(cor(x,y))
  txt = format(c(r,0.123456789),digits = digits)[1]
  txt = paste0(prefix,txt)
  if(missing(cex.cor)) cex.cor = 0.8/strwidth(txt)
  text(0.5,0.5,txt,cex = 4)
}
pairs(df[,c(3,4,5,12)],upper.panel = panel.smooth,lower.panel = panel_cor,
      cex = 1.5,pch = 20,col = "dodgerblue3", bg = "navy blue",
      diag.panel = panel.hist_line, cex.labels = 2,font.labels = 2)



median(df$V12)

#####-----------------  PCA
df$V3
PCA = princomp(~.,data = df[,c(3,4,5,12,13)],cor = TRUE)
summary(PCA,loadings = TRUE)

library(ggplot2)
library(GGally)
load = data.frame(pca1 = PCA$loadings[,1],pca2 = PCA$loadings[,2],pca3 = PCA$loadings[,3],
                  pca4 = PCA$loadings[,4])
ggpairs(load,upper = list(continuous = "blank"),diag = list(continous = "densityDiag"))


library(devtools)
#devtools::install_github("thomasp85/patchwork")
library(patchwork)
rownames(load) = abbreviate(c("rectal temperature","pulse","respiratory",
                              "packed cell colume","total protein"))



p12 = ggplot(load,aes(x = pca1,y = pca2)) + geom_text(aes(label = rownames(load))) 
p13 = ggplot(load,aes(x = pca1,y = pca3)) + geom_text(aes(label = rownames(load))) 
p14 = ggplot(load,aes(x = pca1,y = pca4)) + geom_text(aes(label = rownames(load))) 

p23 = ggplot(load,aes(x = pca2,y = pca3)) + geom_text(aes(label = rownames(load))) 
p24 = ggplot(load,aes(x = pca2,y = pca4)) + geom_text(aes(label = rownames(load))) 
p34 = ggplot(load,aes(x = pca3,y = pca4)) + geom_text(aes(label = rownames(load))) 


p12  + p13 + p14 + p23 + p24 + p24 +
  plot_layout(ncol = 3) +
  plot_annotation(title = "Coefficient for PCA",
                 # subtitle = "Plot subtitle",
                  tag_levels = 'A',
                  tag_suffix = ')')
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'

###  scores of PCA
score = PCA$scores[,1:4]
colnames(score) = c("pca1","pca2","pca3","pca4")
score = as.data.frame(score)
ggplot(score,aes(x = pca1,y = pca2,color = as.factor(df$V7),
                 pch = as.factor(df$V7))) + geom_point(cex = 2) 
ggplot(score,aes(x = pca2,y = pca1,color = as.factor(df$V14),
                 pch = as.factor(df$V14))) + geom_point(cex = 2) 

biplot(PCA)


##################  CCA
rm(list = ls())
df = read.csv("final_data2.csv")
conti_var = df[,c(4,5,3,12,13)] # first 2 in X sets, last 3 in y sets
cormat = round(cor(apply(conti_var,2,scale)),3)
cormat
r11 = cormat[1:2,1:2]
r12 = cormat[1:2,3:5]
r21 = t(r12)
r22 = cormat[3:5,3:5]
e1 = solve(r11)%*%r12%*%solve(r22)%*%r21
e2 = solve(r22)%*%r21%*%solve(r11)%*%r12
ei1 = eigen(e1)
ei2 = eigen(e2)

abbreviate(c("rectal temperature","pulse","respiratory",
             "packed cell colume","total protein"))
u = as.matrix(df[,c(4,5)])%*% ei1$vectors
v = as.matrix(df[,c(3,12,13)])%*%ei2$vectors
plot(u[,1],v[,1])



###################   MDS
rm(list = ls())
df = read.csv("final_data2.csv")
dis = dist(df[,c(3,4,5,12,13)])

library(StatMatch)


dist_m = mahalanobis.dist(df[,c(3,4,5,12,13)])
#mat = as.matrix(dis)
mds = cmdscale(dist_m,k=5,eig = TRUE)

lambda2 = mds$eig^2
sca = cumsum(lambda2)/sum(lambda2)
point = as.data.frame(mds$points)
library(ggplot2)
ggplot(point,aes(x = V1,y=V2,color = as.factor(df$V2),
                 pch = as.factor(df$V2))) + geom_point(cex = 2) +
                 xlab("Coor1") + ylab("Coor2")


ggplot(point,aes(x = V1,y=V2,color = as.factor(df$V8),
                 pch = as.factor(df$V8))) + geom_point(cex = 2) +
                 xlab("Coor1") + ylab("Coor2")


library(MASS)
mat = as.matrix(dis)
mat[mat==0] = 1
mds2 = isoMDS(mat,k=5)


point = as.data.frame(mds2$points)
library(ggplot2)
ggplot(point,aes(x = V1,y=V2,color = as.factor(df$V2),
                 pch = as.factor(df$V2))) + geom_point(cex = 2) +
  xlab("Coor1") + ylab("Coor2")


ggplot(point,aes(x = V1,y=V2,color = as.factor(df$V8),
                 pch = as.factor(df$V8))) + geom_point(cex = 2) +
  xlab("Coor1") + ylab("Coor2")


##
km = kmeans(df[,c(3,4,5,12,13)],2)
km$cluster
ggplot(point,aes(x = V1,y=V2,color = as.factor(km$cluster),
                 pch =as.factor( km$cluster))) + geom_point(cex = 2) +
  xlab("Coor1") + ylab("Coor2")






#####  CA
library(vcd)
a = table(df$V6,df$V9)
rownames = c("norm","warm","cool","cold")
dimnames(a) = list(rownames,seq(1,5))
names(dimnames(a)) = c("temperature of extremities","pain level")
a
mosaic(a,shade = T)


library(ca)
camodel = ca(a)

par(pty = "s",cex = 2)
plot(camodel)





