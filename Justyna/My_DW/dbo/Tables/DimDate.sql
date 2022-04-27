CREATE TABLE [dbo].[DimDate] (
    [DateKey]     INT         NOT NULL,
    [Date]        DATETIME    NULL,
    [DayOfMonth]  VARCHAR (2) NULL,
    [DayName]     VARCHAR (9) NULL,
    [Month]       VARCHAR (2) NULL,
    [MonthName]   VARCHAR (9) NULL,
    [Quarter]     CHAR (1)    NULL,
    [QuarterName] VARCHAR (9) NULL,
    [Year]        CHAR (4)    NOT NULL,
    [YearName]    CHAR (7)    NOT NULL,
    [MonthYear]   CHAR (10)   NOT NULL,
    [MMYYYY]      CHAR (6)    NOT NULL,
    [IsWeekday]   BIT         NULL,
    [Timeshtamp]  DATETIME    DEFAULT (getdate()) NULL,
    PRIMARY KEY CLUSTERED ([DateKey] ASC)
);

