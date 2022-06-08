CREATE TABLE [dbo].[DimCustomer] (
    [CustomerKey]          INT            IDENTITY (1, 1) NOT NULL,
    [CustomerID]           INT            NULL,
    [CustomerAlternateKey] VARCHAR (10)   NULL,
    [PersonType]           NCHAR (2)      NULL,
    [Title]                NVARCHAR (8)   NULL,
    [FirstName]            NVARCHAR (50)  NULL,
    [MiddleName]           NVARCHAR (50)  NULL,
    [LastName]             NVARCHAR (50)  NULL,
    [NameStyle]            BIT            NULL,
    [EmailPromotion]       INT            NULL,
    [Suffix]               NVARCHAR (10)  NULL,
    [EmailAddress]         NVARCHAR (50)  NULL,
    [PhoneNumber]          NVARCHAR (25)  NULL,
    [CreatedDate]          DATETIME       DEFAULT (getdate()) NULL,
    [ModifiedDate]         DATETIME       NULL,
    [HashCode]             VARBINARY (30) NULL
);

