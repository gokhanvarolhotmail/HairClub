/* CreateDate: 05/06/2013 22:24:24.330 , ModifyDate: 05/08/2013 14:53:45.250 */
GO
/***********************************************************************

PROCEDURE:	spApp_CMSCreateNewClient

DESTINATION SERVER:

DESTINATION DATABASE:

AUTHOR: Alex Pasieka

IMPLEMENTOR:

DATE IMPLEMENTED: 9/08/2008

LAST REVISION DATE: 9/08/2008

--------------------------------------------------------------------------------------------------------
NOTES:
	05/08/2013 - MB - Changed to call procedure from HCSQL2\SQL2005 to create CMS 2.5 client
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:

EXEC spApp_CMSCreateNewClient
	'123 Main St.'
,	'561'
,	'232'
,	'Boca Raton'
,	'12345'
,	''
,	'M'
,	'Mike'
,	'Blike'
,	'123-4567'
,	'FL'
,	'33431'
***********************************************************************/


CREATE PROCEDURE [dbo].[spApp_CMSCreateNewClient]
	@Address		varchar(50)
,	@AreaCode		char(3)
,	@CenterNumber	varchar(5)
,	@City			varchar(50)
,	@ContactID		varchar(50)
,	@EmailAddress	varchar(100)
,	@Gender			char(1)
,	@LastName		varchar(50)
,	@FirstName		varchar(50)
,	@PhoneNumber	varchar(20)
,	@State			char(2)
,	@Zip			varchar(10)
AS
DECLARE
	@PackagePath	varchar(1000)
,	@cmd			varchar(4000)
BEGIN
	IF @CenterNumber LIKE '2%'
	BEGIN
		INSERT INTO [CMSCreateClientLog](
			[Address]
		,	AreaCode
		,	CenterNumber
		,	City
		,	ContactID
		,	EmailAddress
		,	Gender
		,	LastName
		,	FirstName
		,	PhoneNumber
		,	[State]
		,	Zip
		,	IsProcessed
		,	CreateDate
		) VALUES (
			@Address
		,	@AreaCode
		,	@CenterNumber
		,	@City
		,	@ContactID
		,	@EmailAddress
		,	@Gender
		,	@LastName
		,	@FirstName
		,	@PhoneNumber
		,	@State
		,	@Zip
		,	0
		,	GETDATE()
		)
	END

END
GO
