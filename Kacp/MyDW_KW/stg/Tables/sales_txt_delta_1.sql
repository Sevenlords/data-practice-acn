CREATE TABLE [stg].[sales_txt_delta] (
    [order_number] VARCHAR (20) NOT NULL,
    [line_number]  VARCHAR (20) NULL,
    [date]         DATE         NULL,
    [customer]     VARCHAR (10) NOT NULL,
    [country]      VARCHAR (50) NULL,
    [product]      VARCHAR (25) NOT NULL,
    [qty]          SMALLINT     NULL,
    [unit_price]   MONEY        NULL,
    [Timestamp]    DATETIME     DEFAULT (getdate()) NULL,
    [Filename]     VARCHAR (50) NULL
);

