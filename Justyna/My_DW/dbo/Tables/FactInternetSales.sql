USE [My_DW]
GO

/****** Object:  Table [dbo].[FactInternetSales]    Script Date: 5/13/2022 12:09:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[FactInternetSales](
	[SalesOrderID] [int] NOT NULL,
	[SalesOrderNumber] [nvarchar](25) NOT NULL,
	[SalesOrderDetailID] [int] NOT NULL,
	[DateKey] [int] NULL,
	[CustomerKey] [int] NOT NULL,
	[ProductKey] [int] NULL,
	[OrderQty] [smallint] NOT NULL,
	[UnitPrice] [money] NOT NULL,
	[ExtendedAmout] [money] NOT NULL,
	[UnitPriceDiscountPct] [money] NOT NULL,
	[DiscountAmount] [money] NULL,
	[ProductStandartCost] [money] NULL,
	[TotalProductCost] [money] NOT NULL,
	[SalesAmount] [money] NOT NULL,
	[Timestamp] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FactInternetSales] ADD  DEFAULT (getdate()) FOR [Timestamp]
GO



