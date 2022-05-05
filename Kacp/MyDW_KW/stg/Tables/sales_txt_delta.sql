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

use kw_dw

select order_number, line_number, product, qty, unit_price from stg.sales_txt_delta where order_number = 100407

select * from
	stg.sales_txt st
	join dw.dim_reseller dr on st.customer = dr.ResellerAlternateKey -- ResellerKey
	join dw.dim_date dd on dd.Date = st.date
	join dw.dim_product dp on st.product = dp.ProductAlternateKey


select * from stg.sales_sales_orderheader
select * from dw.dim_product
select * from stg.sales_txt
select * from dw.fact_ResellerSales

select * from dw.dim_reseller

