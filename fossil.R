##Data Preparation

#Import packages
library(tidyverse)
library(ggplot2)
library(plotly)
library(readxl)
library(tidyr)
library(here)
library(htmlwidgets)



## Importing data
#load the data using the file path, sheet = 3 selects the tab you want to use and skip = 8 indicates to R Studio that we want to eliminate the first 8 rows of information

data <- read_excel(here("data", "emissions.xlsx"), sheet = 3, skip = 8)


## Reshape your data

#this will create Year, Country and Emissions columns
longy_data <- pivot_longer(
  data, 
  cols = -Year,           
  names_to = "Country",   
  values_to = "Emissions")

head(longy_data)


## Define your variables
data_cleaned <- longy_data %>%
  filter(Country == "Asia"|
           Country == "Africa"|
           Country == "Central America"|
           Country == "Europe"|
           Country == "Middle East"|
           Country == "North America"|
           Country == "Oceania"|
           Country == "South America"|
           Country == "World")

data_cleaned <- data_cleaned  %>% filter(Year != 2021)

## Plot the data


p <-ggplot(data_cleaned, aes(x = Year, y = Emissions, group = Country))
p + geom_line()


## Personalize your graph

ggplot(data_cleaned, aes(x = Year, y = Emissions, group = Country, color = Country)) +
  geom_line(linewidth = 0.7, alpha = 0.7) + #linewidth adjust the size of the lines and alpha adjusts the transparency 
  theme_minimal() +    #changes the background
  labs(
    title = "Global Emission Trends by Continent", #adds a title
    subtitle = "Shown is the carbon emissions in million tonnes of carbon every ten years.", #adds a subtitle
    caption = "Source: Integrated Carbon Observation System", #adds a caption
    x = "Year",        #names the x axis
    y = "Emissions",   #namres the y axis
    color = "Legend")  #adds color to the continents.


## Save the plot in order to make it interactive
gg <- ggplot(data_cleaned, aes(x = Year, y = Emissions, group = Country, color = Country)) +
  geom_line(linewidth = 0.7, alpha = 0.7) +  
  theme_minimal() +
  labs(
    title = "Global Emission Trends by Continent",
    subtitle = "Shown is the carbon emissions in million tonnes of carbon every ten years.",
    caption = "Source: Integrated Carbon Observation System",
    x = "Year",
    y = "Emissions",
    color = "Legend")  


## Convert to plotly object
```{r warning = FALSE}
interactive_plot <- ggplotly(gg) %>%
  layout(
    annotations = list(
      list(
        x = 0.5,
        y = 1.02,
        text = "Shown is the carbon emissions in million tonnes of carbon every ten years.",
        showarrow = FALSE,
        xref = "paper",
        yref = "paper",
        font = list(size = 12))))
```

## Ensure it works on R Markdown
```{r warning = FALSE}
saveWidget(as_widget(interactive_plot), "interactive_plot.html", selfcontained = TRUE)
```

## Make the graph interactive 
```{r warning = FALSE}
ggplotly(gg) %>%
  layout(
    margin = list(b = 100, l = 100),  # Adjust bottom and left margins for axis labels
    xaxis = list(
      title = list(
        text = "Year",  # Add custom x-axis title
        font = list(size = 14)
      )
    ),
    yaxis = list(
      title = list(
        text = "Emissions (million tonnes)",  # Add custom y-axis title
        font = list(size = 14)
      )
    ),
    annotations = list(
      # Add the main subtitle
      list(
        x = 0.5,
        y = 1.05,
        text = "Shown is the carbon emissions in million tonnes of carbon every ten years.",
        showarrow = FALSE,
        xref = "paper",
        yref = "paper",
        font = list(size = 12)
      ),
      # Add the caption as a separate annotation
      list(
        x = 0,
        y = -0.2,  # Position it below the graph
        text = "Source: Integrated Carbon Observation System",
        showarrow = FALSE,
        xref = "paper",
        yref = "paper",
        xanchor = "left",  # Align to the left
        font = list(size = 10, color = "gray"))))

```

#The end result should be an interactive graph that displays the continentsand their respective fossil emissions on a thirty-year period.
