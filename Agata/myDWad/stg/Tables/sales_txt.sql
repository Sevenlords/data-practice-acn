CREATE TABLE [stg].[sales_txt] (
    [order_number] INT          NOT NULL,
    [line_number]  INT          NULL,
    [date]         DATETIME     NULL,
    [reseller]     VARCHAR (10) NULL,
    [country]      VARCHAR (50) NULL,
    [product]      VARCHAR (25) NOT NULL,
    [qty]          SMALLINT     NOT NULL,
    [unit_price]   MONEY        NOT NULL,
    [timesthamp]   DATETIME     DEFAULT (getdate()) NULL,
    [filename]     VARCHAR (50) NULL
);

