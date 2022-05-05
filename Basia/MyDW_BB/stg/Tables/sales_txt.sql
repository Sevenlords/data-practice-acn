CREATE TABLE [stg].[sales_txt] (
    [order_number] INT           NULL,
    [line_number]  INT           NULL,
    [date]         DATETIME      NULL,
    [reseller]     NVARCHAR (30) NULL,
    [country]      NVARCHAR (20) NULL,
    [product]      NVARCHAR (30) NULL,
    [qty]          INT           NULL,
    [unit_price]   INT           NULL,
    [timestamp]    DATETIME      DEFAULT (getdate()) NULL
);

