CREATE TABLE [dbo].[DimCustomer] (
    [CustomerKey]          INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID]           INT           NOT NULL,
    [CustomerAlternateKey] VARCHAR (10)  NOT NULL,
    [PersonType]           NCHAR (2)     NOT NULL,
    [Title]                NVARCHAR (8)  NOT NULL,
    [FirstName]            NVARCHAR (50) NOT NULL,
    [MiddleName]           NVARCHAR (50) NOT NULL,
    [LastName]             NVARCHAR (50) NOT NULL,
    [NameStyle]            BIT           NOT NULL,
    [EmailPromotion]       INT           NOT NULL,
    [Suffix]               NVARCHAR (10) NOT NULL,
    [EmailAddress]         NVARCHAR (50) NOT NULL,
    [PhoneNumber]          NVARCHAR (25) NOT NULL,
    [CreatedDate]          DATETIME      NULL,
    [ModifiedDate]         DATETIME      NULL
);

