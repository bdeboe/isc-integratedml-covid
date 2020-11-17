Class COVID.DailyDataCountry Extends %Persistent
{

Parameter USEEXTENTSET = 1;

Property Country As %String(MAXLEN = 200);

Property DailyDate As %Date;

Property Confirmed As %Integer [ InitialExpression = 0 ];

Property Deaths As %Integer [ InitialExpression = 0 ];

Property Recovered As %Integer [ InitialExpression = 0 ];

Index CountryDate On (Country, DailyDate) [ PrimaryKey, Unique ];

Index Country On Country [ Type = bitmap ];

Index DailyDate On DailyDate [ Type = bitmap ];

Storage Default
{
<Data name="DailyDataCountryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Country</Value>
</Value>
<Value name="3">
<Value>DailyDate</Value>
</Value>
<Value name="4">
<Value>Confirmed</Value>
</Value>
<Value name="5">
<Value>Deaths</Value>
</Value>
<Value name="6">
<Value>Recovered</Value>
</Value>
</Data>
<DataLocation>^csQK.BOOU.1</DataLocation>
<DefaultData>DailyDataCountryDefaultData</DefaultData>
<ExtentLocation>^csQK.BOOU</ExtentLocation>
<IdLocation>^csQK.BOOU.1</IdLocation>
<Index name="$DailyDataCountry">
<Location>^csQK.BOOU.2</Location>
</Index>
<Index name="Country">
<Location>^csQK.BOOU.3</Location>
</Index>
<Index name="CountryDate">
<Location>^csQK.BOOU.4</Location>
</Index>
<Index name="DailyDate">
<Location>^csQK.BOOU.5</Location>
</Index>
<Index name="IDKEY">
<Location>^csQK.BOOU.1</Location>
</Index>
<IndexLocation>^csQK.BOOU.I</IndexLocation>
<StreamLocation>^csQK.BOOU.S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
