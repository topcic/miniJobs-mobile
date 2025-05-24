BEGIN TRANSACTION;


DECLARE @UserId INT;
DECLARE @ApplicantId INT;
DECLARE @EmployerId INT;


DECLARE @i INT = 1;
WHILE @i <= 10
BEGIN
    SET @UserId = NULL;
    DECLARE @ApplicantEmail NVARCHAR(100) = CONCAT('applicant', @i, '@minijobs.ba');
    
    IF NOT EXISTS (SELECT 1 FROM users WHERE email = @ApplicantEmail)
    BEGIN
        INSERT INTO users (first_name, last_name, email, password_hash, access_failed_count, deleted, account_confirmed, created, phone_number, city_id)
        VALUES (
            CONCAT('Applicant', @i), 
            CONCAT('User', @i), 
            @ApplicantEmail, 
            CONVERT(VARCHAR(32), HASHBYTES('MD5', CAST(NEWID() AS VARCHAR(36))), 2), 
            0, 0, 1, GETUTCDATE(), 
            CONCAT('+387 6', ABS(CHECKSUM(NEWID())) % 1000000), 
            ABS(CHECKSUM(NEWID())) % 50 + 1
        );
        
        SET @ApplicantId = SCOPE_IDENTITY();
        
        INSERT INTO applicants (id) VALUES (@ApplicantId);
        
        INSERT INTO user_roles (user_id, role_id)
        VALUES (@ApplicantId, 'Applicant');
    END
    
    SET @i = @i + 1;
END


SET @i = 1;
WHILE @i <= 10
BEGIN
    SET @UserId = NULL;
    DECLARE @EmployerEmail NVARCHAR(100) = CONCAT('employer', @i, '@minijobs.ba');
    
    IF NOT EXISTS (SELECT 1 FROM users WHERE email = @EmployerEmail)
    BEGIN
        INSERT INTO users (first_name, last_name, email, password_hash, access_failed_count, deleted, account_confirmed, created, phone_number, city_id)
        VALUES (
            CONCAT('Employer', @i), 
            CONCAT('User', @i), 
            @EmployerEmail, 
            CONVERT(VARCHAR(32), HASHBYTES('MD5', CAST(NEWID() AS VARCHAR(36))), 2), -- Random password hash
            0, 0, 1, GETUTCDATE(), 
            CONCAT('+387 6', ABS(CHECKSUM(NEWID())) % 1000000), 
            ABS(CHECKSUM(NEWID())) % 50 + 1
        );
        
        SET @EmployerId = SCOPE_IDENTITY();
        
        INSERT INTO employers (id) VALUES (@EmployerId);
        
        INSERT INTO user_roles (user_id, role_id)
        VALUES (@EmployerId, 'Employer');
    END
    
    SET @i = @i + 1;
END

-- Create 50 Jobs (created within the last 10 days by random employers)
INSERT INTO jobs (name, description, street_address_and_number, applications_duration, status, required_employees, created, created_by, wage, city_id, job_type_id, deleted_by_admin)
SELECT 
    CONCAT('Job ', n.n) AS name,
    CONCAT('[{"insert":"Description for job', n.n, '"}]') AS description,
    CONCAT('Street ', CAST(ABS(CHECKSUM(NEWID())) % 100 + 1 AS VARCHAR)) AS street_address_and_number,
    ABS(CHECKSUM(NEWID())) % 30 + 1 AS applications_duration,
    ABS(CHECKSUM(NEWID())) % 5 AS status, -- Random 0 to 4
    ABS(CHECKSUM(NEWID())) % 10 + 1 AS required_employees,
    DATEADD(DAY, -ABS(CHECKSUM(NEWID())) % 10, GETUTCDATE()) AS created, -- Random date within last 10 days
    14 + (ABS(CHECKSUM(NEWID())) % 10) AS created_by, -- Random ID between 14 and 23
    CASE WHEN RAND() > 0.3 THEN ABS(CHECKSUM(NEWID())) % 100 + 1 ELSE NULL END AS wage,
    ABS(CHECKSUM(NEWID())) % 50 + 1 AS city_id,
    ABS(CHECKSUM(NEWID())) % 20 + 1 AS job_type_id,
    0
FROM (SELECT TOP 50 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n FROM master..spt_values a CROSS JOIN master..spt_values b) n;


-- Insert Job Questions for all 50 jobs (3 questions per job: IDs 1, 2, 3)
INSERT INTO job_questions (question_id, job_id)
SELECT 
    q.question_id,
    j.id AS job_id
FROM jobs j
CROSS JOIN (VALUES (1), (2), (3)) AS q(question_id)
WHERE j.created > DATEADD(DAY, -10, GETUTCDATE()); -- All jobs from this script

