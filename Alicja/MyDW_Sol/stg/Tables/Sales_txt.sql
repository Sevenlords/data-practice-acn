CREATE TABLE [stg].[Sales_txt] (
    [order_number] VARCHAR (50) NULL,
    [line_number]  VARCHAR (50) NULL,
    [date]         VARCHAR (50) NULL,
    [customer]     VARCHAR (50) NULL,
    [country]      VARCHAR (50) NULL,
    [product]      VARCHAR (50) NULL,
    [qty]          VARCHAR (50) NULL,
    [unit_price]   VARCHAR (50) NULL,
    [Timestamp]    DATETIME     DEFAULT (getdate()) NULL,
    [Filename]     VARCHAR (50) NULL
);

