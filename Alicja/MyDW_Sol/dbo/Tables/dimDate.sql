CREATE TABLE [dbo].[dimDate] (
    [DateKey]     INT         NOT NULL,
    [Date]        DATE        NULL,
    [DayOfMonth]  VARCHAR (2) NULL,
    [DayName]     VARCHAR (9) NULL,
    [Month]       VARCHAR (2) NULL,
    [MonthName]   VARCHAR (9) NULL,
    [Quater]      CHAR (1)    NULL,
    [QuaterName]  VARCHAR (9) NULL,
    [Year]        CHAR (4)    NULL,
    [YearName]    CHAR (7)    NULL,
    [MonthYear]   CHAR (10)   NULL,
    [MMYYYY]      CHAR (6)    NULL,
    [IsWeekday]   BIT         NULL,
    [CreatedDate] DATETIME    DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([DateKey] ASC)
);

