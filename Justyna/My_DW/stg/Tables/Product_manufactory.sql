USE [My_DW]
GO

/****** Object:  Table [stg].[Product_manufactory]    Script Date: 5/17/2022 3:33:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [stg].[Product_manufactory](
	[ProductID] [nvarchar](255) NULL,
	[ProductAlternateKey] [nvarchar](255) NULL,
	[ManufactoryId] [nvarchar](255) NULL,
	[DateFrom] [nvarchar](255) NULL,
	[DateTo] [nvarchar](255) NULL,
	[Timestamp] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [stg].[Product_manufactory] ADD  DEFAULT (getdate()) FOR [Timestamp]
GO


