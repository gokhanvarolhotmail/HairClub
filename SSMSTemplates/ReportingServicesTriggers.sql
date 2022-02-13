
CREATE TABLE [Log].[dbo_Catalog]
(
    [LogId]          INT                IDENTITY NOT NULL PRIMARY KEY CLUSTERED
  , [LogUser]        VARCHAR(256)       NOT NULL
  , [LogDate]        DATETIME2(7)       NOT NULL
  , [Action]         CHAR(1)            NOT NULL
  , [ItemID]         [UNIQUEIDENTIFIER] NOT NULL
  , [Path]           [NVARCHAR](425)    COLLATE Latin1_General_CI_AS_KS_WS NOT NULL
  , [Name]           [NVARCHAR](425)    COLLATE Latin1_General_CI_AS_KS_WS NOT NULL
  , [ParentID]       [UNIQUEIDENTIFIER] NULL
  , [Type]           [INT]              NOT NULL
  , [Content]        [VARBINARY](MAX)   NULL
  , [Intermediate]   [UNIQUEIDENTIFIER] NULL
  , [SnapshotDataID] [UNIQUEIDENTIFIER] NULL
  , [LinkSourceID]   [UNIQUEIDENTIFIER] NULL
  , [Property]       [NTEXT]            COLLATE Latin1_General_CI_AS_KS_WS NULL
  , [Description]    [NVARCHAR](512)    COLLATE Latin1_General_CI_AS_KS_WS NULL
  , [Hidden]         [BIT]              NULL
  , [CreatedByID]    [UNIQUEIDENTIFIER] NOT NULL
  , [CreationDate]   [DATETIME]         NOT NULL
  , [ModifiedByID]   [UNIQUEIDENTIFIER] NOT NULL
  , [ModifiedDate]   [DATETIME]         NOT NULL
  , [MimeType]       [NVARCHAR](260)    COLLATE Latin1_General_CI_AS_KS_WS NULL
  , [SnapshotLimit]  [INT]              NULL
  , [Parameter]      [NTEXT]            COLLATE Latin1_General_CI_AS_KS_WS NULL
  , [PolicyID]       [UNIQUEIDENTIFIER] NOT NULL
  , [PolicyRoot]     [BIT]              NOT NULL
  , [ExecutionFlag]  [INT]              NOT NULL
  , [ExecutionTime]  [DATETIME]         NULL
  , [SubType]        [NVARCHAR](128)    COLLATE Latin1_General_CI_AS_KS_WS NULL
  , [ComponentID]    [UNIQUEIDENTIFIER] NULL
  , [ContentSize]    [BIGINT]           NULL
) ;
GO
ALTER TRIGGER [dbo].[TRG_Catalog_DEL_Log]
ON [dbo].[Catalog]
INSTEAD OF DELETE
AS
SET NOCOUNT ON ;

IF OBJECT_ID('[tempdb]..[##TRG_Catalog_DEL_Log]') IS NOT NULL
    RETURN ;

