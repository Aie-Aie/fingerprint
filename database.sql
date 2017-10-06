--create database for Finger Print Stuff Project

--FUNCTIONS PRESENT--
	--getevents(id)
	--getstudentdata(id)
	--newstudent(details...)
	--newevent(details...)
	--newaccesscode(...)

create table studentInfo(
	studid text primary key,
	firstname text not null,
	lastname text not null,
	course text not null
)

create table events(
	studid text references studentInfo(studid),
	event text, 
	eventdate timestamp,
	signin text,
	signout text

)

create table access(
	
	studid text primary key references studentInfo(studid),
	fingerprint text
)

create table admin(
	firstname text,
	lastname text,
	username text primary key,
	password text
)

create or replace function newadmin(parfirstname text, parlastname text, paruname text, parpwd text) returns text as
	$$

		declare
			loc_id text;
			loc_res text;
			
			
		begin
			
			select into loc_id username from admin where username=paruname;
			if loc_id isnull then
				insert into admin(firstname, lastname, username, password) values (parfirstname, parlastname, paruname, parpwd);
			
				loc_res = 'OK';

			else
				loc_res ='Data exists';		

			end if;
				return loc_res;

		end;
	$$
	language 'plpgsql'
-- select newadmin('ailen grace', 'aspe','aaspe', 'akolagini')

create or replace function checkaccess(paruname text, parpwd text) returns text as
	$$

		declare
			loc_id text;
			loc_res text;
		
		begin
			select into loc_id username from admin where username = paruname and password=parpwd;
			
			if loc_id is null then
				loc_res = 'Unauthorized';
			
			else
				loc_res = 'Granted';
			
			end if;
				return loc_res;
		end;
	$$

	language 'plpgsql';
select checkaccess('aaspe', 'akolagini');

create or replace function newstudents (parID text, parFNAME text, parLNAME text, parCOURSE text) returns text as

	$$ 
		declare
			loc_id text;
			loc_res text;

		begin
			select into loc_id studid from studentInfo where studid=parID;
			if loc_id isnull then
				insert into studentInfo(studid, firstname, lastname, course) values (parID, parFNAME, parLNAME, parCOURSE);
			
				loc_res = 'OK';

			else
				loc_res ='Data exists';		

			end if;
				return loc_res;

		end;

	$$ 
	language 'plpgsql'

--select newstudents('2013-1364', 'Ailen Grace', 'Aspe', 'BSEC')
create or replace function newaccesscode(parID text, parHASH text) returns text as
	$$
		declare
			loc_id text;
			loc_res text;

		begin
			loc_id = (select access.studid from access, studentInfo where access.studid= studentInfo.studid);

			if loc_id isnull then
				insert into access (studid, fingerprint) values (parID, parHASH);
				loc_res ='OK';

			else
				loc_res ='Data exists';

			end if;
				return loc_res;
		end;

	$$
	language 'plpgsql'

--select newaccesscode('2013-1364', 'hash')


create or replace function newevent(parID text, parEVENT text, parIN text, parOUT text) returns text as
	$$
		declare
			loc_id text;
			loc_res text;

		begin 
			loc_id =(select  events.event from events, studentInfo where events.studid=studentInfo.studid and events.event=parEVENT);

			if loc_id isnull then
				insert into events (studid, event, eventdate, signin, signout) values (parID, parEVENT, now(), parIN, parOUT);
				loc_res ='OK';

			else
				loc_res='Data exists';

			end if;
				return loc_res;
		end;
	$$
	language 'plpgsql'
--select newevent('2013-1364', 'COE2 Week 2017', 'yes', 'no')

create or replace function dropEmployee(par_id int8) returns text as
    $$
        declare
            loc_id text;
            loc_res text;
        begin
            select into loc_id id from employees where id =par_id;
            if loc_id isnull then
                loc_res ='Data Not Found.';
            else

				delete from employees where id= par_id;
                loc_res ='Data deleted';
            end if;
                return loc_res;
		end;
    $$
        language 'plpgsql';

create or replace function dropEvent(parEvent text) returns text as
	$$
		declare 
			loc_res text;
			loc_id text;
		begin
			select into loc_id event from events where event =parEvent;

			if loc_id isnull then
				loc_res ='Data not found';
			else
				delete from events where event = parEvent;
				loc_res ='Data deleted';
			end if;
				return loc_res;
		end;

	$$
	language 'plpgsql';

	--select dropEvent('COE Week 2017');
create or replace function getevents(in parID text, out text, out text, out text, out timestamp, out text, out text) returns setof record as
	$$
		select  studentInfo.firstname, studentInfo.lastname, events.event, events.eventdate, events.signin, events.signout from events, studentInfo where studentInfo.studid = parID and studentInfo.studid = events.studid;
	$$
	language 'sql';

--select getevents('2013-1364')

create or replace function getstudentdata(in parID text, out text, out text, out text, out text) returns setof record as
	$$
		select studid, firstname, lastname, course from studentInfo where studid= parID;

	$$
	language 'sql'
--select getstudentdata('2013-1364')
	