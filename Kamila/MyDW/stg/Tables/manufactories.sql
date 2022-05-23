CREATE TABLE [stg].[manufactories] (
    [ManufactoryId]   NVARCHAR (255) NULL,
    [ManufactoryName] NVARCHAR (255) NULL,
    [timestamp]       DATETIME       DEFAULT (getdate()) NULL
);

