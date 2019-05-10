library(shinydashboard)
library(leaflet)
library(plotly)
library(shiny)

source("plotlyGraphWidget.r")


library(shiny)
library(leaflet)
library(dplyr)
library(tidyr)
library(tidyverse)

t2_ports <- read.csv("db/ports.csv") 
#%>% dplyr::filter(Wpi_country_code == "ES" | Wpi_country_code == "US" | Wpi_country_code == "IN")
t2_ports <- t2_ports[order(t2_ports$Main_port_name),]
t2_ports_src <- unique(t2_ports$Main_port_name)
t2_ports_dest <- unique(t2_ports$Main_port_name)

t2_countries <- unique(t2_ports$Wpi_country_code)
t2_countries <- t2_countries[order(t2_countries)]

t2_vessel <- read.csv("db/vessels.csv")