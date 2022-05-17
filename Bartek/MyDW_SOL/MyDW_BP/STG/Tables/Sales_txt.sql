CREATE TABLE [STG].[Sales_txt] (
    [Order_number] INT          NOT NULL,
    [Line_Number]  INT          NOT NULL,
    [Date]         DATETIME     NOT NULL,
    [Reseller]     VARCHAR (10) NOT NULL,
    [Country]      VARCHAR (50) NULL,
    [Product]      VARCHAR (50) NULL,
    [qty]          SMALLINT     NULL,
    [unit_price]   MONEY        NULL,
    [timeshtamp]   DATETIME     NULL,
    [filename]     VARCHAR (50) NULL
);

