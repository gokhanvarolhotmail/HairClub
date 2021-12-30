/* CreateDate: 05/13/2010 20:10:31.027 , ModifyDate: 05/13/2010 20:10:31.027 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimMembership] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimMembership]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimMembership]()
-----------------------------------------------------------------------
-- Change History
-----------------------------------------------------------------------
-- Version    Date      Author     Description
-- -------  --------  -----------  -------------------------------------
--  v1.0			  RLifke       Initial Creation
-----------------------------------------------------------------------

RETURNS @tbl  TABLE (TableName varchar(150)
					, FieldKey bigint
					, FieldSSID varchar(150)
					)  AS
BEGIN



	DECLARE	 @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_cms_dds].[DimMembership]'

	INSERT INTO @tbl
		SELECT @TableName, [MembershipKey], [MembershipSSID]
		FROM [bi_health].[synHC_DDS_DimMembership] WITH (NOLOCK)
		WHERE [MembershipSSID] NOT
		IN (
				SELECT SRC.MembershipID
				FROM [bi_health].[synHC_SRC_TBL_CMS_cfgMembership] SRC WITH (NOLOCK)
				)
		AND [MembershipKey] <> -1







RETURN
END
GO
