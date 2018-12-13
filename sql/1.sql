select * from projects where id in 
(select project_id from user_rights where person_id=:PID)
