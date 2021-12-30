/* CreateDate: 07/15/2008 10:53:19.217 , ModifyDate: 01/25/2010 08:13:27.323 */
GO
/*===============================================================================================
-- Procedure Name:			spRpt_MediaSources
-- Procedure Description:
--
-- Created By:				Alex Pasieka
-- Implemented By:			Alex Pasieka
-- Last Modified By:		Alex Pasieka
--
-- Date Created:			7/15/2008
-- Date Implemented:
-- Date Last Modified:
--
-- Destination Server:		HCSQL2\SQL2005
-- Destination Database:	BOSMarketing
-- Related Application:		Media Sources Report

================================================================================================
**NOTES**

================================================================================================

Sample Execution:

EXEC spRpt_Mediasources 1, 'Active'
================================================================================================*/


CREATE PROCEDURE [dbo].[spRpt_MediaSources]
	@MediaID	smallint
,	@Active		varchar(25)
AS
BEGIN
	IF @MediaID = 0 --All Media Types
	BEGIN
		IF @Active = 'All' --Active AND Inactive sources
		BEGIN
			SELECT
				SourceCode
			,	SourceName
			,	PhoneID
			,	Number
			,	Active
			,	NumberTypeID
			,	NumberType
			,	Media
			,	Level02Location
			,	Level03Language
			,	Level04Format
			,	Level05Creative
			,	[Description]
			,	StartDate
			,	EndDate
			,	HCDNIS
			,	VendorDNIS
			,	VendorDNIS2
			,	CreationDate
			,	LastUpdateDate
			FROM vw_MediaSourceReport
			ORDER BY Media, Level02Location, Level03Language, Level04Format, SourceName, SourceCode
		END
		IF @Active = 'Active' --Only Active sources
		BEGIN
			SELECT
				SourceCode
			,	SourceName
			,	PhoneID
			,	Number
			,	Active
			,	NumberTypeID
			,	NumberType
			,	Media
			,	Level02Location
			,	Level03Language
			,	Level04Format
			,	Level05Creative
			,	[Description]
			,	StartDate
			,	EndDate
			,	HCDNIS
			,	VendorDNIS
			,	VendorDNIS2
			,	CreationDate
			,	LastUpdateDate
			FROM vw_MediaSourceReport
			WHERE
				GETDATE() BETWEEN StartDate and EndDate
			ORDER BY Media, Level02Location, Level03Language, Level04Format, SourceName, SourceCode
		END
		IF @Active = 'Inactive'
		BEGIN
			SELECT
				SourceCode
			,	SourceName
			,	PhoneID
			,	Number
			,	Active
			,	NumberTypeID
			,	NumberType
			,	Media
			,	Level02Location
			,	Level03Language
			,	Level04Format
			,	Level05Creative
			,	[Description]
			,	StartDate
			,	EndDate
			,	HCDNIS
			,	VendorDNIS
			,	VendorDNIS2
			,	CreationDate
			,	LastUpdateDate
			FROM vw_MediaSourceReport
			WHERE
				GETDATE() NOT BETWEEN StartDate and EndDate
			ORDER BY Media, Level02Location, Level03Language, Level04Format, SourceName, SourceCode
		END
	END
	IF @MediaID >= 1 --Only the selected Media Type
	BEGIN
		IF @Active = 'All' --Active AND Inactive sources
		BEGIN
			SELECT
				SourceCode
			,	SourceName
			,	PhoneID
			,	Number
			,	Active
			,	NumberTypeID
			,	NumberType
			,	Media
			,	Level02Location
			,	Level03Language
			,	Level04Format
			,	Level05Creative
			,	[Description]
			,	StartDate
			,	EndDate
			,	HCDNIS
			,	VendorDNIS
			,	VendorDNIS2
			,	CreationDate
			,	LastUpdateDate
			FROM vw_MediaSourceReport
			WHERE
				MediaID = @MediaID
			ORDER BY Media, Level02Location, Level03Language, Level04Format, SourceName, SourceCode
		END
		IF @Active = 'Active' --Only Active sources
		BEGIN
			SELECT
				SourceCode
			,	SourceName
			,	PhoneID
			,	Number
			,	Active
			,	NumberTypeID
			,	NumberType
			,	Media
			,	Level02Location
			,	Level03Language
			,	Level04Format
			,	Level05Creative
			,	[Description]
			,	StartDate
			,	EndDate
			,	HCDNIS
			,	VendorDNIS
			,	VendorDNIS2
			,	CreationDate
			,	LastUpdateDate
			FROM vw_MediaSourceReport
			WHERE
				GETDATE() BETWEEN StartDate and EndDate
			and	MediaID = @MediaID
			ORDER BY Media, Level02Location, Level03Language, Level04Format, SourceName, SourceCode
		END
		IF @Active = 'Inactive' --Only Inactive sources
		BEGIN
			SELECT
				SourceCode
			,	SourceName
			,	PhoneID
			,	Number
			,	Active
			,	NumberTypeID
			,	NumberType
			,	Media
			,	Level02Location
			,	Level03Language
			,	Level04Format
			,	Level05Creative
			,	[Description]
			,	StartDate
			,	EndDate
			,	HCDNIS
			,	VendorDNIS
			,	VendorDNIS2
			,	CreationDate
			,	LastUpdateDate
			FROM vw_MediaSourceReport
			WHERE
				GETDATE() NOT BETWEEN StartDate and EndDate
			and MediaID = @MediaID
			ORDER BY Media, Level02Location, Level03Language, Level04Format, SourceName, SourceCode
		END
	END
END
GO
