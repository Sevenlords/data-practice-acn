CREATE TABLE [DW].[DimCustomer] (
    [CustomerKey]          INT           IDENTITY (1, 1) NOT NULL,
    [CustomerID]           INT           NOT NULL,
    [CustomerAlternateKey] VARCHAR (10)  NOT NULL,
    [PersonType]           NCHAR (2)     NOT NULL,
    [Title]                NVARCHAR (8)  NOT NULL,
    [FirstName]            NVARCHAR (50) NOT NULL,
    [MiddleName]           NVARCHAR (50) NOT NULL,
    [LastName]             NVARCHAR (50) NOT NULL,
    [NameStyle]            BIT           NOT NULL,
    [Suffix]               NVARCHAR (10) NOT NULL,
    [EmailAddress]         NVARCHAR (50) NOT NULL,
    [PhoneNumber]          NVARCHAR (25) NOT NULL,
    [ModifiedDate]         DATETIME      NULL,
    [CreatedDate]          DATETIME      NULL
);




GO
  CREATE TRIGGER [DW].CustomerMD
ON DW.DimCustomer AFTER UPDATE
AS
BEGIN
    IF UPDATE( [CustomerKey])
        RETURN
 
    UPDATE DW.DimCustomer
        SET ModifiedDate = DEFAULT

	FROM DW.DimCustomer d
    JOIN Inserted i
        ON d.CustomerKey = i.CustomerKey
END;
