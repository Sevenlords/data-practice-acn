CREATE TABLE [stg].[sales_txt_delta] (
    [order_number] VARCHAR (50) NULL,
    [line_number]  VARCHAR (50) NULL,
    [date]         VARCHAR (50) NULL,
    [reseller]     VARCHAR (10) NULL,
    [country]      VARCHAR (50) NULL,
    [product]      VARCHAR (50) NULL,
    [qty]          VARCHAR (50) NULL,
    [unit_price]   VARCHAR (50) NULL,
    [timesthamp]   DATETIME     DEFAULT (getdate()) NULL,
    [filename]     VARCHAR (50) NULL
);

