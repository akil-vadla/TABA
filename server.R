#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(magrittr)
library(igraph)
library(ggraph)
library(ggplot2)
options(shiny.maxRequestSize=30*1024^2)
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  #Reading text data from the uploaded text file
  Dataset <- reactive({
    if (is.null(input$file1)) { return(NULL) }
    else{
      TextData <- as.character(readLines(input$file1$datapath))
      return(TextData)
    }
  })
  
  #Language model used on the text uploaded
  Lang_Model <- reactive({
    if (is.null(input$file2)) { return(NULL) }
    else{
      ModelData <- udpipe_load_model(input$file2$datapath)
      return(ModelData)
    }
  })
  
  #Co-Occurrence Plot
  output$plot1 = renderPlot({
    x <- as.data.frame(udpipe_annotate(Lang_Model(),x = Dataset()))
    y <- cooccurrence(x=subset(x,xpos %in% input$xpos),
                      term = "lemma",
                      group = c("doc_id","paragraph_id","sentence_id"))
    wordnetwork <- y
    wordnetwork <- igraph::graph_from_data_frame(wordnetwork)
    
    ggraph(wordnetwork, layout = "fr")+
      geom_edge_link(edge_colour = "orange")+
      geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
      labs(title = "Co-Occurrences Plot")
  
    })
  
  
}) 
