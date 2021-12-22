/* CreateDate: 07/16/2008 15:27:55.993 , ModifyDate: 01/25/2010 08:13:27.323 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spApp_MediaSourceUpdateOnContactSource
	@SourceCode		nchar(20)
,	@Description	nchar(50)
,	@Active			nchar(1)
,	@OldSourceCode	nchar(20)
AS
BEGIN
	UPDATE onca_source
	SET
		source_code = @SourceCode
	,	[description] = @Description
	,	active = @Active
	WHERE source_code = @OldSourceCode
END
GO
