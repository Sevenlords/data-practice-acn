USE [My_DW]
GO

/****** Object:  Table [stg].[SalesTXT]    Script Date: 5/2/2022 9:19:55 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [stg].[SalesTXT](
	[Order_number] [varchar](50) NOT NULL,
	[Line_number] [varchar](50) NULL,
	[Date] [varchar](50) NULL,
	[Reseller] [varchar](50) NOT NULL,
	[Country] [varchar](50) NULL,
	[Product] [varchar](50) NOT NULL,
	[Qty] [varchar](50) NULL,
	[Unit_price] [varchar](50) NULL,
	[Timestamp] [datetime] NULL,
	[Filename] [varchar](50) NULL
) ON [PRIMARY]
GO

ALTER TABLE [stg].[SalesTXT] ADD  DEFAULT (getdate()) FOR [Timestamp]
GO


