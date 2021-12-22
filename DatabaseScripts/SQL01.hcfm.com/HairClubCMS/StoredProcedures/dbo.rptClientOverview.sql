/****** Object:  StoredProcedure [dbo].[rptClientOverview]    Script Date: 12/11/2013 9:40:56 AM ******/


/*===============================================================================================
-- Procedure Name:              rptClientOverview
-- Procedure Description:
--
-- Created By:                  Hdu
-- Date Created:				11/15/2012
================================================================================================
**NOTES**
Not to be confused with the rptAppointment this one is for the stylist appointment printout.

11/22/2013	RMH		Added fields - tp.TechnicalProfileDate and hs.HairSystemDescription (WO#94068).
11/26/2013	RMH		Added ISNULL(CAST(tp.LastTemplateDate AS DATE),CAST(tp.TechnicalProfileDate AS DATE)) AS LastTemplateDate.
12/02/2013	RMH		Edited the function [fn_GetClientAccumLastUsedDate] to find the maximium Accumulator Date for all memberships.
12/06/2013	RMH		Added hs.HairSystemDescriptionShort AS 'SystemType'and SP.ScalpPreparationDescription AS 'ScalpPreparation'.
12/11/2013	RMH		Added variable @ScalpPreparationDescriptions to find a comma-separated list of Scalp Preparations.
06/17/2014	RMH		Added ds.DeveloperSizeDescription and dv.DeveloperVolumeDescription
02/04/2015	RMH		Added CurrentXtrandsClientMembershipGUID to the ClientMembershipGUID logic
02/07/2017  RMH		Removed the Technical Profile information (#134857)
04/02/2019  RMH		Added two temp tables; Added AddOnMonthlyFee [7715]
================================================================================================
Sample Execution:
EXEC rptClientOverview 'D7321219-FCA6-468E-8DB9-C54AB9541084'  --Ruehl, Judi (339641)
EXEC rptClientOverview 'A41571A8-7CED-4753-B26E-F2999630AC9A'  --ZIMMERMAN, JACK (614545) Hans Wiemann (355)
================================================================================================*/

CREATE PROCEDURE [dbo].[rptClientOverview]
	@ClientGUID UNIQUEIDENTIFIER
AS
BEGIN

/************* Create temp tables ***************************************************************/

CREATE TABLE #EFT(
			ClientGUID NVARCHAR(50)
		,	ClientFullNameCalc NVARCHAR(150)
		,	CenterDescriptionFullCalc NVARCHAR(50)
		,	MembershipID INT
		,	MembershipDescription NVARCHAR(50)
		,	RenewalDate DATETIME
		,	EFTAccountTypeDescription NVARCHAR(50)
		,	FeePayCycleDescription NVARCHAR(50)
		,	MonthlyFee DECIMAL(18,4)
		,	ContractPrice DECIMAL(18,4)
		,	AR DECIMAL(18,4)

		,	HairSystemTotal INT
		,	HairSystemUsed INT
		,	HairSystemRemaining INT
		,	HairSystemDate DATETIME

		,	ServicesTotal INT
		,	ServicesUsed INT
		,	ServicesRemaining  INT
		,	ServicesDate DATETIME

		,	SolutionsTotal INT
		,	SolutionsUsed INT
		,	SolutionsRemaining INT
		,	SolutionsDate DATETIME

		,	ProdKitTotal INT
		,	ProdKitUsed INT
		,	ProdKitRemaining INT
		,	ProdKitDate DATETIME
		,	AddOnMonthlyFee  DECIMAL(18,4)
)

 CREATE TABLE #AddOn(
			ClientIdentifier INT
		,	ClientFullNameCalc  NVARCHAR(150)
		,	ClientGUID  NVARCHAR(50)
		,	AddOnMonthlyFee DECIMAL(18,4)
 )


