Class COVID.DailyData Extends %Persistent
{

Parameter USEEXTENTSET = 1;

Property Country As %String(MAXLEN = 200);

Property State As %String(MAXLEN = 500);

Property Locality As %String(MAXLEN = 500);

Property DailyDate As %Date;

Property Confirmed As %Integer [ InitialExpression = 0 ];

Property Deaths As %Integer [ InitialExpression = 0 ];

Property Recovered As %Integer [ InitialExpression = 0 ];

Index CountryDate On (Country, State, Locality, DailyDate) [ PrimaryKey, Unique ];

Storage Default
{
<Data name="DailyDataDefaultData">
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
<Value name="7">
<Value>State</Value>
</Value>
<Value name="8">
<Value>Locality</Value>
</Value>
</Data>
<DataLocation>^COVID.DailyDataD</DataLocation>
<DefaultData>DailyDataDefaultData</DefaultData>
<ExtentLocation>^csQK.DWSq</ExtentLocation>
<IdLocation>^COVID.DailyDataD</IdLocation>
<Index name="CountryDate">
<Location>^csQK.DWSq.2</Location>
</Index>
<Index name="IDKEY">
<Location>^csQK.DWSq.1</Location>
</Index>
<IndexLocation>^COVID.DailyDataI</IndexLocation>
<StreamLocation>^COVID.DailyDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
