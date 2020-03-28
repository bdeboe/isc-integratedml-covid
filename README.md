# IntegratedML COVID-19 Experiments

This repository contains a few helper classes to support experimenting with the COVID-19 dataset [published by John Hopkins](https://github.com/CSSEGISandData/COVID-19) through InterSystems IRIS IntegratedML.

## Setting up


1. Download the original dataset by cloning the CSSE dataset by running the following OS shell command:

    ```
    git clone https://github.com/CSSEGISandData/COVID-19.git
    ```

2. Import this repository's code from an IRIS shell in your namespace of choice and import the data:

    ```
    do $system.OBJ.LoadDir("/path/to/src/iris/",,"c",1)
    do ##class(COVID.Utils).LoadData("/path/to/CSSEGISandData/\COVID-19\csse_covid_19_data\csse_covid_19_time_series\")
    ```

    This will amend any data already loaded, so to pick up an updated source file, just re-run the `LoadData()` method.

3. ...
