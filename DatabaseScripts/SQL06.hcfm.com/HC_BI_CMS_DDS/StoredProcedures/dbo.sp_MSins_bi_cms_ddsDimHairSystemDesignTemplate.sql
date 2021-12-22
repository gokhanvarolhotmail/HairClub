/* CreateDate: 10/03/2019 23:03:40.583 , ModifyDate: 10/03/2019 23:03:40.583 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_bi_cms_ddsDimHairSystemDesignTemplate]
    @c1 int,
    @c2 nvarchar(50),
    @c3 nvarchar(50),
    @c4 nvarchar(10),
    @c5 int,
    @c6 nchar(1),
    @c7 tinyint,
    @c8 datetime,
    @c9 datetime,
    @c10 varchar(200),
    @c11 tinyint,
    @c12 int,
    @c13 int,
    @c14 uniqueidentifier
as
begin
	insert into [bi_cms_dds].[DimHairSystemDesignTemplate] (
		[HairSystemDesignTemplateKey],
		[HairSystemDesignTemplateSSID],
		[HairSystemDesignTemplateDescription],
		[HairSystemDesignTemplateDescriptionShort],
		[HairSystemDesignTemplateSortOrder],
		[Active],
		[RowIsCurrent],
		[RowStartDate],
		[RowEndDate],
		[RowChangeReason],
		[RowIsInferred],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[msrepl_tran_version]
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
		default,
		@c14	)
end
GO
