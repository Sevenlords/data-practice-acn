USE [My_DW]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [stg].[SalesTXT_Delta](
	[Order_number] [varchar](50) NULL,
	[Line_number] [varchar](50) NULL,
	[Date] [varchar](50) NULL,
	[Reseller] [varchar](50) NULL,
	[Country] [varchar](50) NULL,
	[Product] [varchar](50) NULL,
	[Qty] [varchar](50) NULL,
	[Unit_price] [varchar](50) NULL,
	[Timestamp] [datetime] NULL,
	[Filename] [varchar](50) NULL
) ON [PRIMARY]
GO

ALTER TABLE [stg].[SalesTXT_Delta] ADD  DEFAULT (getdate()) FOR [Timestamp]
GO


