CREATE TABLE [dbo].[FactInternetSales](
	[SalesOrderID] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](25) NOT NULL,
	[SalesOrderDetailID] [int] NOT NULL,
	[DateKey] [int] NOT NULL,
	[CustomerKey] [int] NOT NULL,
	[ProductKey] [int] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [money] NOT NULL,
	[UnitPriceDiscountPct] [money] NOT NULL,
	[DiscountAmount] [int] NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[timestamp] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactInternetSales] ADD  DEFAULT (getdate()) FOR [timestamp]