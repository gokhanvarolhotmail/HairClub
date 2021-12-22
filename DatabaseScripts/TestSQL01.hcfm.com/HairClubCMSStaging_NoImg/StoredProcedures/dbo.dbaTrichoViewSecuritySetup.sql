/* CreateDate: 09/24/2014 22:38:26.100 , ModifyDate: 03/18/2015 22:59:26.470 */
GO
/***********************************************************************

PROCEDURE:				dbaTrichoViewSecuritySetup

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		09/18/2014

LAST REVISION DATE: 	09/18/2014


--------------------------------------------------------------------------------------------------------
NOTES: 	Sets up security for TrichoView
	* 09/18/14 MVT - Created
	* 10/28/14 MVT - Turned on full TrichoView for 211,244,283
	* 10/31/14 MVT - Added Scalp Health option
	* 11/03/14 MVT - Turned on full TrichoView for 296
	* 11/06/14 MVT - Turned on full TrichoView for 213,225,226
	* 11/07/14 MVT - Turned on full TrichoView for 205
	* 11/11/14 MVT - Turned on full TrichoView for 276
	* 11/12/14 MVT - Turned on full TrichoView for 214,250,267
	* 11/13/14 MVT - Turned on full TrichoView for 249,275,203
	* 11/14/14 MVT - Turned on full TrichoView for 219,202,295,294,204,237
	* 11/18/14 MVT - Turned on full TrichoView for 282
	* 11/19/14 MVT - Turned on full TrichoView for 224,220,209,265
	* 11/20/14 MVT - Turned on full TrichoView for 208,207,216,227,259
	* 11/21/14 MVT - Turned on full TrichoView for 206,268
	* 11/24/14 MVT - Turned on full TrichoView for 215,263,270
	* 11/25/14 MVT - Turned on full TrichoView for 271,281
	* 11/26/14 MVT - Turned on full TrichoView for 274
	* 12/02/14 SAL - Turned on full TrichoView for 239,286
	* 12/02/14 MVT - Turned on full TrichoView for 278
	* 12/03/14 MVT - Turned on full TrichoView for 264
	* 12/04/14 MVT - Turned on full TrichoView for 261,280,293,287,284
	* 12/05/14 MVT - Turned on full TrichoView for 223,290,253,285,230,291
	* 12/09/14 MVT - Turned on full TrichoView for 231,235,292
	* 12/09/14 SAL - Turned on full TrichoView for 286
	* 12/10/14 SAL - Turned on full TrichoView for 260,228,232,289,217
	* 12/11/14 MVT - Turned on full TrichoView for 241,229,242
	* 12/12/14 MVT - Turned on full TrichoView for 258,255
	* 12/15/14 MVT - Turned on full TrichoView for 849,825,890,851,802,809,848,818,819
	* 12/16/14 SAL - Turned on full TrichoView for 234,272,243
	* 12/18/14 SAL - Turned on full TrichoView for 222
	* 12/23/14 SAL - Turned on full TrichoView for 288
	* 01/05/15 SAL - Turned on full TrichoView for 891
	* 01/07/15 SAL - Turned on full TrichoView for 254
	* 01/08/15 SAL - Turned on full TrichoView for 201,251
	* 01/09/15 SAL - Turned on full TrichoView for 221,252
	* 01/16/15 MVT - Modified to Enable Scalp Health and SebuTest for full TrichoView
	* 01/22/15 MVT - Turned on full TrichoView for 240
	* 01/23/15 MVT - Turned on full TrichoView for 212
	* 01/23/15 MVT - Turned on full TrichoView for 218
	* 02/14/15 MVT - Turned on full TrichoView for 896
	* 03/04/15 SAL - Turned on full TrichoView for 210
	* 03/18/15 SAL - Turned on full TrichoView for 256, 257

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC dbaTrichoViewSecuritySetup 0,0,1

***********************************************************************/

CREATE PROCEDURE [dbo].[dbaTrichoViewSecuritySetup]
	  @IsStaging bit
	  , @IsDev bit
	  , @IsLive bit
