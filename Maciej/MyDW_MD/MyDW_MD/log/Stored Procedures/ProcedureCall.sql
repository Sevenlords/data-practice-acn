CREATE procedure [log].[ProcedureCall] (
	@ProcedureName nvarchar(400) = NULL,
	@ProcedureID int,
	@Step int,
	@Comment nvarchar(400)
	)

AS
BEGIN 

declare @name nvarchar(400) = Object_NAME(@ProcedureID)

insert into [log].[Procedure]
	([ProcedureName]
	,[Step]
	,[Comment])
select @name, @Step, @Comment

END