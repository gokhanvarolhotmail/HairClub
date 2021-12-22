/* CreateDate: 10/08/2007 15:56:59.410 , ModifyDate: 01/25/2010 08:11:31.790 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:		spsvc_GetInquiryFile

VERSION:		v2.0

DESTINATION SERVER:	HCTESTSQL1\SQL2005

DESTINATION DATABASE: 	BOS

RELATED APPLICATION:  	DNC Processing

AUTHOR: 		Howard Abelow v1.5 and 2.0 - Originally Designed by Sean Knight

IMPLEMENTOR: 		Howard Abelow

DATE IMPLEMENTED: 	10/9/2007

LAST REVISION DATE: 	10/9/2007

------------------------------------------------------------------------
NOTES: 	Gets the data to create the inquiry file.
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC spsvc_GetInquiryFile

***********************************************************************/

CREATE PROCEDURE [dbo].[spsvc_GetInquiryFile] AS


		SELECT DISTINCT
				OUT.[Phone]
			,	OUT.[LastContactDate]
		FROM   [DNC_OUT] OUT
				RIGHT JOIN [dnc_staging] d
					ON d.[Phone] = OUT.[Phone]
		WHERE   OUT.[DNC] = 0
				AND OUT.[LastSaleDate] IS NULL
		ORDER BY OUT.[Phone]
GO
