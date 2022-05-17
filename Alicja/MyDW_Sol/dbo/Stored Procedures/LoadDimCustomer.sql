CREATE procedure [dbo].[LoadDimCustomer] as

	--truncate table dbo.dimCustomer

	drop table if exists #customers

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
		ISNULL(PP.PhoneNumber, 'N/D') AS [Phone]
	into #customers
		from [stg].[Sales_Customer] AS C
		JOIN [stg].[Person_Person] AS P
		ON C.PersonID = P.BusinessEntityID
		LEFT JOIN [stg].[Person_EmailAddress] AS EA
		ON P.BusinessEntityID = EA.BusinessEntityID
		LEFT JOIN [stg].[Person_PersonPhone] AS PP
		ON P.BusinessEntityID = PP.BusinessEntityID

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
		[ModifiedDate] = getdate()
	from [dbo].[dimCustomer] a
	join #customers b on a.CustomerID = b.CustomerID
	where
		a.[CustomerID] != b.[CustomerID]
		or a.[CustomerAlternateKey] != b.[CustomerAlternateKey]
		or a.[PersonType] != b.[PersonType]
		or a.[Title] != b.[Title]
		or a.[FirstName] != b.[FirstName]
		or a.[MiddleName] != b.[MiddleName]
		or a.[LastName] != b.[LastName]
		or a.[NameStyle] != b.[NameStyle]
		or a.[EmailPromotion] != b.[EmailPromotion]
		or a.[Suffix] != b.[Suffix]
		or a.[EmailAddress] != b.[EmailAddress]
		or a.[Phone] != b.[Phone]

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
		  ,[CreatedDate]
		  ,[ModifiedDate])
	select b.*, getdate(), getdate()
	from [dbo].[dimCustomer] a
	right join #customers b on a.CustomerID = b.CustomerID
	where a.CustomerID is null

	/*
	delete a
	from [dbo].[dimCustomer] a
	left join #customers b on a.CustomerID = b.CustomerID
	where b.CustomerID is null
	*/
