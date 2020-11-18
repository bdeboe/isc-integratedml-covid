# IntegratedML COVID-19 Experiments

This repository contains a few helper classes to support experimenting with the COVID-19 dataset [published by John Hopkins](https://github.com/CSSEGISandData/COVID-19) through [InterSystems IRIS IntegratedML](https://docs.intersystems.com/irislatest/csp/docbook/Doc.View.cls?KEY=GIML).

## Loading the code

Import this repository's code from an IRIS shell in your namespace of choice:

  ```ObjectScript
  do $system.OBJ.LoadDir("/path/to/this-repo/src/","c",,1)
  ```

Or, using [ZPM](https://github.com/intersystems-community/zpm), which will also load the data (see below)
   
  ```ObjectScript
  zpm "load /path/to/this-repo/"
  ```

## Loading the data

To load the COVID-19 data from the [CSSE repository](https://github.com/CSSEGISandData/COVID-19) that also serves as the data source to the famous [COVID-19 dashboard hosted by John Hopkins University](https://coronavirus.jhu.edu/map.html), all you need is a simple call to the `Download()` method:

  ```ObjectScript
  do ##class(COVID.Utils).Download()
  ```

Calling this method repetitively will pull the latest version of the source files and amend what's already in your database. 

When installing this module using ZPM, the `Download()` method is called as part of the configure step. To refresh the data, you can either `zpm load` the module again, or call `Download()` manually using the command above.

## Exploring the data

Now you can start exploring the dataset and build models based on the available tables:
 - `COVID.DailyData` is the base table populated based on the CSSE dataset, having state-level details for some countries
 - `COVID.DailyDataCountry` aggregates that data by country
 - `COVID.Countries` has country-level population data

Some (supposedly) useful queries gathering data for consecutive days as additional columns can be produced by the `BuildSQL()` utility method in `COVID.Utils`:

```SQL
SELECT c.Country, c.Population, c.PopulationDensity,
    d.DailyDate, d.Confirmed, d.Deaths, d.Recovered,
    d1.DailyDate AS D1_DailyDate,  d1.Confirmed AS D1_Confirmed, d1.Deaths AS D1_Deaths, d1.Recovered AS D1_Recovered ,
    d2.DailyDate AS D2_DailyDate,  d2.Confirmed AS D2_Confirmed, d2.Deaths AS D2_Deaths, d2.Recovered AS D2_Recovered
FROM COVID.DailyDataCountry d 
    JOIN COVID.Countries c ON d.Country = c.Country
    JOIN COVID.DailyDataCountry d1 ON d.Country = d1.Country AND d.DailyDate = DATEADD('day',1,d1.DailyDate)
    JOIN COVID.DailyDataCountry d2 ON d.Country = d2.Country AND d.DailyDate = DATEADD('day',2,d2.DailyDate)
```
