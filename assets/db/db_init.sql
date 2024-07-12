
CREATE TABLE t_ReminderItem (
    [id]    INTEGER  NOT NULL PRIMARY KEY
    ,[title]    TEXT NOT NULL
    ,[name]    TEXT NOT NULL
    ,[email]    TEXT NOT NULL
    ,[picture_large]    TEXT NOT NULL
    ,[picture_thumbnail]    TEXT NOT NULL
    ,[date]    TEXT NOT NULL
    ,[time]    TEXT NOT NULL
    ,[is_selected]    INTEGER NOT NULL
    ,[is_notified]    INTEGER NOT NULL
);
