CREATE TABLE [dw].[dim_date](
	[DateKey]		[int]  NOT NULL,
	[Date]			[date] NULL,
	[DayOfMonth]	[varchar](2) NULL,
	[DayName]		[varchar](9) NULL,
	[Month]			[varchar](2) NULL,
	[MonthName]		[varchar](9) NULL,
	[Quarter]		[char](1) NULL,
	[QuarterName]	[varchar](9) NULL,
	[Year]			[char](4) NULL,
	[YearName]		[char](7) NULL,
	[MonthYear]		[char](10) NULL,
	[MMYYYY]		[char](6) NULL,
	[IsWeekday]		[varchar](9) NULL,
	[CreatedDate]	[datetime]  DEFAULT (getdate()) NULL,
	PRIMARY KEY CLUSTERED ([DateKey] ASC)
)