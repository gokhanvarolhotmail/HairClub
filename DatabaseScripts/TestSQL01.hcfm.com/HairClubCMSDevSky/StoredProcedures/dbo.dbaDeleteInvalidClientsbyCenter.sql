/* CreateDate: 01/04/2013 16:54:28.077 , ModifyDate: 02/27/2017 09:49:16.007 */
GO
/***********************************************************************

		PROCEDURE:				dbaDeleteInvalidClientsbyCenter

		DESTINATION SERVER:		SQL01

		DESTINATION DATABASE: 	HairClubCMS

		RELATED APPLICATION:  	CMS

		AUTHOR: 				Kevin Murdoch

		IMPLEMENTOR: 			Kevin Murdoch

		DATE IMPLEMENTED: 		12/21/2012

		LAST REVISION DATE: 	01/15/2013

		--------------------------------------------------------------------------------------------------------
		NOTES: 	Delete invalid client records
			* 12/21/12 KRM - Created Stored Proc
			* 03/02/2015 MVT - Updated proc for Xtrands Business Segment

		--------------------------------------------------------------------------------------------------------

		SAMPLE EXECUTION:

		EXEC dbaDeleteInvalidClientsbyCenter '286'

		***********************************************************************/

		CREATE PROCEDURE [dbo].[dbaDeleteInvalidClientsbyCenter](
			@Center int
		)AS
		BEGIN
			SET NOCOUNT ON

			SELECT cl.clientguid
			INTO #DeletedClients
			FROM datClient cl
				left outer join datsalesorder so with (nolock)
					on cl.clientguid = so.clientguid
				left outer join dathairsystemorder hso with (nolock)
					on cl.clientguid = hso.clientguid
				left outer join dathairsystemordertransaction hsot with (nolock)
					on cl.clientguid = hsot.clientguid
				left outer join datclienteft e with (nolock)
					on cl.clientguid = e.clientguid
				left outer join datClientTransaction ct with (nolock)
					on cl.clientguid = ct.clientguid
				left outer join datappointment ap with (nolock)
					on cl.clientguid = ap.clientguid
				--left outer join dbaclientprofitability cp with (nolock)
				--	on cl.clientguid = cp.clientguid
				left outer join datnotification n with (nolock)
					on cl.clientguid = n.clientguid
				left outer join dattechnicalprofilehistory tph with (nolock)
					on cl.clientguid = tph.clientguid
				left outer join datpaycycletransaction pct with (nolock)
					on cl.clientguid = pct.clientguid
				left outer join datAccountReceivable art with (nolock)
					on cl.clientguid = art.clientguid

			WHERE
				so.SalesOrderGUID is null
				and hso.hairsystemorderguid is null
				and hsot.hairsystemordertransactionguid is null
				and e.clienteftguid is null
				and ct.clienttransactionguid is null
				and ap.appointmentguid is null
				--and cp.clientprofitabilityid is null
				and n.notificationid is null
				and tph.technicalprofilehistoryguid is null
				and pct.paycycletransactionguid is null
				and art.accountreceivableid is null
				and cl.centerid = @Center
				and cl.createdate < '07/01/2008'

				UPDATE CL
				set [CurrentBioMatrixClientMembershipGUID] = null,
					[CurrentSurgeryClientMembershipGUID] = null,
					[CurrentExtremeTherapyClientMembershipGUID] = null,
					[CurrentXtrandsTherapyClientMembershipGUID] = null
				FROM datclient CL
					INNER JOIN #DeletedClients dc
						on CL.ClientGUID = dc.ClientGUID

				update hsot
				set PreviousClientMembershipGUID = hsot.clientmembershipguid
				--select *
				from dathairsystemorderTransaction hsot
					inner join datclientmembership clm
						on hsot.PreviousClientMembershipGUID = clm.clientmembershipguid
					inner join datclient cl
						on clm.clientguid = cl.clientguid
					inner join #DeletedClients dc
						on cl.clientguid = dc.clientguid

				update hso
				set hso.OriginalClientMembershipGUID = hso.clientmembershipguid
				--select *
				from dathairsystemorder hso
					inner join datclientmembership clm
						on hso.OriginalClientMembershipGUID = clm.clientmembershipguid
					inner join datclient cl
						on clm.clientguid = cl.clientguid
					inner join #DeletedClients dc
						on cl.clientguid = dc.clientguid

				update itr
				set itr.FromClientMembershipGUID = itr.toClientMembershipGUID
				--select *
				from datInventoryTransferRequest itr
					inner join datclientmembership clm
						on itr.FromClientMembershipGUID = clm.clientmembershipguid
					inner join datclient cl
						on clm.clientguid = cl.clientguid
					inner join #DeletedClients dc
						on cl.clientguid = dc.clientguid

				DELETE CLMA
				FROM datclientMembership CLM
					INNER JOIN #DeletedClients dc
						on CLM.ClientGUID = dc.ClientGUID
					INNER JOIN datClientMembershipAccum CLMA
						ON CLM.ClientmembershipGUID = CLMA.ClientmembershipGUID


				DELETE CLM
				FROM datclientMembership CLM
					INNER JOIN #DeletedClients dc
						on CLM.ClientGUID = dc.ClientGUID

				DELETE CLN
				FROM datNotesClient CLN
					INNER JOIN #DeletedClients dc
						on CLN.ClientGUID = dc.ClientGUID

				UPDATE hso
				set hso.OriginalClientGUID = hso.ClientGUID
				--select *
				from dathairsystemorder hso
					inner join #DeletedClients dc
						on hso.originalclientguid = dc.clientguid

				DELETE CL
				FROM datclient CL
					INNER JOIN #DeletedClients dc
						on CL.ClientGUID = dc.ClientGUID
		END
GO
