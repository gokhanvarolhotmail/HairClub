/* CreateDate: 06/17/2008 15:50:08.167 , ModifyDate: 01/25/2010 08:13:27.480 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE spApp_MediaSourceLevel05AddNew
	@Level05Code	varchar(10)
,	@Level05Name	varchar(50)
AS
BEGIN
	INSERT INTO MediaSourceLevel05 (
		Level05CreativeCode
	,	Level05Creative	)
	VALUES (
		@Level05Code
	,	@Level05Name	)
END
GO
