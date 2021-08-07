library(shiny)
library(rmarkdown)


#Load helper functions


# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Type Assist"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            p(span("Type-assist",style="color:blue"),"is an application that uses n-gram modeling to
              predict next word while typing a sentence."),
            p("This project is developed as part of the Data Science Specialization hosted on Coursera by 
              John Hopkins University. The training data has been provided by Swiftkey, 
              is publicly available, collected from randomly chosen news, tweets and blogs."),
            img(src="Coursera_Logo.jpg", height=100, width=200),
            img(src="university_logo.png", height=100, width=200),
            div(img(src="swift_key.jpg", height=100, width=100, align="center"), style="float:right") 
            
        ),
            

        # Show a plot of the generated distribution
        mainPanel(
            navbarPage(title="Project",
            tabPanel("App",
                     fluidPage(
                            textInput("ngramInput","Start typing:"),
                            verbatimTextOutput("predWord")
                     )
            ),
            tabPanel("Data Exploration",
                     includeHTML("Data Exlporation.html")
                     ),
            tabPanel("Model Description",
                     includeHTML("model_description.html"))
                
                    )
        )
    )
))
