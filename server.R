#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

list.of.packages <- c("rsconnect" ,"tidyverse","ggplot2", "shiny", "data.table", "DT", "readr", "ggeasy", "RCurl")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(RCurl)
library(shiny)
library(tidyverse)
library(data.table)
library(DT)
library(readr)
library(ggeasy)
library(rsconnect)
library(ggplot2)

# 1. Importacion datos

ruta <- "https://raw.githubusercontent.com/AlvaroMartinAmor/UNED-Data-Visualization-shiny/main/stats.csv"
stats <- read.csv(ruta)

stats

#   2.A stats dataset 
stats_b <- stats %>%
    separate("season", c("Season_YearStart", "Season_YearEnd"), sep = "-") %>%
    group_by(team) %>%
    mutate_if(is.character,as.numeric) %>%
    ungroup() %>%
    filter(Season_YearStart > 2009) %>%
    mutate(draws = (38 - wins -losses), points = (wins*3 + draws)) %>%
    mutate(diff_goals = (goals-goals_conceded))


str(stats_b) 

#Creacion variables
stats <- stats_b[2:length(stats_b)]

winners_table<- stats_c[, .SD[which.max(points)],
                        by = .(Season_YearStart),
                        .SDcols=c("team", "points","wins", "losses", "draws", "goals", "goals_conceded", "diff_goals")]

team1 <- unique(stats_b$team)

nums <- sapply(stats_b, is.numeric)
numericas <- names(stats_b[nums])

# --------SHINY-------

shinyServer(function(input, output) {
    
    output$Image <- renderImage({
        # When input$n is 1, filename is ./images/image1.jpeg
        filename <- normalizePath(file.path('C:/Users/alvar/Desktop/UNED/8. Visualizacion Avanzada R/Trabajo modulo/Premier_League/PremierLeague/logo_PL.jpg',
                                            paste('image', input$n, '.jpg', sep='')))
        # Return a list containing the filename
        list(src = filename)
    }, deleteFile = FALSE)

        
    
    output$winners_table <- DT::renderDataTable({
        
        winners_table<- stats_c[, .SD[which.max(points)],
                                by = .(Season_YearStart),
                                .SDcols=c("team", "points","wins", "losses", "draws", "goals", "goals_conceded", "diff_goals")]
        datatable(winners_table, colnames = c("Temporada", "Equipo", "Puntos", "Victorias", "Empates", "Derrotas", "GF", "GC", "DG"))
        })
    
    
    output$winners_titles <- renderPlot({
        winners_table %>% 
            group_by(team) %>% 
            summarise(titles = n()) %>%
            ggplot(aes(x=team, y= titles, fill = team)) +
            geom_bar(stat = 'identity')+
            labs(x = "Equipo", y = "Nº de títulos")+
            ggtitle("Títulos Premier League 2010/11 - 2017/18")+
            theme(legend.position = "none")+
            ggeasy::easy_center_title() 


        })
    
    
    output$lineplot <- renderPlot({
      sel_team <- c(input$team, input$team2, input$team3)  
      p <- ggplot(subset(stats_b, team %in% sel_team), 
                  aes_string(x="Season_YearStart", y=input$variable, by = "team", colour = "team")) + 
        geom_line()+
        geom_point(size=3) +
        theme(plot.title = element_text(size = 30, face = "bold", hjust = 0.5,) ,legend.position= "top",
              axis.title.x = element_text(size = 20, face = "italic"),
              axis.title.y = element_text(size = 20, face = "italic"))+
        ggtitle("Comparación de estadísticas de equipos") +
        xlab("Año inicio temporada") +
        ylab(input$variable)
      
      
      print(p)
      

        
    })
    
})        
    


