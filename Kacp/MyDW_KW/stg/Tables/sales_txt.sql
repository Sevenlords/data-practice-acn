
CREATE TABLE [stg].[sales_txt](
	[order_number] [int] NOT NULL,
	[line_number] [int] NULL,
	[date] [date] NULL,
	[customer] [varchar](10) NOT NULL,
	[country] [varchar](50) NULL,
	[product] [varchar](25) NOT NULL,
	[qty] [smallint] NULL,
	[unit_price] [money] NULL,
	[Timestamp] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [stg].[sales_txt] ADD  DEFAULT (getdate()) FOR [Timestamp]
GO