AS
BEGIN
	SET NOCOUNT ON

	UPDATE cfgConfigurationCenter SET
		[IsEnhSalesConsultEnabled] = 0
		,[LastUpdate] = GETUTCDATE()
		,[LastUpdateUser] = 'sa-tvsec'


	UPDATE [cfgCenterTrichoView] SET
		 [IsProfileAvailable] = 0
		,[IsScalpAvailable] = 0
		,[IsScopeAvailable] = 0
		,[IsDensityAvailable] = 0
		,[IsWidthAvailable] = 0
		,[IsScaleAvailable] = 0
		,[IsHealthAvailable] = 0
		,[IsHMIAvailable] = 0
		,[IsImageEditorAvailable] = 0
		,[IsTrichoViewReportAvailable] = 0
		,[IsSebumAvailable] = 0
		,[IsScalpHealthAvailable] = 0
		,[LastUpdate] = GETUTCDATE()
		,[LastUpdateUser] = 'sa-tvsec'



	IF @IsLive = 1
	BEGIN

		PRINT 'Setting up TrichoView for Live'

		UPDATE cfgConfigurationCenter SET
			[IsEnhSalesConsultEnabled] = 1
			,[LastUpdate] = GETUTCDATE()
			,[LastUpdateUser] = 'sa-tvsec'
		WHERE (CenterID < 300 and CenterID > 200) OR
			(CenterID >= 800 and CenterID NOT IN (804,745,747,811,814,748,821,746,822,807,820,806,817,805))


		UPDATE [cfgCenterTrichoView] SET
			 [IsProfileAvailable] = 1
			,[IsScalpAvailable] = 0
			,[IsScopeAvailable] = 1
			,[IsDensityAvailable] = 0
			,[IsWidthAvailable] = 0
			,[IsScaleAvailable] = 0
			,[IsHealthAvailable] = 0
			,[IsHMIAvailable] = 0
			,[IsImageEditorAvailable] = 0
			,[IsTrichoViewReportAvailable] = 1
			,[IsSebumAvailable] = 0
			,[IsScalpHealthAvailable] = 0
			,[LastUpdate] = GETUTCDATE()
			,[LastUpdateUser] = 'sa-tvsec'
		WHERE (CenterID < 300 and CenterID > 200) OR
				(CenterID >= 800 and CenterID NOT IN (804,745,747,811,814,748,821,746,822,807,820,806,817,805))

		-- Turn on full TrichoView for select centers
		UPDATE [cfgCenterTrichoView] SET
			 [IsProfileAvailable] = 1
			,[IsScalpAvailable] = 1
			,[IsScopeAvailable] = 1
			,[IsDensityAvailable] = 1
			,[IsWidthAvailable] = 1
			,[IsScaleAvailable] = 1
			,[IsHealthAvailable] = 0
			,[IsHMIAvailable] = 1
			,[IsImageEditorAvailable] = 1
			,[IsTrichoViewReportAvailable] = 1
			,[IsSebumAvailable] = 1
			,[IsScalpHealthAvailable] = 1
			,[LastUpdate] = GETUTCDATE()
			,[LastUpdateUser] = 'sa-tvsec'
		WHERE CenterID IN (211,244,283,296,213,225,226,205,276,214,250,267,249,275,203,219,202,
								295,294,204,237,282,224,220,209,265,208,207,216,227,259,206,268,
								215,263,270,271,281,274,239,286,278,264,261,280,293,287,284,
								223,290,253,285,230,291,231,235,292,286,260,228,232,289,217,
								241,229,242,258,255,849,825,890,851,802,809,848,818,819,234,272,
								243,222,288,891,254,201,251,221,252,240,212,218,896,210,256,257)

	END
	ELSE IF @IsStaging = 1 OR @IsDev = 1
	BEGIN

		PRINT 'Setting up TrichoView for Staging/Dev'

		UPDATE cfgConfigurationCenter SET
			[IsEnhSalesConsultEnabled] = 1

		UPDATE [cfgCenterTrichoView] SET
			 [IsProfileAvailable] = 1
			,[IsScalpAvailable] = 1
			,[IsScopeAvailable] = 1
			,[IsDensityAvailable] = 1
			,[IsWidthAvailable] = 1
			,[IsScaleAvailable] = 1
			,[IsHealthAvailable] = 0
			,[IsHMIAvailable] = 1
			,[IsImageEditorAvailable] = 1
			,[IsTrichoViewReportAvailable] = 1
			,[IsSebumAvailable] = 1
			,[IsScalpHealthAvailable] = 1
			,[LastUpdate] = GETUTCDATE()
			,[LastUpdateUser] = 'sa-tvsec'

	END

END
GO
