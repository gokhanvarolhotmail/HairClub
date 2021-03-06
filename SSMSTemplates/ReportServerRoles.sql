/* https://stackoverflow.com/questions/63421196/in-ssrs-2019-how-are-taskmask-and-roleflags-to-be-interpreted */
SELECT
    [r].*
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 1), 1) = '1', 1, 0) AS BIT) AS [ConfigureAccess]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 2), 1) = '1', 1, 0) AS BIT) AS [CreateLinkedReports]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 3), 1) = '1', 1, 0) AS BIT) AS [ViewReports]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 4), 1) = '1', 1, 0) AS BIT) AS [ManageReports]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 5), 1) = '1', 1, 0) AS BIT) AS [ViewResources]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 6), 1) = '1', 1, 0) AS BIT) AS [ManageResources]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 7), 1) = '1', 1, 0) AS BIT) AS [ViewFolders]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 8), 1) = '1', 1, 0) AS BIT) AS [ManageFolders]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 9), 1) = '1', 1, 0) AS BIT) AS [ManageSnapshots]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 10), 1) = '1', 1, 0) AS BIT) AS [Subscribe]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 11), 1) = '1', 1, 0) AS BIT) AS [ManageAnySubscription]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 12), 1) = '1', 1, 0) AS BIT) AS [ViewDataSources]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 13), 1) = '1', 1, 0) AS BIT) AS [ManageDataSources]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 14), 1) = '1', 1, 0) AS BIT) AS [ViewModels]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 15), 1) = '1', 1, 0) AS BIT) AS [ManageModels]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 16), 1) = '1', 1, 0) AS BIT) AS [ConsumeReports]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 17), 1) = '1', 1, 0) AS BIT) AS [Comment]
  , CAST(IIF([r].[RoleFlags] = 0 AND RIGHT(LEFT([r].[TaskMask] + '0', 18), 1) = '1', 1, 0) AS BIT) AS [ManageComments]
  , CAST(IIF([r].[RoleFlags] = 1 AND RIGHT(LEFT([r].[TaskMask] + '0', 1), 1) = '1', 1, 0) AS BIT) AS [ManageRoles]
  , CAST(IIF([r].[RoleFlags] = 1 AND RIGHT(LEFT([r].[TaskMask] + '0', 2), 1) = '1', 1, 0) AS BIT) AS [ManageSystemSecurity]
  , CAST(IIF([r].[RoleFlags] = 1 AND RIGHT(LEFT([r].[TaskMask] + '0', 3), 1) = '1', 1, 0) AS BIT) AS [ViewSystemProperties]
  , CAST(IIF([r].[RoleFlags] = 1 AND RIGHT(LEFT([r].[TaskMask] + '0', 4), 1) = '1', 1, 0) AS BIT) AS [ManageSystemProperties]
  , CAST(IIF([r].[RoleFlags] = 1 AND RIGHT(LEFT([r].[TaskMask] + '0', 5), 1) = '1', 1, 0) AS BIT) AS [ViewSharedSchedules]
  , CAST(IIF([r].[RoleFlags] = 1 AND RIGHT(LEFT([r].[TaskMask] + '0', 6), 1) = '1', 1, 0) AS BIT) AS [ManageSharedSchedules]
  , CAST(IIF([r].[RoleFlags] = 1 AND RIGHT(LEFT([r].[TaskMask] + '0', 7), 1) = '1', 1, 0) AS BIT) AS [GenerateEvents]
  , CAST(IIF([r].[RoleFlags] = 1 AND RIGHT(LEFT([r].[TaskMask] + '0', 8), 1) = '1', 1, 0) AS BIT) AS [ManageJobs]
  , CAST(IIF([r].[RoleFlags] = 1 AND RIGHT(LEFT([r].[TaskMask] + '0', 9), 1) = '1', 1, 0) AS BIT) AS [ExecuteReportDefinitions]
  , CAST(IIF([r].[RoleFlags] = 2 AND RIGHT(LEFT([r].[TaskMask] + '0', 1), 1) = '1', 1, 0) AS BIT) AS [ViewModelItems]
FROM [dbo].[Roles] AS [r] ;
