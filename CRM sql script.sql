select * from accounts;
select * from opportunityproduct;
select * from opportunitydata;
select * from usertable;
select* from leads;

##1 Total Leads
select count(LeadID) from leads;

##2 expected Amount from converted leads
SELECT Converted, count(l.ConvertedAccountID) as Converted_Accounts, 
sum(op.ExpectedAmount) as Expected_Amount
FROM leads l inner join opportunitydata op on l.ConvertedOpportunityID = op.OpportunityID
GROUP BY Converted;

##3--Conversion rate--
select converted,(count(converted))
from leads l group by converted;
select concat(round((1033/count(converted)*100),2),"%") as conversion_rate from leads;

##4--Converted Accounts--
select count(l.ConvertedAccountID)
from leads l left join  opportunitydata op on l.ConvertedOpportunityID=op.OpportunityID
where l.Converted="TRUE";

## 5--- Converted Opportunities--
-- Converted Opportunities
select count(ConvertedOpportunityID)
from leads where trim(convertedopportunityID) <> '';

##6---Lead Source
select LeadSource, 
count(LeadID) as total_leads from leads group by LeadSource order by total_leads desc;

##7---- Lead By Industry---
--  Lead By industry
select Industry,
count(LeadID) as total_leads from leads group by Industry order by total_leads desc;

##8----Lead By Stage---
select Stage, count(LeadID) as Total_Leads from leads l inner join 
opportunitydata op on l.ConvertedOpportunityID= op.OpportunityID group by Stage 
order by Total_Leads desc;

##-----------------------------------------------------------------------------------------


##--- OPPORTUNITY KPI

##--1----
select sum(ExpectedAmount) from opportunitydata;

##---2-- Active OPPORTUNITIES
select u.active, count(o.OpportunityID) as Active_Opportunities
from usertable as u inner join opportunitydata as o on 
u.UserID=o.OwnerID group by u.active;

##----3----- Conversion rate 
select Converted, count(ConvertedOpportunityID) from leads group by Converted;
select count(LeadID) from leads;
select concat(round(1033/10000*100,2),"%") as Conversion_Rate;

##----4--- Win rate
select Won, count(OpportunityID) from opportunitydata group by Won;
select count(OpportunityID) from opportunitydata;
select concat(round(1443/4489*100,2),"%") as Win_Rate;

##------5----- Loss rate
select Closed, count(OpportunityID) from opportunitydata group by Closed;
select count(OpportunityID) from opportunitydata;
select concat(round(3374/4489*100,2),"%") as Loss_Rate;

##-----6----- Expected Amount By Opportunity Type
select OpportunityType,sum(ExpectedAmount) from opportunitydata group by OpportunityType;

##----7---- Trend Analysis 
SELECT YEAR(l.CreatedDate) AS YEAR, QUARTER(l.CreatedDate) AS QUARTER,
SUM(op.Amount) AS ACTUAL_AMOUNT,
SUM(op.ExpectedAmount) AS EXPECTED_AMOUNT,
SUM(op.ExpectedAmount) - SUM(op.Amount) AS VARIANCE
FROM leads l LEFT JOIN  opportunitydata op 
ON l.ConvertedOpportunityID = op.OpportunityID GROUP BY  YEAR(l.CreatedDate),
QUARTER(l.CreatedDate) ORDER BY  YEAR(l.CreatedDate), QUARTER(l.CreatedDate);

-- Running Total Active Vs Total Opportunities over Time
select year(createddate) as year,count(opportunityid) as total_opportunities
from opportunitydata where closed = "true"group by closed,year
order by total_opportunities desc;

-- Closed Won vs Total Closed over Time
select year(CreatedDate) as year, 
stage,count(Closed) as closed_opportunities 
from opportunitydata where stage = "Closed Won" group by  Stage,year;

#--Closed Lost vs Total Lost over Time
select year(CreatedDate) as year, 
stage,count(closed) as Lost_Opportunities
from opportunitydata where stage = "Closed Lost" group by  Stage,year;

##---8---- Opportunities By Industries
select Industry, Count(OpportunityID) as Total_Opportunities 
from opportunitydata group by Industry order by Total_Opportunities desc;
 
 ##---9--- Total Opportunities By Opportunity Type
 select OpportunityType, sum(OpportunityID) as Total_opportunities 
 from opportunitydata group by OpportunityType; 

select OpportunityType, sum(ExpectedAmount) as Total_ExpectedAmount
from opportunitydata group by OpportunityType;

##-----10---- User Type by users
select count(userID) as Total_Users from usertable;
select UserType, count(UserID) as Total_Users from usertable group by UserType;
##--10---- Country Wise Users
select Country, count(UserID) as Total_Users from usertable group by Country;
##---11---- City Wise Leads
select City, count(LeadID) as Total_Leads from leads group by City;
##----12---- City Wise Opportunities
select l.City, count(op.OpportunityID) as Total_Opportunities 
from leads l inner join opportunitydata op 
on  l.ConvertedOpportunityID=op.OpportunityID group by l.City;

##---13--- Product Name Wise Porducts
select ProductName, Count(ProductID) as Total_Products from opportunityproduct
group by ProductName; 

##---14--- ProductName Wise Total_Sales and Total_Orders
select ProductName, sum(SalesPrice) as Total_Sales,Count(SortOrder) as Total_orders
from opportunityproduct group by Productname order by Total_orders desc;

##----15--- Product Name Wise Discounts
SELECT 
    ProductName,
    ListPrice,
    Discount,
    (Discount / ListPrice) * 100 AS Discount_Percentage FROM opportunityproduct;
    

    



