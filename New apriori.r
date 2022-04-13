install.packages("dplyr")
library(dplyr)

install.packages("plyr", dependencies= TRUE)
library(plyr); 

# arules' available that provides functions to read the transactions and find association rules.
install.packages("arules", dependencies=TRUE)
library(arules)

# Read the 'New Bollywood song list ' csv file. 

df_SongsData <- read.csv("New Bollywood Song List.csv")

glimpse(df_SongsData)

# we have to convert the dataframe into transactions format such that we have all the items
# bought at the same time in one row. For this, we use a function called ddply, offered by 
# package plyr.

# Mood wise assosiation rules

# The next step is to actually convert the dataframe into basket format, based on the user id and mood of song
# or artist or movies

df_SongList <- ddply(df_SongsData,c("User.ID","Mood.of.song"), 
                     function(df1)paste(df1$Song.Title,
                                        collapse = ","))
colnames(df_SongList) <- c("","","song_title")


# Write the resulting table to a csv file. The reason we do this is, when we write a dataframe to
# a .csv file, it attaches a row number by default. (unless, of course you were to explicitly tell
# it not to, by using the argument "row.names=FALSE" in the write.csv function).

write.csv(df_SongList,"NewSongList.csv", row.names = TRUE)


# Using the read.transactions() functions, we can read the file ItemList.csv and convert it to a transaction format

txn = read.transactions(file="NewSongList.csv", 
                        rm.duplicates= TRUE, format="basket",sep=",",cols=1);


# Parameters: Transaction file: ItemList.csv
# rm.duplicates : to make sure that we have no duplicate transaction entried
# format : basket (row 1: transaction ids, row 2: list of items)
# sep: separator between items, in this case commas
# cols : column number of transaction IDs

txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)

# Quotes are introduced in transactions, which are unnecessary and result in some incorrect results. 
# So, we must get rid of them:


# Finally, run the apriori algorithm on the transactions by specifying minimum values for support and confidence.

basket_rules <- apriori(txn,parameter = list(sup = 0.03, conf = 0.05,target="rules"));

df_basket <- as(basket_rules,"data.frame")
View(df_basket)

summary(basket_rules)

# for finding correct rulles we speparte rules according to lift of 75% percentile according to sumary of rules 
basket_rules = subset(basket_rules, lift >= 29)
df_basket <- as(basket_rules,"data.frame")
View(df_basket)



# Plot a few graphs that can help you visualize the rules. Install and load the 'arulesViz' 
# library for association rules specific visualizations:

library(arulesViz)
plot(basket_rules)
plot(basket_rules, method = "grouped", control = list(k = 1))
plot(basket_rules, method="graph", control=list(type="items"))
plot(basket_rules, method="paracoord",  control=list(alpha=.5, reorder=TRUE))

plot(basket_rules,measure=c("support","lift"),shading="confidence",interactive=T)



# Movie wise Association Rules
df_SongList_m <- ddply(df_SongsData,c("User.ID","Movie.Name"), 
                     function(df1)paste(df1$Song.Title,
                                        collapse = ","))
colnames(df_SongList_m) <- c("","","song_title")

write.csv(df_SongList_m,"C:/Users/Admin/Desktop/Apriori/M_wise_List.csv", row.names = TRUE)


txn = read.transactions(file="C:/Users/Admin/Desktop/Apriori/M_wise_List.csv", 
                        rm.duplicates= TRUE, format="basket",sep=",",cols=1);


txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)

basket_rules_m <- apriori(txn,parameter = list(sup = 0.001, conf = 0.004,target="rules"));
View(df_basket_m)

df_basket_m <- as(basket_rules_m,"data.frame")
summary(basket_rules_m)

basket_rules_m = subset(basket_rules_m, lift >= 114)
df_basket_m <- as(basket_rules_m,"data.frame")
View(df_basket_m)

library(arulesViz)
plot(basket_rules_m)
plot(basket_rules_m, method = "grouped", control = list(k = 1))
plot(basket_rules_m, method="graph", control=list(type="items"))

# Artist wise 


df_SongList_a <- ddply(df_SongsData,c("User.ID","Artist.Of.Song"), 
                     function(df1)paste(df1$Song.Title,
                                        collapse = ","))
colnames(df_SongList_a) <- c("","","song_title")

write.csv(df_SongList_a,"C:/Users/Admin/Desktop/Apriori/A_SongList.csv", row.names = TRUE)


txn = read.transactions(file="C:/Users/Admin/Desktop/Apriori/A_SongList.csv", 
                        rm.duplicates= TRUE, format="basket",sep=",",cols=1);


txn@itemInfo$labels <- gsub("\"","",txn@itemInfo$labels)

basket_rules_a <- apriori(txn,parameter = list(sup = 0.04, conf = 0.5,target="rules"));

df_basket_a <- as(basket_rules_a,"data.frame")
View(df_basket_a)


plot(basket_rules_a)
plot(basket_rules_a, method = "grouped", control = list(k = 1))
plot(basket_rules_a, method="graph", control=list(type="items"))


