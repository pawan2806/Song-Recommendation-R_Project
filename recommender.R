library(plyr)
library(dplyr)
library(scales)
library(lsa)
df_SongsData <- read.csv("songFeatures.csv")
min_max_norm <- function(x) {
    if(max(x)==0 && min(x)==0){
        x
    }else{
        (x - min(x)) / (max(x) - min(x))
    }
    
  }
df_SongsDataNormalized <- as.data.frame(lapply(df_SongsData[4:14], min_max_norm))
# print(df_SongsDataNormalized[1:2,1])    #Columns, then Rows CxR
# print(df_SongsDataNormalized)
mm = t(as.matrix(df_SongsDataNormalized[,]))
similarityMatrix <- cosine(mm)
# print(similarityMatrix)
print(paste("Choose index Between 0 and ", nrow(df_SongsDataNormalized)-1))
indexToBeRecommended <- as.integer(readline());
# print(indexToBeRecommended)

songRow <- similarityMatrix[indexToBeRecommended+1,]
songPairs <- vector(mode = "list", length = length(songRow))
for(var in 1:length(songRow)) {
    songPairs[[var]] <- c(songRow[var],var)
}
sortedSongPairs <- order(-sapply(songPairs, `[`, 1))

print("CHECKPOINT3")
print(paste("Top 5 Recommendations for the song ",df_SongsData[indexToBeRecommended+1,2]," are "))
# print(sortedSongPairs)
for(var in 1:5){
    x <- sortedSongPairs[var]
    print(x)
    # print("NUM")
    print(df_SongsData[x,2])
}
