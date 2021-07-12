Select * From AirportsFlights..flights

-- Number of Flights on each day of the month
Select DayofMonth, Count(*) as NumberofFlights From AirportsFlights..flights
Group By DayofMonth
Order By DayofMonth

-- Aggregated number of flights of each airline in each day of the month
Select DayofMonth, Carrier, Count(*) 
Over (Partition By Carrier) as NumberofAirlineFlights 
From AirportsFlights..flights
Order by DayofMonth, Carrier, NumberofAirlineFlights desc

-- Number of flights of each airline in each day of the month
Select DayofMonth, Carrier, Count(*) From AirportsFlights..flights
Order by DayofMonth

-- Number of flights of each airline in each day of the week
Select DayOfWeek, Carrier, Count(*) From AirportsFlights..flights
Order by DayOfWeek

-- Number of flights of each airport in each day of the month
Select f.DayofMonth, a.airport_id, Count(*) as NumberOfFlights
From AirportsFlights..flights f Join AirportsFlights..airports a
On f.DestAirportID = a.airport_id
Group by a.airport_id, f.DayofMonth
Order by f.DayofMonth

-- Number of flights of each airport in each day of the week
Select f.DayOfWeek, a.airport_id, Count(*) as NumberOfFlights
From AirportsFlights..flights f Join AirportsFlights..airports a
On f.DestAirportID = a.airport_id
Group by a.airport_id, f.DayOfWeek
Order by f.DayOfWeek

-- Number of flights that are on time (+/- 5 mins) for arriving and departing flights for each airline
Select Carrier, Count(*) as NumberofFlightsOnTime From AirportsFlights..flights
Where DepDelay <= 5
And ArrDelay <= 5
Group By Carrier
Order By NumberofFlightsOnTime desc

-- CTE to show the percentage of flights that departed and arrived on time for each airline
With FlightsOnTime (Carrier, NumberofFlightsOnTime)
as
(
Select Carrier, Count(*) as NumberofFlightsOnTime From AirportsFlights..flights
Where DepDelay <= 5
And ArrDelay <= 5
Group By Carrier
), 
TotalFlights (Carrier, NumberofFlights)
as
(
Select Carrier, Count(*) as NumberofFlights From AirportsFlights..flights
Group By Carrier
)
Select *, round((cast(FlightsOnTime.NumberofFlightsOnTime as float)/(cast(TotalFlights.NumberofFlights as float))*100),2) as FlightsOnTimePercentage
From FlightsOnTime Join TotalFlights
On FlightsOnTime.Carrier = TotalFlights.Carrier
Order By FlightsOnTimePercentage desc

-- CTE to show the percentage of flights that departed and arrived on time for each airline and their corresponding maximum departure and arrival delay times
With FlightsOnTime (Carrier, NumberofFlightsOnTime)
as
(
Select Carrier, Count(*) as NumberofFlightsOnTime From AirportsFlights..flights
Where DepDelay <= 5
And ArrDelay <= 5
Group By Carrier
), 
TotalFlights (Carrier, MaxDepDelay, MaxArrDelay, NumberofFlights)
as
(
Select Carrier, MAX(DepDelay), MAX(ArrDelay), Count(*) as NumberofFlights From AirportsFlights..flights
Group By Carrier
)
Select *, round((cast(FlightsOnTime.NumberofFlightsOnTime as float)/(cast(TotalFlights.NumberofFlights as float))*100),2) as FlightsOnTimePercentage, 
TotalFlights.MaxDepDelay, TotalFlights.MaxArrDelay
From FlightsOnTime Join TotalFlights 
On FlightsOnTime.Carrier = TotalFlights.Carrier 
Order By FlightsOnTimePercentage desc

-- Max Departure and Arrival Delays of each airline as well as the number of flights
Select Carrier, Max(DepDelay) as MaxDepDelay, Max(ArrDelay) as MaxArrDelay, Count(*) as NumberOfFlights From AirportsFlights..flights
Group By Carrier
Order By MaxDepDelay, MaxArrDelay desc