/* CreateDate: 08/16/2012 08:53:07.597 , ModifyDate: 08/16/2012 08:53:07.597 */
GO
/***********************************************************************

PROCEDURE:	[spsvc_NobleSourceExport]

DESTINATION SERVER:	   HCWH1 - BALDY

DESTINATION DATABASE: Warehouse

RELATED APPLICATION:  Barth CMS Export

AUTHOR: Marlon Burrell

IMPLEMENTOR: Marlon Burrell

DATE IMPLEMENTED: 11/5/09

LAST REVISION DATE: 11/5/09

------------------------------------------------------------------------
This procedure exports source, tollfree number and DNIS information to NOBLE
------------------------------------------------------------------------

SAMPLE EXEC:
exec [spsvc_NobleSourceExport]

***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_NobleSourceExport] AS
BEGIN

	SET NOCOUNT ON
	SET XACT_ABORT ON

	SELECT MediaSourceSources.SourceCode
	,	REPLACE(REPLACE(REPLACE(REPLACE(MediaSourceTollFreeNumbers.Number, '(',''), ')',''), '-',''), ' ','') AS 'TollFreeNumber'
	,	MediaSourceTollFreeNumbers.HCDNIS AS 'HairclubDNIS'
	--,	MediaSourceTollFreeNumbers.VendorDNIS AS 'ConnectionDNIS'
	--,	MediaSourceTollFreeNumbers.VendorDNIS2 AS 'LiveOpsDNIS'
	FROM MediaSourceSources MediaSourceSources
		LEFT OUTER JOIN MediaSourceTollFreeNumbers MediaSourceTollFreeNumbers
			ON MediaSourceSources.PhoneID = MediaSourceTollFreeNumbers.NumberID
		LEFT OUTER JOIN MediaSourceNumberTypes MediaSourceNumberTypes
			ON MediaSourceSources.NumberTypeID = MediaSourceNumberTypes.NumberTypeID
	WHERE MediaSourceTollFreeNumbers.Number IS NOT NULL
		AND GETDATE() BETWEEN MediaSourceSources.[StartDate] AND MediaSourceSources.[EndDate]
	ORDER BY MediaSourceSources.SourceCode

END
GO
