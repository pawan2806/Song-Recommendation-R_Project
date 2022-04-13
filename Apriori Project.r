install.packages("dplyr")
library(dplyr)

install.packages("plyr", dependencies= TRUE)
library(plyr); 

df_SongsData <- read.csv("Bollywood Song List Dataset.csv")

glimpse(df_SongsData)

install.packages("arules", dependencies=TRUE)
library(arules)

# Mood wise assosiation rules

df_SongList <- ddply(df_SongsData,c("User.ID","Mood.of.song"), 
                     function(df1)paste(df1$Song.Title,
                                        collapse = ","))
colnames(df_SongList) <- c("","","song_title")

write.csv(df_SongList,"NewSongList.csv", row.names = TRUE)


txn = read.transactions(file="NewSongList.csv", 
                        rm.duplicates= TRUE, format="basket",sep=",",cols=1);


txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)

basket_rules <- apriori(txn,parameter = list(sup = 0.001, conf = 0.001,target="rules"));
View(df_basket)
df_basket <- as(basket_rules,"data.frame")

summary(basket_rules)

basket_rules = subset(basket_rules, lift >= 29)
df_basket <- as(basket_rules,"data.frame")
View(df_basket)




# Movie wise Association Rules
df_SongList_m <- ddply(df_SongsData,c("User.ID","Movie.Name"), 
                       function(df1)paste(df1$Song.Title,
                                          collapse = ","))
colnames(df_SongList_m) <- c("","","song_title")

write.csv(df_SongList_m,"M_wise_List.csv", row.names = TRUE)


txn = read.transactions(file="M_wise_List.csv", 
                        rm.duplicates= TRUE, format="basket",sep=",",cols=1);


txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)

basket_rules_m <- apriori(txn,parameter = list(sup = 0.01, conf = 0.04,target="rules"));

df_basket_m <- as(basket_rules_m,"data.frame")
summary(basket_rules_m)

basket_rules_m = subset(basket_rules_m, lift >= 18)
df_basket_m <- as(basket_rules_m,"data.frame")
View(df_basket_m)


# Artist wise 


df_SongList_a <- ddply(df_SongsData,c("User.ID","Artist.Of.Song"), 
                       function(df1)paste(df1$Song.Title,
                                          collapse = ","))
colnames(df_SongList_a) <- c("","","song_title")

write.csv(df_SongList_a,"A_SongList.csv", row.names = TRUE)


txn = read.transactions(file="A_SongList.csv", 
                        rm.duplicates= TRUE, format="basket",sep=",",cols=1);


txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)

basket_rules_a <- apriori(txn,parameter = list(sup = 0.04, conf = 0.5,target="rules"));

df_basket_a <- as(basket_rules_a,"data.frame")
View(df_basket_a)


library(arulesViz)
plot(basket_rules)
plot(basket_rules, method = "grouped", control = list(k = 5))
plot(basket_rules, method="graph", control=list(type="items"))
plot(basket_rules, method="paracoord",  control=list(alpha=.5, reorder=TRUE))
plot(basket_rules,measure=c("support","lift"),shading="confidence",interactive=T)
