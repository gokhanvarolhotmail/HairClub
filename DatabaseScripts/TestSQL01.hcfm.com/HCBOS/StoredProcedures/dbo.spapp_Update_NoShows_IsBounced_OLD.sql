/* CreateDate: 09/19/2006 13:24:56.827 , ModifyDate: 01/25/2010 08:11:31.807 */
GO
CREATE   PROCEDURE  [dbo].[spapp_Update_NoShows_IsBounced_OLD]

AS

/*

**  Update the noshows with the flag that specifies a .

**  bounced email for the NS1 campaign email that was sent

** Revision History:

** ------------------------------------------------------------------

**  Date       Name      Description     	Project

** ------------------------------------------------------------------

**  09/19/06  HABELOW   CREATE     		No Show Emails


*/



SET NOCOUNT ON

UPDATE  dbo.noshowsdaily

SET  isBounced = 1

FROM  dbo.NoShowsBounced nsb

	INNER JOIN  dbo.noshowsdaily nsd

	ON nsb.recordid = nsd.recordid
GO
