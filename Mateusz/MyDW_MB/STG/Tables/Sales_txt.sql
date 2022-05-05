CREATE TABLE [STG].[Sales_txt] (
    [order_number] VARCHAR (50)  NOT NULL,
    [line_number]  INT           NOT NULL,
    [date]         DATETIME      NOT NULL,
    [customer]     VARCHAR (10)  NOT NULL,
    [country]      VARCHAR (50)  NOT NULL,
    [product]      NVARCHAR (25) NOT NULL,
    [qty]          SMALLINT      NOT NULL,
    [unit_price]   MONEY         NOT NULL,
    [timeshtamp]   DATETIME      NOT NULL,
    [filename]     VARCHAR (50)  NOT NULL
);

