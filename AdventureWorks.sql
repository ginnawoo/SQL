/*Database: AdventureWorks2008.bak (https://docs.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver15&tabs=ssms)
  SQL Server Version: 2008
  Created By: Ginna W.
  Notes: (2/28/21: Created new script. Working progress!)
*/

SELECT 
CASE WHEN SPQH.SalesQuota > 200000 and SPQH.QuotaDate >= '2007-01-01'
	THEN SPQH.BusinessEntityID ELSE cast(SPQH.BusinessEntityID as varchar(10)) END AS ID,
CAST(SPQH.QuotaDate AS date) QuotaDate,
CASE 
	WHEN SP.TerritoryID IS NOT NULL 
	THEN SP.TerritoryID END AS TerritoryID,
ST.Name,
ST.SalesYTD,
ST.SalesLastYear,
ST.SalesLastYear - ST.SalesYTD AS DifferenceTotal,
CASE
	WHEN  ST.SalesLastYear - ST.SalesYTD > 1200000 THEN 'Exceptional Result'
	WHEN  ST.SalesLastYear - ST.SalesYTD > 100000 THEN 'Good Result'
	ELSE 'Need Improvements'
	END AS 'Result',
CASE 
	WHEN StateP.StateProvinceCode IN ('FL','CA','TX','OR')
	THEN StateP.StateProvinceCode ELSE '-' END AS [State]
FROM [Sales].[SalesPersonQuotaHistory] SPQH
INNER JOIN [Sales].[SalesPerson] SP 
ON SPQH.BusinessEntityID = SP.BusinessEntityID
INNER JOIN [Sales].[SalesTerritory] ST
ON SP.TerritoryID = ST.TerritoryID
INNER JOIN [Person].[StateProvince] StateP
ON ST.TerritoryID = StateP.TerritoryID
WHERE SPQH.QuotaDate >= '2007-01-01' AND StateP.StateProvinceCode IS NOT NULL