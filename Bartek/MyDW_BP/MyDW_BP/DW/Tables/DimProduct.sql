CREATE TABLE [DW].[DimProduct] (
    [ProductKey]             INT            IDENTITY (1, 1) NOT NULL,
    [ProductID]              INT            NOT NULL,
    [ProductName]            NVARCHAR (50)  NOT NULL,
    [ProductAlternateKey]    NVARCHAR (25)  NOT NULL,
    [StandardCost]           MONEY          NOT NULL,
    [FinishedGoodFlag]       BIT            NOT NULL,
    [Color]                  NVARCHAR (15)  NULL,
    [ListPrice]              MONEY          NOT NULL,
    [Size]                   NVARCHAR (5)   NULL,
    [SizeUnitMeasureCode]    NCHAR (3)      NULL,
    [Weight]                 DECIMAL (8, 2) NULL,
    [WeightUnitMeasureCode]  NCHAR (3)      NULL,
    [DaysToManufacture]      INT            NOT NULL,
    [ProductLine]            NCHAR (3)      NULL,
    [Class]                  NCHAR (3)      NULL,
    [Style]                  NCHAR (3)      NULL,
    [ProductCategoryID]      INT            NOT NULL,
    [ProductCategoryName]    NVARCHAR (50)  NOT NULL,
    [ProductSubcategoryID]   INT            NOT NULL,
    [ProductSubcategoryName] NVARCHAR (50)  NOT NULL,
    [ProductModelID]         INT            NOT NULL,
    [ProductModelName]       NVARCHAR (50)  NOT NULL,
    [SellStartDate]          DATETIME       NOT NULL,
    [SellEndDate]            DATETIME       NULL,
    [SourceModifiedDate]     DATETIME       NOT NULL,
    [TimeStamp]              DATETIME       DEFAULT (getdate()) NOT NULL
);


GO
  CREATE TRIGGER [DW].ProductMD
ON DW.DimProduct AFTER UPDATE
AS
BEGIN
    IF UPDATE( [ProductKey])
        RETURN
 
    UPDATE DW.DimProduct
        SET ModifiedDate = DEFAULT

	FROM DW.DimProduct d
    JOIN Inserted i
        ON d.ProductKey = i.ProductKey
END;
