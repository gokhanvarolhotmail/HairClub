/* CreateDate: 07/01/2008 10:39:29.023 , ModifyDate: 01/25/2010 08:13:27.480 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spApp_MediaSourceQwestTypeAddNew
	@Qwest	varchar(50)
AS
BEGIN
	INSERT INTO MediaSourceQwestOptions (
		Qwest	)
	VALUES (
		@Qwest	)
END
GO
