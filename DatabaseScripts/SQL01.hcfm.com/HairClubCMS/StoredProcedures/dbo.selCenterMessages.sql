/***********************************************************************

PROCEDURE:				selCenterMessages

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		8/6/09

LAST REVISION DATE: 	08/16/2019

--------------------------------------------------------------------------------------------------------
NOTES: 	Queries data for Center specific rules and reports back information/warnings

		03/07/2010 prm - added notification for non-retail clients with AR balances
		03/19/2010 prm - added notifications for Inventory Requests
		11/04/2010 prm - added Hair System Hold logic
		12/10/2010 prm - don't show AR credit Notifications in non-surgery
		12/10/2010 prm - Don't limit hold to sample/manual or center 100
		12/15/2010 prm - added variables at beginning of query to determine if current center is
							is corp headquarter & surgery center and use that in all queries after
		04/25/2011 mvt - modified the notification for 'Inventory Transfer Request (show in From Center when requested)'
							to also include a center description of the requesting center.
		05/24/2011 mvt - modified to use transaction date that the order went on hold for the record date
							of the Hold notifications.
		03/06/2012 mvt - added static notifications from datNotification table
		04/26/2012 mlm - added FeeDate is results
		05/14/2012 mvt - added a parameter that detrmines if Fee notifications should be included
		09/24/2013 mlm - Client Notification were returning multiple message due to Client Membership Join
		11/13/2013 mlm - Added Logic to handle new Service Request Notifications.
		11/14/2013 mvt - Added Logic for the inactive fee profile notifications.
		01/02/2014 mvt - Added logic to ignore 'Abandoned' transfers.
		01/07/2014 mvt - added separate notification for repair orders that have a charge decision.
		04/10/2014 mlm - Added Notification for Visiting Center for 'Pending Service Authorization Requests'
		04/10/2014 mlm - Added Notification for Pending Priority Hair Requests, that have not been approved/denied
		02/27/2015 sal - Added new Xtrands Business Segment (datClient.CurrentXtrandsClientMembershipGUID)
		03/05/2015 mvt - Modified query to include Xtrands Business Segment for the:
							-Non retail clients with an AR Credit
							-Non retail clients with an AR Balance
		12/01/2016 mvt - Added Web Appointments notifications.
		09/11/2017 sal - Updated to return CenterDescriptionFullCalc in place of CenterID in the CenterMessageDescription for:
							Inventory Transfer Request Messages
							Pending Service Authorization Requests
							Pending Inventory Transfer Request
						 Removed 'Client:' prefix from all selects 'AS ReferenceTo'
		12/14/2017 sal - Updated WHERE clause for Monthly Fees to only return notifications where the NotificationDate >= Today
							and removed some CASE statements that will never get hit because a WHERE clause limitation was added
							and the CASE was never updated.	(TFS#10034)
		12/22/2017 sal - Put back in the CASE statements I removed on 12/14/2017.  Found that they were in fact needed! (TFS#10062)
		03/19/2018 sal - Remove 'Web Appointments' messages (TFS #10365)
		08/15/2018 jcl - added web appointment - Hair Fit (TFS #11200)
		09/24/2018 sal - Updated to return Hair Fit Appointment notifications for appointments with a NULL appointment
							status.  Also made Appointment Type a variable based on the Short Description. (TFS #11381)
		08/16/2019 JLM - Updated to look at CurrentMDPClientMembershipGUID business segment. (TFS 12847)


--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

selCenterMessages 292, '9D815C72-8FEE-4680-8570-000A01E5784E', 1

***********************************************************************/
CREATE PROCEDURE [dbo].[selCenterMessages]
	@CenterID int,
	@EmployeeGUID uniqueidentifier,
	@IncludeFeesNotifications bit
AS
BEGIN
	DECLARE @HairOrderCreditDays int = 5
	DECLARE @OrderOtherCenterDays int = 3
	DECLARE @OutstandingSurBalanceDays int = 14
	DECLARE @InventoryTransferRequestStatus_Requested nvarchar(10) = 'Requested'
	DECLARE @InventoryTransferRequestStatus_Rejected nvarchar(10) = 'Rejected'
	DECLARE @InventoryTransferRequestStatus_Accepted nvarchar(10) = 'Accepted'
	DECLARE @InventoryTransferRequestStatus_Shipped nvarchar(10) = 'Shipped'
	DECLARE @InventoryTransferRequestStatus_Completed nvarchar(10) = 'Completed'
	DECLARE @HairSystemOrderStatus_HQHold nvarchar(10) = 'HQ-Hold'
	DECLARE @RetailMembershipID int
	SELECT @RetailMembershipID = MembershipID FROM cfgMembership WHERE MembershipDescriptionShort = 'SHOWSALE'

	DECLARE @AppointmentTypeID_HairFit int
	SELECT @AppointmentTypeID_HairFit = AppointmentTypeID FROM lkpAppointmentType WHERE AppointmentTypeDescriptionShort = 'HairFit'

	DECLARE @IsCorpHeadQuarters bit
	SELECT @IsCorpHeadQuarters = ISNULL(IsCorporateHeadquartersFlag,0) FROM cfgCenter WHERE CenterID = @CenterID

	DECLARE @IsSurgeryCenter bit = 0
	--SELECT @IsSurgeryCenter = CASE WHEN EmployeeDoctorGUID IS NOT NULL THEN 1 ELSE 0 END FROM cfgCenter WHERE CenterID = @CenterID

	DECLARE @CenterBusinessTypeDescriptionShort nvarchar(10)
	SELECT @CenterBusinessTypeDescriptionShort = bt.CenterBusinessTypeDescriptionShort
		FROM cfgConfigurationCenter config
			INNER JOIN lkpCenterBusinessType bt ON bt.CenterBusinessTypeID = config.CenterBusinessTypeID
	WHERE config.CenterID = @CenterID

	IF @CenterBusinessTypeDescriptionShort = 'Surgery'
		SET @IsSurgeryCenter = 1

