USE [KW_DW]
GO

/****** Object:  Table [stg].[sales_txt_delta]    Script Date: 29.04.2022 13:59:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [stg].[sales_txt_delta](
	[order_number] [varchar](20) NOT NULL,
	[line_number] [varchar](20) NULL,
	[date] [date] NULL,
	[customer] [varchar](10) NOT NULL,
	[country] [varchar](50) NULL,
	[product] [varchar](25) NOT NULL,
	[qty] [smallint] NULL,
	[unit_price] [money] NULL,
	[Timestamp] [datetime] NULL,
	[Filename] [varchar](50) NULL
) ON [PRIMARY]
GO

ALTER TABLE [stg].[sales_txt_delta] ADD  DEFAULT (getdate()) FOR [Timestamp]
GO


