USE [My_DW]
GO

/****** Object:  Table [stg].[Manufactories]    Script Date: 5/17/2022 3:35:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [stg].[Manufactories](
	[ManufactoryId] [nvarchar](255) NULL,
	[ManufactoryName] [nvarchar](255) NULL,
	[Timestamp] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [stg].[Manufactories] ADD  DEFAULT (getdate()) FOR [Timestamp]
GO


