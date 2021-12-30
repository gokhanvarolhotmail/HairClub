/* CreateDate: 06/25/2008 16:27:28.630 , ModifyDate: 01/25/2010 08:13:27.480 */
GO
CREATE PROCEDURE [dbo].[spApp_MediaSourceNumberTypeAddNew]
	@NumberType		varchar(50)
AS
BEGIN
	INSERT INTO MediaSourceNumberTypes (
		NumberType	)
	VALUES (
		@NumberType	)
END
GO
