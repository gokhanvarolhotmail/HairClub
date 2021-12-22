/* CreateDate: 06/25/2008 12:30:18.267 , ModifyDate: 01/25/2010 08:13:27.480 */
GO
CREATE PROCEDURE [dbo].[spApp_MediaSourceTollFreeNumberUpdate]
	@NumberID			int
,	@Number				varchar(15)
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
		UPDATE MediaSourceTollFreeNumbers
		SET
			Number			=	@Number
		,	HCDNIS			=	@HCDNIS
		,	VendorDNIS		=	@VendorDNIS
		,	VendorDNIS2		=	@VendorDNIS2
		,	VoiceMail		=	@VoiceMail
		,	Notes			=	@Notes
		,	QwestID			=	@QwestID
		,	Active			=	@Active
		,	NumberTypeID	=	@NumberTypeID
		WHERE
			NumberID		=	@NumberID

		UPDATE MediaSourceSources
		SET NumberTypeID = @NumberTypeID
		WHERE PhoneID = @NumberID


	END
GO
