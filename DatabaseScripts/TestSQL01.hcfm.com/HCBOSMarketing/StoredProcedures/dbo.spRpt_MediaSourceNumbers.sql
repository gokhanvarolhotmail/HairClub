/* CreateDate: 08/04/2008 10:37:39.210 , ModifyDate: 01/25/2010 08:13:27.323 */
GO
/*===============================================================================================
-- Procedure Name:			spRpt_MediaSourceNumbers
-- Procedure Description:
--
-- Created By:				Alex Pasieka
-- Implemented By:			Alex Pasieka
-- Last Modified By:		Alex Pasieka
--
-- Date Created:			8/04/2008
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

EXEC spRpt_MediasourcNumbers 1, 'Active'
================================================================================================*/

CREATE PROCEDURE spRpt_MediaSourceNumbers
	@NumberTypeID	tinyint
,	@Active			varchar(25)
AS
BEGIN
	IF @NumberTypeID = 0 --All Number Types
	BEGIN
		IF @Active = 'All'
		BEGIN
			SELECT
				NumberType
			,	Number
			,	HCDNIS
			,	VendorDNIS
			,	Active
			,	SourceCode
			,	Media
			FROM
				TollFreeNumbers_vw
			ORDER BY
				NumberType
			,	Number
		END
		IF @Active = 'Active'
		BEGIN
			SELECT
				NumberType
			,	Number
			,	HCDNIS
			,	VendorDNIS
			,	Active
			,	SourceCode
			,	Media
			FROM
				TollFreeNumbers_vw
			WHERE
				Active = 1
			ORDER BY
				NumberType
			,	Number
		END
		IF @Active = 'Inactive'
		BEGIN
			SELECT
				NumberType
			,	Number
			,	HCDNIS
			,	VendorDNIS
			,	Active
			,	SourceCode
			,	Media
			FROM
				TollFreeNumbers_vw
			WHERE
				Active = 0
			ORDER BY
				NumberType
			,	Number
		END
	END
	IF @NumberTypeID >= 1
	BEGIN
		IF @Active = 'All'
		BEGIN
			SELECT
				NumberType
			,	Number
			,	HCDNIS
			,	VendorDNIS
			,	Active
			,	SourceCode
			,	Media
			FROM
				TollFreeNumbers_vw
			WHERE
				NumberTypeID = @NumberTypeID
			ORDER BY
				NumberType
			,	Number
		END
		IF @Active = 'Active'
		BEGIN
			SELECT
				NumberType
			,	Number
			,	HCDNIS
			,	VendorDNIS
			,	Active
			,	SourceCode
			,	Media
			FROM
				TollFreeNumbers_vw
			WHERE
				Active = 1
			and	NumberTypeID = @NumberTypeID
			ORDER BY
				NumberType
			,	Number
		END
		IF @Active = 'Inactive'
		BEGIN
			SELECT
				NumberType
			,	Number
			,	HCDNIS
			,	VendorDNIS
			,	Active
			,	SourceCode
			,	Media
			FROM
				TollFreeNumbers_vw
			WHERE
				Active = 0
			and	NumberTypeID = @NumberTypeID
			ORDER BY
				NumberType
			,	Number
		END
	END
END
GO