-- Insert Job Question Answers (logic based on wage for question_id = 2)
INSERT INTO job_question_answers (job_question_id, proposed_answer_id)
SELECT 
    jq.id AS job_question_id,
    CASE 
        WHEN j.wage IS NULL AND jq.question_id = 2 THEN 15 -- If wage is NULL, question 2 gets answer ID 15
        ELSE (SELECT TOP 1 pa.id FROM proposed_answers pa WHERE pa.question_id = jq.question_id ORDER BY pa.id)  
    END AS proposed_answer_id
FROM job_questions jq
JOIN jobs j ON jq.job_id = j.id;

-- Create Job Applications (random applicants, multiple per job, no duplicates)
WITH ApplicantPool AS (
    SELECT 
        j.id AS job_id,
        u.id AS applicant_id,
        ROW_NUMBER() OVER (PARTITION BY j.id ORDER BY NEWID()) AS rn -- Randomize applicants per job
    FROM jobs j
    CROSS JOIN (
        SELECT u.id 
        FROM users u 
        JOIN user_roles ur ON u.id = ur.user_id 
        WHERE ur.role_id = 'Applicant'
    ) u
    WHERE j.created > DATEADD(DAY, -10, GETUTCDATE())
    AND j.status != 0 -- Exclude jobs with status = 0
    AND RAND() > 0.2 -- 80% chance of generating an application possibility
)
INSERT INTO job_applications (job_id, created_by, created, status, is_deleted)
SELECT 
    ap.job_id,
    ap.applicant_id AS created_by,
    GETUTCDATE() AS created,
    CAST(RAND(CHECKSUM(NEWID())) * 3 AS INT) AS status, -- Random status 0-2
    0 AS is_deleted
FROM ApplicantPool ap
WHERE ap.rn <= ABS(CHECKSUM(NEWID())) % 5 + 1 -- Randomly limit to 1-5 applications per job
AND NOT EXISTS (
    SELECT 1 
    FROM job_applications ja 
    WHERE ja.job_id = ap.job_id 
    AND ja.created_by = ap.applicant_id
); -- Ensure no duplicate applications
-- Generate missing ratings bidirectionally (no duplicates), for job_application.status=1 and job.status=3

-- Step 1: Union all required missing pairs with direction flags
WITH potential_ratings AS (
    SELECT 
        ja.id AS job_application_id,
        ja.created_by AS applicant_id,
        j.created_by AS employer_id
    FROM job_applications ja
    JOIN jobs j ON ja.job_id = j.id
    WHERE ja.status = 1 AND j.status = 3
),
missing_ratings AS (
    SELECT
        pr.job_application_id,
        pr.applicant_id AS created_by,
        pr.employer_id AS rated_user_id
    FROM potential_ratings pr
    WHERE NOT EXISTS (
        SELECT 1 FROM ratings r
        WHERE r.job_application_id = pr.job_application_id
          AND r.created_by = pr.applicant_id
          AND r.rated_user_id = pr.employer_id
    )
    UNION ALL
    SELECT
        pr.job_application_id,
        pr.employer_id AS created_by,
        pr.applicant_id AS rated_user_id
    FROM potential_ratings pr
    WHERE NOT EXISTS (
        SELECT 1 FROM ratings r
        WHERE r.job_application_id = pr.job_application_id
          AND r.created_by = pr.employer_id
          AND r.rated_user_id = pr.applicant_id
    )
)
-- Step 2: Insert the non-duplicate ratings randomly
INSERT INTO ratings (value, comment, job_application_id, rated_user_id, is_active, created_by, created)
SELECT 
    CAST(RAND(CHECKSUM(NEWID())) * 5 + 1 AS INT) AS value,
    CONCAT('Auto-generated review ', ABS(CHECKSUM(NEWID())) % 100000) AS comment,
    mr.job_application_id,
    mr.rated_user_id,
    1 AS is_active,
    mr.created_by,
    GETUTCDATE()
FROM missing_ratings mr;
-- Create Saved Jobs (random applicants saving jobs)
INSERT INTO saved_jobs (created_by, job_id, is_deleted, created)
SELECT 
    FLOOR(RAND(CHECKSUM(NEWID())) * 12) + 2 AS created_by,
    j.id AS job_id,
    ROUND(RAND(CHECKSUM(NEWID())), 0) AS is_deleted,
    GETUTCDATE() AS created
FROM jobs j
WHERE j.created > DATEADD(DAY, -10, GETUTCDATE())
  AND RAND(CHECKSUM(NEWID())) > 0.4;

COMMIT TRANSACTION;