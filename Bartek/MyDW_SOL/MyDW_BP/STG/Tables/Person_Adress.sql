CREATE TABLE [STG].[Person_Adress] (
    [AddressID]       INT             NULL,
    [AddressLine1]    NVARCHAR (60)   NULL,
    [AddressLine2]    NVARCHAR (60)   NULL,
    [City]            NVARCHAR (30)   NULL,
    [StateProvinceID] INT             NULL,
    [PostalCode]      NVARCHAR (15)   NULL,
    [SpatialLocation] VARBINARY (MAX) NULL,
    [ModifiedDate]    DATETIME        NULL,
    [Time_Stamp]      DATETIME        CONSTRAINT [DF_Time_Stamp_Person_Adress] DEFAULT (getdate()) NULL
);

