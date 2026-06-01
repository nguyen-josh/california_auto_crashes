# California Car Crashes
# Analyzes data from car crashes in California from 2014 - 2023 by the crash type, causes, location, and time.

library(shiny)
library(tidyverse) 
library(lubridate)
library(leaflet)
library(plotly)

 crashes = read_csv(
   file = "crashes_california.csv", 
   col_types = list(
     col_double(),    #  1) CASE_ID
     col_double(),    #  2) ACCIDENT_YEAR
     col_date(),      #  3) COLLISION_DATE 
     col_double(),    #  4) COLLISION_TIME 
     col_double(),    #  5) HOUR 
     col_integer(),   #  6) DAY_OF_WEEK 
     col_character(), #  7) WEATHER_1 
     col_character(), #  8) WEATHER_2 
     col_character(), #  9) STATE_HWY_IND
     col_character(), # 10) COLLISION_SEVERITY 
     col_integer(),   # 11) NUMBER_KILLED 
     col_integer(),   # 12) NUMBER_INJURED 
     col_integer(),   # 13) PARTY_COUNT 
     col_character(), # 14) PCF_VIOL_CATEGORY 
     col_character(), # 15) TYPE_OF_COLLISION 
     col_character(), # 16) ROAD_SURFACE 
     col_character(), # 17) ROAD_COND_1 
     col_character(), # 18) ROAD_COND_2 
     col_character(), # 19) LIGHTING 
     col_character(), # 20) PEDESTRIAN_ACCIDENT 
     col_character(), # 21) BICYCLE_ACCIDENT 
     col_character(), # 22) MOTORCYCLE_ACCIDENT 
     col_character(), # 23) TRUCK_ACCIDENT 
     col_character(), # 24) NOT_PRIVATE_PROPERTY 
     col_character(), # 25) ALCOHOL_INVOLVED 
     col_character(), # 26) COUNTY 
     col_character(), # 27) CITY 
     col_character(), # 28) PO_NAME
     col_double(),    # 29) ZIP_CODE
     col_double(),    # 30) POINT_X 
     col_double()     # 31) POINT_Y 
   ))

 crashes <- crashes |>
   mutate(
     year = ACCIDENT_YEAR,
     month = month(COLLISION_DATE),
     wday = wday(COLLISION_DATE, label = TRUE)
   )
 
 years_available <- sort(unique(crashes$year))
 pcf_categories <- sort(unique(crashes$PCF_VIOL_CATEGORY))
 cities_available <- sort(unique(crashes$PO_NAME))
 type_collisions <- sort(unique(crashes$TYPE_OF_COLLISION))
 collision_severities <- sort(unique(crashes$COLLISION_SEVERITY))
 
ui <- fluidPage(
  
  titlePanel("Car Crashes in California (2014 - 2023)"),
  
  sidebarLayout(
    sidebarPanel(
      
      conditionalPanel(
        condition = "input.tabselected==1",
        h4("Exploratory Analysis Filters"),
        sliderInput("year_range", "Select Year Range:",
                    min = min(years_available),
                    max = max(years_available),
                    value = c(min(years_available), max(years_available)),
                    sep = ""),
        selectInput("pcf_filter",
                    "Select PCF Violation Category:",
                    choices = c("All", pcf_categories),
                    selected = "All"),
        selectInput("type_filter",
                    "Select Type(s) of Collision:",
                    choices = type_collisions,
                    selected = type_collisions,
                    multiple = TRUE)
      ),
      
      conditionalPanel(
        condition = "input.tabselected==2",
        h4("Map Filters"),
        selectInput("map_year",
                    "Select Year:",
                    choices = years_available,
                    selected = max(years_available)),
        selectInput("map_cities",
                    "Select City(ies):",
                    choices = cities_available,
                    selected = c("LOS ANGELES", "SAN FRANCISCO"),
                    multiple = TRUE),
        selectInput("map_pcf",
                    "Select PCF Violation Category(ies):",
                    choices = pcf_categories,
                    selected = pcf_categories[1],
                    multiple = TRUE),
        radioButtons("map_color",
                     "Color code by:",
                     choices = c("TYPE_OF_COLLISION", "COLLISION_SEVERITY"),
                     selected = "TYPE_OF_COLLISION")
      ),
      
    ),
    
    mainPanel(
      tabsetPanel(
        type = "tabs",

        tabPanel(title = "Explore",
                 value = 1,
                 plotlyOutput(outputId = "plot1"),
                 hr(),
                 plotOutput(outputId = "plot2"),
                 hr(),
                 plotOutput(outputId = "plot3")),

        tabPanel(title = "Map",
                 value = 2,
                 leafletOutput("map", height = 600)),

        id = "tabselected"
        
      ) 
    )
    
    
  ) 
) 
 
