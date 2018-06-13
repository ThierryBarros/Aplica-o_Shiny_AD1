#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
library(tidyverse)
library(here)
library(ggplot2)
library(rsconnect)
library(plotly)
source(here("code/read_wrangle.R"))

vias = read_wrangle_data()

profissoes_nos_dados = vias %>% 
  filter(!is.na(profissao)) %>%  
  pull(profissao) %>% 
  unique()

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    prof_selecionada = reactive({input$profissao})
    

    output$distPlot <- renderPlot({
        vias_profissao = vias %>% filter(comprimento<input$tamanho & arvore<input$arvore & profissao == prof_selecionada())
        vias_profissao %>% 
            ggplot(aes(x = pontoonibu)) + 
            geom_histogram(binwidth = 1, 
                           boundary = 0, 
                           fill = "darkgreen") + 
            scale_x_continuous(limits = c(0, input$bins)) + ggtitle(paste("Histograma dos pontos de ônibus de Campina Grande para profissão:",toString(prof_selecionada())) )  + xlab("quantidade de pontos de ônibus") + ylab("numero de ruas")
    })
    output$dPlot <- renderPlot({
        vias_profissao = vias %>% filter(comprimento<input$tamanho & arvore<input$arvore & profissao == prof_selecionada())
        plot_ly(vias_profissao,x = vias_profissao$comprimento, y =vias_profissao$arvore, 
                text = paste("Onibus: ",vias_profissao$pontoonibu),
                mode = "markers", color = vias_profissao$arvores_100m_mean, size = vias_profissao$pontoonibu) 
        
        
    })
 
    
    output$listagem <- renderTable({
        vias %>% 
            filter(comprimento<input$tamanho & arvore<input$arvore & profissao == prof_selecionada()) %>% 
            select(nome = nomelograd, 
                   comprimento, arvore) %>% arrange(desc(comprimento),desc(arvore)) %>% head(input$numero) 
           
        
    })
    
})
