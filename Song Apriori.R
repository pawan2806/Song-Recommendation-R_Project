install.packages("dplyr")
library(dplyr)

install.packages("plyr", dependencies= TRUE)
library(plyr); 

df_SongsData <- read.csv("Songs Data.csv")

# df_sorted <- df_SongsData[playlist(df_SongsData$User.ID),]
# df_sorted$User.ID <- as.numeric(df_sorted$User.ID)

# convert the dataframe into transactions format

df_SongList <- ddply(df_SongsData,c("User.ID","Date"), 
                     function(df1)paste(df1$Songs, 
                                        collapse = ","))

df_SongList$User.ID <- NULL
df_SongList$Date <- NULL

#Rename column headers for ease of use
colnames(df_SongList) <- c("Songs")

write.csv(df_SongList,"C:/Users/Admin/Desktop/Apriori/SongList.csv", row.names = TRUE)

install.packages("arules", dependencies=TRUE)
library(arules)

txn = read.transactions(file="C:/Users/Admin/Desktop/Apriori/SongList.csv", 
                        rm.duplicates= TRUE, format="basket",sep=",",cols=1);

txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)


basket_rules <- apriori(txn,parameter = list(sup = 0.001, conf = 0.05,target="rules"));

df_basket <- as(basket_rules,"data.frame")
View(df_basket)

install.packages("arulesViz")
library(arulesViz)
plot(basket_rules)
plot(basket_rules, method="graph", control=list(type="items"))
plot(basket_rules,measure=c("support","lift"),shading="confidence",interactive=T)

itemFrequencyPlot(txn, topN = 5)
# F-P Growth 


install.packages("rJava")
library("rJava")
install.packages("rCBA")
library("rCBA")

rules = rCBA::fpgrowth(txn, support=0.003, confidence=0.03, consequent="Songs", parallel=FALSE)
inspect(rules)

fpgrowth(txn, support = 0.001, confidence = 0.05, maxLength = 5,
         consequent = Songs, verbose = TRUE, parallel = TRUE)


# buildFPGrowth(txn, className = df$Songs, verbose = TRUE, parallel = TRUE)






# darshan

install.packages("rCBA")
library("rCBA")

dataf= read.csv("C:/Users/Admin/Desktop/Apriori/Songs Data.csv")         

trans=as(dataf, "transactions")
itemLabels(trans)

train <- sapply(dataf,as.factor)
train <- data.frame(train, check.names=FALSE)
txns <- as(train,"transactions")

rules = rCBA::fpgrowth(txns, support=0.3, confidence=0.3, maxLength=8,consequent="Type.of.Vehicle",
                       parallel=FALSE)
inspect(rules)
predictions <- rCBA::classification(train,rules)
table(predictions)
sum(as.character(train$Type.of.Vehicle)==as.character(predictions),na.rm=TRUE)/length(predictions)

