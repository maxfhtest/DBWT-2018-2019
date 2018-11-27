-- DESCRIBE users;
REPLACE INTO `users` (`id`, `firstname`, `lastname`, `mail`, `loginname`, `last_login`, `created_at`, `birth`, `age`, `salt`, `hash`, `active`) VALUES (21, 'Bugs', 'Findmore', 'dbwt2018@ismypassword.com', 'bugfin', '2018-11-14 17:44:10', '2018-11-14', '1996-12-13', 0, 'MPVdLDf0zNVzpOHP+GmRxoBg9mdJIlc5', '4nx5U6DIE+N8xsbpwUr3Q1KG', 1);
REPLACE INTO `users` (`id`, `firstname`, `lastname`, `mail`, `loginname`, `last_login`, `created_at`, `birth`, `age`, `salt`, `hash`, `active`) VALUES (22, 'Donald', 'Truck', 'testing@ismypassword.com', 'dot', '2018-11-14 17:44:10', '2018-11-14', '1991-12-11', 0, 'Ydn1iGl08JvvkVExSEiKDQhfYOaCtgOO', 'm5kZ68YVNU3xBiDqorthK9UP', 1);
REPLACE INTO `users` (`id`, `firstname`, `lastname`, `mail`, `loginname`, `last_login`, `created_at`, `birth`, `age`, `salt`, `hash`, `active`) VALUES (23, 'Fiona', 'Index', 'an0ther@ismypassword.com', 'fionad', '2018-11-14 17:44:10', '2018-11-14', '1993-12-10', 0, 'I5GXy7BwYU2t3pHZ5YkBfKMbvN7Sr81O', 'oYylNvPe7YmjO1IHNdLA/XxJ', 1);
REPLACE INTO `users` (`id`, `firstname`, `lastname`, `mail`, `loginname`, `last_login`, `created_at`, `birth`, `age`, `salt`, `hash`, `active`) VALUES (24, 'Wendy', 'Burger', 's3cr3tz@ismypassword.com', 'bkahuna', '2018-11-14 17:44:10', '2018-11-14', '1982-12-12', 0, 't1TAVguVwIiejXf3baaObIAtPx7Y+2iY', 'IMK2n5r8RUVFo4bMMS8uDyH4', 1);
REPLACE INTO `users` (`id`, `firstname`, `lastname`, `mail`, `loginname`, `last_login`, `created_at`, `birth`, `age`, `salt`, `hash`, `active`) VALUES (25, 'Monster', 'Robot', '^;_`;^@ismypassword.com', 'root', '2018-11-14 17:44:10', '2018-11-14', '1982-12-12', 0, 'dX8YsBM9atpYto9caWHJM6Eet7bUngxk', 'nRt3MSBdNUHPj/q02WPgXaDA', 1);
-- DESCRIBE users_friends;
REPLACE INTO `users` (`friendone`, `friendtwo`) VALUES (21, 22);
REPLACE INTO `users` (`friendone`, `friendtwo`) VALUES (21, 23);
REPLACE INTO `users` (`friendone`, `friendtwo`) VALUES (21, 24);
REPLACE INTO `users` (`friendone`, `friendtwo`) VALUES (22, 23);
REPLACE INTO `users` (`friendone`, `friendtwo`) VALUES (22, 24);

