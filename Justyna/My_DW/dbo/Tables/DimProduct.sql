USE [My_DW]
GO

/****** Object:  Table [dbo].[DimProduct]    Script Date: 6/9/2022 10:22:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DimProduct](
	[ProductKey] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductName] [nvarchar](50) NOT NULL,
	[ProductAlternateKey] [nvarchar](25) NOT NULL,
	[StandartCost] [money] NOT NULL,
	[FinishedGoodFlag] [bit] NOT NULL,
	[Color] [nvarchar](15) NOT NULL,
	[ListPrice] [money] NOT NULL,
	[Size] [nvarchar](5) NOT NULL,
	[SizeUnitMeasureCode] [nchar](3) NOT NULL,
	[Weight] [decimal](8, 2) NOT NULL,
	[WeightUnitMeasureCode] [nchar](3) NOT NULL,
	[DaysToManufacture] [int] NOT NULL,
	[ProductLine] [nchar](3) NOT NULL,
	[Class] [nchar](3) NOT NULL,
	[Style] [nchar](3) NOT NULL,
	[ProductCategoryID] [int] NOT NULL,
	[ProductCategoryName] [nvarchar](50) NOT NULL,
	[ProductSubcategoryID] [int] NOT NULL,
	[ProductSubcategoryName] [nvarchar](50) NOT NULL,
	[ProductModelID] [int] NOT NULL,
	[ProductModelName] [nvarchar](50) NOT NULL,
	[SellStartDate] [datetime] NOT NULL,
	[SellEndDate] [datetime] NOT NULL,
	[SourceModifiedDate] [datetime] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[ManufactoryId] [int] NOT NULL,
	[ManufactoryName] [nvarchar](255) NOT NULL,
	[DateFrom] [date] NULL,
	[DateTo] [date] NULL,
	[CurrentRowIndicator] [nvarchar](20) NULL
) ON [PRIMARY]
GO


