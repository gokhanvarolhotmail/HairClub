/* CreateDate: 05/12/2010 11:11:19.503 , ModifyDate: 12/10/2012 17:24:55.647 */
GO
CREATE    FUNCTION [bi_health].[fnHC_CheckInferredCount_DimClientMembership] ()
-----------------------------------------------------------------------
-- [fnHC_CheckInferredCount_DimClientMembership]
--
--SELECT * FROM [bi_health].[fnHC_CheckInferredCount_DimClientMembership]()
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



	DECLARE	  @TableName				varchar(150)	-- Name of table

 	SET @TableName = N'[bi_cms_dds].[DimClientMembership]'


	INSERT INTO @tbl
		SELECT @TableName, ClientMembershipKey, CAST(ClientMembershipSSID as varchar(150))
		FROM [bi_health].[synHC_DDS_DimClientMembership] DW WITH (NOLOCK)
		WHERE DW.[RowIsInferred] = 1 and ClientMembershipKey<>-1


	--SELECT COUNT(*)
	--FROM [bi_health].[synHC_DDS_DimClientMembership] DW WITH (NOLOCK)
	--WHERE DW.[RowIsInferred] = 1




RETURN
END
GO
