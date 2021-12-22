/* CreateDate: 06/25/2008 12:38:21.413 , ModifyDate: 01/25/2010 08:13:27.480 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spApp_MediaSourceTollFreeNumberAddNew]
	@Number				varchar(15)
,	@HCDNIS				varchar(10)
,	@VendorDNIS			varchar(10)
,	@VendorDNIS2		VARCHAR(10)
,	@VoiceMail			varchar(50)
,	@Notes				varchar(200)
,	@QwestID			smallint
,	@Active				bit
,	@NumberTypeID		smallint
AS
	BEGIN
		INSERT INTO MediaSourceTollFreeNumbers (
			Number
		,	HCDNIS
		,	VendorDNIS
		,	[VendorDNIS2]
		,	VoiceMail
		,	Notes
		,	QwestID
		,	Active
		,	NumberTypeID	)
		VALUES (
			@Number
		,	@HCDNIS
		,	@VendorDNIS
		,	@VendorDNIS2
		,	@VoiceMail
		,	@Notes
		,	@QwestID
		,	@Active
		,	@NumberTypeID	)
	END
GO
