CREATE TABLE [STG].[Sales_Store] (
    [BusinessEntityID] INT            NULL,
    [Name]             NVARCHAR (50)  NULL,
    [SalesPersonID]    INT            NULL,
    [Demographics]     NVARCHAR (MAX) NULL,
    [ModifiedDate]     DATETIME       NULL,
    [Time_Stamp]       DATETIME       CONSTRAINT [DF_Time_Stamp_Sales_Store] DEFAULT (getdate()) NULL
);

