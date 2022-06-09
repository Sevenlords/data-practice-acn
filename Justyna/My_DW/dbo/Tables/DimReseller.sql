USE [My_DW]
GO

/****** Object:  Table [dbo].[DimReseller]    Script Date: 6/9/2022 10:22:35 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DimReseller](
	[ResellerKey] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[ResellerAlternateKey] [varchar](10) NOT NULL,
	[ResellerName] [nvarchar](50) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL
) ON [PRIMARY]
GO


