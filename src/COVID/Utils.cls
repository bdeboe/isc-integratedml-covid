Class COVID.Utils
{

/// Based on CSSE data from https://github.com/CSSEGISandData/COVID-19
ClassMethod LoadData(pDir As %String = "C:\Users\bdeboe\GitHub\COVID-19\csse_covid_19_data\csse_covid_19_time_series\") As %Status
{
	set tSC = $$$OK
	try {
		set tSeparator = $s($$$isWINDOWS:"\", 1:"/")
		set:$e(pDir,*)'=tSeparator pDir = pDir_tSeparator
		
		set tStatement = ##class(%SQL.Statement).%New()
		set tFile = ##class(%Stream.FileCharacter).%New()
		for tGroup = "confirmed", "deaths", "recovered" {
			set tSC = tFile.LinkToFile(pDir_"time_series_covid19_"_tGroup_"_global.csv")
			quit:$$$ISERR(tSC)
			
			set tSC = tStatement.%Prepare("INSERT OR UPDATE INTO COVID.DailyData (Country, State, DailyDate, "_tGroup_") VALUES (?, ?, TO_DATE(?||'20','MM/DD/YYYY'), ?)")
			quit:$$$ISERR(tSC)
			
			set tHeader = tFile.ReadLine(), tColCount = $l(tHeader,",")
			
			while 'tFile.AtEnd {
				set tLine = tFile.ReadLine(), tPos=0
				set tPos=tPos+1, tState = $piece(tLine,",",tPos)
				set tPos=tPos+1, tCountry = $piece(tLine,",",tPos)
				if $e(tCountry)="""" {
					while $e(tCountry,*)'="""" {
						set tPos=tPos+1, tCountry = tCountry_","_$piece(tLine,",",tPos)
					}
					set tCountry = $e(tCountry,2,*-1)
				}
				set tPos=tPos+1, tLat = $piece(tLine,",",tPos)
				set tPos=tPos+1, tLong = $piece(tLine,",",tPos)
				
				set:tState="" tState = "Combined"
				
				for i = 1:1:tColCount {
					set tDate = $piece(tHeader,",",i+4)
					set tNumber = $piece(tLine,",",i+tPos)
					do tStatement.%Execute(tCountry, tState, tDate, tNumber)
				}
			}
		}
		
		// now update aggregate table
		do ##class(%SQL.Statement).%ExecDirect(,"TRUNCATE TABLE COVID.DailyDataCountry")
		do ##class(%SQL.Statement).%ExecDirect(,"INSERT INTO COVID.DailyDataCountry (Country, DailyDate, Confirmed, Deaths, REcovered) SELECT %EXACT(Country) As Country, DailyDate, SUM(Confirmed) AS Confirmed, SUM(Deaths) AS Deaths, SUM(Recovered) AS Recovered FROM COVID.DailyData GROUP BY %EXACT(Country), DailyDate")
		
		// and populate the countries table (should be static, but cheap!)
		do ##class(COVID.Countries).Load()
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

ClassMethod BuildSQL(pDays As %Integer = 1, pIncludeDates As %Boolean = 1) As %String
{
	set tNL = $c(13,10)
	set tSELECT = "SELECT c.Country, c.Population, c.PopulationDensity, "_tNL
	set:pIncludeDates tSELECT = tSELECT_" d.DailyDate,"
	set tSELECT = tSELECT_" d.Confirmed, d.Deaths, d.Recovered"
	set tFROM = "FROM COVID.DailyDataCountry d JOIN COVID.Countries c ON d.Country = c.Country"
	for i = 1:1:pDays {
		set tSELECT = tSELECT_", "_tNL
		set:pIncludeDates tSELECT = tSELECT_" d"_i_".DailyDate AS D"_i_"_DailyDate, "
		set tSELECT = tSELECT_" d"_i_".Confirmed AS D"_i_"_Confirmed, d"_i_".Deaths AS D"_i_"_Deaths, d"_i_".Recovered AS D"_i_"_Recovered "
		set tFROM = tFROM_tNL_" JOIN COVID.DailyDataCountry d"_i_" ON d.Country = d"_i_".Country AND d.DailyDate = DATEADD('day',"_i_",d"_i_".DailyDate) "
	}
	
	quit tSELECT_tNL_tFROM
}

}
