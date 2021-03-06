# CurrencyConverter

# How to run
- clone the project
- run `carthage bootstrap` to pull down dependencies (install carthage if you don't have one)
- run `CurrencyConverter` target for main app.
- cmd + 'u' to run unit tests and UI tests. (currently test coverage 94.5%, mainly because AlertController is not UI tested.)


# Requirement
You should implement one screen with a list of currencies

The app must download and update rates every 1 second using API https://revolut.duckdns.org/latest?base=EUR. 
List all currencies you get from the endpoint (one per row). 
Each row has an input where you can enter any amount of money. 
When you tap on currency row it should slide to top and its input becomes first responder. 
When you’re changing the amount the app must simultaneously update the corresponding value for other currencies. 
Use swift programming language and any libraries you want. 
UI does not have to be exactly the same, it’s up to you.
