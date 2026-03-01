## Decisions made throughout development

### NOAA weather requesting
##### What were we trying to achieve? 
We are trying to fetch current weather data for our users based on their location. 

##### What are the constraints?
We considered using apple's WeatherKit which would have been a way easier way to fetch weather data for the user's current location. 
However, in order to use WeatherKit, you must have a paid apple developer account. Therefore, we decided to go the free route, which
just means we have to program fetching and processing weather data ourselves. 

##### Where can you find the NOAA weather implementation?
The NOAA weather implementation is in the file `WeatherService`. There are comments inside that break down the code, but here is a 
high level overview: 

1. Implementation delail
2. Implementation delail
3. Implementation delail
