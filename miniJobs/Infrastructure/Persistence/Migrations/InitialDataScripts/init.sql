IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'miniJobs_hangfire')
BEGIN
    CREATE DATABASE miniJobs_hangfire;
END;