CREATE TABLE [dw].[customers_temp] (
    [CustomerID]           INT            NOT NULL,
    [CustomerAlternateKey] VARCHAR (10)   NOT NULL,
    [PersonType]           NVARCHAR (2)   NOT NULL,
    [Title]                NVARCHAR (8)   NOT NULL,
    [FirstName]            NVARCHAR (50)  NOT NULL,
    [MiddleName]           NVARCHAR (50)  NOT NULL,
    [LastName]             NVARCHAR (50)  NOT NULL,
    [NameStyle]            BIT            NOT NULL,
    [EmailPromotion]       INT            NOT NULL,
    [Suffix]               NVARCHAR (10)  NOT NULL,
    [EmailAddress]         NVARCHAR (50)  NOT NULL,
    [PhoneNumber]          NVARCHAR (25)  NOT NULL,
    [HashCode]             VARBINARY (30) NULL
);



