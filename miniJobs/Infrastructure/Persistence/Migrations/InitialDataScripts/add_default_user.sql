BEGIN TRANSACTION;

DECLARE @UserId INT;

-- Check if user exists
IF NOT EXISTS (SELECT 1 FROM users WHERE email = 'admin@minijobs.ba')
BEGIN
    -- Insert the user
    INSERT INTO users (first_name, last_name, email, password_hash, access_failed_count, deleted, account_confirmed, created)
--password Minijobs1234!
    VALUES ('Admin', 'Admin', 'admin@minijobs.ba', '1F46B8AA772546584A5853F16CABBCFD', 0, 0, 1, GETUTCDATE()); 

    -- Get the last inserted ID
    SET @UserId = SCOPE_IDENTITY();
END
ELSE
BEGIN
    -- Get the existing user's ID
    SELECT @UserId = id FROM users WHERE email = 'admin@minijobs.ba';
END

-- Insert role only if user ID is found
IF NOT EXISTS (SELECT 1 FROM user_roles WHERE user_id = @UserId AND role_id = 'Administrator')
BEGIN
    INSERT INTO user_roles (user_id, role_id)
    VALUES (@UserId, 'Administrator');
END

COMMIT TRANSACTION;