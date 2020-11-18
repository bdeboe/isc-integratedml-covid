Class COVID.Utils
{

ClassMethod Download(pTempDir As %String = "/tmp/covid19/", pLoad As %Boolean = 1, pVerbose As %Boolean = 1) As %Status
{
	set tSC = $$$OK
	try {
		
		w:pVerbose !,"Downloading CSSE data from https://github.com/CSSEGISandData/COVID-19"
				
		set tSeparator = $s($$$isWINDOWS:"\",1:"/")
		if pTempDir="" {
			set pTempDir = $s($$$isWINDOWS:"C:\tmp\covid19\", 1:"/tmp/covid19/")
		} elseif $e(pTempDir,*)'=tSeparator {
			set pTempDir = pTempDir_tSeparator
		}
		do ##class(%File).CreateDirectoryChain(pTempDir)
		
		set tFilePtr = ##class(%Stream.FileBinary).%New()
		for tFilename = "confirmed_global", "confirmed_US", "deaths_global", "deaths_US", "recovered_global" {
			
			set tHttpRequest = ##class(%Net.HttpRequest).%New()
			set tHttpRequest.Server = "github.com"
			set tHttpRequest.Https = 1
			set tHttpRequest.SSLConfiguration = "ISC.FeatureTracker.SSL.Config"

			set tURL = "/CSSEGISandData/COVID-19/blob/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_"_tFilename_".csv"
	
			w:pVerbose !,"Downloading ",tURL," ..."
			set tSC = tHttpRequest.Get(tURL_"?raw=true")
			quit:$$$ISERR(tSC)
			if tHttpRequest.HttpResponse.StatusCode'=200 {
				w !,"HTTP error code trying to fetch archive: ",tHttpRequest.HttpResponse.StatusCode
				continue
			}
			
			set tSC = tFilePtr.LinkToFile(pTempDir_$piece(tURL,"/",*))
			quit:$$$ISERR(tSC)
			
			set tSC = tFilePtr.CopyFromAndSave(tHttpRequest.HttpResponse.Data)
			quit:$$$ISERR(tSC)
			
			w:pVerbose " (",$normalize(tFilePtr.FileBinarySize()/1024/1024,2),"MB)"
			
		}
		quit:$$$ISERR(tSC)

		w:pVerbose !
		set:pLoad tSC = ..LoadData(pTempDir, pVerbose)
		quit:$$$ISERR(tSC)
		w:pVerbose !
		
	} catch (ex) {
		set tSC = ex.AsStatus()
	}
	quit tSC
}

/// Based on CSSE data from https://github.com/CSSEGISandData/COVID-19
/// See <Method>Download</Method> for a one-stop-shop way of populating your database
ClassMethod LoadData(pDir As %String = "/path/to/COVID-19/csse_covid_19_data/csse_covid_19_time_series/", pVerbose As %Boolean = 1) As %Status
{
	set tSC = $$$OK
	try {
		set tSeparator = $s($$$isWINDOWS:"\", 1:"/")
		set:$e(pDir,*)'=tSeparator pDir = pDir_tSeparator

		w:pVerbose !,"Loading data from ",pDir
		
		set tStatement = ##class(%SQL.Statement).%New()
		set tFile = ##class(%Stream.FileCharacter).%New()
		for tGroup = "confirmed", "deaths", "recovered" {

			set tSC = tStatement.%Prepare("INSERT OR UPDATE INTO COVID.DailyData (Country, State, Locality, DailyDate, "_tGroup_") VALUES (?, ?, ?, TO_DATE(?||'20','MM/DD/YYYY'), ?)")
			quit:$$$ISERR(tSC)

			// process global file first
			set tSC = tFile.LinkToFile(pDir_"time_series_covid19_"_tGroup_"_global.csv")
			quit:$$$ISERR(tSC)
			write:pVerbose !,"Processing file: '"_tFile.Filename_"'"
			
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
				
				set:tState="" tState = ""
				
				for i = 1:1:tColCount {
					set tDate = $piece(tHeader,",",i+4)
					quit:tDate=""
					set tNumber = $piece(tLine,",",i+tPos)
					do tStatement.%Execute(tCountry, tState, "", tDate, tNumber)
				}
			}

			// process US file format
			continue:tGroup="recovered"
			set tSC = tFile.LinkToFile(pDir_"time_series_covid19_"_tGroup_"_US.csv")
			quit:$$$ISERR(tSC)
			write:pVerbose !,"Processing file: '"_tFile.Filename_"'"

			set tHeader = tFile.ReadLine(), tColCount = $l(tHeader,",")
			
			while 'tFile.AtEnd {
				set tLine = tFile.ReadLine()
				set tState = $piece(tLine,",",7)
				set tLocality = $piece(tLine,",",6)

				set tActualData = $piece(tLine,"""",3)
				for i = 1:1:tColCount {
					set tDate = $piece(tHeader,",",i+11)
					quit:tDate=""
					set tNumber = $piece(tActualData,",",i)
					do tStatement.%Execute("United States", tState, tLocality, tDate, tNumber)
				}

			}
		}
		
		// now update aggregate table
		write:pVerbose !,"Updating aggregate numbers per country"
		do ##class(%SQL.Statement).%ExecDirect(,"TRUNCATE TABLE COVID.DailyDataCountry")
		do ##class(%SQL.Statement).%ExecDirect(,"INSERT INTO COVID.DailyDataCountry (Country, DailyDate, Confirmed, Deaths, REcovered) SELECT %EXACT(Country) As Country, DailyDate, SUM(Confirmed) AS Confirmed, SUM(Deaths) AS Deaths, SUM(Recovered) AS Recovered FROM COVID.DailyData GROUP BY %EXACT(Country), DailyDate")
		
		// and populate the countries table (should be static, but cheap!)
		write:pVerbose !,"Updating country info"
		do ##class(COVID.Countries).Load()
		write:pVerbose !

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
