/* CreateDate: 10/04/2019 14:09:30.193 , ModifyDate: 10/04/2019 14:09:30.193 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_dboAddress__c]
    @c1 nvarchar(18),
    @c2 nvarchar(18),
    @c3 nchar(10),
    @c4 nchar(10),
    @c5 nvarchar(250),
    @c6 nvarchar(250),
    @c7 nvarchar(250),
    @c8 nvarchar(250),
    @c9 nvarchar(50),
    @c10 nvarchar(50),
    @c11 nvarchar(50),
    @c12 nvarchar(50),
    @c13 bit,
    @c14 bit,
    @c15 nvarchar(50),
    @c16 bit,
    @c17 nvarchar(18),
    @c18 datetime,
    @c19 nvarchar(18),
    @c20 datetime
as
begin
	insert into [dbo].[Address__c] (
		[Id],
		[Lead__c],
		[OncContactAddressID__c],
		[OncContactID__c],
		[Street__c],
		[Street2__c],
		[Street3__c],
		[Street4__c],
		[City__c],
		[State__c],
		[Zip__c],
		[Country__c],
		[DoNotMail__c],
		[Primary__c],
		[Status__c],
		[IsDeleted],
		[CreatedById],
		[CreatedDate],
		[LastModifiedById],
		[LastModifiedDate]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20	)
end
GO
