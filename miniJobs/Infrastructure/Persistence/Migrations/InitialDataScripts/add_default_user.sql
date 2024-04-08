BEGIN TRANSACTION;

IF NOT EXISTS (SELECT 1 FROM users WHERE id = 1)
BEGIN
    -- Insert the user only if it doesn't already exist
    INSERT INTO users (first_name, last_name, email, password_hash, access_failed_count, deleted, account_confirmed, created)
    VALUES ('Admin', 'Admin', 'admin@minijobs.ba', UPPER(CONVERT(varbinary, HASHBYTES('MD5', 'Minijobs1234!'), 2)), 0, 0, 1, GETUTCDATE());
END;

-- Insert role for the user (if user exists)
INSERT INTO user_roles (user_id, role_id)
SELECT 1, 'Administrator'
WHERE EXISTS (SELECT 1 FROM users WHERE id = 1);

COMMIT TRANSACTION;
