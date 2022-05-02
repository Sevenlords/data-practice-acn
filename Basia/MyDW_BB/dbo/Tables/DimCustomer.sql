CREATE TABLE [dbo].[DimCustomer] (
    [CustomerKey]          INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID]           INT           NOT NULL,
    [CustomerAlternateKey] VARCHAR (10)  NOT NULL,
    [PersonType]           NVARCHAR (2)  NOT NULL,
    [Title]                NVARCHAR (8)  NULL,
    [FirstName]            NVARCHAR (50) NULL,
    [MiddleName]           NVARCHAR (50) NULL,
    [LastName]             NVARCHAR (50) NULL,
    [NameStyle]            BIT           NULL,
    [EmailPromotion]       INT           NULL,
    [Suffix]               NVARCHAR (10) NULL,
    [EmailAdress]          NVARCHAR (50) NULL,
    [Phone]                NVARCHAR (10) NULL,
    [CreatedDate]          DATETIME      DEFAULT (getdate()) NULL,
    [ModifiedDate]         DATETIME      NULL
);

