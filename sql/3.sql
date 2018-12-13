select * from sotrudniki where f like 'ладыг%' and lab_id = 100000;
insert users (kod_fl, F,I,O,lab_id, right_level, fte_admin)
  select person_id, f,i,o, 100000,2,1 
  from sotrudniki where tab_n=-1;
