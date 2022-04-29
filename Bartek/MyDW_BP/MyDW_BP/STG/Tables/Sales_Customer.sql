CREATE TABLE [STG].[Sales_Customer] (
    [CustomerID]    INT          NULL,
    [PersonID]      INT          NULL,
    [StoreID]       INT          NULL,
    [TerritoryID]   INT          NULL,
    [AccountNumber] VARCHAR (10) NULL,
    [ModifiedDate]  DATETIME     NULL,
    [Time_Stamp]    DATETIME     CONSTRAINT [DF_Time_Stamp_Production_Sales_Customer] DEFAULT (getdate()) NULL
);

