
CREATE procedure [dbo].[loadDimReseller]
as
BEGIN TRY
    
exec log.[procedurecall] @ProcedureID=@@ProcID, @Step=1, @Comment='Start Proc'

delete from DimReseller where ResellerKey=-1 

set identity_insert dimreseller ON
insert into DimReseller([ResellerKey]
      ,[CustomerID]
      ,[ResellerAlternateKey]
      ,[ResellerName]
      ,[Timeshtamp]
      ,[ModifiedDate])
Select -1 [ResellerKey]
      ,-1 [CustomerID]
      ,'-1'[ResellerAlternateKey]
      ,'-1'[ResellerName]
      ,getdate()[Timeshtamp]
      ,getdate()[ModifiedDate]

set identity_insert dimreseller OFF

drop table if exists #reseller

select 
ISNULL(C.CustomerID, -1) AS [CustomerID],
ISNULL(C.AccountNumber, 'N/D') AS [ResellerAlternateKey],
ISNULL(S.Name, 'N/D') AS [ResellerName]
into #reseller
from stg.sales_store s
left join stg.Sales_customer c 
on c.StoreID=s.BusinessEntityID


update a 
set reselleralternatekey=b.reselleralternatekey,
	resellername=b.resellername,
	ModifiedDate = getdate()
from DimReseller a 
	join #reseller b on a.CustomerID=b.CustomerID

insert into DimReseller
	(CustomerID,
	reselleralternatekey,
	resellername,
	Timeshtamp,
	ModifiedDate)
select a.*, getdate(), getdate()
	from #reseller a 
	left join DimReseller b on a.CustomerID=b.CustomerID
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


