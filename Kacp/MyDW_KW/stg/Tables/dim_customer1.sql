CREATE TABLE [stg].[dim_customer1] (
    [PersonType]        NVARCHAR (2)  NULL,
    [Title]             NVARCHAR (8)  NOT NULL,
    [FirstName]         NVARCHAR (50) NULL,
    [MiddleName]        NVARCHAR (50) NOT NULL,
    [LastName]          NVARCHAR (50) NULL,
    [Timestamp]         DATETIME      NULL,
    [CustomerID]        INT           NULL,
    [AccountNumber]     VARCHAR (10)  NULL,
    [AddressLine1]      NVARCHAR (60) NULL,
    [City]              NVARCHAR (30) NULL,
    [StateProvinceID]   INT           NULL,
    [PostalCode]        NVARCHAR (15) NULL,
    [EmailAddress]      NVARCHAR (50) NULL,
    [PhoneNumber]       NVARCHAR (25) NULL,
    [PhoneNumberTypeID] INT           NULL
);

