CREATE procedure [log].[ErrorCall] (
@ErrorNumber int  = null,
@ErrorState int = null,
@ErrorSeverity int = null,
@ErrorLine int = null,
@ErrorProcedure nvarchar(max) = null,
@ErrorMessage nvarchar(max) = null)
AS
BEGIN 


insert into [log].[Error]
	([ErrorNumber],
[ErrorState],
[ErrorSeverity],
[ErrorLine],
[ErrorProcedure],
[ErrorMessage])
select ERROR_NUMBER(), ERROR_STATE(), ERROR_SEVERITY(), ERROR_LINE(), ERROR_PROCEDURE(), ERROR_MESSAGE()
END