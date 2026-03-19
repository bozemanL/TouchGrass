# Touch Grass
Have you ever gone outside and it's raining? That's the worst. When we're busy, its hard to keep up 
with the weather. Instead of always guessing, Touch Grass notifies you for spontaneous outside activities
and helps you be more aware of the weather.

Touch grass is an improved weather app that provides not only forecasts, but notifications for when 
the weather is good, a calendar view, optimized weather windows for activities you enjoy, and much
more. 

##### Target users: Type A planners or people who need to optimize for going outside.
##### Mission: Make going outside easier. 

## Functionality
### LocationManager
##### What were we trying to achieve? 
We want to grab the user's location to get the nearest weather station to provide forecasts. 

##### What are the constraints?
Location is considered a private thing. So, when the user first downloads the app, we must ask them for
permission to use their location.

##### Where can you find the LocationManager?
You can find the `LocationManager` file inside the main project directory. There we handle getting the location
and parsing it into coordinates. We then hand those coordinates to the WeatherService to request forecasts.

### Notifications
##### What were we trying to achieve? 
We want notifications to the user whenever there is nice weather outside for today.

##### What are the constraints?
Notifications are typically only sent if the app is closed. For testing reasons, we want the notifications
to still show up whether or not the app is open. By default, iOS hides the notification, so we devided to 
override iOS's notification behavior in this regard. 

##### Where can you find the NotificationService?
You can find all notification related functionality inside the `NotificationService` file. In the `Touch_GrassApp` file
there is a 2 small functions that override the iOS default and then the `NotificationService` handles the sending and
creation of the notifications.

### NOAA weather requesting
##### What were we trying to achieve? 
We are trying to fetch current weather data for our users based on their location. 

##### What are the constraints?
We considered using apple's WeatherKit which would have been a way easier way to fetch weather data for the user's current location. 
However, in order to use WeatherKit, you must have a paid apple developer account. Therefore, we decided to go the free route, which
just means we have to program fetching and processing weather data ourselves. 

##### Where can you find the NOAA weather implementation?
The NOAA weather implementation is in the file `WeatherService`. There are comments inside that break down the code.
