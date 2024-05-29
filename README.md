
# Art Museum and Painting Analysis Using PostgreSQL
## Project description
This project is a practice exercise to enhance my SQL skills. I used a dataset from Kaggle that contains information about museums, paintings, artists, canvas sizes, and product sizes. The objective is to answer various questions using SQL queries.


## Dataset overview

* Source: [kaggle dataset link](https://www.kaggle.com/datasets/mexwell/famous-paintingsL)
* Description: The dataset includes details about various art museums, the paintings they display, the artists who created the paintings, the sizes of the canvases, and product pricing information.
## Insights
1. Paintings Not Displayed in Museums: Identified paintings that are not currently displayed in any museum.
2. Museums Without Paintings: Found museums that do not have any paintings displayed.
3. Price Analysis: Determined the number of paintings with an asking price higher than their regular price and those priced at less than 50% of their regular price.
4. Expensive Canvas Sizes: Identified the canvas size associated with the most expensive painting.
5. Invalid City Information: Detected museums with invalid city entries.
6. Popular Painting Subjects: Listed the top 10 most frequent painting subjects.
7. Museum Operation Days: Identified museums open on both Sunday and Monday, and those open every single day.
8. Top Museums and Artists: Determined the top 5 most popular museums and artists based on the number of paintings.
9. Longest Operating Museum: Found the museum that is open for the longest duration during a single day.
10. Painting Styles: Analyzed the popularity of different painting styles.
11. Artist and Museum Locations: Identified artists with paintings displayed in multiple countries and the location of the most and least expensive paintings.
12. Canvas Size Popularity: Listed the three least popular canvas sizes based on sale price.

## How to run the project

### Set Up PostgreSQL
* Install PostgreSQL on your local machine.
* Create a new database.
### Import the Dataset
* Ensure you have the dataset in CSV format.
* Use the provided Python script `load_csv.py` to import the CSV data into your PostgreSQL database.
### Run the Queries
1. Navigate to the `/sql` directory.
2. Execute the SQL queries in your PostgreSQL database to perform the analysis.


## Repository Structure

* `/sql`: Directory containing SQL query files.
* `load_csv.py`: Python script to import CSV data into PostgreSQL.
* `README.md`: Project documentation.
## Conclusion

This project helped me practice and improve my SQL skills. I learned how to write complex queries, perform joins, and aggregate data to extract meaningful insights from a dataset. By analyzing the dataset, I was able to answer various questions related to museums, paintings, and artists.
