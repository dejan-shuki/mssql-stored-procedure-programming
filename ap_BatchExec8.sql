create proc util.ap_BatchExec8
-- Execute specified sql files.
    @ServerName sysname = '.\rc',
    @UserId sysname = 'sa',
    @PWD sysname = 'my,password',
    @DirName varchar(400)='C:\sql\test',
    @File varchar(400) = 'list.txt',
    @UseTransaction int = 0,
    @debug int = 0
as

set nocount on

declare @FilePath varchar(500),
        @FileId int,
        @MaxFileID int,
        @OldFileId int,
        @Cmd varchar(1000),
        @i int,
        @iOld int,
        @max int,
        @s varchar(max),
        @line varchar(max)

--- Get list of files
create table #FileList (FileId int identity(1,1),
                        FileName varchar(500))

select  @Cmd = 'cd ' + @DirName + ' & type ' + @File

insert #FileList (FileName)
exec master.sys.xp_cmdshell @Cmd

-- remove empty rows and comments
delete #FileList where FileName is null
delete #FileList where FileName like '--%'

if @debug <> 0
   select * from #FileList

create table #script (SQL    varchar(max), 
                      LineId int identity)

select @FileId = Min (FileId),
       @MaxFileID = Max(FileId) 
from #FileList

-- loop throguh files
WHILE @FileId <= @MaxFileID 
BEGIN
   -- get name of the file to be processed
    select @FilePath = @DirName + '\' + FileName 
    from #FileList 
    where FileId = @FileId
    
    if @FilePath <> ''
    BEGIN
        if @debug <> 0
            print 'Reading ' + @FilePath

        set @cmd = 'Type "' + @FilePath + '"'

        insert #script (SQL)
        exec master.sys.xp_cmdshell @Cmd

        Select  @i = Min (LineId),
                @max = Max(LineId),
                @s = ''
        from #script

        while @i <= @max
        begin

            Select @line = Coalesce(SQL, ' ')
            from #script
            where LineId = @i

            if @debug <> 0
                select 'read line =', @i i, @line line

            if Left(@line, 2) <> 'GO'
            begin
                -- the the line and go another round               
                select @s = @s + char(13) + char(10) + @line
                if @debug <> 0
                    select @s [@s]
            end 
            else
            begin    
                begin try
                    if @debug = 0
                        exec sp_sqlexec @s
                    else
                        select @s
                end try
                begin catch
                    print Error_message()
                    print 'Process stopped.'
                    return
                end catch
                set @s = ''
            end
            -- contunue line by line
            set @iOld = @i
            select @i = Min(LineId)
            from #script
            where LineId > @iOld
        end


    END
    -- get next file
    set @FileID = @FileId + 1
    select @fileID FileId
    
    truncate table #script
END
return
