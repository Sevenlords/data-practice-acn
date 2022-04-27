CREATE TABLE [dbo].[DimDate] (
    [DateKey]        INT           NOT NULL,
    [Date]           DATETIME      NULL,
    [FullDateUK]     CHAR (10)     NULL,
    [DayOfMonth]     INT           NULL,
    [DayName]        NVARCHAR (30) NULL,
    [Month]          INT           NULL,
    [MonthName]      NVARCHAR (30) NULL,
    [MonthOfQuarter] INT           NULL,
    [Quarter]        INT           NULL,
    [QuarterName]    VARCHAR (6)   NULL,
    [Year]           INT           NULL,
    [YearName]       VARCHAR (15)  NOT NULL,
    [MonthYear]      NVARCHAR (16) NOT NULL,
    [MMYYYY]         VARCHAR (14)  NOT NULL,
    [IsWeekday]      INT           NULL,
    [Timeshtamp]     DATETIME      DEFAULT (getdate()) NULL
);

