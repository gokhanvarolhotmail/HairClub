/***********************************************************************
FUNCTION:				GetClientMembershipRanking
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
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
		SELECT  ROW_NUMBER() OVER(ORDER BY ClientMembershipEndDate, DCM.ClientMembershipBeginDate ASC) AS 'ClientMembershipRanking'
		,		DCM.ClientMembershipIdentifier
		,       DCM.ClientMembershipKey
		,       DCM.MembershipKey
		--,		DCM.ClientMembershipBeginDate
		--,		DCM.ClientMembershipEndDate
		FROM    HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
					ON CLT.ClientKey = DCM.ClientKey
		WHERE   CLT.ClientKey = @ClientKey
		ORDER BY DCM.ClientMembershipEndDate
		,		DCM.ClientMembershipBeginDate


SELECT  @ClientMembershipRanking = ClientMembershipRanking
FROM    @tempTable T
WHERE   T.ClientMembershipIdentifier = @ClientMembershipIdentifier


RETURN @ClientMembershipRanking

END
