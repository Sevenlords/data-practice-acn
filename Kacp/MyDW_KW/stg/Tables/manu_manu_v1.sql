CREATE TABLE [stg].[manu_manu_v1] (
    [ManufactoryId]   NVARCHAR (255) NULL,
    [ManufactoryName] NVARCHAR (255) NULL,
    [Timestamp]       DATETIME       DEFAULT (getdate()) NULL
);

