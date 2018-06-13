library(shiny)
library(tidyverse)
library(here)
library(rsconnect)
source(here("code/read_wrangle.R"))

profissoes_nos_dados = read_wrangle_data() %>% 
    filter(!is.na(profissao)) %>%  
    pull(profissao) %>% 
    unique()

comprimento = read_wrangle_data() %>% select(comprimento)
arvore = read_wrangle_data() %>% select(arvore)
# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Ruas de Campina Grande"),
  h3("Veja como é a relação da ruas com o nome da profissão, o número de árvores em cada rua, seu comprimento e número de pontos de ônibus. Dependendo da profissão as características tem ou não forte relação. No final tem uma lista das ruas daquela profissão em ordem crescente de comprimento e número de árvores."),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
        selectInput("profissao", 
                    "Profissão", 
                    choices = profissoes_nos_dados), 
        sliderInput("bins",
                    "Number de pontos de onibus:",
                    min = 1,
                    max = 100,
                    value = 30),
        sliderInput("tamanho",
                    "Comprimento máximo das ruas",
                    min = as.numeric(comprimento[which.min(comprimento$comprimento),1]),
                    max = as.numeric(comprimento[which.max(comprimento$comprimento),1]),
                    value = 1000),
        sliderInput("arvore",
                    "Número máximo de arvores:",
                    min = as.numeric(arvore[which.min(arvore$arvore),1]),
                    max = as.numeric(arvore[which.max(arvore$arvore),1]),
                    value = 20),
        numericInput("numero","Número de ruas:",5,1,50)
        
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"), 
       plotOutput("dPlot"), 
       tableOutput("listagem")
    )
  )

  
  
))
