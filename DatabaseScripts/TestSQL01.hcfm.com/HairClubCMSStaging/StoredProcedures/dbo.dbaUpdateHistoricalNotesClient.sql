/* CreateDate: 11/15/2013 10:27:04.410 , ModifyDate: 02/11/2014 13:35:20.017 */
GO
/***********************************************************************

		PROCEDURE:				dbaUpdateHistoricalNotesClient

		DESTINATION SERVER:		SQL01

		DESTINATION DATABASE: 	HairClubCMS

		RELATED APPLICATION:  	CMS

		AUTHOR: 				Mike Maass

		IMPLEMENTOR: 			Mike Maass

		DATE IMPLEMENTED: 		11/15/2013

		LAST REVISION DATE: 	11/15/2013

		--------------------------------------------------------------------------------------------------------
		NOTES: 	Update NotesClient with latest from CMS 2.5
			* 11/15/2013 MLM - Created Stored Proc

		--------------------------------------------------------------------------------------------------------

		SAMPLE EXECUTION:

		EXEC dbaUpdateHistoricalNotesClient

		***********************************************************************/

		CREATE PROCEDURE [dbo].[dbaUpdateHistoricalNotesClient]
			@CenterID int

		AS
		BEGIN
			SET NOCOUNT ON


			--Update Existing Historical Client Notes
			Update datNotesClient
				SET [NotesClient] = c.[Comment]
					,LastUpdate = GETUTCDATE()
					,LastUpdateUser = 'sa'
			FROM [HCSQL2\SQL2005].[Infostore].[dbo].[Comments] c
				INNER JOIN datClient cl on c.Client_No = cl.ClientNumber_Temp and c.Center = cl.CenterID
				INNER JOIN datNotesClient NC on cl.ClientGUID = nc.ClientGUID
						AND nc.NoteTypeID = 9
			WHERE c.[Comment] IS NOT NULL AND len(rtrim(ltrim(c.[Comment]))) > 0
				AND (cl.CenterID = @CenterID or @CenterID IS NULL)


			--Insert Missing Historical Client Notes.
			INSERT INTO datNotesClient(NotesClientGUID,
					ClientGUID,
					EmployeeGUID,
					AppointmentGUID,
					SalesOrderGUID,
					ClientMembershipGUID,
					NoteTypeID,
					NotesClientDate,
					NotesClient,
					CreateDate,
					CreateUser,
					LastUpdate,
					LastUpdateUser,
					HairSystemOrderGUID)
			SELECT NewID()
				,cl.ClientGUID
				,NULL as EmployeeGUID
				,NULL as AppointmentGUID
				,NULL as SalesOrderGUID
				,NULL as ClientMembershipGUID
				,9 as NoteTypeID --Historical
				,GETUTCDATE() as NotesClientDate
				,c.Comment as NotesClient
				,GETUTCDATE() as CreateDate
				,'sa' as CreateUser
				,GETUTCDATE() as LastUpdate
				,'sa' as LastUpdateUser
				,NULL as HairSystemOrderGUID
			FROM [HCSQL2\SQL2005].[Infostore].[dbo].[Comments] c
				INNER JOIN datClient cl on c.Client_No = cl.ClientNumber_Temp and c.Center = cl.CenterID
				LEFT OUTER JOIN datNotesClient NC on cl.ClientGUID = nc.ClientGUID
						AND nc.NoteTypeID = 9
			WHERE c.[Comment] IS NOT NULL AND len(rtrim(ltrim(c.[Comment]))) > 0
				AND nc.NotesClientGUID IS NULL
				AND (cl.CenterID = @CenterID or @CenterID IS NULL)

 END
GO
