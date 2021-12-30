/* CreateDate: 12/21/2018 15:56:08.377 , ModifyDate: 04/12/2020 22:02:41.640 */
GO
/***********************************************************************

PROCEDURE:				mtnSetNationalMonthlyFeeOnClientMemberships

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				James Lee

IMPLEMENTOR: 			James Lee

DATE IMPLEMENTED: 		12/19/2018

LAST REVISION DATE: 	12/19/2018

--------------------------------------------------------------------------------------------------------
NOTES:  Sets Client Memberships' National Monthly Fee if not already set

		* 12/19/2018	JL	Created (TFS #11780)
		* 06/18/2019	SL	Updated to use EFTTermMonths in place of DurationMonths when calculating
								NationalMonthlyFee (TFS #12673)
		* 03/04/2020	MT	Modified to no longer consider previous Client Membership when setting National Price (TFS #14134)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC mtnSetNationalMonthlyFeeOnClientMemberships

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnSetNationalMonthlyFeeOnClientMemberships]
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY

	--**********************
	--Update Renewals
	--**********************
	--SELECT ISNULL(o_np.NationalMonthlyFee, CASE WHEN c.genderid = 1 AND ISNULL(m.DurationMonths, '') =  '' THEN ROUND(centm.ContractPriceMale/12, 2)
	--											WHEN c.genderid = 1 AND ISNULL(m.DurationMonths, '') <> '' THEN ROUND(centm.ContractPriceMale/m.DurationMonths, 2)
	--											WHEN c.genderid = 2 AND ISNULL(m.DurationMonths, '') =  '' THEN ROUND(centm.ContractPriceFeMale/12, 2)
	--											WHEN c.genderid = 2 AND ISNULL(m.DurationMonths, '') <> '' THEN ROUND(centm.ContractPriceFeMale/m.DurationMonths, 2) END)
	--UPDATE cm
	--SET nationalmonthlyfee = ISNULL(o_np.NationalMonthlyFee, CASE WHEN c.genderid = 1 AND ISNULL(m.DurationMonths, '') =  '' THEN ROUND(centm.ContractPriceMale/12, 2)
	--															  WHEN c.genderid = 1 AND ISNULL(m.DurationMonths, '') <> '' THEN ROUND(centm.ContractPriceMale/m.DurationMonths, 2)
	--															  WHEN c.genderid = 2 AND ISNULL(m.DurationMonths, '') =  '' THEN ROUND(centm.ContractPriceFeMale/12, 2)
	--															  WHEN c.genderid = 2 AND ISNULL(m.DurationMonths, '') <> '' THEN ROUND(centm.ContractPriceFeMale/m.DurationMonths, 2) END)
	----UPDATE cm
	----SET nationalmonthlyfee = ISNULL(o_np.NationalMonthlyFee, CASE WHEN c.genderid = 1 AND ISNULL(cmem.EFTTermMonths, '') =  '' THEN ROUND(centm.ContractPriceMale/12, 2)
	----															  WHEN c.genderid = 1 AND ISNULL(cmem.EFTTermMonths, '') <> '' THEN ROUND(centm.ContractPriceMale/cmem.EFTTermMonths, 2)
	----															  WHEN c.genderid = 2 AND ISNULL(cmem.EFTTermMonths, '') =  '' THEN ROUND(centm.ContractPriceFeMale/12, 2)
	----															  WHEN c.genderid = 2 AND ISNULL(cmem.EFTTermMonths, '') <> '' THEN ROUND(centm.ContractPriceFeMale/cmem.EFTTermMonths, 2) END)
	----    , LastUpdate = GETUTCDATE()
	----	, LastUpdateUser = 'Nightly_SetNtlMthlyFee'
	----FROM datClient c
	----	INNER JOIN dbo.cfgCenter ctr ON ctr.CenterID = c.CenterID
	----	INNER JOIN cfgConfigurationCenter cc ON cc.CenterID = ctr.CenterID
	----	INNER join datClientMembership cm ON cm.ClientGUID = c.ClientGUID
	----	INNER JOIN cfgMembership m on m.Membershipid = cm.Membershipid
	----	INNER JOIN cfgCenterMembership centM ON centM.CenterID = c.CenterID AND centM.MembershipId = m.MembershipID
	----	INNER JOIN cfgConfigurationMembership cmem ON m.MembershipID = cmem.MembershipID
	----OUTER APPLY (
	----	   SELECT prevCM.NationalMonthlyFee
	----	   FROM datSalesOrder so
	----			  INNER JOIN datSalesOrderDetail sod ON sod.Salesorderguid = so.SalesOrderguid
	----			  INNER JOIN cfgSalesCode sc ON sc.Salescodeid = sod.SalesCodeID
	----			  INNER JOIN datClientMembership prevCM on prevCM.ClientMembershipGUID = sod.PreviousClientMembershipGUID
	----	   WHERE so.ClientMembershipGUID = cm.ClientMEmbershipGUID
	----	   ) o_np
	----WHERE cm.ClientMembershipStatusID = 1 AND
	----	cm.IsRenewalFlag = 1 AND
	----	cmem.IsEFTEnabledFlag = 1 AND
	----	cc.IncludeInNationalPricingRenewal = 1  AND
	----	centM.IsActiveFlag = 1 AND
	----	ISNULL(cm.nationalmonthlyfee, '') = ''  AND
	----	ISNULL(o_np.NationalMonthlyFee, CASE WHEN c.GenderID = 1 THEN centM.ContractPriceMale WHEN c.GenderID = 2 THEN centM.ContractPriceFemale end) > 0

	--**********************
	--Update Non-Renewals (Modified to update both Renewals and non-renewals using same logic)
	--**********************
	--SELECT CASE WHEN c.genderid = 1 AND ISNULL(m.DurationMonths, '') =  '' THEN ROUND(centm.ContractPriceMale/12, 2)
	--			WHEN c.genderid = 1 AND ISNULL(m.DurationMonths, '') <> '' THEN ROUND(centm.ContractPriceMale/m.DurationMonths, 2)
	--			WHEN c.genderid = 2 AND ISNULL(m.DurationMonths, '') =  '' THEN ROUND(centm.ContractPriceFeMale/12, 2)
	--			WHEN c.genderid = 2 AND ISNULL(m.DurationMonths, '') <> '' THEN ROUND(centm.ContractPriceFeMale/m.DurationMonths, 2) END
	--UPDATE cm
	--SET nationalmonthlyfee = CASE WHEN c.genderid = 1 AND ISNULL(m.DurationMonths, '') =  '' THEN ROUND(centm.ContractPriceMale/12, 2)
	--							  WHEN c.genderid = 1 AND ISNULL(m.DurationMonths, '') <> '' THEN ROUND(centm.ContractPriceMale/m.DurationMonths, 2)
	--							  WHEN c.genderid = 2 AND ISNULL(m.DurationMonths, '') =  '' THEN ROUND(centm.ContractPriceFeMale/12, 2)
	--							  WHEN c.genderid = 2 AND ISNULL(m.DurationMonths, '') <> '' THEN ROUND(centm.ContractPriceFeMale/m.DurationMonths, 2) END
	UPDATE cm
	SET nationalmonthlyfee = CASE WHEN c.genderid = 1 AND ISNULL(cmem.EFTTermMonths, '') =  '' THEN ROUND(centm.ContractPriceMale/12, 2)
								  WHEN c.genderid = 1 AND ISNULL(cmem.EFTTermMonths, '') <> '' THEN ROUND(centm.ContractPriceMale/cmem.EFTTermMonths, 2)
								  WHEN c.genderid = 2 AND ISNULL(cmem.EFTTermMonths, '') =  '' THEN ROUND(centm.ContractPriceFeMale/12, 2)
								  WHEN c.genderid = 2 AND ISNULL(cmem.EFTTermMonths, '') <> '' THEN ROUND(centm.ContractPriceFeMale/cmem.EFTTermMonths, 2) END
	    , LastUpdate = GETUTCDATE()
		, LastUpdateUser = 'Nightly_SetNtlMthlyFee'
	FROM datClient c
		INNER JOIN dbo.cfgCenter ctr ON ctr.CenterID = c.CenterID
		INNER JOIN cfgConfigurationCenter cc ON cc.CenterID = ctr.CenterID
		INNER join datClientMembership cm ON cm.ClientGUID = c.ClientGUID
		INNER JOIN cfgMembership m on m.Membershipid = cm.Membershipid
		INNER JOIN cfgCenterMembership centM ON centM.CenterID = c.CenterID AND centM.MembershipId = m.MembershipID
		INNER JOIN cfgConfigurationMembership cmem ON m.MembershipID = cmem.MembershipID
	WHERE cm.ClientMembershipStatusID = 1 AND
		--cm.IsRenewalFlag = 0 AND
		cmem.IsEFTEnabledFlag = 1 AND
		cc.IncludeInNationalPricingRenewal = 1  AND
		centM.IsActiveFlag = 1 AND
		ISNULL(cm.nationalmonthlyfee, '') = ''

  END TRY
  BEGIN CATCH
	ROLLBACK TRANSACTION

	DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
  END CATCH

END
GO
