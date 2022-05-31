
--COMMENT

CREATE procedure [dbo].[LoadDimCurrency]
as

BEGIN TRY
exec log.[procedurecall] @ProcedureID=@@ProcID, @Step=1, @Comment='Start Proc'

delete from dimCurrency where CurrencyKey=-1

set identity_insert dimCurrency ON

insert into dimCurrency(
[CurrencyKey]
      ,[CurrencyName]
      ,[CurrencyALternateKey]
      ,[SourceModifiedDate]
      ,[timeshtamp]
      ,[ModifiedDate])
select -1 [CurrencyKey]
      ,'-1'[CurrencyName]
      ,'-1'[CurrencyALternateKey]
      ,getdate()[SourceModifiedDate]
      ,getdate()[timeshtamp]
      ,getdate()[ModifiedDate]

set identity_insert dimCurrency OFF

drop table if exists #currency


select name, CurrencyCode, ModifiedDate
into #currency
from stg.sales_currency

update a 
set 
	[CurrencyName]=name,
	[CurrencyALternateKey]=CurrencyCode,
	[SourceModifiedDate]=b.ModifiedDate,
	ModifiedDate=getdate()
from dimCurrency a
	join #currency b on a.CurrencyALternateKey=b.CurrencyCode



insert into dbo.dimCurrency(
	[CurrencyName],	
	[CurrencyALternateKey],
	[SourceModifiedDate],
	timeshtamp,
	ModifiedDate)
select a.*, getdate(), getdate()
from #currency a
	left join DimCurrency b on a.CurrencyCode=b.CurrencyALternateKey
where b.CurrencyALternateKey is null

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