/* CreateDate: 03/01/2012 07:54:45.710 , ModifyDate: 02/27/2017 09:49:16.990 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:                  mtnActivateCenterContracts

DESTINATION SERVER:         SQL01

DESTINATION DATABASE:		HairClubCMS

RELATED APPLICATION:		CMS

AUTHOR:                     Mike Tovbin

IMPLEMENTOR:                Mike Tovbin

DATE IMPLEMENTED:           02/27/2012

LAST REVISION DATE:			02/27/2012

==============================================================================
DESCRIPTION:    Run nightly to activate Center contracts.

==============================================================================
NOTES:
            * 02/27/2012 MVT - Created Stored Proc
			* 05/11/2015 MVT - Modified to take Priority and Repair into account

==============================================================================
SAMPLE EXECUTION:
EXEC [mtnActivateCenterContracts]
==============================================================================
*/
CREATE PROCEDURE [dbo].[mtnActivateCenterContracts]
AS
BEGIN

		-- SET the active Flag for the Contracts
		Update cfgHairSystemCenterContract
			SET IsActiveContract = 0,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = 'sa-ContractActivate'
		WHERE IsActiveContract = 1


		UPDATE cfgHairSystemCenterContract
			SET IsActiveContract = 1,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = 'sa-ContractActivate'
		FROM cfgHairSystemCenterContract
		WHERE GETUTCDATE() BETWEEN ContractBeginDate AND ContractEndDate

		UPDATE hscc
			SET IsActiveContract = 1,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = 'sa-ContractActivate'
		FROM cfgHairSystemCenterContract hscc
			INNER JOIN (SELECT CenterID, MAX(ContractEndDate) as ContractEndDate
						FROM cfgHairSystemCenterContract
						WHERE CenterID  NOT IN
							(SELECT DISTINCT CenterID FROM cfgHairSystemCenterContract WHERE IsActiveContract = 1)
						GROUP BY CenterID) hscc2 on hscc.CenterID = hscc2.CenterID AND hscc.ContractEndDate = hscc2.ContractEndDate


		UPDATE hscc
			SET IsActiveContract = 1,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = 'sa-ContractActivate'
		FROM cfgHairSystemCenterContract hscc
			INNER JOIN (
				SELECT CenterID, MAX(ContractEndDate) as ContractEndDate
				FROM cfgHairSystemCenterContract
				WHERE CenterID NOT IN
					(SELECT DISTINCT CenterID
							FROM cfgHairSystemCenterContract
							WHERE IsActiveContract = 1
									AND IsRepair = 0
									AND IsPriorityContract = 0)
					 AND IsRepair = 0
					 AND IsPriorityContract = 0
				GROUP BY CenterID) hscc2 on hscc.CenterID = hscc2.CenterID AND hscc.ContractEndDate = hscc2.ContractEndDate
		WHERE hscc.IsRepair = 0
			AND hscc.IsPriorityContract = 0


		UPDATE hscc
			SET IsActiveContract = 1,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = 'sa-ContractActivate'
		FROM cfgHairSystemCenterContract hscc
			INNER JOIN (
				SELECT CenterID, MAX(ContractEndDate) as ContractEndDate
				FROM cfgHairSystemCenterContract
				WHERE CenterID NOT IN
					(SELECT DISTINCT CenterID
							FROM cfgHairSystemCenterContract
							WHERE IsActiveContract = 1
									AND IsRepair = 1
									AND IsPriorityContract = 0)
					 AND IsRepair = 1
					 AND IsPriorityContract = 0
				GROUP BY CenterID) hscc2 on hscc.CenterID = hscc2.CenterID AND hscc.ContractEndDate = hscc2.ContractEndDate
		WHERE hscc.IsRepair = 1
			AND hscc.IsPriorityContract = 0


		UPDATE hscc
			SET IsActiveContract = 1,
				LastUpdate = GETUTCDATE(),
				LastUpdateUser = 'sa-ContractActivate'
		FROM cfgHairSystemCenterContract hscc
			INNER JOIN (
				SELECT CenterID, MAX(ContractEndDate) as ContractEndDate
				FROM cfgHairSystemCenterContract
				WHERE CenterID NOT IN
					(SELECT DISTINCT CenterID
							FROM cfgHairSystemCenterContract
							WHERE IsActiveContract = 1
									AND IsRepair = 0
									AND IsPriorityContract = 1)
					 AND IsRepair = 0
					 AND IsPriorityContract = 1
				GROUP BY CenterID) hscc2 on hscc.CenterID = hscc2.CenterID AND hscc.ContractEndDate = hscc2.ContractEndDate
		WHERE hscc.IsRepair = 0
			AND hscc.IsPriorityContract = 1

END
GO
