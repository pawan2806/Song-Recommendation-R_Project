#R Shiny App for Recommendations
library(shiny)
library(dplyr)
library(shinythemes)
library(bslib)
library(DT)
library(dplyr)
library(plyr)
library(scales)
library(lsa)

getRecommendation <- function(songIdAsArgument) {
  df_SongsData <- read.csv("songFeatures.csv")
min_max_norm <- function(x) {
    if(max(x)==0 && min(x)==0){
        x
    }else{
        (x - min(x)) / (max(x) - min(x))
    }
    
  }
df_SongsDataNormalized <- as.data.frame(lapply(df_SongsData[4:14], min_max_norm))

mm = t(as.matrix(df_SongsDataNormalized[,]))
similarityMatrix <- cosine(mm)

indexToBeRecommended <- songIdAsArgument


songRow <- similarityMatrix[indexToBeRecommended,]
songPairs <- vector(mode = "list", length = length(songRow))
for(var in 1:length(songRow)) {
    songPairs[[var]] <- c(songRow[var],var)
}

sortedSongPairs <- order(-sapply(songPairs, `[`, 1))
print("CHECKPOINT3")

A <- matrix(
  sortedSongPairs,
  nrow = 6,            
  ncol = 2,            
  byrow = FALSE         
)

for(var in 2:6) {
    A[var, 2] <- df_SongsData[sortedSongPairs[var],2]
}


return(as.matrix(A[2:6,]))
}
df_SongsData <- read.csv("songFeatures.csv")
ui <- fluidPage( theme = bs_theme(version = 4, bootswatch = "minty"),

  h2("Playlist Recommendations"),
  
  sidebarLayout(
    
    sidebarPanel(
      
      numericInput("ID", "Input a Song",1 ,
             min = 1, max = 100),
      
      textOutput("songName"),
      actionButton("request", "Get Recommendations!", style="color: #fff; background-color: #228B22; border-color: #2e6da4"),
      br(),
      br(),
      br(),
      br(),
      dataTableOutput('table'),
    ),
    
    mainPanel(
      
      htmlOutput("example"),
      
      dataTableOutput('datasetTable'),
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
getTable <- function() {
  dataset <- as.data.frame(read.csv("songFeatures.csv"))
  # print(dataset)
  df <- data.matrix(dataset)
  # print(df)
  print(length(df[,1]))
  for(var in 1:length(df[,1])) {
    df[var, 2] <- df_SongsData[var,2]
  }
  for(var in 1:length(df[,1])) {
    df[var, 1] <- (as.integer(df[var,1]) +1)
  }

  return(df[,1:2])
}
server <- function(input, output, session) {
  
 states<- reactive({
       getRecommendation((input$ID))
    })
  
  output$songName <- reactive( {
    toString((df_SongsData[(input$ID),2]))
  })

 output$table <- renderDataTable(states(), rownames = FALSE,
  colnames = c("SongID", "Song Name"),)

  datasetStates<- reactive({
       getTable()
    })
  output$datasetTable <- renderDataTable(datasetStates(), rownames = FALSE,
  colnames = c("SongID", "Song Name"),)

}

shinyApp(ui = ui, server = server)
