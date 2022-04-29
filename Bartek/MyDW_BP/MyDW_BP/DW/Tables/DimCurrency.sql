CREATE TABLE [DW].[DimCurrency] (
    [CurrencyKey]          INT           IDENTITY (1, 1) NOT NULL,
    [CurrencyAlternateKey] NVARCHAR (3)  NULL,
    [CurrencyName]         NVARCHAR (50) NULL,
    [SourceModifiedDate]   DATETIME      NULL,
    [TimeStamp]            DATETIME      DEFAULT (getdate()) NOT NULL
);


GO
  Create TRIGGER [DW].[CurrencyMD]
ON [DW].[DimCurrency] AFTER UPDATE
AS
BEGIN
    IF UPDATE( [CurrencyKey])
        RETURN
 
    UPDATE DW.DimCurrency
        SET ModifiedDate = DEFAULT

	FROM DW.DimCurrency
    JOIN Inserted
        ON DW.DimCurrency.CurrencyKey = Inserted.CurrencyKey
END;
