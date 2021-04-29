#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(shinythemes)


# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("sandstone"),
    
    titlePanel("Premier League 2010/11-2017/18 stats"),
    
    navbarPage(img(src ="https://eleconomista.com.ar/wp-content/uploads/2019/07/Premier-League.png", allign="top",
                   height = 35, width = 60),
        
        tabPanel("Introducción",
                 widths = 2,
                 mainPanel(
                     h1("Visualización avanzada de datos", align="center"),
                     h2("Ejercicio fin de modulo", align="center"),
                     h2("Álvaro Martín Amor", align="center"),
                     p("La base de datos utilizada contiene datos sobre la competición nacional
                       inglesa de fútbol Premier League entre las temporadas 2006/07-2017-18, pero los datos analizados parten de la temporada 2010/2011 que es
                       la temporada por la cual empezamos a contar con todas las estadísticas posibles.", align ="left"),
                     p("El objetivo de este ejercicio es realizar gráficos avanzados con Shiny, en los cuales
                       compararemos a los equipos que han disputado esta competición y visualizaremos 
                       diversas estadísticas futbolísticas que nos puedan ayudar a comparar a los equipos.", align="left"),
                     img(src="https://i1.wp.com/www.neogol.com/wp-content/uploads/2020/01/posiciones-premier-league2020-2021-1.jpg",
                         align = "center",height = 300, width = 560),
                     img(src="https://e00-ar-marca.uecdn.es/claro/assets/multimedia/imagenes/2021/03/29/16170452792778.jpg",
                         align = "right",height = 300, width = 400)
                 )),


        tabPanel("Ganadores",
                 sidebarLayout(
                     sidebarPanel(
                         plotOutput("winners_titles")
                     ),
                 
                 mainPanel(
                     titlePanel("Ganadores"),
                     dataTableOutput("winners_table"))
                     
                     )),
        
        tabPanel("Estadísticas de temporada",
            
            sidebarLayout(
                sidebarPanel(
                    
                    # Select type of trend to plot
                    
                    selectInput(inputId = "variable", 
                                label = strong("Seleccione Variable:"),
                                choices = sort(numericas),
                                selected = "points"),
                    
                    selectInput(inputId = "team", 
                                label = strong("Equipo #1"),
                                choices = sort(team1),
                                selected = "Arsenal"),
                    
                    selectInput(inputId = "team2", 
                                label = strong("Equipo #2"),
                                choices = sort(team1),
                                selected = "Chelsea"),
                    
                    selectInput(inputId = "team3", 
                                label = strong("Equipo #3"),
                                choices = sort(team1),
                                selected = "Manchester City")
                ),
                
                mainPanel(
                    plotOutput(outputId = "lineplot", height="600px", width = "1100px"),
                     
                )
            )
                    
        )  
        
    )
    ))
        
