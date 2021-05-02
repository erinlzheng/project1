# Repository for project:
The distribution of (auto) insurance companies, by county, in Georgia, USA relative to population size and number of reported car accidents.
Team C3:
Corey Devin Anderson, Erin Zheng, William Won Jung, Chuck Youngerman

Languages: Python, R
IDEs: Jupyter Notebook (.ipynb), Base R
Output file formats: .csv, .png

We used Python with jupyter notebook and ‘pandas’ (plus additional modules, such as ‘np’, ‘requests’, and ‘json’) to read in and clean data sources acquired from .csv (census and accident). We also developed code for acquiring insurance agency data using Google Maps API, and component code for cleaning and analyzing the data. Places searches were done initially for the first page of search results, which has a maximum of 20 records (places_cities_insurance.ipynb). We then developed code to do a recursive search of next_page_tokens for all places (places_cities_token.ipynb file) and then an analogue set of code for searching more efficiently along a systematic grid of points (places_grid_token.ipynb).
We used geopandas to build a GeoDataFrame for the county boundaries and merged it, by county, with the census, accident, and insurance agency data. The hot-spot analysis was done using the R package ‘spdep’, with the help of ‘gridExtra’, ‘maptools’, ‘rgdal’, ‘sp’, ‘spdep’,  and ‘spatstat’ for handling and manipulating spatial objects and plots. Required shapefiles for the analysis and plots can be found in the files with the suffix shapefile.

Please look towards the README
