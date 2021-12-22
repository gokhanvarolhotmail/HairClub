/* CreateDate: 12/27/2019 12:36:56.217 , ModifyDate: 12/27/2019 12:36:56.217 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSins_dboZipCode__c]
    @c1 nvarchar(18),
    @c2 nvarchar(255),
    @c3 nchar(4),
    @c4 nvarchar(255),
    @c5 nvarchar(80),
    @c6 nchar(4),
    @c7 nvarchar(255),
    @c8 nvarchar(255),
    @c9 bit,
    @c10 nvarchar(18),
    @c11 datetime,
    @c12 nvarchar(18),
    @c13 datetime
as
begin
	insert into [dbo].[ZipCode__c] (
		[Id],
		[City__c],
		[State__c],
		[County__c],
		[Name],
		[Country__c],
		[DMA__c],
		[Timezone__c],
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
		@c13	)
end
GO
