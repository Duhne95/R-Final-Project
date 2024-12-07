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

## Conclusions
There is a clear increase in the CO2 consumption emissions from the years 2000 to 2010, specifically of the World and Asia regions, you can observe that these areas continue to show increasing emissions until 2019 at which point there is a notable decrease in both.

In contrast, Oceania, Middle East, Africa, South America, and Central America have the lowest emissions with a slight increase in CO2 between 2002 and 2020.

North America and Europe have fairly stable emissions with the decade from 2010 to 2020 showing a slight decrease in their emissions.

Overall in can be affirmed that whilst the majority of the regions experienced an increased from 1990 to 2019, there is a  worldwide decrease from 2019 to 2020.

This can be attributed to the population's awareness and actions that there are consequences to our abusive usage of combustion fuels.

## Reference
Pierre Friedlingstein, Michael O’Sullivan, Matthew W. Jones, Robbie M. Andrew, Luke Gregor, Judith Hauck, Corinne Le Quéré, Ingrid T. Luijkx, Are Olsen, Glen P. Peters, Wouter Peters, Julia Pongratz, Clemens Schwingshackl, Stephen Sitch, Josep G. Canadell, Philippe Ciais, Rob B. Jackson,Simone Alin, Ramdane Alkama, Almut Arneth, Vivek K. Arora, Nicholas R. Bates, Meike Becker, Nicolas Bellouin, Henry C. Bittig, Laurent Bopp, Frédéric Chevallier, Louise P. Chini, Margot Cronin, Wiley Evans, Stefanie Falk, Richard A. Feely, Thomas Gasser, Marion Gehlen, Thanos Gkritzalis, Lucas Gloege, Giacomo Grassi, Nicolas Gruber, Özgür Gürses, Ian Harris, Matthew Hefner, Richard A. Houghton, George C. Hurtt, Yosuke Iida, Tatiana Ilyina, Atul K. Jain, Annika Jersild, Koji Kadono, Etsushi Kato, Daniel Kennedy, Kees Klein Goldewijk, Jürgen Knauer, Jan Ivar Korsbakken, Peter Landschützer, Nathalie Lefèvre, Keith Lindsay, Junjie Liu, Zhu Liu, Gregg Marland, Nicolas Mayot, Matthew J. McGrath, Nicolas Metzl, Natalie M. Monacci, David R. Munro, Shin-Ichiro Nakaoka, Yosuke Niwa, Kevin O´Brien, Tsuneo Ono, Paul I. Palmer, Naiqing Pan, Denis Pierrot, Katie Pocock, Benjamin Poulter, Laure Resplandy, Eddy Robertson, Christian Rödenbeck, Carmen Rodriguez, Thais M. Rosan, Jörg Schwinger, Roland Séférian, Jamie D. Shutler, Ingunn Skjelvan, Tobias Steinhoff, Qing Sun, Adrienne J. Sutton, Colm Sweeney, Shintaro Takao, Toste Tanhua, Pieter P. Tans, Xiangjun Tian, Hanqin Tian, Bronte Tilbrook, Hiroyuki Tsujino, Francesco Tubiello, Guido R. van der Werf, Anthony P. Walker, Rik Wanninkhof, Chris Whitehead, Anna Wranne, Rebecca Wright, Wenping Yuan, Chao Yue, Xu Yue, Sönke Zaehle, Jiye Zeng, Bo Zheng. (2022). Global Carbon Budget. Integrated Carbon Observation System. Sci. Data. https://doi.org/xxxxx

Peters, G., Minx, J., Weber, C., and Edenhofer, O. (2011). Growth in emission transfers via international trade from 1990 to 2008. Proceedings of the National Academy of Sciences. 108, 8903-8908. http://www.pnas.org/content/108/21/8903.abstract