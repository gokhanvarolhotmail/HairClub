/* CreateDate: 06/04/2008 12:04:45.230 , ModifyDate: 01/25/2010 08:13:27.463 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spApp_MediaSourceSourcesUpdate] (
	@SourceID			int
,	@SourceName			varchar(100)
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
	@Date		DATETIME
BEGIN
	UPDATE MediaSourceSources
	SET
		SourceName = @SourceName
	,	SourceCode = @SourceCode
	,	PhoneID	= @PhoneID
	,	NumberTypeID = @NumberTypeID
	,	MediaID = @MediaID
	,	Level02ID = @Level02ID
	,	Level03ID = @Level03ID
	,	Level04ID = @Level04ID
	,	Level05ID = @Level05ID
	,	StartDate = @StartDate
	,	EndDate = @EndDate
	,	[Description] = @Description
	,	LastUpdateDate = GETDATE()
	,	IsInHouseSourceFlag = @InHouse
	WHERE
		SourceID = @SourceID

	IF @PhoneID > 0
	BEGIN
		EXEC spApp_MediaSourcePhoneSourceAuditAdd @PhoneID, @SourceID
	END

END
GO
