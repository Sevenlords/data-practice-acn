CREATE TABLE [dw].[dim_date] (
    [DateKey]     INT         NOT NULL,
    [Date]        DATE        NULL,
    [DayOfMonth]  INT         NULL,
    [DayName]     VARCHAR (9) NULL,
    [Month]       INT         NULL,
    [MonthName]   VARCHAR (9) NULL,
    [Quarter]     CHAR (1)    NULL,
    [QuarterName] VARCHAR (9) NULL,
    [Year]        INT         NULL,
    [YearName]    CHAR (7)    NULL,
    [MonthYear]   CHAR (10)   NULL,
    [MMYYYY]      CHAR (6)    NULL,
    [IsWeekday]   VARCHAR (9) NULL,
    [CreatedDate] DATETIME    DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([DateKey] ASC)
);

