INSERT INTO users(id, 
	first_name, last_name, email, password_hash, two_factor_enabled, access_failed_count, lockout_enabled, deleted, account_confirmed)
	VALUES (1 'Admin', 'Admin', 'admin@minijobs.ba', UPPER(MD5('Minijobs1234!')), false, 0, false, false, true)
    ON CONFLICT DO NOTHING;

INSERT INTO user_roles (user_id, role_id) values (1, 'Administrator');