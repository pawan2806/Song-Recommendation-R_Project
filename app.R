#R Shiny App for Recommendations
library(shiny)
library(dplyr)
library(shinythemes)
library(spotifyr)
library(bslib)
library(DT)
library(plyr)
library(dplyr)
library(scales)
library(lsa)

my_function <- function(songIdAsArgument) {
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
# print(paste("Choose index Between 0 and ", nrow(df_SongsDataNormalized)-1))
indexToBeRecommended <- songIdAsArgument
# print(indexToBeRecommended)

songRow <- similarityMatrix[indexToBeRecommended+1,]
songPairs <- vector(mode = "list", length = length(songRow))
for(var in 1:length(songRow)) {
    songPairs[[var]] <- c(songRow[var],var)
}
sortedSongPairs <- order(-sapply(songPairs, `[`, 1))

print("CHECKPOINT3")

return(sortedSongPairs)

}
id <- #redacted
secret <- #redacted
Sys.setenv(SPOTIFY_CLIENT_ID = "42af6f2a1ff744f3b5217c96e4112792")
Sys.setenv(SPOTIFY_CLIENT_SECRET = "461c2912d78b4fcbb9d0a5a0cf36636d")
access_token <- get_spotify_access_token()

genres <- c("acoustic", "afrobeat","alt-rock", "alternative", "ambient", "anime", "black-metal","bluegrass","blues","bossanova",
            "brazil","breakbeat","british","cantopop","chicago-house","children","chill", "classical","club", "comedy","country",
            "dance","dancehall","death-metal","deep-house", "detroit-techno","disco","disney","drum-and-bass","dub","dubstep",
            "edm","electro","electronic","emo","folk","forro","french","funk","garage","german","gospel","goth","grindcore",
            "groove","grunge","guitar","happy","hard-rock","hardcore","hardstyle","heavy-metal","hip-hop","holidays","honky-tonk",
            "house","idm","indian","indie","indie-pop","industrial","iranian","j-dance","j-idol","j-pop","j-rock","jazz","k-pop",
            "kids","latin","latino","malay","mandopop","metal","metal-misc","metalcore","minimal-techno","movies","mpb","new-age",
            "new-release","opera","pagode","party","philippines-opm","piano","pop","pop-film","post-dubstep","power-pop",
            "progressive-house","psych-rock","punk","punk-rock","r-n-b","rainy-day","reggae","reggaeton","road-trip","rock",
            "rock-n-roll","rockabilly","romance","sad","salsa","samba","sertanejo","show-tunes","singer-songwriter","ska",
            "sleep","songwriter","soul","soundtracks","spanish","study","summer","swedish","synth-pop","tango","techno",
            "trance","trip-hop","turkish","work-out","world-music")

ui <- fluidPage( theme = bs_theme(version = 4, bootswatch = "minty"),
  # App title ----
  h2("Playlist Recommendations"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      # Inputs
      numericInput("artist", "Input a Song",0 ,
             min = 1, max = 100),
      actionButton("request", "Get Recommendations!", style="color: #fff; background-color: #228B22; border-color: #2e6da4")
    
    ),
    
    mainPanel(
      
      # Output
      htmlOutput("example"),
      verbatimTextOutput(outputId = "playlist"),
      tags$head(tags$style("#text1{color: red;
                                 font-size: 20px;
                           font-style: italic;
                           }"
                         )
      )
      
    )
  )
)

server <- function(input, output, session) {
  
 states <- reactive({
       my_function((input$artist))
    })
 output$example <- renderUI({

      x <- paste0("<strong>Here are some recommendations (decreasing order of similarity):</strong> \n ", paste(states(), collapse = " "))
      HTML(x)

    }) 
  

}

shinyApp(ui = ui, server = server)