/***************************Main Select Statement******************************************************************/
INSERT INTO #EFT
SELECT
	cl.ClientGUID
	,	cl.ClientFullNameCalc
	,	ce.CenterDescriptionFullCalc
	,	m.MembershipID
	,	m.MembershipDescription
	,	cm.EndDate RenewalDate

	,	eftat.EFTAccountTypeDescription
	,	pc.FeePayCycleDescription
	,	cm.MonthlyFee
	,	cm.ContractPrice
	,	ar.AccumMoney AR

	,	ahs.TotalAccumQuantity HairSystemTotal
	,	ahs.UsedAccumQuantity HairSystemUsed
	,	ahs.AccumQuantityRemainingCalc HairSystemRemaining
	,	dbo.[fn_GetClientAccumLastUsedDate](cl.ClientGUID, 13)   HairSystemDate

	,	asv.TotalAccumQuantity ServicesTotal
	,	asv.UsedAccumQuantity ServicesUsed
	,	asv.AccumQuantityRemainingCalc ServicesRemaining
	,	dbo.[fn_GetClientAccumLastUsedDate](cl.ClientGUID, 16)  ServicesDate

	,	asl.TotalAccumQuantity SolutionsTotal
	,	asl.UsedAccumQuantity SolutionsUsed
	,	asl.AccumQuantityRemainingCalc SolutionsRemaining
	,	dbo.[fn_GetClientAccumLastUsedDate](cl.ClientGUID, 36)  SolutionsDate

	,	apk.TotalAccumQuantity ProdKitTotal
	,	apk.UsedAccumQuantity ProdKitUsed
	,	apk.AccumQuantityRemainingCalc ProdKitRemaining
	,	dbo.[fn_GetClientAccumLastUsedDate](cl.ClientGUID, 37)  ProdKitDate

	,	NULL AS AddOnMonthlyFee
FROM datClient cl
	INNER JOIN cfgCenter ce
		ON ce.CenterID = cl.CenterID
	LEFT JOIN datClientEFT ceft
		ON ceft.ClientGUID = cl.ClientGUID
	LEFT JOIN lkpFeePayCycle pc
		ON pc.FeePayCycleID = ceft.FeePayCycleID
	LEFT JOIN lkpEFTAccountType eftat
		ON eftat.EFTAccountTypeID = ceft.EFTAccountTypeID
	INNER JOIN datClientMembership cm
		ON cm.ClientMembershipGUID = COALESCE(cl.CurrentBioMatrixClientMembershipGUID,cl.CurrentSurgeryClientMembershipGUID,cl.CurrentExtremeTherapyClientMembershipGUID,cl.CurrentXtrandsClientMembershipGUID)
	INNER JOIN cfgMembership m
		ON m.MembershipID = cm.MembershipID
	--Accumulators!
	LEFT JOIN datClientMembershipAccum ahs
		ON ahs.ClientMembershipGUID = cm.ClientMembershipGUID AND ahs.AccumulatorID = 8 --Hair Systems
	LEFT JOIN datClientMembershipAccum asv
		ON asv.ClientMembershipGUID = cm.ClientMembershipGUID AND asv.AccumulatorID = 9 --Services
	LEFT JOIN datClientMembershipAccum asl
		ON asl.ClientMembershipGUID = cm.ClientMembershipGUID AND asl.AccumulatorID = 10 --Solutions
	LEFT JOIN datClientMembershipAccum apk
		ON apk.ClientMembershipGUID = cm.ClientMembershipGUID AND apk.AccumulatorID = 11 --Product Kits
	LEFT JOIN datClientMembershipAccum ar
		ON ar.ClientMembershipGUID = cm.ClientMembershipGUID AND ar.AccumulatorID = 3 --A/R Balance
WHERE cl.ClientGUID = @ClientGUID

/********************** Populate #AddOn where there is an AddOn monthly fee *************************/

INSERT INTO #AddOn
SELECT	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	CLT.ClientGUID
,   SUM(ISNULL(CMA.MonthlyFee,0)) AS AddOnMonthlyFee
FROM dbo.datClientMembershipAddOn CMA
INNER JOIN dbo.cfgAddOn ADDON
	ON ADDON.AddOnID = CMA.AddOnID
INNER JOIN dbo.datClientMembership CM
	ON CM.ClientMembershipGUID = CMA.ClientMembershipGUID
INNER JOIN dbo.datClient CLT
	ON CLT.ClientGUID = CM.ClientGUID
INNER JOIN dbo.lkpAddOnType AOT
	ON AOT.AddOnTypeID = ADDON.AddOnTypeID
WHERE  CMA.ClientMembershipAddOnStatusID = 1 --Active
AND CMA.MonthlyFee IS NOT NULL
AND CLT.ClientGUID = @ClientGUID
AND AOT.IsMonthlyAddOnType = 1
GROUP BY CM.CenterID
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	CLT.ClientGUID

/********************** Update #EFT with the AddOn monthly fee  *************************************/

UPDATE #EFT
SET #EFT.AddOnMonthlyFee =  #AddOn.AddOnMonthlyFee
FROM #AddOn
WHERE #EFT.AddOnMonthlyFee IS NULL

--Final select

SELECT * FROM #EFT





END
