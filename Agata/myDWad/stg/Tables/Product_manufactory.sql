CREATE TABLE [stg].[Product_manufactory] (
    [ProductID]           VARCHAR (50) NULL,
    [ProductAlternateKey] VARCHAR (50) NULL,
    [ManufactoryId]       VARCHAR (50) NULL,
    [DateFrom]            VARCHAR (50) NULL,
    [DateTo]              VARCHAR (50) NULL,
    [timesthamp]          DATETIME     DEFAULT (getdate()) NULL
);

