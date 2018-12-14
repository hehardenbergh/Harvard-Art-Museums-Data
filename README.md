# Artwork Activity at the Fogg Museum

This Shiny App looks at possible relationships between artists' nationalities and the amount of times an object is requested for viewing in the first-floor Modern and Contemporary Art gallery in the Fogg Museum at Harvard University.


## Summary

This project was spurred by my interest in which types of artworks the Fogg Museum exhibits more frequently. My passion for art has 


## Data Information

You can find a complete online catalog of Harvard's artworks with detailed descriptions on their website: https://www.harvardartmuseums.org.

this data was gathered from the Museum’s API, with invaluable help from Jeff Steward, Director of Digital Infrastructure and Emerging Technology at the Harvard Art Museums, who manages the database. The museum's detailed API, which houses interesting data on how users interact with the website, how often artworks are catalogued at different storage sites and how often they are brought into the museum galleries for exhibition. The API can be found here: https://github.com/harvardartmuseums/api-docs (you will need to request an API key. The data is in JSON format).

Concerning the datapoints, specifically the "moves" variable, there is unfortunately no way to discern which type of "move" an object undergoes, whether it is from one storage unit to another, or from one storage unit to the museum and vice versa. Unfortunately, this may skew results for my hypothesis about which types of artworks by different artists get viewed in the gallery more often. It is a compelling data set, nonetheless, with huge differences in how often selected modern and contemporary artworks have been viewed since 2009.


## Link to Shiny App

http://hhardenbergh.shinyapps.io/Harvard_art_museum_objects


### Authored by

*Hannah Hardenbergh*


### Acknowledgments

* A Special Thanks to Jeff Steward, who manages the museum API and database.
* Thank you to Dillon Smith, Ethan McCollister, and Jack Luby, who gave suggestions and helped debug along the way.
