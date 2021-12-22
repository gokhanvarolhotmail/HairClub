/* CreateDate: 08/01/2014 15:40:32.740 , ModifyDate: 02/27/2020 07:44:09.690 */
GO
/***********************************************************************
FUNCTION:				GetClientMembershipRanking
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_DeferredRevenue
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		5/29/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT [dbo].[GetClientMembershipRanking] (340391, '283-1310-105716-02')
***********************************************************************/
CREATE FUNCTION [dbo].[GetClientMembershipRanking]
(
	@ClientKey INT,
	@ClientMembershipIdentifier NVARCHAR(50)
)
RETURNS INT
AS
BEGIN

DECLARE @ClientMembershipRanking INT


DECLARE @tempTable TABLE (
	ClientMembershipRanking INT
,	ClientMembershipIdentifier NVARCHAR(50)
,	ClientMembershipKey INT
,	MembershipKey INT
)

INSERT  @tempTable
		SELECT  ROW_NUMBER() OVER(ORDER BY ClientMembershipBeginDate ASC) AS 'ClientMembershipRanking'
		,		DCM.ClientMembershipIdentifier
		,       DCM.ClientMembershipKey
		,       DCM.MembershipKey
		FROM    HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
		WHERE   DCM.ClientKey = @ClientKey
		ORDER BY DCM.ClientMembershipBeginDate


SELECT  @ClientMembershipRanking = ClientMembershipRanking
FROM    @tempTable T
WHERE   T.ClientMembershipIdentifier = @ClientMembershipIdentifier


RETURN @ClientMembershipRanking

END
GO
