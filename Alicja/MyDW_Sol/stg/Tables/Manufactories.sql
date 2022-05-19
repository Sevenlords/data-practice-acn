CREATE TABLE [stg].[Manufactories] (
    [ManufactoryId]   NVARCHAR (255) NULL,
    [ManufactoryName] NVARCHAR (255) NULL,
    [Timestamp]       DATETIME       DEFAULT (getdate()) NULL
);

