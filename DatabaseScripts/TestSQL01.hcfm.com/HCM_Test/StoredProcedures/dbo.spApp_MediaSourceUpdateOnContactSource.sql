/* CreateDate: 10/01/2008 16:04:42.280 , ModifyDate: 05/01/2010 14:48:10.827 */
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
