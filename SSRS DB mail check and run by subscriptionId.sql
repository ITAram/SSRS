

--Run Job

-- EXEC [ReportServer].dbo.AddEvent @EventType='TimedSubscription', @EventData='3AF9BC1E-9F00-44B9-AEF8-6F4306F836EF' 



USE msdb
EXEC msdb.dbo.sysmail_stop_sp;
EXEC msdb.dbo.sysmail_start_sp;
EXEC msdb.dbo.sysmail_help_queue_sp @queue_type = 'Mail' ;
--SELECT * FROM msdb.dbo.sysmail_allitems;
SELECT * FROM msdb.dbo.sysmail_log 
EXEC msdb.dbo.sysmail_help_account_sp;
--  Check that your server name and server type are correct in the
--      account you are using.
--  Check that your email_address is correct in the account you are
--      using.
EXEC msdb.dbo.sysmail_help_profile_sp;
--  Check that you are using a valid profile in your dbmail command.
EXEC msdb.dbo.sysmail_help_profileaccount_sp;
--  Check that your account and profile are joined together
--      correctly in sysmail_help_profileaccount_sp.
EXEC msdb.dbo.sysmail_help_principalprofile_sp;


 DECLARE @OldUserID uniqueidentifier
 DECLARE @NewUserID uniqueidentifier
 --SELECT @OldUserID = UserID FROM dbo.Users WHERE UserName = 'TOR\072140' --Karen
 --SELECT @OldUserID = UserID FROM dbo.Users WHERE UserName = 'TOR\071621' --Nata
    SELECT @OldUserID = UserID FROM dbo.Users WHERE UserName = 'TOR\012012'
 SELECT @NewUserID = UserID FROM dbo.Users WHERE UserName = 'tor\admin_sqlreport'
 SELECT @OldUserID, @NewUserID 
 UPDATE dbo.Subscriptions SET OwnerID = @NewUserID WHERE OwnerID = @OldUserID


 dbcc freeproccache 
go