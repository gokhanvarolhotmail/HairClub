/* CreateDate: 03/20/2009 14:12:53.933 , ModifyDate: 05/01/2010 14:48:09.927 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:		spsvc_DNC_Get_Inquiry_File

DESTINATION SERVER:	hcsql3\sql2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	DNC Processing

AUTHOR: 		OnContact PSO Fred Remers

IMPLEMENTOR: 		Fred Remers

DATE IMPLEMENTED:

LAST REVISION DATE:

------------------------------------------------------------------------
NOTES: 	Gets the data to create the inquiry file.
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC spsvc_DNC_Get_Inquiry_File

***********************************************************************/

CREATE PROCEDURE [dbo].[spsvc_DNC_Get_Inquiry_File] AS


		SELECT DISTINCT
				OUT.phone
			,	OUT.LastContactDate
		FROM   cstd_dnc_out OUT
				RIGHT JOIN cstd_dnc_staging d
					ON d.Phone = OUT.Phone
		WHERE   OUT.DNC = 0
				AND OUT.LastSaleDate IS NULL
		ORDER BY OUT.Phone
GO
