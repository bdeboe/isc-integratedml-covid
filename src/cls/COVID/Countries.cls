/// Data sourced from https://population.un.org/wpp/Download/Standard/CSV/
/// Scrubbing some groupings and appropriating some countries' spelling to align with COVID data
Class COVID.Countries Extends %Persistent [ Language = objectscript ]
{

Property Country As %String(MAXLEN = 500);

Property Population As %Decimal;

Property PopulationDensity As %Decimal;

ClassMethod Load() As %Status
{
	set tSC = ..%KillExtent()
	set tXData = ##class(%Dictionary.XDataDefinition).%OpenId($classname()_"||data")
	do tXData.Data.ReadLine() // skip wrapper
	do tXData.Data.ReadLine() // skip header
	while 'tXData.Data.AtEnd {
		set tLine = tXData.Data.ReadLine()
		quit:tLine="<data>"
		
		set tCountry = ..%New()
		set tCountry.Country = $piece(tLine,$c(9),1)
		set tCountry.Population = $tr($piece(tLine,$c(9),2),".")
		set tCountry.PopulationDensity = $tr($piece(tLine,$c(9),3),".")
		set tSC = tCountry.%Save()
		quit:$$$ISERR(tSC)
	}
	quit tSC
}

XData data
{
<data>
Location	PopTotal	PopDensity
Afghanistan	38928341	59.627
Albania	2877800	105.029
Algeria	43851043	18.411
American Samoa	55197	275.985
Andean Community	113170819	30.413
Andorra	77265	164.394
Angola	32866268	26.363
Anguilla	15002	166.689
Antigua and Barbuda	97928	222.564
Argentina	45195777	16.515
Armenia	2963234	104.083
Aruba	106766	593.144
Asia	4641054786	149.552
Australia	25499881	3.319
Australia/New Zealand	30322114	3.816
Austria	9006400	109.289
Azerbaijan	10139175	122.664
Bahamas	393248	39.286
Bahrain	1701583	2.238.925
Bangladesh	164689383	1.265.187
Barbados	287371	668.305
Belarus	9449321	46.569
Belgium	11589616	382.748
Belize	397621	17.432
Benin	12123198	107.513
Bermuda	62273	1245.46
Bhutan	771612	20.243
Bolivia	11673029	10.775
Bonaire, Sint Eustatius and Saba	26221	79.942
Bosnia and Herzegovina	3280815	64.33
Botswana	2351625	4.149
Brazil	212559409	25.431
British Virgin Islands	30237	201.58
Brunei	437483	83.014
Bulgaria	6948445	64.006
Burkina Faso	20903278	76.401
Burundi	11890781	463.037
Cabo Verde	555988	137.962
Cambodia	16718971	94.714
Cameroon	26545864	56.157
Canada	37742157	4.15
Caribbean	43532374	192.613
Caribbean Community and Common Market (CARICOM)	18849823	43.582
Cayman Islands	65720	273.833
Central African Republic	4829764	7.753
Central America	179670186	73.267
Central Asia	74338926	18.931
Central European Free Trade Agreement (CEFTA)	25746658	87.771
Central and Southern Asia	2014708531	195.093
Chad	16425859	13.045
Channel Islands	173859	915.047
Chile	19116209	25.71
China	1439323774	153.312
China (and dependencies)	1471286879	156.11
China, Hong Kong SAR	7496988	7.139.989
China, Macao SAR	649342	21.717.124
Taiwan*	23816775	672.6
Colombia	50882884	45.861
Comoros	869595	467.273
Congo (Brazzaville)	5518092	16.158
Cook Islands	17564	73.183
Costa Rica	5094114	99.767
Croatia	4105268	73.361
Cuba	11326616	106.413
Curacao	164100	369.595
Cyprus	1207361	130.667
Czechia	10708982	138.646
Cote d'Ivoire	26378275	82.951
Dem. People's Republic of Korea	25778815	214.092
Congo (Kinshasa)	89561404	39.506
Denmark	5792203	136.512
Denmark (and dependencies)	5897840	12.983
Djibouti	988002	42.623
Dominica	71991	95.988
Dominican Republic	10847904	224.501
Ecuador	17643060	71.038
Egypt	102334403	102.802
El Salvador	6486201	313.041
Equatorial Guinea	1402985	50.017
Eritrea	3546427	35.113
Estonia	1326539	31.294
Eswatini	1160164	67.451
Ethiopia	114963583	114.964
Falkland Islands (Malvinas)	3483	0.286
Faroe Islands	48865	35.004
Fiji	896444	49.066
Finland	5540718	18.233
France	65273512	119.209
France (and dependencies)	68147687	103.614
French Guiana	298682	3.634
French Polynesia	280904	76.75
Gabon	2225728	8.638
Gambia	2416664	238.801
Georgia	3989175	57.406
Germany	83783945	240.372
Ghana	31072945	136.56
Gibraltar	33691	3369.1
Greater Arab Free Trade Area (GAFTA)	413978399	36.547
Greece	10423056	80.862
Greenland	56772	0.138
Grenada	112519	330.938
Guadeloupe	400127	245.778
Guam	168783	312.561
Guatemala	17915567	167.185
Guinea	13132792	53.446
Guinea-Bissau	1967998	69.986
Gulf Cooperation Council (GCC)	58664095	22.8
Guyana	786559	3.996
Haiti	11402533	413.735
High-income countries	1263092934	33.339
Honduras	9904608	88.521
Hungary	9660350	106.709
Iceland	341250	3.404
India	1380004385	464.149
Indonesia	273523621	150.987
Iran	83992953	51.575
Iraq	40222503	92.61
Ireland	4937796	71.677
Isle of Man	85032	149.179
Israel	8655541	399.979
Italy	60461828	205.555
Jamaica	2961161	273.422
Japan	126476458	346.934
Jordan	10203140	114.926
Kazakhstan	18776707	6.955
Kenya	53771300	94.478
Kiribati	119446	147.464
Kuwait	4270563	239.65
Kyrgyzstan	6524191	34.016
Latvia	1886202	30.325
Lebanon	6825442	667.199
Lesotho	2142252	70.562
Liberia	5057677	52.509
Libya	6871287	3.905
Liechtenstein	38137	238.356
Lithuania	2722291	43.436
Luxembourg	625976	241.69
Madagascar	27691019	47.596
Malawi	19129955	202.906
Malaysia	32365998	98.512
Maldives	540542	1.801.807
Mali	20250834	16.596
Malta	441539	1.379.809
Marshall Islands	59194	328.856
Martinique	375265	354.024
Mauritania	4649660	4.511
Mauritius	1271767	626.486
Mayotte	272813	727.501
Melanesia	11122990	21.003
Mexico	128932753	66.325
Micronesia	548927	173.163
Micronesia (Fed. States of)	115021	164.316
Middle Africa	179595125	27.644
Middle-income countries	5753051615	74.718
Monaco	39244	26.338.255
Mongolia	3278292	2.11
Montenegro	628062	46.696
Montserrat	4999	49.99
Morocco	36910558	82.703
Mozambique	31255435	39.746
Burma	54409794	83.286
Namibia	2540916	3.086
Nauru	10834	541.7
Nepal	29136808	203.256
Netherlands	17134873	508.152
Netherlands (and dependencies)	17474842	503.511
New Caledonia	285491	15.618
New Zealand	4822233	18.314
New Zealand (and dependencies)	4842765	18.356
Nicaragua	6624554	55.049
Niger	24206636	19.11
Nigeria	206139587	226.336
Niue	1618	6.223
North Macedonia	2083380	82.608
Northern Mariana Islands	57557	125.124
Norway	5421242	14.842
Oceania	42677809	5.029
Oceania (excluding Australia and New Zealand)	12355695	22.845
Oman	5106622	16.5
Pakistan	220892331	286.546
Palau	18092	39.33
Panama	4314768	58.041
Papua New Guinea	8947027	19.757
Paraguay	7132530	17.953
Peru	32971846	25.759
Philippines	109581085	367.512
Poland	37846605	123.589
Polynesia	683778	84.521
Portugal	10196707	111.33
Puerto Rico	2860840	322.53
Qatar	2881060	248.153
Korea, South	51269183	527.298
Moldova	4033963	122.799
Romania	19237682	83.58
Russia	145934460	8.911
Rwanda	12952209	525.019
RÃ©union	895308	358.123
Saint BarthÃ©lemy	9885	449.318
Saint Helena	6071	15.567
Saint Kitts and Nevis	53192	204.585
Saint Lucia	183629	301.031
Saint Martin (French part)	38659	729.415
Saint Pierre and Miquelon	5795	25.196
Saint Vincent and the Grenadines	110947	284.479
Samoa	198410	70.11
San Marino	33938	565.633
Sao Tome and Principe	219161	228.293
Saudi Arabia	34813867	16.195
Senegal	16743930	86.968
Serbia	8737370	99.901
Seychelles	98340	213.783
Sierra Leone	7976985	110.515
Singapore	5850343	8.357.633
Sint Maarten (Dutch part)	42882	1.261.235
Slovakia	5459643	113.534
Slovenia	2078932	103.224
Small Island Developing States (SIDS)	72076098	60.255
Solomon Islands	686878	24.54
Somalia	15893219	25.334
South Africa	59308690	48.891
South Sudan	11193729	18.322
South-Eastern Asia	668619854	154.035
Spain	46754783	93.735
Sri Lanka	21413250	341.465
West Bank and Gaza	5101416	847.411
Sudan	43849269	24.843
Suriname	586634	3.76
Sweden	10099270	24.612
Switzerland	8654618	219.016
Syria	17500657	95.304
Tajikistan	9537642	68.145
Thailand	69799978	136.624
Timor-Leste	1318442	88.665
Togo	8278737	152.211
Tokelau	1350	135
Tonga	105697	146.801
Trinidad and Tobago	1399491	272.805
Tunisia	11818618	76.072
Turkey	84339067	109.584
Turkmenistan	6031187	12.834
Turks and Caicos Islands	38718	40.756
Tuvalu	11792	393.067
Uganda	45741	228.922
Ukraine	43733759	75.492
United Arab Emirates	9890400	118.306
United Kingdom	67886004	280.602
United Kingdom (and dependencies)	68405089	266.333
Tanzania	59734213	67.435
US Virgin Islands	104423	298.351
US	331002647	36.185
US (and dependencies)	334249447	36.499
Uruguay	3473727	19.848
Uzbekistan	33469199	78.677
Vanuatu	307150	25.197
Venezuela	28435943	32.238
Vietnam	97338583	313.925
Wallis and Futuna Islands	11246	80.329
Western Sahara	597330	2.246
Yemen	29825968	56.492
Zambia	18383956	24.73
Zimbabwe	14862927	38.42
</data>
}

Storage Default
{
<Data name="CountriesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Country</Value>
</Value>
<Value name="3">
<Value>Population</Value>
</Value>
<Value name="4">
<Value>PopulationDensity</Value>
</Value>
</Data>
<DataLocation>^COVID.CountriesD</DataLocation>
<DefaultData>CountriesDefaultData</DefaultData>
<IdLocation>^COVID.CountriesD</IdLocation>
<IndexLocation>^COVID.CountriesI</IndexLocation>
<StreamLocation>^COVID.CountriesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
