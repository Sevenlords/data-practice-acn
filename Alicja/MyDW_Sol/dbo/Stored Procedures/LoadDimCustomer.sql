CREATE procedure [dbo].[LoadDimCustomer] as

	--truncate table dbo.dimCustomer

	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 1, @Comment = 'Start Proc'
	
	begin try

	delete from [dbo].[dimCustomer]
	where CustomerKey = -1

	set identity_insert [dbo].[dimCustomer] ON

	insert into [dbo].[dimCustomer](
		[CustomerKey]
		,[CustomerID]
		,[CustomerAlternateKey]
		,[PersonType]
		,[Title]
		,[FirstName]
		,[MiddleName]
		,[LastName]
		,[NameStyle]
		,[EmailPromotion]
		,[Suffix]
		,[EmailAddress]
		,[Phone]
		,[CreatedDate]
		,[ModifiedDate]
		,[HashCode]
	)
	select
		-1 as [CustomerKey],
		-1 as [CustomerID],
		'-1' as [CustomerAlternateKey],
		'-1' as [PersonType],
		'-1' as [Title],
		'-1' as [FirstName],
		'-1' as [MiddleName],
		'-1' as [LastName],
		0 as [NameStyle],
		-1 as [EmailPromotion],
		'-1' as [Suffix],
		'-1' as [EmailAddress],
		'-1' as [Phone],
		getdate() as [CreatedDate],
		getdate() as [ModifiedDate],
		null as [HashCode]

	set identity_insert [dbo].[dimCustomer] OFF

	--drop table if exists #customers
	drop table if exists [dbo].[dimCustomerTmp]

	select   
		C.CustomerID AS [CustomerID],
		C.AccountNumber AS [CustomerAlternateKey],
		P.PersonType AS [PersonType],
		ISNULL(P.Title, 'N/D') AS [Title],
		P.FirstName AS [FirstName],
		ISNULL(P.MiddleName, 'N/D') AS [MiddleName],
		P.LastName AS [LastName],
		P.NameStyle AS [NameStyle],
		P.EmailPromotion AS [EmailPromotion],
		ISNULL(P.Suffix, 'N/D') AS [Suffix],
		ISNULL(EA.EmailAddress, 'N/D') AS [EmailAddress],
		ISNULL(PP.PhoneNumber, 'N/D') AS [Phone],
		cast(null as varbinary(30)) AS [HashCode]
	--into #customers
	into [dbo].[dimCustomerTmp]
		from [stg].[Sales_Customer] AS C
		JOIN [stg].[Person_Person] AS P
		ON C.PersonID = P.BusinessEntityID
		LEFT JOIN [stg].[Person_EmailAddress] AS EA
		ON P.BusinessEntityID = EA.BusinessEntityID
		LEFT JOIN [stg].[Person_PersonPhone] AS PP
		ON P.BusinessEntityID = PP.BusinessEntityID

	--select * from dbo.dimCustomerTmp

	update [dbo].[dimCustomerTmp]
	set [HashCode] = HASHBYTES('MD5', concat([CustomerID], [CustomerAlternateKey], [PersonType], [Title], [FirstName], [MiddleName], [LastName], 
											[NameStyle], [EmailPromotion], [Suffix], [EmailAddress], [Phone]))

	-- select * from INFORMATION_SCHEMA.COLUMNS

	update a
	set
		[CustomerID] = b.[CustomerID],
		[CustomerAlternateKey] = b.[CustomerAlternateKey],
		[PersonType] = b.[PersonType],
		[Title] = b.[Title],
		[FirstName] = b.[FirstName],
		[MiddleName] = b.[MiddleName],
		[LastName] = b.[LastName],
		[NameStyle] = b.[NameStyle],
		[EmailPromotion] = b.[EmailPromotion],
		[Suffix] = b.[Suffix],
		[EmailAddress] = b.[EmailAddress],
		[Phone] = b.[Phone],
		[ModifiedDate] = getdate(),
		[HashCode] = b.[HashCode]
	from [dbo].[dimCustomer] a
	join [dbo].[dimCustomerTmp] b on a.CustomerID = b.CustomerID
	where a.HashCode <> b.HashCode
	--join #customers b on a.CustomerID = b.CustomerID
	--where
	--	a.[CustomerID] != b.[CustomerID]
	--	or a.[CustomerAlternateKey] != b.[CustomerAlternateKey]
	--	or a.[PersonType] != b.[PersonType]
	--	or a.[Title] != b.[Title]
	--	or a.[FirstName] != b.[FirstName]
	--	or a.[MiddleName] != b.[MiddleName]
	--	or a.[LastName] != b.[LastName]
	--	or a.[NameStyle] != b.[NameStyle]
	--	or a.[EmailPromotion] != b.[EmailPromotion]
	--	or a.[Suffix] != b.[Suffix]
	--	or a.[EmailAddress] != b.[EmailAddress]
	--	or a.[Phone] != b.[Phone]

	insert into dbo.dimCustomer(
		   [CustomerID]
		  ,[CustomerAlternateKey]
		  ,[PersonType]
		  ,[Title]
		  ,[FirstName]
		  ,[MiddleName]
		  ,[LastName]
		  ,[NameStyle]
		  ,[EmailPromotion]
		  ,[Suffix]
		  ,[EmailAddress]
		  ,[Phone]
		  ,[HashCode]
		  ,[CreatedDate]
		  ,[ModifiedDate])
	select b.*, getdate(), getdate()
	from [dbo].[dimCustomer] a
	--right join #customers b on a.CustomerID = b.CustomerID
	right join [dbo].[dimCustomerTmp] b on a.CustomerID = b.CustomerID
	where a.CustomerID is null

	/*
	delete a
	from [dbo].[dimCustomer] a
	--left join #customers b on a.CustomerID = b.CustomerID
	right join [dbo].[dimCustomerTmp] b on a.CustomerID = b.CustomerID
	where b.CustomerID is null
	*/

	exec [log].[ProcedureCall] @ProcedureId = @@procid, @Step = 999, @Comment = 'End Proc'

	end try

	begin catch
		exec [log].[ErrorCall]
	end catch
