CREATE TABLE [stg].[manufactories] (
    [ManufactoryId]   NVARCHAR (255) NULL,
    [ManufactoryName] NVARCHAR (255) NULL,
    [timesthamp]      DATETIME       DEFAULT (getdate()) NULL
);

