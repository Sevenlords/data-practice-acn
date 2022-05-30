
CREATE procedure [dbo].[LoadFactInternetSales]
as
BEGIN TRY
exec log.[procedurecall] @ProcedureID=@@ProcID, @Step=1, @Comment='Start Proc'

drop table if exists #orders

declare @startDate datetime 
select @startDate= isnull(max(Timeshtamp), '1900-01-01') from  dbo.FactInternetSales

select SalesOrderID
into #orders
from stg.Sales_SalesOrderHeader
where OnlineOrderFlag=1
	and timeshtamp>=@startDate


	delete a
	from FactInternetSales a 
	join #orders b on a.SalesOrderID=b.SalesOrderID


insert into dbo.FactInternetSales (
	[SalesOrderID],
	[SalesOrderNumber],
	[SalesOrderDetailID],
	[dateKey],
	[CustomerKey],
	[ProductKey],
	[OrderQty],
	[UnitPrice],
	[ExtendedAmount],
	[UnitPriceDiscount],
	[DiscountAmount],
	[StandardCost],
	[TotalProductCost],
	[SalesAmount])
select 
	soh.SalesOrderID,
	isnull(soh.SalesOrderNumber, -1), 
	isnull(sod.SalesOrderDetailID, -1),
	date.dateKey,
	isnull(cust.CustomerKey, -1),
	isnull(prod.ProductKey, -1),
	sod.OrderQty,
	sod.UnitPrice,
	isnull(sod.UnitPrice*sod.OrderQty,0.00) as [ExtendedAmount],
	sod.UnitPriceDiscount,
	isnull((sod.UnitPrice*sod.OrderQty)*sod.UnitPriceDiscount,0.00) as [DiscountAmount],
	prod.StandardCost,
	prod.StandardCost*sod.OrderQty as [TotalProductCost],
	isnull((sod.UnitPrice*sod.OrderQty)-((sod.UnitPrice*sod.OrderQty)*sod.UnitPriceDiscount),0.0) as SalesAmount
from stg.Sales_SalesOrderHeader soh
	join stg.Sales_SalesOrderDetail sod
	on soh.SalesOrderID=sod.SalesOrderID
	join #orders o on soh.SalesOrderID=o.SalesOrderID
	left join dbo.dimDate date
	on CONVERT(char(8),(soh.OrderDate),112)=date.datekey
	left join dbo.DimCustomer cust
	on cust.CustomerID=soh.CustomerID
	left join dbo.DimProduct as prod
	on sod.ProductID=prod.ProductID  and soh.OrderDate between prod.datefrom and prod.dateto
where soh.OnlineOrderFlag=1

	update FACT
	set FACT.ProductKey = b.ProductKey
	from [dbo].[factInternetSales] FACT
	join (
		select SOH.SalesOrderID, SOD.SalesOrderDetailID, P.ProductKey
		from stg.Sales_SalesOrderHeader SOH
		left join stg.Sales_SalesOrderDetail SOD on SOH.SalesOrderID = SOD.SalesOrderID
		left join dbo.dimProduct P on SOD.ProductID = P.ProductID and SOH.OrderDate between P.DateFrom and P.DateTo
		where SOH.OnlineOrderFlag = 1
	) b on FACT.SalesOrderID = b.SalesOrderID and FACT.SalesOrderDetailID = b.SalesOrderDetailID
	where FACT.ProductKey != b.ProductKey

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
