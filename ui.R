#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that identifies parts of speech in a text
shinyUI(fluidPage(
  titlePanel("UDPipe NLP Workflow"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file1"
                ,"Upload text data file(txt file)"
      ),
      fileInput("file2"
                ,"Upload Language Model for UDPipe"),
      checkboxGroupInput(inputId = "xpos"
                         ,label = "List of xpos"
                         ,c("adjective"="JJ"
                            ,"adverb"="RB"
                            ,"noun"="NN"
                            ,"proper noun"="NNP"
                            ,"verb"="VB")
                         ,selected = c("adjective"="JJ"
                                       ,"noun"="NN"
                                       ,"proper noun"="NNP")
                         ,inline = FALSE)
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  
                  tabPanel("Overview",
                           h4(p("Data input")),
                           p("This app supports only text(.txt) data file.",align="justify"),
                           br(),
                           h4('How to use this App'),
                           p('To use this app, click on', 
                             span(strong("Upload text data file(txt file)")),
                             'and upload the text data file. You can select different parts of speech other than the default selected values from the List of Xpos')),
                  tabPanel("Co-occurence Plot", 
                           plotOutput('plot1'))
      )
    )
  )
))