CREATE TABLE [##TRG_Catalog_DEL_Log] ( [Id] INT ) ;

INSERT [Log].[dbo_Catalog]( [LogUser]
                          , [LogDate]
                          , [Action]
                          , [ItemID]
                          , [Path]
                          , [Name]
                          , [ParentID]
                          , [Type]
                          , [Content]
                          , [Intermediate]
                          , [SnapshotDataID]
                          , [LinkSourceID]
                          , [Property]
                          , [Description]
                          , [Hidden]
                          , [CreatedByID]
                          , [CreationDate]
                          , [ModifiedByID]
                          , [ModifiedDate]
                          , [MimeType]
                          , [SnapshotLimit]
                          , [Parameter]
                          , [PolicyID]
                          , [PolicyRoot]
                          , [ExecutionFlag]
                          , [ExecutionTime]
                          , [SubType]
                          , [ComponentID]
                          , [ContentSize] )
SELECT
    SUSER_SNAME() AS [LogUser]
  , GETDATE() AS [LogDate]
  , 'D' AS [Action]
  , [d].[ItemID]
  , [d].[Path]
  , [d].[Name]
  , [d].[ParentID]
  , [d].[Type]
  , [d].[Content]
  , [d].[Intermediate]
  , [d].[SnapshotDataID]
  , [d].[LinkSourceID]
  , [d].[Property]
  , [d].[Description]
  , [d].[Hidden]
  , [d].[CreatedByID]
  , [d].[CreationDate]
  , [d].[ModifiedByID]
  , [d].[ModifiedDate]
  , [d].[MimeType]
  , [d].[SnapshotLimit]
  , [d].[Parameter]
  , [d].[PolicyID]
  , [d].[PolicyRoot]
  , [d].[ExecutionFlag]
  , [d].[ExecutionTime]
  , [d].[SubType]
  , [d].[ComponentID]
  , [d].[ContentSize]
FROM [Deleted] AS [d] ;

DELETE [c]
FROM [dbo].[Catalog] AS [c]
INNER JOIN [Deleted] AS [d] ON [d].[ItemID] = [d].[ItemID] ;
GO
ALTER TRIGGER [dbo].[TRG_Catalog_UPD_Log]
ON [dbo].[Catalog]
INSTEAD OF UPDATE
AS
SET NOCOUNT ON ;

IF OBJECT_ID('[tempdb]..[##TRG_Catalog_UPD_Log]') IS NOT NULL
    RETURN ;

CREATE TABLE [##TRG_Catalog_UPD_Log] ( [Id] INT ) ;

INSERT [Log].[dbo_Catalog]( [LogUser]
                          , [LogDate]
                          , [Action]
                          , [ItemID]
                          , [Path]
                          , [Name]
                          , [ParentID]
                          , [Type]
                          , [Content]
                          , [Intermediate]
                          , [SnapshotDataID]
                          , [LinkSourceID]
                          , [Property]
                          , [Description]
                          , [Hidden]
                          , [CreatedByID]
                          , [CreationDate]
                          , [ModifiedByID]
                          , [ModifiedDate]
                          , [MimeType]
                          , [SnapshotLimit]
                          , [Parameter]
                          , [PolicyID]
                          , [PolicyRoot]
                          , [ExecutionFlag]
                          , [ExecutionTime]
                          , [SubType]
                          , [ComponentID]
                          , [ContentSize] )
SELECT
    SUSER_SNAME() AS [LogUser]
  , GETDATE() AS [LogDate]
  , 'U' AS [Action]
  , [d].[ItemID]
  , [d].[Path]
  , [d].[Name]
  , [d].[ParentID]
  , [d].[Type]
  , [d].[Content]
  , [d].[Intermediate]
  , [d].[SnapshotDataID]
  , [d].[LinkSourceID]
  , [d].[Property]
  , [d].[Description]
  , [d].[Hidden]
  , [d].[CreatedByID]
  , [d].[CreationDate]
  , [d].[ModifiedByID]
  , [d].[ModifiedDate]
  , [d].[MimeType]
  , [d].[SnapshotLimit]
  , [d].[Parameter]
  , [d].[PolicyID]
  , [d].[PolicyRoot]
  , [d].[ExecutionFlag]
  , [d].[ExecutionTime]
  , [d].[SubType]
  , [d].[ComponentID]
  , [d].[ContentSize]
FROM [Deleted] AS [d] ;

UPDATE [c]
SET
    [c].[Path] = [i].[Path]
  , [c].[Name] = [i].[Name]
  , [c].[ParentID] = [i].[ParentID]
  , [c].[Type] = [i].[Type]
  , [c].[Content] = [i].[Content]
  , [c].[Intermediate] = [i].[Intermediate]
  , [c].[SnapshotDataID] = [i].[SnapshotDataID]
  , [c].[LinkSourceID] = [i].[LinkSourceID]
  , [c].[Property] = [i].[Property]
  , [c].[Description] = [i].[Description]
  , [c].[Hidden] = [i].[Hidden]
  , [c].[CreatedByID] = [i].[CreatedByID]
  , [c].[CreationDate] = [i].[CreationDate]
  , [c].[ModifiedByID] = [i].[ModifiedByID]
  , [c].[ModifiedDate] = [i].[ModifiedDate]
  , [c].[MimeType] = [i].[MimeType]
  , [c].[SnapshotLimit] = [i].[SnapshotLimit]
  , [c].[Parameter] = [i].[Parameter]
  , [c].[PolicyID] = [i].[PolicyID]
  , [c].[PolicyRoot] = [i].[PolicyRoot]
  , [c].[ExecutionFlag] = [i].[ExecutionFlag]
  , [c].[ExecutionTime] = [i].[ExecutionTime]
  , [c].[SubType] = [i].[SubType]
  , [c].[ComponentID] = [i].[ComponentID]
  , [c].[ContentSize] = [i].[ContentSize]
FROM [dbo].[Catalog] AS [c]
INNER JOIN [Inserted] AS [i] ON [i].[ItemID] = [c].[ItemID] ;
GO
ENABLE TRIGGER [dbo].[TRG_Catalog_DEL_Log] ON [dbo].[Catalog]
GO
ENABLE TRIGGER [dbo].[TRG_Catalog_UPD_Log] ON [dbo].[Catalog]
GO

DISABLE TRIGGER [dbo].[TRG_Catalog_DEL_Log] ON [dbo].[Catalog]
GO
DISABLE TRIGGER [dbo].[TRG_Catalog_UPD_Log] ON [dbo].[Catalog]
GO


DROP TRIGGER [dbo].[TRG_Catalog_DEL_Log] 
GO
