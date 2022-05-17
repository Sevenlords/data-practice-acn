CREATE TABLE [stg].[sales_txt] (
    [order_number] INT          NOT NULL,
    [line_number]  INT          NULL,
    [date]         DATE         NULL,
    [customer]     VARCHAR (10) NOT NULL,
    [country]      VARCHAR (50) NULL,
    [product]      VARCHAR (25) NOT NULL,
    [qty]          SMALLINT     NULL,
    [unit_price]   MONEY        NULL,
    [Timestamp]    DATETIME     DEFAULT (getdate()) NULL,
    [Filename]     VARCHAR (50) NULL
);

