CREATE TABLE [DW].[DimReseller] (
    [ResellerKey]          INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID]           INT           NULL,
    [ResellerAlternateKey] VARCHAR (10)  NULL,
    [ResellerName]         NVARCHAR (50) NULL,
    [CreatedDate]          DATETIME      CONSTRAINT [DF_Reseller_CD] DEFAULT (getdate()) NOT NULL,
    [ModifiedDate]         DATETIME      CONSTRAINT [DF_Reseller_MD] DEFAULT (getdate()) NULL
);


GO
  CREATE TRIGGER [DW].ResselerMD
ON DW.DimReseller AFTER UPDATE
AS
BEGIN
    IF UPDATE( [ResellerKey])
        RETURN
 
    UPDATE DW.DimReseller
        SET ModifiedDate = DEFAULT

	FROM DW.DimReseller
    JOIN Inserted
        ON DW.DimReseller.ResellerKey = Inserted.ResellerKey
END;
