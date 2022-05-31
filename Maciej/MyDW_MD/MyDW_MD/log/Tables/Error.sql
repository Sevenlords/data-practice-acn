CREATE TABLE [log].[Error] (
    [ErrorDate]      DATETIME2 (7)  DEFAULT (getdate()) NOT NULL,
    [ErrorNumber]    INT            NULL,
    [ErrorState]     INT            NULL,
    [ErrorSeverity]  INT            NULL,
    [ErrorLine]      INT            NULL,
    [ErrorProcedure] NVARCHAR (MAX) NULL,
    [ErrorMessage]   NVARCHAR (MAX) NULL
);

