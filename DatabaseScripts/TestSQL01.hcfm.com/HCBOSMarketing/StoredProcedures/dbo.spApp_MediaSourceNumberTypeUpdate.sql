/* CreateDate: 06/25/2008 16:26:25.003 , ModifyDate: 01/25/2010 08:13:27.480 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spApp_MediaSourceNumberTypeUpdate]
	@NumberTypeID	tinyint
,	@NumberType		varchar(50)
AS
BEGIN
	UPDATE MediaSourceNumberTypes
	SET NumberType = @NumberType
	WHERE NumberTypeID = @NumberTypeID
END
GO
