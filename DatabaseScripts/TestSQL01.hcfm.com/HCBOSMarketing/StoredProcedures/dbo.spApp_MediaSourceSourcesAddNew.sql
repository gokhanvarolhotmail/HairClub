/* CreateDate: 05/30/2008 14:11:56.120 , ModifyDate: 01/25/2010 08:13:27.447 */
GO
CREATE PROCEDURE [dbo].[spApp_MediaSourceSourcesAddNew] (
	@SourceName			varchar(100)
,	@SourceCode			varchar(20)
,	@StartDate			smalldatetime
,	@EndDate			smalldatetime
,	@PhoneID			int
,	@NumberTypeID		int
,	@Description		varchar(1000)
,	@MediaID			int
,	@Level02ID			int
,	@Level03ID			int
,	@Level04ID			int
,	@Level05ID			INT
,	@InHouse			CHAR(1)	)
AS
DECLARE
	@SourceID		INT
,	@Date			datetime
BEGIN
	INSERT INTO MediaSourceSources (
		SourceName
	,	SourceCode
	,	StartDate
	,	EndDate
	,	PhoneID
	,	NumberTypeID
	,	[Description]
	,	MediaID
	,	Level02ID
	,	Level03ID
	,	Level04ID
	,	Level05ID
	,	CreationDate
	,	LastUpdateDate
	,	IsInHouseSourceFlag	)
	VALUES (
		@SourceName
	,	@SourceCode
	,	@StartDate
	,	@EndDate
	,	@PhoneID
	,	@NumberTypeID
	,	@Description
	,	@MediaID
	,	@Level02ID
	,	@Level03ID
	,	@Level04ID
	,	@Level05ID
	,	GETDATE()
	,	GETDATE()
	,	@InHouse	)

	SELECT @SourceID = @@IDENTITY

	IF @PhoneID > 0
	BEGIN
		EXEC spApp_MediaSourcePhoneSourceAuditAdd @PhoneID, @SourceID
	END

END
GO
