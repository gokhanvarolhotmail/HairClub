/* CreateDate: 07/30/2015 15:49:42.240 , ModifyDate: 07/30/2015 15:49:42.240 */
GO
create procedure [sp_MSins_dboMediaSourceTollFreeNumbers]
    @c1 bit,
    @c2 int,
    @c3 varchar(50),
    @c4 varchar(50),
    @c5 varchar(50),
    @c6 varchar(50),
    @c7 varchar(50),
    @c8 smalldatetime,
    @c9 varchar(200),
    @c10 smallint,
    @c11 tinyint,
    @c12 varchar(50)
as
begin
	insert into [dbo].[MediaSourceTollFreeNumbers](
		[Active],
		[NumberID],
		[Number],
		[SourceCode],
		[HCDNIS],
		[VendorDNIS],
		[VoiceMail],
		[AirDate],
		[Notes],
		[QwestID],
		[NumberTypeID],
		[VendorDNIS2]
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
    @c12	)
end
GO
