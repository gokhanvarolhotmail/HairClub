/* CreateDate: 05/03/2010 12:21:10.973 , ModifyDate: 04/20/2021 07:37:49.340 */
GO
/****************************************************************************************************
CHANGE HISTORY:
11/16/2018 - RH - Added LeadCreationDateKey from FactLead
11/16/2018  -KM - Fixed it
--			02/26/2020  KMurdoch     Added Refersion to HCRef
--			04/24/2020  KMurdoch     Modified Bosley Appointment to be determined by Owner Type = 'Bosley Consult'
--			07/08/2020  KMurdoch     Added in check for status to filter out Merged, Inactive and Test Leads associated with consults
--			08/05/2020  KMurdoch     Added PromoCodeKey
--			08/07/2020  KMurdoch     Added LeadCreationTimeKey
--			09/03/2020  KMurdoch	 Added Refersion Source Codes
--			09/08/2020	KMurdoch	 Added New Lead Status 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION'
--			09/10/2020  KMurdoch     Changed inner join to Fact Lead to Left outer
--			10/02/2020  KMurdoch     Restricted to 2017 forward
--          12/14/2020  KMurdoch	 Added date logic to make referrals count as Consultations after 12/1/2020
--			01/25/2021	KMurdoch     Removed logic to eliminate Bebacks from consultations
----------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [bi_mktg_dds].[vwFactActivityResults]
****************************************************************************************************/
CREATE VIEW [bi_mktg_dds].[vwFactActivityResults] AS
SELECT      DE.FullDate AS PartitionDate,
			FAR.ActivityResultDateKey,
			FAR.ActivityResultKey,
			FAR.ActivityResultTimeKey,
			FAR.ActivityKey,
            FAR.ActivityDateKey,
			FAR.ActivityTimeKey,
			FAR.ActivityCompletedDateKey,
			FAR.ActivityCompletedTimeKey,
			FAR.ActivityDueDateKey,
			FAR.ActivityStartTimeKey,
            FAR.OriginalAppointmentDateKey,
			FAR.ActivitySavedDateKey,
			FAR.ActivitySavedTimeKey,
			FAR.ContactKey,
			FAR.CenterKey,
			FAR.SalesTypeKey,
			FAR.SourceKey,
            FAR.ActionCodeKey,
			FAR.ResultCodeKey,
			FAR.GenderKey,
			FAR.OccupationKey,
			FAR.EthnicityKey,
			FAR.MaritalStatusKey,
			FAR.HairLossTypeKey,
			FAR.AgeRangeKey,
            FAR.CompletedByEmployeeKey,
			FAR.ClientNumber,
			CASE WHEN LEFT(DC.SFDC_LeadID, 3) = '003' THEN FAR.Appointments ELSE CASE WHEN DC.ContactStatusSSID IN ('LEAD','CLIENT','HWLEAD','HWCLIENT','EVENT','PROSPECT', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION') THEN FAR.Appointments ELSE 0 END END AS 'Appointments',
			CASE WHEN LEFT(DC.SFDC_LeadID, 3) = '003' THEN FAR.Show ELSE CASE WHEN DC.ContactStatusSSID IN ('LEAD','CLIENT','HWLEAD','HWCLIENT','EVENT','PROSPECT', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION') THEN FAR.Show ELSE 0 END END AS 'Show',
			CASE WHEN LEFT(DC.SFDC_LeadID, 3) = '003' THEN FAR.NoShow ELSE CASE WHEN DC.ContactStatusSSID IN ('LEAD','CLIENT','HWLEAD','HWCLIENT','EVENT','PROSPECT', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION') THEN FAR.NoShow ELSE 0 END END AS 'NoShow',
			CASE WHEN LEFT(DC.SFDC_LeadID, 3) = '003' THEN FAR.Sale ELSE CASE WHEN DC.ContactStatusSSID IN ('LEAD','CLIENT','HWLEAD','HWCLIENT','EVENT','PROSPECT', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION') THEN FAR.Sale ELSE 0 END END AS 'Sale',
			CASE WHEN LEFT(DC.SFDC_LeadID, 3) = '003' THEN FAR.NoSale ELSE CASE WHEN DC.ContactStatusSSID IN ('LEAD','CLIENT','HWLEAD','HWCLIENT','EVENT','PROSPECT', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION') THEN FAR.NoSale ELSE 0 END END AS 'NoSale',
			CASE --WHEN FAR.BeBack = 1 AND FAR.SourceKey IN (4157,5536,5537,5538,6013,6014,7112,7113,7114,7115,7116,7117,7118,7119,7206,7497)
				--THEN 1   --BEBACK
							--BOSREFVAN,BOSREFPORT,BOSREFSALT,BOSREFSTLOU,BOSREFTYCO,BOSREFTWSN,BOSREFBUR,
							--BOSREFDTO,BOSREFEDM,BOSREFHAL,BOSREFMIS,BOSREFOTT,BOSREFTOR,BOSREFWIN,BOSREFNOLA, BOSIND
				--WHEN FAR.ActionCodeKey IN(5,15) THEN 0
								--BEBACK, INHOUSE --RH 05/21/2015 Returned INHOUSE to consultations
				WHEN FAR.ActionCodeKey IN(5) AND FAR.ActivityDateKey < 20201201 THEN 0
							--BEBACK
				WHEN FAR.SourceKey IN (4156,6998) AND FAR.ActivityDateKey < 20201201 THEN 0
							--BOSRef
				WHEN FAR.SourceKey IN (4155,4467,4535) AND FAR.ActivityDateKey < 20201201 THEN 0
							--BOSOthRef = BOSDMREF,BOSBIOEMREF,BOSBIODMREF
				WHEN FAR.SourceKey IN (471,1301,1343,1865,3427,9987,10257,21056,21057,21058,21059,21060,21061,21062) AND FAR.ActivityDateKey < 20201201 THEN 0
							--HCRef = CORP REFER,REFERAFRND,STYLEREFER,REGISSTYRFR,NBREFCARD,REFEROTHER
				WHEN LEFT(DC.SFDC_LeadID, 3) = '003' THEN 1
				WHEN LEFT(DC.SFDC_LeadID, 3) <> '003' AND DC.ContactStatusSSID NOT IN ('LEAD','CLIENT','HWLEAD','HWCLIENT','EVENT','PROSPECT', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION') THEN 0
				ELSE FAR.Consultation
				END AS 'Consultation',
			CASE --WHEN FAR.BeBack = 1 AND FAR.SourceKey IN (4157,5536,5537,5538,6013,6014,7112,7113,7114,7115,7116,7117,7118,7119,7206,7497)
					--AND FAR.NoShow <> 1 THEN 0
							--BOSREFVAN,BOSREFPORT,BOSREFSALT,BOSREFSTLOU,BOSREFTYCO,BOSREFTWSN,BOSREFBUR,
							--BOSREFDTO,BOSREFEDM,BOSREFHAL,BOSREFMIS,BOSREFOTT,BOSREFTOR,BOSREFWIN,BOSREFNOLA
				WHEN FAR.BeBack = 1 AND FAR.ActionCodeKey = 15 THEN 0
							--INHOUSE
				WHEN FAR.BeBack = 1 AND (FAR.SourceKey IN (4156,4155,4467,4535,471,1301,10257,1343,1865,3427,9987) AND FAR.ActivityDateKey < 20201201)  THEN 0
							--BOSREF,BOSDMREF,BOSBIOEMREF,BOSBIODMREF,CORP REFER, REFERAFRND, REFEROTHER,STYLEREFER, REGISSTYRFR, NBREFCARD,4Q2016LWEXLD
				WHEN FAR.BeBack = 1 AND (FAR.SourceKey NOT IN (4156,4155,4467,4535,471,1301,10257,1343,1865,3427,9987) AND FAR.ActivityDateKey < 20201201) THEN 1
							--BOSREF,BOSDMREF,BOSBIOEMREF,BOSBIODMREF,CORP REFER, REFERAFRND, REFEROTHER,STYLEREFER, REGISSTYRFR, NBREFCARD,4Q2016LWEXLD
				WHEN FAR.ActionCodeKey = 5 AND (FAR.SourceKey NOT IN (4156,4155,4467,4535,471,1301,10257,1343,1865,3427,9987) AND FAR.ActivityDateKey < 20201201) THEN 1
							--BEBACK & BOSREF,BOSDMREF,BOSBIOEMREF,BOSBIODMREF,CORP REFER, REFERAFRND,REFEROTHER, STYLEREFER, REGISSTYRFR, NBREFCARD ,4Q2016LWEXLD
				ELSE FAR.BeBack
				END AS 'BeBack',
			FAR.BeBack AS 'BebackAlt',
			CASE WHEN FAR.BeBack = 1 AND FAR.ResultCodeKey = 27 THEN 1 ELSE 0 END AS 'BeBackNoShow',
            FAR.SurgeryOffered,
			FAR.ReferredToDoctor,
			FAR.InitialPayment,
			FAR.ActivityEmployeeKey,
			ISNULL(FL.SourceKey, -1) AS 'LeadSourceKey',
			ISNULL(FL.PromotionCodeKey, -1) AS 'PromoCodeKey',
			ISNULL(CASE WHEN FAR.GenderKey = 2 THEN ST.LTVFemale ELSE ST.LTVMale END , 0) AS 'LTValue',
			ISNULL(CASE WHEN FAR.GenderKey = 2 THEN ST.LTVFemaleYearly ELSE ST.LTVMaleYearly END , 0) AS 'LTValueYr',
			CASE WHEN FAR.ActionCodeKey = 15 THEN 1 ELSE 0 END AS 'Inhouse',
			CASE WHEN DS.OwnerType = 'Bosley Consult' THEN 1 ELSE 0 END AS 'BOSAppt',

			CASE WHEN FAR.SourceKey IN (4156,6998) THEN 1 ELSE 0 END AS 'BOSRef',
						--BOSREF
			CASE WHEN FAR.SourceKey IN (4155,4467,4535) THEN 1 ELSE 0 END AS 'BOSOthRef',
						--BOSDMREF,BOSBIOEMREF,BOSBIODMREF
			CASE WHEN FAR.SourceKey IN (471,1301,10257, 1343,1865,3427,9987,21056,21057,21058,21059,21060,21061,21062) THEN 1 ELSE 0 END AS 'HCRef',
						--CORP REFER,REFERAFRND,REFEROTHER,STYLEREFER,REGISSTYRFR,NBREFCARD,4Q2016LWEXLD,Refersion source codes = IPREFCLRERECA12476,IPREFCLRERECA12476DC,IPREFCLRERECA12476DF
						--IPREFCLRERECA12476DP,IPREFCLRERECA12476MC,IPREFCLRERECA12476MF,IPREFCLRERECA12476MP
			ISNULL(FL.LeadCreationDateKey, -1) AS 'LeadCreationDateKey',
			ISNULL(FL.LeadCreationTimeKey, -1) AS 'LeadCreationTimeKey',
			--dc.LeadSource AS 'CommunicationMethod'
			FAR.Accomodation,
			ISNULL(fl.RecentSourceKey,-1) AS 'RecentLeadSourceKey'
FROM         bi_mktg_dds.FactActivityResults AS FAR
			INNER JOIN bi_mktg_dds.DimContact dc
				ON dc.ContactKey = FAR.ContactKey
			INNER JOIN  [HC_BI_ENT_DDS].bief_dds.DimDate AS DE
				ON FAR.ActivityDueDateKey = DE.DateKey
			LEFT OUTER JOIN bi_mktg_dds.FactLead AS FL
				ON FAR.ContactKey = FL.ContactKey
			LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
				ON DS.SourceKey = FL.SourceKey
			LEFT OUTER JOIN bi_mktg_dds.DimSalesType ST
				ON FAR.SalesTypeKey = ST.SalesTypeKey
WHERE     DE.FullDate BETWEEN '01/01/2017' AND DATEADD(dd,0, DATEDIFF(dd,0,GETUTCDATE()))
--GROUP BY DE.FullDate,
--			FAR.ActivityResultDateKey,
--			FAR.ActivityResultKey,
--			FAR.ActivityResultTimeKey,
--			FAR.ActivityKey,
--            FAR.ActivityDateKey,
--			FAR.ActivityTimeKey,
--			FAR.ActivityCompletedDateKey,
--			FAR.ActivityCompletedTimeKey,
--			FAR.ActivityDueDateKey,
--			FAR.ActivityStartTimeKey,
--            FAR.OriginalAppointmentDateKey,
--			FAR.ActivitySavedDateKey,
--			FAR.ActivitySavedTimeKey,
--			FAR.ContactKey,
--			FAR.CenterKey,
--			FAR.SalesTypeKey,
--			FAR.SourceKey,
--			ISNULL(FL.PromotionCodeKey, -1),
--            FAR.ActionCodeKey,
--			FAR.ResultCodeKey,
--			FAR.GenderKey,
--			FAR.OccupationKey,
--			FAR.EthnicityKey,
--			FAR.MaritalStatusKey,
--			FAR.HairLossTypeKey,
--			FAR.AgeRangeKey,
--            FAR.CompletedByEmployeeKey,
--			FAR.ClientNumber,
--			CASE WHEN LEFT(DC.SFDC_LeadID, 3) = '003' THEN FAR.Appointments ELSE CASE WHEN DC.ContactStatusSSID IN ('LEAD','CLIENT','HWLEAD','HWCLIENT','EVENT','PROSPECT', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION') THEN FAR.Appointments ELSE 0 END END,
--			CASE WHEN LEFT(DC.SFDC_LeadID, 3) = '003' THEN FAR.Show ELSE CASE WHEN DC.ContactStatusSSID IN ('LEAD','CLIENT','HWLEAD','HWCLIENT','EVENT','PROSPECT', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION') THEN FAR.Show ELSE 0 END END,
--			CASE WHEN LEFT(DC.SFDC_LeadID, 3) = '003' THEN FAR.NoShow ELSE CASE WHEN DC.ContactStatusSSID IN ('LEAD','CLIENT','HWLEAD','HWCLIENT','EVENT','PROSPECT', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION') THEN FAR.NoShow ELSE 0 END END,
--			CASE WHEN LEFT(DC.SFDC_LeadID, 3) = '003' THEN FAR.Sale ELSE CASE WHEN DC.ContactStatusSSID IN ('LEAD','CLIENT','HWLEAD','HWCLIENT','EVENT','PROSPECT', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION') THEN FAR.Sale ELSE 0 END END,
--			CASE WHEN LEFT(DC.SFDC_LeadID, 3) = '003' THEN FAR.NoSale ELSE CASE WHEN DC.ContactStatusSSID IN ('LEAD','CLIENT','HWLEAD','HWCLIENT','EVENT','PROSPECT', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION') THEN FAR.NoSale ELSE 0 END END
--			,	CASE --WHEN FAR.BeBack = 1 AND FAR.SourceKey IN (4157,5536,5537,5538,6013,6014,7112,7113,7114,7115,7116,7117,7118,7119,7206,7497) THEN 1
--				WHEN FAR.ActionCodeKey IN(5) THEN 0
--				WHEN FAR.SourceKey IN (4156,6998) AND FAR.ActivityDateKey <= 20201201 THEN 0
--				WHEN FAR.SourceKey IN (4155,4467,4535) AND FAR.ActivityDateKey <= 20201201 THEN 0
--				WHEN FAR.SourceKey IN (471,1301,1343,1865,3427,9987,10257,21056,21057,21058,21059,21060,21061,21062) AND FAR.ActivityDateKey <= 20201201 THEN 0
--				WHEN LEFT(DC.SFDC_LeadID, 3) = '003' THEN 1
--				WHEN LEFT(DC.SFDC_LeadID, 3) <> '003' AND DC.ContactStatusSSID NOT IN ('LEAD','CLIENT','HWLEAD','HWCLIENT','EVENT','PROSPECT', 'NEW', 'PURSUING', 'CONVERTED', 'SCHEDULED', 'CONSULTATION') THEN 0
--				ELSE FAR.Consultation
--				END
--			,	CASE --WHEN FAR.BeBack = 1 AND FAR.SourceKey IN (4157,5536,5537,5538,6013,6014,7112,7113,7114,7115,7116,7117,7118,7119,7206,7497)  AND FAR.NoShow <> 1 THEN 0
--				WHEN FAR.BeBack = 1 AND FAR.ActionCodeKey = 15 THEN 0
--				WHEN FAR.BeBack = 1 AND (FAR.SourceKey IN (4156,4155,4467,4535,471,1301,10257,1343,1865,3427,9987) AND FAR.ActivityDateKey <= 20201201) THEN 0
--				WHEN FAR.BeBack = 1 AND (FAR.SourceKey NOT IN (4156,4155,4467,4535,471,1301,10257,1343,1865,3427,9987) AND FAR.ActivityDateKey <= 20201201) THEN 1
--				WHEN FAR.ActionCodeKey = 5 AND (FAR.SourceKey NOT IN (4156,4155,4467,4535,471,1301,10257,1343,1865,3427,9987) AND FAR.ActivityDateKey <= 20201201) THEN 1
--				ELSE FAR.BeBack	END
--			,	FAR.BeBack
--			,	FAR.SurgeryOffered
--			,	FAR.ReferredToDoctor
--			,	FAR.InitialPayment
--			,	FAR.ActivityEmployeeKey
--			,	ISNULL(FL.SourceKey, -1)
--			,	ISNULL(CASE WHEN FAR.GenderKey = 2 THEN ST.LTVFemale ELSE ST.LTVMale END , 0)
--			,	ISNULL(CASE WHEN FAR.GenderKey = 2 THEN ST.LTVFemaleYearly ELSE ST.LTVMaleYearly END , 0)
--          	,	CASE WHEN FAR.ActionCodeKey = 15 THEN 1 ELSE 0 END
--			,	CASE WHEN DS.OwnerType = 'Bosley Consult' THEN 1 ELSE 0 END
--			,	CASE WHEN FAR.SourceKey IN (4156,6998) THEN 1 ELSE 0 END
--			,	CASE WHEN FAR.SourceKey IN (4155,4467,4535) THEN 1 ELSE 0 END
--			,	CASE WHEN FAR.SourceKey IN (471,1301,10257,1343,1865,3427,9987) THEN 1 ELSE 0 END
--			,	ISNULL(FL.LeadCreationDateKey, -1)
--			,	ISNULL(fl.LeadCreationTimeKey, -1)
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties =
   Begin PaneConfigurations =
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane =
      Begin Origin =
         Top = 0
         Left = 0
      End
      Begin Tables =
         Begin Table = "FAR"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 114
               Right = 256
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DD"
            Begin Extent =
               Top = 114
               Left = 417
               Bottom = 349
               Right = 693
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane =
   End
   Begin DataPane =
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 10
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane =
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'bi_mktg_dds', @level1type=N'VIEW',@level1name=N'vwFactActivityResults'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'bi_mktg_dds', @level1type=N'VIEW',@level1name=N'vwFactActivityResults'
GO