(
	--Appointments for center's clients in other centers today
	SELECT c.ClientFullNameCalc AS ReferenceTo, cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, NULL AS RecordGUID,
		2 AS SortOrder, 'Appointment at other center' AS CenterMessageDescriptionShort, a.AppointmentDate AS RecordDate,
		ISNULL(c.ClientFullNameAlt3Calc,'') + ' is scheduled for an appointment in the ' + ISNULL(CenterDescriptionFullAlt1Calc,'') + ' today.' AS CenterMessageDescription,
		NULL AS NotificationID, NULL as FeeDate
	FROM datClientMembership cm
		INNER JOIN datClient c ON cm.ClientGUID = c.ClientGUID
		INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID

		INNER JOIN datAppointment a ON cm.ClientMembershipGUID = a.ClientMembershipGUID
		INNER JOIN cfgCenter apptctr ON a.CenterID = apptctr.CenterID
	WHERE @IsCorpHeadQuarters = 0 AND @IsSurgeryCenter = 1
		AND cm.CenterID = @CenterID
		AND (
			a.AppointmentDate = CAST(GETDATE() as DATE)
			AND a.CenterID <> cm.CenterID
		)
		AND (a.IsDeletedFlag IS NULL OR a.IsDeletedFlag = 0)
)
UNION (
	--Orders for center's clients in other centers over the past @OrderOtherCenterDays (3) days
	SELECT c.ClientFullNameCalc AS ReferenceTo, cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, NULL AS RecordGUID,
		3 AS SortOrder, 'Recent orders at other center' AS CenterMessageDescriptionShort, so.OrderDate AS RecordDate,
		ISNULL(c.ClientFullNameAlt3Calc,'') + ' has completed an order in the ' + ISNULL(apptctr.CenterDescriptionFullAlt1Calc,'') + ' within the past ' + CAST(@OrderOtherCenterDays AS varchar) + ' days.' AS CenterMessageDescription,
		NULL AS NotificationID, NULL as FeeDate
	FROM datClientMembership cm
		INNER JOIN datClient c ON cm.ClientGUID = c.ClientGUID
		INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID

		INNER JOIN datSalesOrder so ON cm.ClientMembershipGUID = so.ClientMembershipGUID
		INNER JOIN cfgCenter apptctr ON so.CenterID = apptctr.CenterID
	WHERE @IsCorpHeadQuarters = 0 AND @IsSurgeryCenter = 1
		AND cm.CenterID = @CenterID
		AND (
			so.OrderDate >= CAST(DATEADD(d,-1 * @OrderOtherCenterDays,GETDATE()) as DATE)
			AND so.CenterID <> cm.CenterID
			AND so.IsClosedFlag = 1 AND so.IsVoidedFlag = 0
		)
)
UNION (
	--Surgery Appointments scheduled in the next @OutstandingSurBalanceDays (14) days where the client has an outstanding contract balance
	SELECT c.ClientFullNameCalc AS ReferenceTo, cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, NULL AS RecordGUID,
		1 AS SortOrder, 'Outstanding Contract Balance' AS CenterMessageDescriptionShort, a.AppointmentDate AS RecordDate,
		ISNULL(c.ClientFullNameAlt3Calc,'') + ' has a balance of $' + CONVERT(varchar, (ISNULL(cm.ContractPrice,0) - ISNULL(cm.ContractPaidAmount,0)), 1) + ' and is scheduled for for surgery within the next ' + CAST(@OutstandingSurBalanceDays AS varchar) + ' days. (' + CONVERT(varchar, a.AppointmentDate, 1) + ')' AS CenterMessageDescription,
		NULL AS NotificationID, NULL as FeeDate
	FROM datClientMembership cm
		INNER JOIN datClient c ON cm.ClientGUID = c.ClientGUID
		INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID

		INNER JOIN datAppointment a ON cm.ClientMembershipGUID = a.ClientMembershipGUID
		INNER JOIN datAppointmentDetail ad ON a.AppointmentGUID = ad.AppointmentGUID
		INNER JOIN cfgSalesCode sc ON ad.SalesCodeID = sc.SalesCodeID
		INNER JOIN cfgCenter apptctr ON a.CenterID = apptctr.CenterID
	WHERE @IsCorpHeadQuarters = 0 AND @IsSurgeryCenter = 1
		AND cm.CenterID = @CenterID
		AND (
			a.AppointmentDate <= CAST(DATEADD(d,@OutstandingSurBalanceDays,GETDATE()) as DATE)
			AND a.CheckoutTime IS NULL
			AND (ISNULL(cm.ContractPrice,0) - ISNULL(cm.ContractPaidAmount,0)) > 0
			AND sc.SalesCodeDescriptionShort = 'SURPOST'
		)
		AND (a.IsDeletedFlag IS NULL OR a.IsDeletedFlag = 0)
)
UNION
(
	--Non retail clients with an AR balance
		SELECT c.ClientFullNameCalc AS ReferenceTo,
		CASE WHEN cmBIO.IsActiveFlag = 1 THEN cmBIO.ClientMembershipGUID
			WHEN cmEXT.IsActiveFlag = 1 THEN cmEXT.ClientMembershipGUID
			WHEN cmSUR.IsActiveFlag = 1 THEN cmSUR.ClientMembershipGUID
			WHEN cmXTR.IsActiveFlag = 1 THEN cmXTR.ClientMembershipGUID
			WHEN cmMDP.IsActiveFlag = 1 THEN cmMDP.ClientMembershipGUID
			WHEN NOT cmBIO.ClientMembershipGUID IS NULL THEN cmBIO.ClientMembershipGUID
			WHEN NOT cmEXT.ClientMembershipGUID IS NULL THEN cmEXT.ClientMembershipGUID
			WHEN NOT cmSUR.ClientMembershipGUID IS NULL THEN cmSUR.ClientMembershipGUID
			WHEN NOT cmXTR.ClientMembershipGUID IS NULL THEN cmXTR.ClientMembershipGUID
			WHEN NOT cmMDP.ClientMembershipGUID IS NULL THEN cmMDP.ClientMembershipGUID
			WHEN NOT cmRETAIL.ClientMembershipGUID IS NULL THEN cmRETAIL.ClientMembershipGUID
		ELSE NULL END AS ClientMembershipGUID,
		CASE WHEN cmBIO.IsActiveFlag = 1 THEN cmBIO.BeginDate
			WHEN cmEXT.IsActiveFlag = 1 THEN cmEXT.BeginDate
			WHEN cmSUR.IsActiveFlag = 1 THEN cmSUR.BeginDate
			WHEN cmXTR.IsActiveFlag = 1 THEN cmXTR.BeginDate
			WHEN cmMDP.IsActiveFlag = 1 THEN cmMDP.BeginDate
			WHEN NOT cmBIO.ClientMembershipGUID IS NULL THEN cmBIO.BeginDate
			WHEN NOT cmEXT.ClientMembershipGUID IS NULL THEN cmEXT.BeginDate
			WHEN NOT cmSUR.ClientMembershipGUID IS NULL THEN cmSUR.BeginDate
			WHEN NOT cmXTR.ClientMembershipGUID IS NULL THEN cmXTR.BeginDate
			WHEN NOT cmMDP.ClientMembershipGUID IS NULL THEN cmMDP.BeginDate
			WHEN NOT cmRETAIL.ClientMembershipGUID IS NULL THEN cmRETAIL.BeginDate
		ELSE NULL END AS BeginDate,
		CASE WHEN cmBIO.IsActiveFlag = 1 THEN mBIO.MembershipDescription
			WHEN cmEXT.IsActiveFlag = 1 THEN mEXT.MembershipDescription
			WHEN cmSUR.IsActiveFlag = 1 THEN mSUR.MembershipDescription
			WHEN cmXTR.IsActiveFlag = 1 THEN mXTR.MembershipDescription
			WHEN cmMDP.IsActiveFlag = 1 THEN mMDP.MembershipDescription
			WHEN NOT cmBIO.ClientMembershipGUID IS NULL THEN mBIO.MembershipDescription
			WHEN NOT cmEXT.ClientMembershipGUID IS NULL THEN mEXT.MembershipDescription
			WHEN NOT cmSUR.ClientMembershipGUID IS NULL THEN mSUR.MembershipDescription
			WHEN NOT cmXTR.ClientMembershipGUID IS NULL THEN mXTR.MembershipDescription
			WHEN NOT cmMDP.ClientMembershipGUID IS NULL THEN mMDP.MembershipDescription
			WHEN NOT cmRETAIL.ClientMembershipGUID IS NULL THEN mRETAIL.MembershipDescription
		ELSE NULL END AS MembershipDescription,
		NULL AS RecordGUID,
		5 AS SortOrder, 'AR Credit' AS CenterMessageDescriptionShort, NULL AS RecordDate,
		ISNULL(c.ClientFullNameAlt3Calc,'') + ' has an outstanding AR balance of $' + CAST(ROUND(c.ARBalance,2) AS varchar) + '.' AS CenterMessageDescription,
		NULL AS NotificationID, NULL as FeeDate
	FROM datClient c
		LEFT JOIN datClientMembership cmBIO ON c.CurrentBioMatrixClientMembershipGUID = cmBIO.ClientMembershipGUID AND cmBIO.MembershipID <> @RetailMembershipID
		LEFT JOIN cfgMembership mBIO ON cmBIO.MembershipID = mBIO.MembershipID
		LEFT JOIN datClientMembership cmXTR ON c.CurrentXtrandsClientMembershipGUID = cmXTR.ClientMembershipGUID AND cmXTR.MembershipID <> @RetailMembershipID
		LEFT JOIN cfgMembership mXTR ON cmXTR.MembershipID = mXTR.MembershipID
		LEFT JOIN datClientMembership cmEXT ON c.CurrentExtremeTherapyClientMembershipGUID = cmEXT.ClientMembershipGUID AND cmEXT.MembershipID <> @RetailMembershipID
		LEFT JOIN cfgMembership mEXT ON cmEXT.MembershipID = mEXT.MembershipID
		LEFT JOIN datClientMembership cmSUR ON c.CurrentSurgeryClientMembershipGUID = cmSUR.ClientMembershipGUID AND cmSUR.MembershipID <> @RetailMembershipID
		LEFT JOIN cfgMembership mSUR ON cmSUR.MembershipID = mSUR.MembershipID
		LEFT JOIN datClientMembership cmMDP ON c.CurrentMDPClientMembershipGUID = cmMDP.ClientMembershipGUID AND cmMDP.MembershipID <> @RetailMembershipID
		LEFT JOIN cfgMembership mMDP ON cmMDP.MembershipID = mMDP.MembershipID
		LEFT JOIN datClientMembership cmRETAIL ON c.ClientGUID = cmRETAIL.ClientMembershipGUID AND cmSUR.MembershipID = @RetailMembershipID
		LEFT JOIN cfgMembership mRETAIL ON cmRETAIL.MembershipID = mRETAIL.MembershipID
		LEFT JOIN cfgCenter ctr ON c.CenterID = ctr.CenterID
	WHERE @IsCorpHeadQuarters = 0 AND @IsSurgeryCenter = 1
		AND c.CenterID = @CenterID
		AND ROUND(c.ARBalance,2) > 0
		AND CASE WHEN cmBIO.IsActiveFlag = 1 THEN cmBIO.ClientMembershipGUID
			WHEN cmEXT.IsActiveFlag = 1 THEN cmEXT.ClientMembershipGUID
			WHEN cmSUR.IsActiveFlag = 1 THEN cmSUR.ClientMembershipGUID
			WHEN cmXTR.IsActiveFlag = 1 THEN cmXTR.ClientMembershipGUID
			WHEN cmMDP.IsActiveFlag = 1 THEN cmMDP.ClientMembershipGUID
			WHEN NOT cmBIO.ClientMembershipGUID IS NULL THEN cmBIO.ClientMembershipGUID
			WHEN NOT cmEXT.ClientMembershipGUID IS NULL THEN cmEXT.ClientMembershipGUID
			WHEN NOT cmSUR.ClientMembershipGUID IS NULL THEN cmSUR.ClientMembershipGUID
			WHEN NOT cmXTR.ClientMembershipGUID IS NULL THEN cmXTR.ClientMembershipGUID
			WHEN NOT cmMDP.ClientMembershipGUID IS NULL THEN cmMDP.ClientMembershipGUID
			WHEN NOT cmRETAIL.ClientMembershipGUID IS NULL THEN cmRETAIL.ClientMembershipGUID
		ELSE NULL END IS NOT NULL

)
UNION
(
	--Non retail clients with an AR Credit
	SELECT c.ClientFullNameCalc AS ReferenceTo,
		CASE WHEN cmBIO.IsActiveFlag = 1 THEN cmBIO.ClientMembershipGUID
			WHEN cmEXT.IsActiveFlag = 1 THEN cmEXT.ClientMembershipGUID
			WHEN cmSUR.IsActiveFlag = 1 THEN cmSUR.ClientMembershipGUID
			WHEN cmXTR.IsActiveFlag = 1 THEN cmXTR.ClientMembershipGUID
			WHEN cmMDP.IsActiveFlag = 1 THEN cmMDP.ClientMembershipGUID
			WHEN NOT cmBIO.ClientMembershipGUID IS NULL THEN cmBIO.ClientMembershipGUID
			WHEN NOT cmEXT.ClientMembershipGUID IS NULL THEN cmEXT.ClientMembershipGUID
			WHEN NOT cmSUR.ClientMembershipGUID IS NULL THEN cmSUR.ClientMembershipGUID
			WHEN NOT cmXTR.ClientMembershipGUID IS NULL THEN cmXTR.ClientMembershipGUID
			WHEN NOT cmMDP.ClientMembershipGUID IS NULL THEN cmMDP.ClientMembershipGUID
			WHEN NOT cmRETAIL.ClientMembershipGUID IS NULL THEN cmRETAIL.ClientMembershipGUID
		ELSE NULL END AS ClientMembershipGUID,
		CASE WHEN cmBIO.IsActiveFlag = 1 THEN cmBIO.BeginDate
			WHEN cmEXT.IsActiveFlag = 1 THEN cmEXT.BeginDate
			WHEN cmSUR.IsActiveFlag = 1 THEN cmSUR.BeginDate
			WHEN cmXTR.IsActiveFlag = 1 THEN cmXTR.BeginDate
			WHEN cmMDP.IsActiveFlag = 1 THEN cmMDP.BeginDate
			WHEN NOT cmBIO.ClientMembershipGUID IS NULL THEN cmBIO.BeginDate
			WHEN NOT cmEXT.ClientMembershipGUID IS NULL THEN cmEXT.BeginDate
			WHEN NOT cmSUR.ClientMembershipGUID IS NULL THEN cmSUR.BeginDate
			WHEN NOT cmXTR.ClientMembershipGUID IS NULL THEN cmXTR.BeginDate
			WHEN NOT cmMDP.ClientMembershipGUID IS NULL THEN cmMDP.BeginDate
			WHEN NOT cmRETAIL.ClientMembershipGUID IS NULL THEN cmRETAIL.BeginDate
		ELSE NULL END AS BeginDate,
		CASE WHEN cmBIO.IsActiveFlag = 1 THEN mBIO.MembershipDescription
			WHEN cmEXT.IsActiveFlag = 1 THEN mEXT.MembershipDescription
			WHEN cmSUR.IsActiveFlag = 1 THEN mSUR.MembershipDescription
			WHEN cmXTR.IsActiveFlag = 1 THEN mXTR.MembershipDescription
			WHEN cmMDP.IsActiveFlag = 1 THEN mMDP.MembershipDescription
			WHEN NOT cmBIO.ClientMembershipGUID IS NULL THEN mBIO.MembershipDescription
			WHEN NOT cmEXT.ClientMembershipGUID IS NULL THEN mEXT.MembershipDescription
			WHEN NOT cmSUR.ClientMembershipGUID IS NULL THEN mSUR.MembershipDescription
			WHEN NOT cmXTR.ClientMembershipGUID IS NULL THEN mXTR.MembershipDescription
			WHEN NOT cmMDP.ClientMembershipGUID IS NULL THEN mMDP.MembershipDescription
			WHEN NOT cmRETAIL.ClientMembershipGUID IS NULL THEN mRETAIL.MembershipDescription
		ELSE NULL END AS MembershipDescription,
		NULL AS RecordGUID,
		5 AS SortOrder, 'AR Credit' AS CenterMessageDescriptionShort, NULL AS RecordDate,
		ISNULL(c.ClientFullNameAlt3Calc,'') + ' has a credit of $' + CAST(ROUND(-1 * c.ARBalance,2) AS varchar) + '.' AS CenterMessageDescription,
		NULL AS NotificationID, NULL as FeeDate
	FROM datClient c
		LEFT JOIN datClientMembership cmBIO ON c.CurrentBioMatrixClientMembershipGUID = cmBIO.ClientMembershipGUID AND cmBIO.MembershipID <> @RetailMembershipID
		LEFT JOIN cfgMembership mBIO ON cmBIO.MembershipID = mBIO.MembershipID
		LEFT JOIN datClientMembership cmXTR ON c.CurrentXtrandsClientMembershipGUID = cmXTR.ClientMembershipGUID AND cmXTR.MembershipID <> @RetailMembershipID
		LEFT JOIN cfgMembership mXTR ON cmXTR.MembershipID = mXTR.MembershipID
		LEFT JOIN datClientMembership cmEXT ON c.CurrentExtremeTherapyClientMembershipGUID = cmEXT.ClientMembershipGUID AND cmEXT.MembershipID <> @RetailMembershipID
		LEFT JOIN cfgMembership mEXT ON cmEXT.MembershipID = mEXT.MembershipID
		LEFT JOIN datClientMembership cmSUR ON c.CurrentSurgeryClientMembershipGUID = cmSUR.ClientMembershipGUID AND cmSUR.MembershipID <> @RetailMembershipID
		LEFT JOIN cfgMembership mSUR ON cmSUR.MembershipID = mSUR.MembershipID
		LEFT JOIN datClientMembership cmMDP ON c.CurrentMDPClientMembershipGUID = cmMDP.ClientMembershipGUID AND cmMDP.MembershipID <> @RetailMembershipID
		LEFT JOIN cfgMembership mMDP ON cmMDP.MembershipID = mMDP.MembershipID
		LEFT JOIN datClientMembership cmRETAIL ON c.ClientGUID = cmRETAIL.ClientMembershipGUID AND cmSUR.MembershipID = @RetailMembershipID
		LEFT JOIN cfgMembership mRETAIL ON cmRETAIL.MembershipID = mRETAIL.MembershipID
		LEFT JOIN cfgCenter ctr ON c.CenterID = ctr.CenterID
	WHERE @IsCorpHeadQuarters = 0 AND @IsSurgeryCenter = 1
		AND c.CenterID = @CenterID
		AND ROUND(c.ARBalance,2) < 0
		AND CASE WHEN cmBIO.IsActiveFlag = 1 THEN cmBIO.ClientMembershipGUID
			WHEN cmEXT.IsActiveFlag = 1 THEN cmEXT.ClientMembershipGUID
			WHEN cmSUR.IsActiveFlag = 1 THEN cmSUR.ClientMembershipGUID
			WHEN cmXTR.IsActiveFlag = 1 THEN cmXTR.ClientMembershipGUID
			WHEN cmMDP.IsActiveFlag = 1 THEN cmMDP.ClientMembershipGUID
			WHEN NOT cmBIO.ClientMembershipGUID IS NULL THEN cmBIO.ClientMembershipGUID
			WHEN NOT cmEXT.ClientMembershipGUID IS NULL THEN cmEXT.ClientMembershipGUID
			WHEN NOT cmSUR.ClientMembershipGUID IS NULL THEN cmSUR.ClientMembershipGUID
			WHEN NOT cmXTR.ClientMembershipGUID IS NULL THEN cmXTR.ClientMembershipGUID
			WHEN NOT cmMDP.ClientMembershipGUID IS NULL THEN cmMDP.ClientMembershipGUID
			WHEN NOT cmRETAIL.ClientMembershipGUID IS NULL THEN cmRETAIL.ClientMembershipGUID
		ELSE NULL END IS NOT NULL
)
UNION (
	--Inventory Transfer Request (show in From Center when requested)
	SELECT c.ClientFullNameCalc AS ReferenceTo, cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, itr.InventoryTransferRequestGUID AS RecordGUID,
		1 AS SortOrder, 'Transfer Request' AS CenterMessageDescriptionShort, itr.InventoryTransferRequestDate AS RecordDate,
		toCent.CenterDescriptionFullCalc + ' has requested the transfer of hair system ''' + hso.HairSystemOrderNumber + ''' from client ' + c.ClientFullNameAlt3Calc + '.' AS CenterMessageDescription,
		NULL AS NotificationID, NULL as FeeDate
	FROM datInventoryTransferRequest itr
		LEFT JOIN lkpInventoryTransferRequestStatus itrs ON itr.InventoryTransferRequestStatusID = itrs.InventoryTransferRequestStatusID
		LEFT JOIN datHairSystemOrder hso ON itr.HairSystemOrderGUID = hso.HairSystemOrderGUID
		INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = itr.FromClientMembershipGUID
		INNER JOIN datClient c ON cm.ClientGUID = c.ClientGUID
		INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
		INNER JOIN cfgCenter toCent ON itr.ToCenterID = toCent.CenterID
	WHERE (@IsCorpHeadQuarters = 1 OR @IsSurgeryCenter = 0)
		AND itr.FromCenterID = @CenterID
		AND itrs.InventoryTransferRequestStatusDescription = @InventoryTransferRequestStatus_Requested
)
UNION (
	--Inventory Transfer Request (show in To Center when rejected)
	SELECT c.ClientFullNameCalc AS ReferenceTo, cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, itr.InventoryTransferRequestGUID AS RecordGUID,
		2 AS SortOrder, 'Transfer Request Rejected' AS CenterMessageDescriptionShort, itr.LastStatusChangeDate AS RecordDate,
		fromCent.CenterDescriptionFullCalc + ' has rejected your request for the transfer of hair system ''' + hso.HairSystemOrderNumber + ''' to client ' + c.ClientFullNameAlt3Calc + '.' AS CenterMessageDescription,
		NULL AS NotificationID, NULL as FeeDate
	FROM datInventoryTransferRequest itr
		LEFT JOIN lkpInventoryTransferRequestStatus itrs ON itr.InventoryTransferRequestStatusID = itrs.InventoryTransferRequestStatusID
		LEFT JOIN datHairSystemOrder hso ON itr.HairSystemOrderGUID = hso.HairSystemOrderGUID
		INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = itr.ToClientMembershipGUID
		INNER JOIN datClient c ON cm.ClientGUID = c.ClientGUID
		INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
		INNER JOIN cfgCenter fromCent ON itr.FromCenterID = fromCent.CenterID
	WHERE (@IsCorpHeadQuarters = 1 OR @IsSurgeryCenter = 0)
		AND itr.ToCenterID = @CenterID
		AND itrs.InventoryTransferRequestStatusDescription = @InventoryTransferRequestStatus_Rejected
)
UNION (
	--Inventory Transfer Request (show in To Center when accepted)
	SELECT c.ClientFullNameCalc AS ReferenceTo, cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, hso.HairSystemOrderGUID AS RecordGUID,
		3 AS SortOrder, 'Transfer Request Accepted' AS CenterMessageDescriptionShort, itr.LastStatusChangeDate AS RecordDate,
		fromCent.CenterDescriptionFullCalc + ' has accepted the transfer of hair system ''' + hso.HairSystemOrderNumber + ''' to client ' + c.ClientFullNameAlt3Calc + '.' AS CenterMessageDescription,
		NULL AS NotificationID, NULL as FeeDate
	FROM datInventoryTransferRequest itr
		LEFT JOIN lkpInventoryTransferRequestStatus itrs ON itr.InventoryTransferRequestStatusID = itrs.InventoryTransferRequestStatusID
		LEFT JOIN datHairSystemOrder hso ON itr.HairSystemOrderGUID = hso.HairSystemOrderGUID
		INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = itr.ToClientMembershipGUID
		INNER JOIN datClient c ON cm.ClientGUID = c.ClientGUID
		INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
		INNER JOIN cfgCenter fromCent ON itr.FromCenterID = fromCent.CenterID
	WHERE (@IsCorpHeadQuarters = 1 OR @IsSurgeryCenter = 0)
		AND itr.ToCenterID = @CenterID
		AND itrs.InventoryTransferRequestStatusDescription IN (@InventoryTransferRequestStatus_Accepted, @InventoryTransferRequestStatus_Shipped)
)
UNION (

	--Hair System Orders On Hold for corporate review
	SELECT c.ClientFullNameCalc AS ReferenceTo, cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, hso.HairSystemOrderGUID AS RecordGUID,
		3 AS SortOrder, 'Hold Order For Review' AS CenterMessageDescriptionShort,
		ISNULL((SELECT MAX(t.HairSystemOrderTransactionDate)
						FROM datHairSystemOrderTransaction t
							INNER JOIN lkpHairSystemOrderStatus s ON t.NewHairSystemOrderStatusID = s.HairSystemOrderStatusID
						WHERE t.HairSystemOrderGUID = hso.HairSystemOrderGUID AND t.PreviousHairSystemOrderStatusID <> t.NewHairSystemOrderStatusID
							AND s.HairSystemOrderStatusDescriptionShort = @HairSystemOrderStatus_HQHold
						GROUP BY t.HairSystemOrderGUID), hso.HairSystemOrderDate) AS RecordDate,
		'Hair system ''' + hso.HairSystemOrderNumber + ''' for client ' + c.ClientFullNameAlt3Calc + ' is currently on hold for review.' AS CenterMessageDescription,
		NULL AS NotificationID, NULL as FeeDate
	FROM datHairSystemOrder hso
		INNER JOIN lkpHairSystemOrderStatus hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
		INNER JOIN datClientMembership cm ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
		INNER JOIN datClient c ON cm.ClientGUID = c.ClientGUID
		INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
		INNER JOIN cfgCenter ctr ON hso.CenterID = ctr.CenterID
		LEFT JOIN lkpHairSystemDesignTemplate hsdt ON hso.HairSystemDesignTemplateID = hsdt.HairSystemDesignTemplateID
	WHERE (@IsCorpHeadQuarters = 1)
		AND hso.IsOnHoldForReviewFlag = 1 -- AND (hso.IsSampleOrderFlag = 1 OR hsdt.IsManualTemplateFlag = 1)
		AND hsos.HairSystemOrderStatusDescriptionShort IN (@HairSystemOrderStatus_HQHold)
)
UNION (
	--Hair System Orders that had a credit accepted (Exclude Repair Orders)
	SELECT c.ClientFullNameCalc AS ReferenceTo, cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, hso.HairSystemOrderGUID AS RecordGUID,
		4 AS SortOrder, 'Hair Order Credit Approved' AS CenterMessageDescriptionShort, hso.HairSystemOrderDate AS RecordDate,
		'Credit was approved for Hair system ''' + hso.HairSystemOrderNumber + ''' for client ' + c.ClientFullNameAlt3Calc + '.' AS CenterMessageDescription,
		NULL AS NotificationID, NULL as FeeDate
	FROM datHairSystemOrder hso
		INNER JOIN lkpHairSystemOrderStatus hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
		INNER JOIN datClientMembership cm ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
		INNER JOIN datClient c ON cm.ClientGUID = c.ClientGUID
		INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
	WHERE (@IsCorpHeadQuarters = 0) AND @IsSurgeryCenter = 0 AND hso.IsRepairOrderFlag = 0 -- exclude Repair Orders
		AND hso.ClientHomeCenterID = @CenterID
		AND hso.RequestForCreditAcceptedDate >= CAST(DATEADD(d,-1 * @HairOrderCreditDays,GETDATE()) as DATE)
)
UNION (
	--Hair System Orders that had a credit accepted (Exclude Repair Orders)
	SELECT c.ClientFullNameCalc AS ReferenceTo, cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, hso.HairSystemOrderGUID AS RecordGUID,
		5 AS SortOrder, 'Hair Order Credit Denied' AS CenterMessageDescriptionShort, hso.HairSystemOrderDate AS RecordDate,
		'Credit was declined for Hair system ''' + hso.HairSystemOrderNumber + ''' for client ' + c.ClientFullNameAlt3Calc + '.' AS CenterMessageDescription,
		 NULL AS NotificationID, NULL as FeeDate
	FROM datHairSystemOrder hso
		INNER JOIN lkpHairSystemOrderStatus hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
		INNER JOIN datClientMembership cm ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
		INNER JOIN datClient c ON cm.ClientGUID = c.ClientGUID
		INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
	WHERE (@IsCorpHeadQuarters = 0) AND @IsSurgeryCenter = 0 AND hso.IsRepairOrderFlag = 0 -- exclude Repair Orders
		AND hso.ClientHomeCenterID = @CenterID
		AND hso.RequestForCreditDeclinedDate >= CAST(DATEADD(d,-1 * @HairOrderCreditDays,GETDATE()) as DATE)
)
UNION (
	--Hair System Repair Orders that had a credit decision
	SELECT c.ClientFullNameCalc AS ReferenceTo, cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, hso.HairSystemOrderGUID AS RecordGUID,
		4 AS SortOrder, 'Repair Hair Orders' AS CenterMessageDescriptionShort, hso.HairSystemOrderDate AS RecordDate,
		'Repair Order (' + hso.HairSystemOrderNumber + ') was received by Corporate and will be sent to the Factory for Hair Add.' AS CenterMessageDescription,
		NULL AS NotificationID, NULL as FeeDate
	FROM datHairSystemOrder hso
		INNER JOIN lkpHairSystemOrderStatus hsos ON hso.HairSystemOrderStatusID = hsos.HairSystemOrderStatusID
		INNER JOIN datClientMembership cm ON hso.ClientMembershipGUID = cm.ClientMembershipGUID
		INNER JOIN datClient c ON cm.ClientGUID = c.ClientGUID
		INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
	WHERE (@IsCorpHeadQuarters = 0) AND @IsSurgeryCenter = 0 AND hso.IsRepairOrderFlag = 1 -- Repair Orders
		AND hso.ClientHomeCenterID = @CenterID
		AND ( hso.RequestForCreditAcceptedDate >= CAST(DATEADD(d,-1 * @HairOrderCreditDays,GETDATE()) as DATE)
				OR hso.RequestForCreditDeclinedDate >= CAST(DATEADD(d,-1 * @HairOrderCreditDays,GETDATE()) as DATE) )
)
UNION (
	-- Static Fee messages that have not bee acknowledged yet
	SELECT
		CASE WHEN nt.NotificationTypeDescriptionShort = 'Fees' THEN 'Monthly Fees'
			 WHEN nt.NotificationTypeDescriptionShort = 'Client' THEN c.ClientFullNameCalc
		ELSE NULL END AS ReferenceTo,
		cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, NULL AS RecordGUID,
		5 AS SortOrder, nt.NotificationTypeDescription AS CenterMessageDescriptionShort, n.NotificationDate AS RecordDate,
		n.[Description] AS CenterMessageDescription, n.NotificationID, n.FeeDate as FeeDate
	FROM datNotification n
		INNER JOIN lkpNotificationType nt ON n.NotificationTypeID = nt.NotificationTypeID
		LEFT OUTER JOIN cfgEmployeePositionJoin epj ON epj.EmployeeGUID = @EmployeeGUID
		LEFT OUTER JOIN lkpEmployeePosition ep ON epj.EmployeePositionID = ep.EmployeePositionID
		LEFT OUTER JOIN datClientMembership cm ON n.ClientGUID = cm.ClientGUID
		LEFT OUTER JOIN datClient c ON n.ClientGUID = c.ClientGUID
		LEFT OUTER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
	WHERE @IncludeFeesNotifications = 1 AND n.IsAcknowledgedFlag = 0 AND n.CenterID = @CenterID
		AND nt.NotificationTypeDescriptionShort = 'Fees'
		AND n.NotificationDate >= DATEADD(day, DATEDIFF(day, '19000101', GETDATE()), '19000101')
)
UNION (
	-- Static Inactive Fee Profile messages that have not been acknowledged yet.
	SELECT
		NULL AS ReferenceTo,
		cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, NULL AS RecordGUID,
		5 AS SortOrder, nt.NotificationTypeDescription AS CenterMessageDescriptionShort, n.NotificationDate AS RecordDate,
		n.[Description] AS CenterMessageDescription, n.NotificationID, n.FeeDate as FeeDate
	FROM datNotification n
		INNER JOIN lkpNotificationType nt ON n.NotificationTypeID = nt.NotificationTypeID
		LEFT OUTER JOIN cfgEmployeePositionJoin epj ON epj.EmployeeGUID = @EmployeeGUID
		LEFT OUTER JOIN lkpEmployeePosition ep ON epj.EmployeePositionID = ep.EmployeePositionID
		INNER JOIN datClient c ON n.ClientGUID = c.ClientGUID
		INNER JOIN datClientEFT ceft ON ceft.ClientGUID = c.ClientGUID AND ceft.IsActiveFlag = 0
		INNER JOIN datClientMembership cm ON ceft.ClientMembershipGUID = cm.ClientMembershipGUID
		INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
	WHERE n.IsAcknowledgedFlag = 0 AND n.CenterID = @CenterID
		AND nt.NotificationTypeDescriptionShort = 'InactvFee'
)
UNION (
	-- Static messages that have not bee acknowledged yet (Not Fees)
	SELECT
		CASE WHEN nt.NotificationTypeDescriptionShort = 'Fees' THEN 'Monthly Fees'
			 WHEN nt.NotificationTypeDescriptionShort = 'Client' THEN c.ClientFullNameCalc
			 WHEN nt.NotificationTypeDescriptionShort = 'SrvRqst' THEN c.ClientFullNameCalc
		ELSE NULL END AS ReferenceTo,
		cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, NULL AS RecordGUID,
		6 AS SortOrder, nt.NotificationTypeDescription AS CenterMessageDescriptionShort, n.NotificationDate AS RecordDate,
		n.[Description] AS CenterMessageDescription, n.NotificationID, n.FeeDate as FeeDate
	FROM datNotification n
		INNER JOIN lkpNotificationType nt ON n.NotificationTypeID = nt.NotificationTypeID
		LEFT OUTER JOIN cfgEmployeePositionJoin epj ON epj.EmployeeGUID = @EmployeeGUID
		LEFT OUTER JOIN lkpEmployeePosition ep ON epj.EmployeePositionID = ep.EmployeePositionID
		INNER JOIN datClient c ON n.ClientGUID = c.ClientGUID
		INNER JOIN datClientMembership cm ON n.ClientGUID = cm.ClientGUID
		LEFT OUTER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
	WHERE n.IsAcknowledgedFlag = 0 AND n.CenterID = @CenterID
		AND nt.NotificationTypeDescriptionShort <> 'Fees'
		AND nt.NotificationTypeDescriptionShort <> 'InactvFee'
		AnD nt.NotificationTypeDescriptionShort <> 'SrvAppr'
		AND (c.CurrentBioMatrixClientMembershipGUID = cm.ClientMembershipGUID
				OR c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
				OR c.CurrentExtremeTherapyClientMembershipGUID = cm.ClientMembershipGUID
				OR c.CurrentXtrandsClientMembershipGUID = cm.ClientMembershipGUID
				OR c.CurrentMDPClientMembershipGUID = cm.ClientMembershipGUID)
)
UNION (
	-- Service Request Approval
	SELECT
		c.ClientFullNameCalc AS ReferenceTo,
		cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, NULL AS RecordGUID,
		7 AS SortOrder, 'Service Authorization Request Accepted' AS CenterMessageDescriptionShort, n.NotificationDate AS RecordDate,
		n.[Description] AS CenterMessageDescription, n.NotificationID, n.FeeDate as FeeDate
	FROM datNotification n
		INNER JOIN datAppointment a on n.AppointmentGUID = a.AppointmentGUID
		INNER JOIN lkpNotificationType nt ON n.NotificationTypeID = nt.NotificationTypeID
		LEFT OUTER JOIN cfgEmployeePositionJoin epj ON epj.EmployeeGUID = @EmployeeGUID
		LEFT OUTER JOIN lkpEmployeePosition ep ON epj.EmployeePositionID = ep.EmployeePositionID
		INNER JOIN datClient c ON n.ClientGUID = c.ClientGUID
		INNER JOIN datClientMembership cm ON n.ClientGUID = cm.ClientGUID
		LEFT OUTER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
	WHERE n.IsAcknowledgedFlag = 0 AND n.CenterID = @CenterID
		AND nt.NotificationTypeDescriptionShort = 'SrvAppr'
		and a.IsAuthorizedFlag = 1
		AND (c.CurrentBioMatrixClientMembershipGUID = cm.ClientMembershipGUID
				OR c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
				OR c.CurrentExtremeTherapyClientMembershipGUID = cm.ClientMembershipGUID
				OR c.CurrentXtrandsClientMembershipGUID = cm.ClientMembershipGUID
				OR c.CurrentMDPClientMembershipGUID = cm.ClientMembershipGUID)
)
UNION (
	-- Service Request Approval
	SELECT
		c.ClientFullNameCalc AS ReferenceTo,
		cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, NULL AS RecordGUID,
		8 AS SortOrder, 'Service Authorization Request Rejected' AS CenterMessageDescriptionShort, n.NotificationDate AS RecordDate,
		n.[Description] AS CenterMessageDescription, n.NotificationID, n.FeeDate as FeeDate
	FROM datNotification n
		INNER JOIN datAppointment a on n.AppointmentGUID = a.AppointmentGUID
		INNER JOIN lkpNotificationType nt ON n.NotificationTypeID = nt.NotificationTypeID
		LEFT OUTER JOIN cfgEmployeePositionJoin epj ON epj.EmployeeGUID = @EmployeeGUID
		LEFT OUTER JOIN lkpEmployeePosition ep ON epj.EmployeePositionID = ep.EmployeePositionID
		INNER JOIN datClient c ON n.ClientGUID = c.ClientGUID
		INNER JOIN datClientMembership cm ON n.ClientGUID = cm.ClientGUID
		LEFT OUTER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
	WHERE n.IsAcknowledgedFlag = 0 AND n.CenterID = @CenterID
		AND nt.NotificationTypeDescriptionShort = 'SrvAppr'
		and a.IsAuthorizedFlag = 0
		AND (c.CurrentBioMatrixClientMembershipGUID = cm.ClientMembershipGUID
				OR c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
				OR c.CurrentExtremeTherapyClientMembershipGUID = cm.ClientMembershipGUID
				OR c.CurrentXtrandsClientMembershipGUID = cm.ClientMembershipGUID
				OR c.CurrentMDPClientMembershipGUID = cm.ClientMembershipGUID)
)
UNION (
	-- Pending Service Authorization Requests
	SELECT
		c.ClientFullNameCalc AS ReferenceTo,
		cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, NULL AS RecordGUID,
		9 AS SortOrder, 'Pending Service Authorization Requests' AS CenterMessageDescriptionShort, n.NotificationDate AS RecordDate,
		REPLACE(REPLACE(n.[Description], vcent.CenterDescriptionFullCalc, cent.CenterDescriptionFullCalc),'requested', 'a pending service') AS New_CenterMessageDescription
		, n.NotificationID, n.FeeDate as FeeDate
	FROM datNotification n
		INNER JOIN lkpNotificationType nt ON n.NotificationTypeID = nt.NotificationTypeID
		LEFT OUTER JOIN cfgEmployeePositionJoin epj ON epj.EmployeeGUID = @EmployeeGUID
		LEFT OUTER JOIN lkpEmployeePosition ep ON epj.EmployeePositionID = ep.EmployeePositionID
		INNER JOIN datClient c ON n.ClientGUID = c.ClientGUID
		INNER JOIN datClientMembership cm ON n.ClientGUID = cm.ClientGUID
		INNER JOIN cfgCenter cent on n.CenterID = cent.CenterID
		INNER JOIN cfgCenter vcent on n.VisitingCenterID = vcent.CenterID
		INNER JOIN datAppointment a on n.AppointmentGUID = a.AppointmentGUID
		LEFT OUTER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
	WHERE n.IsAcknowledgedFlag = 0 AND n.VisitingCenterID = @CenterID
		AND nt.NotificationTypeDescriptionShort = 'SrvRqst'
		AND (c.CurrentBioMatrixClientMembershipGUID = cm.ClientMembershipGUID
				OR c.CurrentSurgeryClientMembershipGUID = cm.ClientMembershipGUID
				OR c.CurrentExtremeTherapyClientMembershipGUID = cm.ClientMembershipGUID
				OR c.CurrentXtrandsClientMembershipGUID = cm.ClientMembershipGUID
				OR c.CurrentMDPClientMembershipGUID = cm.ClientMembershipGUID)
)
UNION (
	--Pending Inventory Transfer Request (show in From Center when requested)
	SELECT c.ClientFullNameCalc AS ReferenceTo, cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, itr.InventoryTransferRequestGUID AS RecordGUID,
		10 AS SortOrder, 'Pending Transfer Request' AS CenterMessageDescriptionShort, itr.InventoryTransferRequestDate AS RecordDate,
		FromCent.CenterDescriptionFullCalc + ' has a pending transfer request for hair system ''' + hso.HairSystemOrderNumber + ''' from client ' + c.ClientFullNameAlt3Calc + '.' AS CenterMessageDescription,
		NULL AS NotificationID, NULL as FeeDate
	FROM datInventoryTransferRequest itr
		LEFT JOIN lkpInventoryTransferRequestStatus itrs ON itr.InventoryTransferRequestStatusID = itrs.InventoryTransferRequestStatusID
		LEFT JOIN datHairSystemOrder hso ON itr.HairSystemOrderGUID = hso.HairSystemOrderGUID
		INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = itr.FromClientMembershipGUID
		INNER JOIN datClient c ON cm.ClientGUID = c.ClientGUID
		INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
		INNER JOIN cfgCenter FromCent ON itr.FromCenterID = FromCent.CenterID
	WHERE (@IsCorpHeadQuarters = 1 OR @IsSurgeryCenter = 0)
		AND itr.ToCenterID = @CenterID
		AND itrs.InventoryTransferRequestStatusDescription = @InventoryTransferRequestStatus_Requested
)

/*******WEB APPOINTMENT (HAIR FIT)   ************************/
UNION (
	SELECT c.ClientFullNameCalc AS ReferenceTo, cm.ClientMembershipGUID, cm.BeginDate, m.MembershipDescription, a.AppointmentGUID AS RecordGUID,
		8 AS SortOrder, 'HairFit Appointment' AS CenterMessageDescriptionShort, a.AppointmentDate AS RecordDate,
		'HairFit Appointment' AS CenterMessageDescription,
		NULL AS NotificationID, NULL as FeeDate
	FROM datClientMembership cm
		INNER JOIN datClient c ON cm.ClientGUID = c.ClientGUID
		INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID

		INNER JOIN datAppointment a ON cm.ClientMembershipGUID = a.ClientMembershipGUID
		INNER JOIN cfgCenter apptctr ON a.CenterID = apptctr.CenterID

		INNER JOIN lkpAppointmentType t ON a.AppointmentTypeID = t.AppointmentTypeID
	WHERE cm.CenterID = @CenterID
		AND (a.IsDeletedFlag IS NULL OR a.IsDeletedFlag = 0)
		AND a.AppointmentTypeID = @AppointmentTypeID_HairFit
		AND a.AppointmentStatusID IS NULL
		AND a.AppointmentDate > DATEADD(day, DATEDIFF(day, '19000101', GETDATE()), '19000101')
)

ORDER BY SortOrder, ReferenceTo
OPTION(RECOMPILE)

END
