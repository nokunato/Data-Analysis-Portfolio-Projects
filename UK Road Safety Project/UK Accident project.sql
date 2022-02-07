use [UK Accident stuff]

-- Median severity value
with bike as (select vehicle_types.code, vehicle_types.label, Vehicles_2015.Vehicle_Type, Accidents_2015.Accident_Severity
from dbo.Vehicles_2015
join vehicle_types
on Vehicles_2015.Vehicle_Type = vehicle_types.code
join Accidents_2015
on Accidents_2015.Accident_Index = Vehicles_2015.Accident_Index
where vehicle_types.label like '%Motorcycle%' and vehicle_types.label like '%motorcycle%' and vehicle_types.code = 23)

select((select max(cast(Accident_Severity AS int)) from
(SELECT TOP 50 PERCENT Accident_Severity FROM bike ORDER BY Accident_Severity) as bottomhalf)
+
(select min(cast(Accident_Severity as int)) from
(SELECT TOP 50 PERCENT Accident_Severity FROM bike ORDER BY Accident_Severity DESC) as tophalf)) / 2 as median


-- Accident severity and Total accidents per vehicle type
select vehicle_types.label, count(Accident_Severity) as Total_accident, Accidents_2015.Accident_Severity
from dbo.vehicle_types
join Vehicles_2015
on vehicle_types.code = Vehicles_2015.Vehicle_Type
join Accidents_2015
on Accidents_2015.Accident_Index = Vehicles_2015.Accident_Index
group by vehicle_types.label, Accidents_2015.Accident_Severity
order by Total_accident desc

--Average Severity by vehicle type
select vehicle_types.label, avg(cast(Accidents_2015.Accident_Severity as decimal(7, 2))) as Average_severity from dbo.vehicle_types
join Vehicles_2015
on vehicle_types.code = Vehicles_2015.Vehicle_Type
join Accidents_2015
on Accidents_2015.Accident_Index = Vehicles_2015.Accident_Index
group by vehicle_types.label

--Average Severity and Total Accidents by Motorcyle
select vehicle_types.label, avg(cast(Accidents_2015.Accident_Severity as decimal(7, 2))) as Average_severity,
count(Accidents_2015.Accident_Severity) as Total_accident from dbo.vehicle_types
join Vehicles_2015
on vehicle_types.code = Vehicles_2015.Vehicle_Type
join Accidents_2015
on Accidents_2015.Accident_Index = Vehicles_2015.Accident_Index
where vehicle_types.label like '%Motorcycle%' and vehicle_types.label like '%motorcycle%'
group by vehicle_types.label
order by Average_severity, Total_accident

'''SELECT vt.label AS 'Vehicle Type', AVG(cast(a.accident_severity as decimal(7, 2))) AS 'Average_Severity', COUNT(vt.label) AS 'Number of Accidents'
FROM Accidents_2015 a
JOIN Vehicles_2015 v ON a.accident_index = v.accident_index
JOIN vehicle_types vt ON v.vehicle_type = vt.code
WHERE vt.label LIKE '%otorcycle%'
GROUP BY vt.label
ORDER BY 2,3;'''