#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
#######################################
#Team Details#
#Akil Baba Vadla          - 11810098
#Pavan Kumar Reddy Banda  - 11810005
#Ravi Kumar Musinana      - 11810064 
#######################################
library(shiny)
library(udpipe)
library(magrittr)
library(igraph)
library(ggraph)
library(ggplot2)
library(plyr)
library(wordcloud)
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
    wordnetwork <- head(y,100)
    wordnetwork <- igraph::graph_from_data_frame(wordnetwork)
    
    ggraph(wordnetwork, layout = "fr")+
      geom_edge_link(edge_colour = "orange")+
      geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
      theme_graph(base_family = "Arial Narrow") +  
      theme(legend.position = "none") +
      labs(title = "Co-Occurrences Plot")
  
    })
  #XPOS Frequency Plot
  output$plot2 = renderPlot({
    x <- as.data.frame(udpipe_annotate(Lang_Model(),x = Dataset()))
    y <- subset(x,xpos %in% input$xpos)
    xpos_count<-count(y$xpos)
    barplot(xpos_count$freq
            ,col = xpos_count$x
            ,legend.text = xpos_count$x
            ,args.legend = list(x="topright")
            ,ylab = "XPOS frequencies"
            ,ylim = c(0,100))
  })
  
  #Word Cloud
  output$plot3 = renderPlot({
    x <- as.data.frame(udpipe_annotate(Lang_Model(),x = Dataset()))
    y <- subset(x,xpos %in% input$xpos)
    freq_data <- txt_freq(y$lemma)
    wordcloud(words = freq_data$key,
              freq = freq_data$freq,
              min.freq = 2,
              max.words = 100,
              random.order = FALSE,
              colors = brewer.pal(6,"Dark2"))
  })
  
}) 
