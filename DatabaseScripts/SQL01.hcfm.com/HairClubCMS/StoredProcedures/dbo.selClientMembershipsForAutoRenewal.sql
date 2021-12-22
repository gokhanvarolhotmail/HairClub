/***********************************************************************

PROCEDURE:				selClientMembershipsForAutoRenewal

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		07/25/2017

LAST REVISION DATE: 	07/25/2017

--------------------------------------------------------------------------------------------------------
NOTES:  Selects the list of client memberships that qualify for auto-renewal
		The job (D_0150_ClientMembershipAutoRenewal) that runs the SSIS package that executes this stored
		proc is run daily at 1:50AM

		The SSIS package sends the Membership Service the following which get passed to this SP:
			DateTime.Now.Date for the @EndDateLowerLimit parameter and
			DateTime.Now.AddDays(+1).Date for the @EndDateUpperLimit

		* 07/25/2017	SAL	Created
		* 06/18/2018	SAL	Updated to return clients whose memberships expire the day priot to the date
								range passed in to the proc. (TFS #11009)
		* 07/25/2018	SAL Updated to return clients whose memberships expire during the date range passed
								in to the proc (reversing the change put in on 06/18/18) (TFS #11162)

		* 01/15/2019	JLM	Updated to return the 'IncludeInNationalPricingRenewal' flag from the client memberships
								center (TFS #11861)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

selClientMembershipsForAutoRenewal '07/25/2017 12:00:00 AM','07/26/2017 12:00:00 AM'

***********************************************************************/

CREATE PROCEDURE [dbo].[selClientMembershipsForAutoRenewal]
	@EndDateLowerLimit datetime,
	@EndDateUpperLimit datetime
AS
BEGIN
  SET NOCOUNT ON
	--Set the end date lower and upper limits to the prior day
	--SELECT @EndDateLowerLimit = DATEADD(day, -1, @EndDateLowerLimit)
	--SELECT @EndDateUpperLimit = DATEADD(day, -1, @EndDateUpperLimit)

  	;WITH

	AutoRenewRules as
		(SELECT mr.CurrentMembershipID, mr.CenterBusinessTypeID
		FROM cfgMembershipRule mr
				inner join lkpMembershipRuleType rt on mr.MembershipRuleTypeID = rt.MembershipRuleTypeID
		WHERE mr.IsActiveFlag = 1
			and rt.MembershipRuleTypeDescriptionShort = 'RenewAuto')

	SELECT cm.ClientMembershipGUID as ClientMembershipGUID,
		   cc.IncludeInNationalPricingRenewal as IncludeInNationalPricingRenewal
	FROM datClientMembership cm
		inner join lkpClientMembershipStatus cms on cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
		inner join datClient cl on cm.ClientGUID = cl.ClientGUID
		inner join cfgConfigurationCenter cc on cl.CenterID = cc.CenterID
		inner join cfgMembership m on cm.MembershipID = m.MembershipID
		inner join lkpRevenueGroup rg on m.RevenueGroupID = rg.RevenueGroupID
		inner join AutoRenewRules rr on (m.MembershipID = rr.CurrentMembershipID and cc.CenterBusinessTypeID = rr.CenterBusinessTypeID)
	WHERE (cm.EndDate >= @EndDateLowerLimit and cm.EndDate < @EndDateUpperLimit)
		and cl.IsAutoRenewDisabled = 0
		and cms.ClientMembershipStatusDescriptionShort = 'A'
		and rg.RevenueGroupDescriptionShort = 'PCP'


	--;with

	--AutoRenewEnabledCenters as
	--	(select cc.CenterID
	--	from cfgConfigurationCenter cc
	--		inner join lkpCenterBusinessType cbt on cc.CenterBusinessTypeID = cbt.CenterBusinessTypeID
	--	where cbt.IsAutoRenewEnabled = 1),

	--AutoRenewEnabledRenewRules as
	--	(select mr.CurrentMembershipID, cbt.CenterBusinessTypeID
	--	from cfgMembershipRule mr
	--			inner join lkpMembershipRuleType rt on mr.MembershipruletypeId = rt.MembershipRuleTypeID
	--			left join cfgMembership cm ON cm.MembershipID = mr.CurrentMembershipID
	--			inner join lkpCenterBusinessType cbt on mr.CenterBusinessTypeID = cbt.CenterBusinessTypeID
	--	where mr.IsActiveFlag = 1
	--		and rt.MembershipRuleTypeDescriptionShort = 'Renew'
	--		and mr.CenterBusinessTypeID in (select CenterBusinessTypeID
	--										from lkpCenterBusinessType
	--										where IsAutoRenewEnabled = 1))

	--select cm.ClientMembershipGUID
	--from datClientMembership cm
	--	inner join lkpClientMembershipStatus cms on cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
	--	inner join datClient cl on cm.ClientGUID = cl.ClientGUID
	--	inner join cfgConfigurationCenter cc on cl.CenterID = cc.CenterID
	--	inner join lkpCenterBusinessType cbt on cc.CenterBusinessTypeID = cbt.CenterBusinessTypeID
	--	inner join cfgMembership m on cm.MembershipID = m.MembershipID
	--	inner join cfgConfigurationMembership cfm on m.MembershipID = cfm.MembershipID
	--	inner join lkpRevenueGroup rg on m.RevenueGroupID = rg.RevenueGroupID
	--	inner join AutoRenewEnabledCenters ec on cl.CenterID = ec.CenterID
	--	inner join AutoRenewEnabledRenewRules rr on (m.MembershipID = rr.CurrentMembershipID and cc.CenterBusinessTypeID = rr.CenterBusinessTypeID)
	--where (cm.EndDate >= @EndDateLowerLimit and cm.EndDate <= @EndDateUpperLimit)
	--	and cfm.IsAutoRenewDisabled = 0
	--	and cl.IsAutoRenewDisabled = 0
	--	and cms.ClientMembershipStatusDescriptionShort = 'A'
	--	and rg.RevenueGroupDescriptionShort = 'PCP'
END
