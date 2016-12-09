USE [msdb]
GO

/****** Object:  Job [Back Up Database SES, DiscountShop and TerminalSAP: Wed Sat]    Script Date: 12/11/2015 15:05:31 ******/
IF  EXISTS (SELECT job_id FROM msdb.dbo.sysjobs_view WHERE name = N'Back Up Database SES, DiscountShop and TerminalSAP: Wed Sat')
EXEC msdb.dbo.sp_delete_job @job_id=N'1207f1b4-706a-49e3-990e-6c80b895bb43', @delete_unused_schedule=1
GO

USE [msdb]
GO

/****** Object:  Job [Back Up Database SES, DiscountShop and TerminalSAP: Wed Sat]    Script Date: 12/11/2015 14:59:29 ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]]    Script Date: 12/11/2015 14:59:29 ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'Back Up Database SES, DiscountShop and TerminalSAP: Wed Sat', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Выполнение полного резервного копирования БД: SES, DiscountShop и TerminalSAP с последующим архивированием и переносом на резервный сервер.', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'DIXY\backup', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [backup ses, discountshop and terminalsap]    Script Date: 12/11/2015 14:59:30 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'backup ses, discountshop and terminalsap', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'BACKUP DATABASE [SES] TO  DISK = N''E:\dbbackup\SES.bak'' WITH NOFORMAT, INIT,  NAME = N''SES-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N''SES'' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N''SES'' )
if @backupSetId is null begin raiserror(N''Verify failed. Backup information for database ''''SES'''' not found.'', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N''E:\dbbackup\SES.bak'' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO
BACKUP DATABASE [discountShop] TO  DISK = N''E:\dbbackup\DiscountShop.bak'' WITH NOFORMAT, INIT,  NAME = N''DiscountShop-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N''DiscountShop'' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N''DiscountShop'' )
if @backupSetId is null begin raiserror(N''Verify failed. Backup information for database ''''DiscountShop'''' not found.'', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N''E:\dbbackup\DiscountShop.bak'' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO
BACKUP DATABASE [TerminalSAP] TO  DISK = N''E:\dbbackup\TerminalSAP.bak'' WITH NOFORMAT, INIT,  NAME = N''TerminalSAP-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N''TerminalSAP'' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N''TerminalSAP'' )
if @backupSetId is null begin raiserror(N''Verify failed. Backup information for database ''''TerminalSAP'''' not found.'', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N''E:\dbbackup\TerminalSAP.bak'' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO
BACKUP DATABASE [SES_DC] TO  DISK = N''E:\dbbackup\SES_DC.bak'' WITH NOFORMAT, INIT,  NAME = N''SES_DC-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N''SES_DC'' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N''SES_DC'' )
if @backupSetId is null begin raiserror(N''Verify failed. Backup information for database ''''SES_DC'''' not found.'', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N''E:\dbbackup\SES_DC.bak'' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO
', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [add ses to archive]    Script Date: 12/11/2015 14:42:08 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'add ses to archive', 
		@step_id=2, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"c:\Program Files\7-Zip\7z.exe" a "E:\dbbackup\SES" "E:\dbbackup\SES.bak"', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [add discountshop to archive]    Script Date: 12/11/2015 14:42:08 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'add discountshop to archive', 
		@step_id=3, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"c:\Program Files\7-Zip\7z.exe" a "E:\dbbackup\DiscountShop" "E:\dbbackup\DiscountShop.bak"', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [add terminalsap to archive]    Script Date: 12/11/2015 14:42:08 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'add terminalsap to archive', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"c:\Program Files\7-Zip\7z.exe" a "E:\dbbackup\TerminalSAP" "E:\dbbackup\TerminalSAP.bak"', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [add SES_DC to archive]    Script Date: 12/11/2015 14:42:08 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'add SES_DC to archive', 
		@step_id=4, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'"c:\Program Files\7-Zip\7z.exe" a "E:\dbbackup\SES_DC" "E:\dbbackup\SES_DC.bak"',
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [copy ses to backup_server]    Script Date: 12/11/2015 14:42:09 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'copy ses to backup_server', 
		@step_id=5, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'xcopy E:\dbbackup\SES.7z \\10.81.32.4\E$\bkpsrv\dbbackup_3 /Y', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [copy discountshop to backup_server]    Script Date: 12/11/2015 14:42:09 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'copy discountshop to backup_server', 
		@step_id=6, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'xcopy E:\dbbackup\DiscountShop.7z \\10.81.32.4\E$\bkpsrv\dbbackup_3 /Y', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [copy terminalsap to backup_server]    Script Date: 12/11/2015 14:42:09 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'copy terminalsap to backup_server', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'xcopy E:\dbbackup\TerminalSAP.7z \\10.81.32.4\E$\bkpsrv\dbbackup_3 /Y',
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [copy SES_DC to backup_server]    Script Date: 12/11/2015 14:42:09 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'copy SES_DC to backup_server', 
		@step_id=7, 
		@cmdexec_success_code=0, 
		@on_success_action=3, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'xcopy E:\dbbackup\SES_DC.7z \\10.81.32.4\E$\bkpsrv\dbbackup_3 /Y',
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [delete backups]    Script Date: 12/11/2015 14:42:09 ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'delete backups', 
		@step_id=8, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'CmdExec', 
		@command=N'del "E:\dbbackup\SES.bak" "E:\dbbackup\SES_DC.bak" "E:\dbbackup\DiscountShop.bak" "E:\dbbackup\TerminalSAP"', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'Wed Sat', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=72, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20090929, 
		@active_end_date=99991231, 
		@active_start_time=40000, 
		@active_end_time=235959, 
		@schedule_uid=N'001c9514-6e31-4189-9cd2-00e4a3f817f0'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

