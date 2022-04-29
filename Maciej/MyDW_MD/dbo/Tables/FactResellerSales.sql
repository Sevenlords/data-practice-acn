CREATE TABLE [dbo].[FactResellerSales](
	[SalesOrderID] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](25) NOT NULL,
	[SalesOrderDetailID] [int] NOT NULL,
	[DateKey] [int] NOT NULL,
	[ResellerKey] [int] NOT NULL,
	[ProductKey] [int] NOT NULL,
	[OrderQuantity] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmount] [int] NOT NULL,
	[UnitPriceDiscountPct] [money] NOT NULL,
	[DiscountAmount] [money] NOT NULL,
	[ProductStandardCost] [money] NOT NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[Timestamp] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactResellerSales] ADD  DEFAULT (getdate()) FOR [Timestamp]