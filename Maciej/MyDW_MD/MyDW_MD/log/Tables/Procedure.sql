CREATE TABLE [log].[Procedure] (
    [Log Date]      DATETIME2 (7)  DEFAULT (getdate()) NOT NULL,
    [ProcedureName] NVARCHAR (400) NULL,
    [Step]          INT            NULL,
    [Comment]       NVARCHAR (400) NULL
);

