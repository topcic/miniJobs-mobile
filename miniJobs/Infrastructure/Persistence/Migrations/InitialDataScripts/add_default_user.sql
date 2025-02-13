BEGIN TRANSACTION;

DECLARE @UserId INT;
DECLARE @ApplicantId INT;
DECLARE @EmployerId INT;

-- Check if admin user exists
IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'admin@minijobs.ba')
BEGIN
    -- Insert the admin user
    INSERT INTO users (first_name, last_name, email, password_hash, access_failed_count, deleted, account_confirmed, created)
    VALUES ('Admin', 'Admin', 'admin@minijobs.ba', '1F46B8AA772546584A5853F16CABBCFD', 0, 0, 1, GETUTCDATE()); 

    -- Get the last inserted ID
    SET @UserId = SCOPE_IDENTITY();
END
ELSE
BEGIN
    -- Get the existing admin user's ID
    SELECT @UserId = id FROM users WHERE email = 'admin@minijobs.ba';
END

-- Insert role for Admin if not exists
IF NOT EXISTS (SELECT 1 FROM user_roles WHERE user_id = @UserId AND role_id = 'Administrator')
BEGIN
    INSERT INTO user_roles (user_id, role_id)
    VALUES (@UserId, 'Administrator');
END

-- Check if applicant user exists
IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'applicant@minijobs.ba')
BEGIN
    -- Insert the applicant user
    INSERT INTO users (first_name, last_name, email, password_hash, access_failed_count, deleted, account_confirmed, created, phone_number, city_id)
    VALUES ('Applicant', 'User', 'applicant@minijobs.ba', '1F46B8AA772546584A5853F16CABBCFD', 0, 0, 1, GETUTCDATE(), '+387 62 243333', 1); 

    -- Get the last inserted ID
    SET @ApplicantId = SCOPE_IDENTITY();
    
    -- Insert into applicants (created column is required)
    INSERT INTO applicants (id)
    VALUES (@ApplicantId);
END
ELSE
BEGIN
    -- Get the existing applicant user's ID
    SELECT @ApplicantId = id FROM users WHERE email = 'applicant@minijobs.ba';
END

-- Insert role for Applicant if not exists
IF NOT EXISTS (SELECT 1 FROM user_roles WHERE user_id = @ApplicantId AND role_id = 'Applicant')
BEGIN
    INSERT INTO user_roles (user_id, role_id)
    VALUES (@ApplicantId, 'Applicant');
END

-- Check if employer user exists
IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'employer@minijobs.ba')
BEGIN
    -- Insert the employer user
    INSERT INTO users (first_name, last_name, email, password_hash, access_failed_count, deleted, account_confirmed, created, phone_number, city_id)
    VALUES ('Employer', 'User', 'employer@minijobs.ba', '1F46B8AA772546584A5853F16CABBCFD', 0, 0, 1, GETUTCDATE(), '+387 61 112233', 1); 

    -- Get the last inserted ID
    SET @EmployerId = SCOPE_IDENTITY();

    -- Insert into employers WITHOUT created column
    INSERT INTO employers (id) VALUES (@EmployerId);
END
ELSE
BEGIN
    -- Get the existing employer user's ID
    SELECT @EmployerId = id FROM users WHERE email = 'employer@minijobs.ba';
END

-- Insert role for Employer if not exists
IF NOT EXISTS (SELECT 1 FROM user_roles WHERE user_id = @EmployerId AND role_id = 'Employer')
BEGIN
    INSERT INTO user_roles (user_id, role_id)
    VALUES (@EmployerId, 'Employer');
END

COMMIT TRANSACTION;
