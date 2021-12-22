/* CreateDate: 09/19/2006 10:42:59.610 , ModifyDate: 01/25/2010 08:11:31.807 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE  [dbo].[spapp_Update_NoShows_SentEmails]

AS

/*

**  Update the noshows with the flag that specifies a NS1 campaign email was sent.

**  after the no show

** Revision History:

** ------------------------------------------------------------------

**  Date       Name      Description     	Project

** ------------------------------------------------------------------

**  09/19/06  HABELOW   CREATE     		No Show Emails

**  08/02/07  MWEGNER(ONC) Retrofit for ONCV

*/



SET NOCOUNT ON


UPDATE dbo.noshowsdaily

SET SentEmail = 1

FROM hcm.dbo.EmailConfirm ec

	INNER JOIN bos.dbo.noshowsdaily nsd ON

	ec.contact_id = nsd.contact_id

	AND nsd.NoShowDate = cast(ec.mergefield02 as datetime)

	AND ec.mergefield08 = 'NS1'

WHERE nsd.HasEmail = 1
GO
