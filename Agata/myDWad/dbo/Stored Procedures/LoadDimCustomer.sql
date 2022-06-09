




CREATE procedure [dbo].[LoadDimCustomer]
as


exec log.[procedurecall] @ProcedureID=@@ProcID, @Step=1, @Comment='Start Proc'

BEGIN TRY

delete from dimcustomer where CustomerKey=-1 

set identity_insert dimcustomer ON
insert into DimCustomer([CustomerKey]
      ,[CustomerID]
      ,[CustomerAlternateKey]
      ,[PersonType]
      ,[Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[NameStyle]
      ,[EmailPromotion]
      ,[Suffix]
      ,[EmailAddress]
      ,[PhoneNumber]
      ,[Timeshtamp]
      ,[ModifiedDate]
      ,[HashCode])
Select -1 [CustomerKey]
      ,-1 [CustomerID]
      ,'-1'[CustomerAlternateKey]
      ,'-'[PersonType]
      ,'-1'[Title]
      ,'-1'[FirstName]
      ,'-1'[MiddleName]
      ,'-1'[LastName]
      ,'-1'[NameStyle]
      ,-1[EmailPromotion]
      ,'-1'[Suffix]
      ,'-1'[EmailAddress]
      ,'-1'[PhoneNumber]
      ,getdate()[Timeshtamp]
      ,getdate()[ModifiedDate]
      ,null[HashCode]

set identity_insert dimcustomer OFF

drop table if exists dbo.dimCustomerTmp



SELECT   
		ISNULL(C.CustomerID, -1) AS [CustomerID],
		ISNULL(C.AccountNumber, 'N/D') AS [CustomerAlternateKey],
		ISNULL(P.PersonType, '#') AS [PersonType],
		ISNULL(P.Title, 'N/D') AS [Title],
		ISNULL(P.FirstName, 'N/D') AS [FirstName],
		ISNULL(P.MiddleName, 'N/D') AS [MiddleName],
		ISNULL(P.LastName, 'N/D') AS [LastName],
		ISNULL(P.NameStyle, 'N/D') AS [NameStyle],
		ISNULL(P.EmailPromotion, -1) AS [EmailPromotion],
		ISNULL(P.Suffix, 'N/D') AS [Suffix],
		ISNULL(EA.EmailAddress, 'N/D') AS [EmailAddress],
		ISNULL(PP.PhoneNumber, 'N/D') AS [PhoneNumber],
		CAST(NULL AS varbinary(30)) AS [HashCode]
		into dbo.DimCustomerTmp
	FROM mydw.stg.Sales_Customer AS C
	JOIN mydw.stg.Person_Person AS P
	ON C.PersonID = P.BusinessEntityID
	LEFT JOIN mydw.stg.Person_EmailAddress AS EA
	ON P.BusinessEntityID = EA.BusinessEntityID
	LEFT JOIN mydw.stg.Person_PersonPhone AS PP
	ON P.BusinessEntityID = PP.BusinessEntityID



update dbo.dimCustomerTmp
set HashCode=HASHBYTES('MDS', convert(varchar(10),[CustomerID])
+CustomerAlternateKey
+PersonType+Title
+FirstName
+LastName
+convert(varchar(10),NameStyle)
+convert(varchar(10),EmailPromotion)
+Suffix
+EmailAddress
+PhoneNumber)

	update a 
	set 
	   [CustomerID]=b.[CustomerID]
      ,[CustomerAlternateKey]=b.[CustomerAlternateKey]
      ,[PersonType]=b.[PersonType]
      ,[Title]=b.[Title]
      ,[FirstName]=b.[FirstName]
      ,[MiddleName]=b.[MiddleName]
      ,[LastName]=b.[LastName]
      ,[NameStyle]=b.[NameStyle]
      ,[EmailPromotion]=b.[EmailPromotion]
      ,[Suffix]=b.[Suffix]
      ,[EmailAddress]=b.[EmailAddress]
      ,[PhoneNumber]=b.phonenumber
	  ,ModifiedDate = getdate()
	  ,hashcode=b.HashCode
	from DimCustomer a 
		join dbo.dimCustomerTmp b on a.CustomerID=b.customerID
	where a.hashcode<>b.HashCode 

insert into dbo.DimCustomer
([CustomerID]
      ,[CustomerAlternateKey]
      ,[PersonType]
      ,[Title]
      ,[FirstName]
      ,[MiddleName]
      ,[LastName]
      ,[NameStyle]
      ,[EmailPromotion]
      ,[Suffix]
      ,[EmailAddress]
      ,[PhoneNumber]
	  ,HashCode
	  ,Timeshtamp
	  ,ModifiedDate)	  
SELECT  a.*, GETDATE(), getdate()
from dbo.DimCustomerTmp a 
	 left join DimCustomer b on a.CustomerID=b.CustomerID
	where b.CustomerID is null


exec log.[procedurecall] @ProcedureID=@@ProcID, @Step=999, @Comment='End Proc'

END TRY
BEGIN CATCH

declare @ErrorNumber int = (select ERROR_NUMBER())
declare @ErrorState int = (select ERROR_STATE())
declare @ErrorSeverity int = (select ERROR_SEVERITY())
declare @ErrorLine int = (select ERROR_LINE())
declare @ErrorProcedure varchar(max) = (select ERROR_PROCEDURE())
declare @ErrorMessage varchar(max) = (select ERROR_MESSAGE())

exec log.ErrorCall @ErrorNumber,@ErrorState,@ErrorSeverity,@ErrorLine, @ErrorProcedure,@ErrorMessage


END CATCH
		