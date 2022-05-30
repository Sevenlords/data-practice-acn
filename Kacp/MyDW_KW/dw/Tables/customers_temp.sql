CREATE TABLE [dw].[customers_temp] (
    [CustomerID]           INT            NULL,
    [CustomerAlternateKey] VARCHAR (10)   NULL,
    [PersonType]           NVARCHAR (2)   NULL,
    [Title]                NVARCHAR (8)   NOT NULL,
    [FirstName]            NVARCHAR (50)  NULL,
    [MiddleName]           NVARCHAR (50)  NOT NULL,
    [LastName]             NVARCHAR (50)  NULL,
    [NameStyle]            BIT            NULL,
    [EmailPromotion]       INT            NULL,
    [Suffix]               NVARCHAR (10)  NOT NULL,
    [EmailAddress]         NVARCHAR (50)  NOT NULL,
    [PhoneNumber]          NVARCHAR (25)  NOT NULL,
    [HashCode]             VARBINARY (30) NULL
);

