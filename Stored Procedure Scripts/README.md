searchStoredProceduresForUse does a brute force search through all files in a Cartella workspace to see if there are any references to stored procedures on the database anywhere in the code. 

compareUsedWithAllSp works with SQL Server profiler and basically compares the database's record of the stored procedure against all the logged uses of procedures called through Cartella. Requires a decent amount of manual work but would give a decent idea of what scripts are not being used (even if they're referenced).
