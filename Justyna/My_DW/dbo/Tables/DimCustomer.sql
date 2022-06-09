USE [My_DW]
GO

/****** Object:  Table [dbo].[DimCustomer]    Script Date: 6/9/2022 10:19:46 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DimCustomer](
	[CustomerKey] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[CustomerAlternateKey] [varchar](10) NOT NULL,
	[PersonType] [nchar](2) NOT NULL,
	[Title] [nvarchar](8) NOT NULL,
	[FirstName] [nvarchar](50) NOT NULL,
	[MiddleName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[NameStyle] [bit] NOT NULL,
	[EmailPromotion] [int] NOT NULL,
	[Suffix] [nvarchar](10) NOT NULL,
	[EmailAddress] [nvarchar](50) NOT NULL,
	[PhoneNumber] [nvarchar](25) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[HashCode] [varbinary](30) NULL
) ON [PRIMARY]
GO


