/* CreateDate: 07/01/2008 10:38:35.773 , ModifyDate: 01/25/2010 08:13:27.480 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spApp_MediaSourceQwestTypeUpdate
	@QwestID	smallint
,	@Qwest		varchar(50)
AS
BEGIN
	UPDATE MediaSourceQwestOptions
	SET Qwest = @Qwest
	WHERE QwestID = @QwestID
END
GO
