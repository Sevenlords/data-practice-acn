CREATE TABLE [stg].[Person.Address] (
    [ModifiedDate]    DATETIME        NULL,
    [AddressID]       INT             NULL,
    [AddressLine1]    NVARCHAR (60)   NULL,
    [AddressLine2]    NVARCHAR (60)   NULL,
    [City]            NVARCHAR (30)   NULL,
    [StateProvinceID] INT             NULL,
    [PostalCode]      NVARCHAR (15)   NULL,
    [SpatialLocation] VARBINARY (MAX) NULL,
    [timestamp]       DATETIME        DEFAULT (getdate()) NULL
);

