/* CreateDate: 05/13/2010 20:06:20.610 , ModifyDate: 05/13/2010 20:06:20.610 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimClientMembership] ()
-----------------------------------------------------------------------
-- [fnHC_CheckExtraRecordsInWarehouse_DimClientMembership]
--
--SELECT * FROM [bi_health].[fnHC_CheckExtraRecordsInWarehouse_DimClientMembership]()
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

 	SET @TableName = N'[bi_cms_dds].[DimClientMembership]'

	INSERT INTO @tbl
		SELECT @TableName, [ClientMembershipKey], [ClientMembershipSSID]
		FROM [bi_health].[synHC_DDS_DimClientMembership]  WITH (NOLOCK)
		WHERE [ClientMembershipSSID] NOT
		IN (
				SELECT SRC.ClientMembershipGUID
				FROM [bi_health].[synHC_SRC_TBL_CMS_datClientMembership] SRC WITH (NOLOCK)
				)
		AND [ClientMembershipKey] <> -1







RETURN
END
GO