server <- function(input, output) {
  
  filtered_data_tab1 <- reactive({
    df <- crashes
    df <- df |> filter(
      year >= input$year_range[1],
      year <= input$year_range[2]
    )
    if(input$pcf_filter != "All") {
      df <- df |> filter(PCF_VIOL_CATEGORY == input$pcf_filter)
    }
    df <- df |> filter(TYPE_OF_COLLISION %in% input$type_filter)
    df
  })
  
  output$plot1 <- renderPlotly({
    df <- filtered_data_tab1()
    yearly_counts <- df |>
      group_by(year) |>
      summarise(num_crashes = n())
    p <- ggplot(yearly_counts, aes(x = factor(year), y = num_crashes)) +
      geom_col(fill = "skyblue") +
      labs(
        title = "Number of Crashes per Year",
        x = "Year",
        y = "Number of Crashes"
      ) +
      theme_minimal()
    ggplotly(p)
  })

  output$plot2 <- renderPlot({
    df <- filtered_data_tab1()
    day_counts <- df |>
      group_by(wday) |>
      summarise(num_crashes = n())
    ggplot(day_counts, aes(x = wday, y = num_crashes)) +
      geom_col(fill = "#FC4661") +
      labs(
        title = "Number of Crashes by Day of Week",
        x = "Day of Week",
        y = "Number of Crashes"
      ) +
      theme_minimal()
  })
  
  output$plot3 <- renderPlot({
    df <- filtered_data_tab1()
    severity_counts <- df |>
      group_by(COLLISION_SEVERITY, wday) |>
      summarise(num_crashes = n(), .groups = "drop")
    ggplot(severity_counts, aes(x = wday, y = num_crashes)) +
      geom_col(fill = "darkgreen") +
      facet_wrap(~ COLLISION_SEVERITY, scales = "free_y") +
      labs(
        title = "Crashes by Day of Week and Collision Severity",
        x = "Day of Week",
        y = "Number of Crashes"
      ) +
      theme_minimal()
  })
  
  filtered_map_data <- reactive({
    df <- crashes
    df <- df |> filter(year == input$map_year)
    df <- df |> filter(PO_NAME %in% input$map_cities)
    df <- df |> filter(PCF_VIOL_CATEGORY %in% input$map_pcf)
    df
  })
  
  output$map <- renderLeaflet({
    df <- filtered_map_data()
    if(input$map_color == "TYPE_OF_COLLISION") {
      pal <- colorFactor(palette = "Set1", domain = df$TYPE_OF_COLLISION)
      color_col <- df$TYPE_OF_COLLISION
    } else {
      pal <- colorFactor(palette = "Set1", domain = df$COLLISION_SEVERITY)
      color_col <- df$COLLISION_SEVERITY
    }
    leaflet(data = df) |>
      addTiles() |>
      addCircleMarkers(
        lng = ~POINT_X,
        lat = ~POINT_Y,
        color = ~pal(color_col),
        radius = 4,
        stroke = FALSE,
        fillOpacity = 0.7,

        label = ~paste0("Date: ", COLLISION_DATE, 
                        "<br>Type: ", TYPE_OF_COLLISION,
                        "<br>Cause: ", PCF_VIOL_CATEGORY,
                        "<br>Severity: ", COLLISION_SEVERITY),
        labelOptions = labelOptions(style = list("font-weight" = "normal", padding = "3px 8px"), direction = "auto")
      ) |>
      addLegend("bottomright", pal = pal, values = color_col, title = input$map_color)
  })
  
}

shinyApp(ui = ui, server = server)
