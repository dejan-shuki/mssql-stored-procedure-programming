SET NOCOUNT ON
SELECT 'CREATE LOGIN [' + name + '] '
+ 'with password = ''My1.Password'', 
DEFAULT_DATABASE = tempdb,
sid ='
, sid
--select *
FROM sys.server_principals
WHERE principal_id > 256
and type_desc = 'SQL_LOGIN'

SELECT 'CREATE LOGIN [' + name + '] FROM WINDOWS; '
FROM sys.server_principals
WHERE principal_id > 256
and type_desc = 'WINDOWS_LOGIN'
and name not in ('NT AUTHORITY\SYSTEM', 'BUILTIN\Administrators')


select 'EXEC sp_addsrvrolemember '''+loginname+''', ''sysadmin'''
from syslogins
where sysadmin = 1
union
select 'EXEC sp_addsrvrolemember '''+loginname+''', ''securityadmin'''
from syslogins
where securityadmin = 1
union
select 'EXEC sp_addsrvrolemember '''+loginname+''', ''serveradmin'''
from syslogins
where serveradmin = 1
union
select 'EXEC sp_addsrvrolemember '''+loginname+''', ''setupadmin'''
from syslogins
where setupadmin = 1
union
select 'EXEC sp_addsrvrolemember '''+loginname+''', ''processadmin'''
from syslogins
where processadmin = 1
union
select 'EXEC sp_addsrvrolemember '''+loginname+''', ''diskadmin'''
from syslogins
where diskadmin = 1
union
select 'EXEC sp_addsrvrolemember '''+loginname+''', ''dbcreator'''
from syslogins
where dbcreator = 1
union
select 'EXEC sp_addsrvrolemember '''+loginname+''', ''bulkadmin'''
from syslogins
where bulkadmin = 1

-----------------------------------------
-----------------------------------------
select 'Run these after dbs are created:'

select ' EXEC sp_defaultdb @loginame = ''' + name + ''''
,', @defdb = ''' + Coalesce(default_database_name, 'tempdb') + ''''
FROM sys.server_principals
WHERE principal_id > 256
and type_desc = 'SQL_LOGIN'

----------------------------------------

select ' EXEC sp_defaultdb @loginame = ''' + name + ''''
,', @defdb = ''' + Coalesce(default_database_name, 'tempdb') + ''''
FROM sys.server_principals
WHERE principal_id > 256
and type_desc = 'WINDOWS_LOGIN'
and name not in ('NT AUTHORITY\SYSTEM', 'BUILTIN\Administrators')
