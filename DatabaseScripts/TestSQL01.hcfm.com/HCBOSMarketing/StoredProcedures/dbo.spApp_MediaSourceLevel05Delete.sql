/* CreateDate: 06/17/2008 16:29:56.510 , ModifyDate: 01/25/2010 08:13:27.480 */
GO
CREATE PROCEDURE spApp_MediaSourceLevel05Delete
	@Level05ID	int
AS
BEGIN
	DELETE
	FROM MediaSourceLevel05
	WHERE Level05ID = @Level05ID
END
GO
