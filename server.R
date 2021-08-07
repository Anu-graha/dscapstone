library(shiny)

# Load helper function

source("func.r")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$predWord<-renderText({
        if(!input$ngramInput==""){
            #print(input$ngramInput)
        nextWord<-getNextWord(str_trim(input$ngramInput))
        }
        nextWord
    })  
    
})
