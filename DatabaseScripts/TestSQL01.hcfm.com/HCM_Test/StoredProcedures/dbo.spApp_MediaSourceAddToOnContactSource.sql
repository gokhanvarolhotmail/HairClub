/* CreateDate: 10/01/2008 16:04:52.580 , ModifyDate: 05/01/2010 14:48:10.857 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spApp_MediaSourceAddToOnContactSource
	@SourceCode		nchar(20)
,	@Description	nchar(50)
,	@Active			nchar(1)
AS
BEGIN
	INSERT INTO onca_Source (
		source_code
	,	[description]
	,	active	)
	VALUES (
		@SourceCode
	,	@Description
	,	@Active)
END
GO
