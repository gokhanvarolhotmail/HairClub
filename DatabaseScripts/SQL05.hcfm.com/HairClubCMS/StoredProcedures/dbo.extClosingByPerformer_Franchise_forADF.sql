/* CreateDate: 10/15/2021 10:28:31.203 , ModifyDate: 11/04/2021 17:10:00.517 */
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--EXEC [dbo].[extClosingByPerformer_Franchise_forADF]
CREATE PROCEDURE [dbo].[extClosingByPerformer_Franchise_forADF](
	@Center varchar(10) = NULL

)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



			--IF OBJECT_ID('tempdb..#task2', N'U') IS NOT NULL
			--	DROP TABLE #task2;
			--GO

			--IF OBJECT_ID('tempdb..#SalesData', N'U') IS NOT NULL
			--	DROP TABLE #SalesData;
			--GO


			--IF OBJECT_ID('tempdb..#Final', N'U') IS NOT NULL
			--	DROP TABLE #Final;
			--GO


			--IF OBJECT_ID('tempdb..#Center', N'U') IS NOT NULL
			--	DROP TABLE #Center;
			--GO


			--IF OBJECT_ID('tempdb..#FinalDs', N'U') IS NOT NULL
			--	DROP TABLE #FinalDs;
			--GO

			SELECT ctr.CenterKey
				 , ctr.CenterSSID
				 , ctr.CenterNumber
				 , ctr.CenterDescription
			INTO #Center
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					 INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct
								ON ct.CenterTypeSSID = ctr.CenterTypeSSID
			WHERE CT.CenterTypeDescriptionShort IN ('F', 'JV')
              AND ctr.Active = 'Y'



			SELECT dd.FullDate,
				   clt.ClientSSID                                 as ClientGUID,
				   clt.ClientIdentifier,
				   clt.ClientFirstName + ' ' + clt.ClientLastName as ClientFullName,
				   clt.ClientEMailAddress,
				   c.CenterNumber,
				   c.CenterDescription,
				   de.FirstName + ' ' + de.LastName               as OrderPerformerCNCT,
				   de2.FirstName + ' ' + de2.LastName             as ConsultationPerformerCNCT,
				   sc.SalesCodeDescription,
				   dso.SalesOrderGUID,
				   da.SalesforceTaskID,
				   dso.AppointmentGUID,
				   SUM(ISNULL(fst.NB_AppsCnt, 0))                 AS 'NB1Applications'
					,
				   SUM(ISNULL(fst.NB_GrossNB1Cnt, 0)) +
				   SUM(ISNULL(fst.NB_MDPCnt, 0))                  AS 'GrossNB1Count'
					,
				   (SUM(ISNULL(fst.NB_TradCnt, 0)) + SUM(ISNULL(fst.NB_GradCnt, 0)) + SUM(ISNULL(fst.NB_ExtCnt, 0)) +
					SUM(ISNULL(fst.S_PostExtCnt, 0)) + SUM(ISNULL(fst.NB_XTRCnt, 0)) + SUM(ISNULL(fst.S_SurCnt, 0)) +
					SUM(ISNULL(fst.NB_MDPCnt, 0)) +
					SUM(ISNULL(fst.S_PRPCnt, 0)))                 AS 'NetNB1Count'
					,
				   (SUM(ISNULL(fst.NB_TradAmt, 0)) + SUM(ISNULL(fst.NB_GradAmt, 0)) + SUM(ISNULL(fst.NB_ExtAmt, 0)) +
					SUM(ISNULL(fst.S_PostExtAmt, 0)) + SUM(ISNULL(fst.NB_XTRAmt, 0)) + SUM(ISNULL(fst.NB_MDPAmt, 0)) +
					SUM(ISNULL(fst.NB_LaserAmt, 0)) + SUM(ISNULL(fst.S_SurAmt, 0)) +
					SUM(ISNULL(fst.S_PRPAmt, 0)))                 AS 'NetNB1Sales',
				   sod.ExtendedPriceCalc,
				   sod.Price,
				   sod.Discount,
				   sod.Tax1,
				   sod.Tax2,
				   sod.TaxRate1,
				   sod.TaxRate2,
				   sod.PriceTaxCalc,
				   sod.TotalTaxCalc,
				   sot.SalesOrderTypeDescription as OrderType,
				   sod.SalesCodeDescription as OrderDescription,
				   m.MembershipDescription
			into #SalesData
			FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst --???????
					 INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
								ON dd.DateKey = fst.OrderDateKey
					 INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc ---???
								ON sc.SalesCodeKey = fst.SalesCodeKey
					 INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd ----???
								ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
					 INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so ---????
								ON so.SalesOrderKey = fst.SalesOrderKey
					 INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod ---???
								ON sod.SalesOrderDetailKey = fst.SalesOrderDetailKey
					 INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm ---???
								ON cm.ClientMembershipKey = so.ClientMembershipKey
					 INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m ---????
								ON m.MembershipKey = cm.MembershipKey
					 INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr ---???
								ON ctr.CenterKey = cm.CenterKey
					 INNER JOIN #Center c
								ON c.CenterNumber = ctr.CenterNumber
					 INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt ----???
								ON clt.ClientKey = fst.ClientKey
					 LEFT JOIN HairClubCMS.dbo.datSalesOrder dso on dso.SalesOrderGUID = so.SalesOrderSSID
					 LEFT JOIN HairClubCMS.[dbo].[lkpSalesOrderType] sot on dso.SalesOrderTypeID = sot.SalesOrderTypeID
					 left join HairClubCMS.dbo.datAppointment da on da.AppointmentGUID = dso.AppointmentGUID
					 left join HairClubCMS.dbo.datEmployee de on sod.Employee1SSID = de.EmployeeGUID
					 left join HairClubCMS.dbo.datAppointmentEmployee dae on dae.AppointmentGUID = da.AppointmentGUID
					 left join HairClubCMS.dbo.datEmployee de2 on de2.EmployeeGUID = dae.EmployeeGUID
			WHERE dd.FullDate BETWEEN '2021-06-15' aND getdate()
			  AND sc.SalesCodeKey NOT IN (665, 654, 393, 668)
			  AND so.IsVoidedFlag = 0
			GROUP BY dd.FullDate, c.CenterNumber, c.CenterDescription, de.FirstName + ' ' + de.LastName,
					 de2.FirstName + ' ' + de2.LastName, sc.SalesCodeDescription, dso.SalesOrderGUID, da.SalesforceTaskID,
					 dso.AppointmentGUID, sod.ExtendedPriceCalc, sod.Price, sod.Discount, sod.PriceTaxCalc, sod.Tax1,
					 sod.Tax2, sod.TaxRate1, sod.TaxRate2, sod.TotalTaxCalc, clt.ClientSSID,
					 clt.ClientIdentifier,
					 clt.ClientFirstName + ' ' + clt.ClientLastName, clt.ClientEMailAddress, sot.SalesOrderTypeDescription,sod.SalesCodeDescription,
					 m.MembershipDescription



			SELECT CAST(t.ActivityDate AS DATE)   AS 'FullDate'
				 , t.Id
				 , ISNULL(t.CenterNumber__c, 100) as centerNumber
				 , c.CenterDescription
				 , t.Action__c
				 , t.Result__c
				 , t.SourceCode__c
				 , t.Accommodation__c
				 , CASE
					   WHEN (
							   (
									   t.Action__c = 'Be Back'
									   OR t.SourceCode__c IN
										  ('REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF', 'BOSREF',
										   'BOSBIOEMREF', 'BOSNCREF', '4Q2016LWEXLD', 'REFEROTHER', 'IPREFCLRERECA12476',
										   'IPREFCLRERECA12476DC', 'IPREFCLRERECA12476DF', 'IPREFCLRERECA12476DP',
										   'IPREFCLRERECA12476MC', 'IPREFCLRERECA12476MF', 'IPREFCLRERECA12476MP'
											  )
								   )
							   AND t.ActivityDate < '12/1/2020'
						   ) THEN 1
					   ELSE 0
				END                               AS 'ExcludeFromConsults'
				 , CASE
					   WHEN t.SourceCode__c IN
							('CORP REFER', 'REFERAFRND', 'STYLEREFER', 'REGISSTYRFR', 'NBREFCARD', 'BOSDMREF', 'BOSREF',
							 'BOSBIOEMREF', 'BOSBIODMREF', '4Q2016LWEXLD', 'REFEROTHER'
								) AND t.ActivityDate < '12/1/2020' THEN 1
					   ELSE 0
				END                               AS 'ExcludeFromBeBacks'
				 , CASE
					   WHEN (t.Action__c = 'Be Back' AND t.ActivityDate < '12/1/2020') THEN 1
					   ELSE 0
				END                               AS 'BeBacksToExclude'
			into #task2
			FROM sql06.HC_BI_SFDC.dbo.VWTask_MS t
					 INNER JOIN #Center c
								ON c.CenterNumber = ISNULL(t.CenterNumber__c, 100)
				 --  LEFT OUTER JOIN HC_BI_SFDC.dbo.Lead l ---??
				 --                 ON l.Id = t.WhoId
				 --  LEFT OUTER JOIN HC_BI_SFDC.dbo.Account a ---??? sf new def??
				 --                 ON a.PersonContactId = t.WhoId
			WHERE LTRIM(RTRIM(t.Action__c)) IN ('Appointment', 'Be Back', 'In House', 'Recovery')
			  AND CAST(t.ActivityDate AS DATE) BETWEEN '2021-06-15' AND getdate()
			  AND ISNULL(t.IsDeleted, 0) = 0


			select sd.FullDate                          as OrderDate,
				   ft.FullDate                          as ConsultationDate,
				   sd.SalesOrderGUID,
				   sum(sd.NetNB1Count)                  as NetNB1Count,
				   sum(sd.GrossNB1Count)                as GrossNB1Count,
				   sum(sd.NetNB1Sales)                  as NetNB1Sales,
				   sum(isnull(sd.ExtendedPriceCalc, 0)) as ExtendedPriceCalc,
				   sum(isnull(sd.Price, 0))             as Price,
				   sum(isnull(sd.Discount, 0))          as Discount,
				   sum(isnull(sd.PriceTaxCalc, 0))      as PriceTaxCalc,
				   sum(isnull(sd.Tax1, 0))              as Tax1,
				   sum(isnull(sd.Tax2, 0))              as Tax2,
				   sum(isnull(sd.TaxRate1, 0))          as TaxRate1,
				   sum(isnull(sd.TaxRate2, 0))          as TaxRate2,
				   sum(isnull(sd.TotalTaxCalc, 0))      as TotalTaxCalc,
				   sd.OrderType,
				   sd.OrderDescription,
				   sd.MembershipDescription,
				   sd.ClientGUID,
				   sd.ClientIdentifier,
				   sd.ClientFullName,
				   sd.ClientEMailAddress,
				   sd.CenterDescription                    OrderCenterDescription,
				   sd.CenterNumber                         OrderCenterNumber,
				   ft.centerNumber                      as ConsultationCenterNumber,
				   ft.CenterDescription                 as ConsultationCenterDescription,
				   ft.Accommodation__c                  as accomodation,
				   ft.result__c                         as ConsultationResult,
				   fa.OpportunityID,
				   sa.appointmentNumber,
				   sd.ConsultationPerformerCNCT,
				   sd.OrderPerformerCNCT,
				   sd.AppointmentGUID,
				   fa.accountID,
				   fa.LeadID,
				   ft.id                                   ConsultationID,
				   CASE
					   WHEN ISNULL(ft.Result__c, '') IN ('Completed', 'Show Sale', 'Show No Sale') AND
							ISNULL(ft.ExcludeFromConsults, 0) = 0 and
							ISNULL(ft.Action__c, '') in ('Appointment', 'In House', 'Recovery', 'be back')
						   THEN 1
					   ELSE 0 END                       AS 'Consultations',
				   CASE
					   WHEN
							   (ISNULL(ft.Accommodation__c, 'In Person Consult') = 'In Person Consult' or
								ft.Accommodation__c like 'center%' or
								ft.Accommodation__c = 'Company') AND
							   ISNULL(ft.Result__c, '') IN
							   ('Completed', 'Show No Sale', 'Show Sale') and
							   ISNULL(ft.Action__c, '') in
							   ('Appointment', 'In House', 'Recovery', 'Be Back') and
							   --ISNULL(t.Result__c, '') IN ('Show No Sale', 'Show Sale') AND
							   ISNULL(ft.ExcludeFromConsults, 0) = 0
						   THEN 1
					   ELSE 0 END                       AS 'InPersonConsultations'
					,
				   CASE
					   WHEN ((ISNULL(ft.Accommodation__c, 'In Person Consult') like 'virtual%' or
							  ISNULL(ft.Accommodation__c, 'In Person Consult') like 'Video%')) AND
							ISNULL(ft.Result__c, '') IN ('Completed', 'Show No Sale', 'Show Sale') and
							ISNULL(ft.Action__c, '') in ('Appointment', 'In House', 'Recovery', 'Be Back') and
						   -- ISNULL(t.Result__c, '') IN ('Show No Sale', 'Show Sale') AND
							ISNULL(ft.ExcludeFromConsults, 0) = 0
						   THEN 1
					   ELSE 0 END                       AS 'VirtualConsultations'
			into #FinalDs
			from #salesdata sd
					 full outer join #task2 ft
									 on ft.id = sd.SalesforceTaskID
					 left join sql06.HC_BI_SFDC.Synapse_pool.FactAppointment fa on ft.Id = fa.AppointmentId
					 left join sql06.HC_BI_SFDC.dbo.ODS_SF_ServiceAppointment sa on ft.id = sa.id
			where (ft.FullDate between '2021-06-15' AND getdate())
			   or (sd.FullDate between '2021-06-15' AND getdate())
			group by sd.FullDate, ft.FullDate, sd.CenterDescription, sd.CenterNumber, sd.ConsultationPerformerCNCT,
					 sd.OrderPerformerCNCT, sd.AppointmentGUID,
					 ft.id, ft.centerNumber,
					 ft.CenterDescription, ft.Accommodation__c, ft.result__c, fa.OpportunityID, sa.appointmentNumber, fa.accountID,
					 FA.LeadID, sd.ClientGUID,
					 sd.ClientIdentifier,
					 sd.ClientFullName,
					 sd.ClientEMailAddress,
					 sd.SalesOrderGUID,
					 sd.OrderType,
					 sd.OrderDescription,
					 sd.MembershipDescription,
					 CASE
						 WHEN ((ISNULL(ft.Accommodation__c, 'In Person Consult') like 'virtual%' or
								ISNULL(ft.Accommodation__c, 'In Person Consult') like 'Video%')) AND
							  ISNULL(ft.Result__c, '') IN ('Completed', 'Show No Sale', 'Show Sale') and
							  ISNULL(ft.Action__c, '') in ('Appointment', 'In House', 'Recovery', 'Be Back') and
							 -- ISNULL(t.Result__c, '') IN ('Show No Sale', 'Show Sale') AND
							  ISNULL(ft.ExcludeFromConsults, 0) = 0
							 THEN 1
						 ELSE 0 END,
					 CASE
						 WHEN
								 (ISNULL(ft.Accommodation__c, 'In Person Consult') = 'In Person Consult' or
								  ft.Accommodation__c like 'center%' or
								  ft.Accommodation__c = 'Company') AND
								 ISNULL(ft.Result__c, '') IN
								 ('Completed', 'Show No Sale', 'Show Sale') and
								 ISNULL(ft.Action__c, '') in
								 ('Appointment', 'In House', 'Recovery', 'Be Back') and
								 --ISNULL(t.Result__c, '') IN ('Show No Sale', 'Show Sale') AND
								 ISNULL(ft.ExcludeFromConsults, 0) = 0
							 THEN 1
						 ELSE 0 END,
					 CASE
						 WHEN ISNULL(ft.Result__c, '') IN ('Completed', 'Show Sale', 'Show No Sale') AND
							  ISNULL(ft.ExcludeFromConsults, 0) = 0 and
							  ISNULL(ft.Action__c, '') in ('Appointment', 'In House', 'Recovery', 'be back')
							 THEN 1
						 ELSE 0 END


			select ConsultationDate,
				   OrderDate,
				   sum(isnull(NetNB1Count, 0))              as NetNB1Count,
				   sum(isnull(GrossNB1Count, 0))            as GrossNB1Count,
				   sum(isnull(NetNB1Sales, 0))              as NetNB1Sales,
				   sum(isnull(ExtendedPriceCalc, 0))        as ExtendedPriceCalc,
				   sum(isnull(Price, 0))                    as Price,
				   sum(isnull(Discount, 0))                 as Discount,
				   sum(isnull(PriceTaxCalc, 0))             as PriceTaxCalc,
				   sum(isnull(Tax1, 0))                     as Tax1,
				   sum(isnull(Tax2, 0))                     as Tax2,
				   sum(isnull(TaxRate1, 0))                 as TaxRate1,
				   sum(isnull(TaxRate2, 0))                 as TaxRate2,
				   sum(isnull(TotalTaxCalc, 0))             as TotalTaxCalc,
				   OrderType,
				   OrderDescription,
				   MembershipDescription,
				   --ClientGUID,
				   ClientIdentifier,
				   ClientFullName,
				   ClientEMailAddress,
				   OrderCenterDescription,
				   OrderCenterNumber,
				   ConsultationCenterNumber,
				   accomodation,--AppoitnemtnType
				   CASE WHEN sa.AppointmentType in ('video','Virtual','Center;Virtual') THEN 'Virtual'
						WHEN sa.AppointmentType in ('Center','company') THEN 'Center' ELSE '' END AS AppointmentType,
				   ConsultationResult,
				   --OpportunityID,
				   f.appointmentNumber,
				   ConsultationPerformerCNCT,
				   OrderPerformerCNCT,
				   sr.Name                                  as SFPerformer,
				   a.FirstName + ' ' + a.lastname           as PersonAccountFullName,
				   dl.LeadFirstName + ' ' + dl.LeadLastName as LeadFullName,
				   f.accountID
				   --f.LeadID,
				  -- ConsultationID                           as ServiceAppointmentID,
				  -- Consultations                            as IsConsultation,
				  -- InPersonConsultations,
				  -- VirtualConsultations
			into #final
			from #FinalDs f
					 left join sql06.HC_BI_SFDC.dbo.ODS_SF_ServiceAppointment sa on sa.id = f.ConsultationID
					 left join sql06.HC_BI_SFDC.dbo.ODS_SF_Account a on a.id = f.accountID
					 left join sql06.HC_BI_SFDC.synapse_pool.DimLead dl on dl.leadid = f.LeadID
					 left join sql06.HC_BI_SFDC.synapse_pool.AssignedResource ar on ar.ServiceAppointmentID = f.ConsultationID
					 left join sql06.HC_BI_SFDC.synapse_pool.ServiceResource sr on sr.id = ar.serviceresourceID
			group by OrderCenterDescription, ConsultationDate, OrderCenterNumber, ConsultationCenterNumber, accomodation,
					 ConsultationResult,
					 --OpportunityID,
					 f.appointmentNumber, ConsultationPerformerCNCT, OrderPerformerCNCT,
					 --ConsultationID,
					 InPersonConsultations, VirtualConsultations, f.accountID,
					 --f.LeadID,
					 --Consultations,
					 --InPersonConsultations,
					 --VirtualConsultations,
					 a.FirstName + ' ' + a.lastname,
					 dl.LeadFirstName + ' ' + dl.LeadLastName, sr.Name, --ClientGUID,
					 ClientIdentifier,
					 ClientFullName,
					 ClientEMailAddress,OrderDate,sa.AppointmentType,OrderDescription,OrderType,MembershipDescription



			select Accomodation,AppointmentType,ConsultationPerformerCNCT,OrderPerformerCNCT,SFPerformer,ClientIdentifier into #Updatetable
			from #final
			where OrderDescription = 'Assign Membership'

			update #final
			set Accomodation = a.Accomodation
			,AppointmentType = a.AppointmentType
			,ConsultationPerformerCNCT  = a.ConsultationPerformerCNCT
			,OrderPerformerCNCT = a.OrderPerformerCNCT
			,SFPerformer = a.SFPerformer
			from #Updatetable a
			where #final.ClientIdentifier = a.ClientIdentifier and OrderDescription <> 'Assign Membership'



			truncate table dbo.ClosingByPerformer_Franchise_forADF

			insert into dbo.ClosingByPerformer_Franchise_forADF(
						[ConsultationDate]
				  ,[OrderDate]
				  ,[NetNB1Count]
				  ,[GrossNB1Count]
				  ,[NetNB1Sales]
				  ,[ExtendedPriceCalc]
				  ,[Price]
				  ,[Discount]
				  ,[PriceTaxCalc]
				  ,[Tax1]
				  ,[Tax2]
				  ,[TaxRate1]
				  ,[TaxRate2]
				  ,[TotalTaxCalc]
				  ,OrderType
				  ,OrderDescription
				  ,MembershipDescription
				  ,[ClientIdentifier]
				  ,[ClientFullName]
				  ,[ClientEMailAddress]
				  ,[OrderCenterDescription]
				  ,[OrderCenterNumber]
				  ,[ConsultationCenterNumber]
				  ,[accomodation]
				  ,[AppoitnemtnType]
				  ,[ConsultationResult]
				  ,[appointmentNumber]
				  ,[ConsultationPerformerCNCT]
				  ,[OrderPerformerCNCT]
				  ,[SFPerformer]
				  ,[PersonAccountFullName]
				  ,[LeadFullName]
				  ,[accountID])
			Select
				[ConsultationDate]
				,[OrderDate]
				,[NetNB1Count]
				,[GrossNB1Count]
				,[NetNB1Sales]
				,[ExtendedPriceCalc]
				,[Price]
				,[Discount]
				,[PriceTaxCalc]
				,[Tax1]
				,[Tax2]
				,[TaxRate1]
				,[TaxRate2]
				,[TotalTaxCalc]
				,OrderType
				,OrderDescription
				,MembershipDescription
				,[ClientIdentifier]
				,[ClientFullName]
				,[ClientEMailAddress]
				,[OrderCenterDescription]
				,[OrderCenterNumber]
				,[ConsultationCenterNumber]
				,[accomodation]
				,AppointmentType
				,[ConsultationResult]
				,[appointmentNumber]
				,[ConsultationPerformerCNCT]
				,[OrderPerformerCNCT]
				,[SFPerformer]
				,[PersonAccountFullName]
				,[LeadFullName]
				,[accountID]
			from #Final
			where ConsultationResult in ('Show Sale','Show No Sale','Rescheduled','Completed','Weather') or ConsultationResult is null
END
GO
