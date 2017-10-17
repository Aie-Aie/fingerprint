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

create table eventlist(
	studid text ,
	event text,
	signin text,
	signout text

)

create table events(
	event text primary key,
	eventdate text
);

create table eventdata(
	event text,
	eventdate text,
	studid text,
	signin text,
	signout text

)


create table admin(
	username text primary key,
	password text
)



create or replace function signinevent(parid text, parevent text, pardate text) returns text as
	$$
		declare
			loc_res text;
			loc_id text;

		begin
			loc_id := (select studid from eventdata where studid=parid and event =parevent);

			if loc_id isnull then
				insert into eventdata(event, eventdate, studid, signin, signout) values(parevent, pardate, parid, 'yes', '');
				loc_res ='Added';

			else


	$$
	language 'plpgsql'

create or replace function newevent(pareventname text, pareventdate text) returns text as
	$$ 
		declare
			loc_id text;
			loc_res text;

		begin 
			select into loc_id event from events where event =pareventname;

			if loc_id isnull then
				insert into events(event, eventdate) values (pareventname, pareventdate);

				loc_res ='OK';
			else
				loc_res ='Data exists';
			end if;
				return loc_res;
		end;
	$$
	language 'plpgsql';

--select newevent('GAKOP', '2017-10-10')

create or replace function neweventlist(pareventname text, parstudid text) returns text as
	$$
		declare
			loc_res text;
			loc_id  text;

		begin
			select into loc_id studid from eventlist, events where studid = parstudid and events.event = pareventname;

			if loc_id isnull then
				insert into eventlist(studid, event) values (parstudid, pareventname);
				loc_res ='OK';

			else
				loc_res ='Data exists';

			end if;
				return loc_res;
		end;
	$$
	language 'plpgsql';

--select neweventlist('GAKOP', '2013-1364')

--old
create or replace function signinstud(parID text, parevent text, pardate text) returns text as
	$$
		declare
			loc_res text;
			loc_id text;
			loc_data text;
		begin
			
			select into loc_id studid from eventlist where event = parevent and studid=parID;

			if loc_id isnull then
				insert into eventlist(studid, event, signin) values (parID, parevent, 'yes');
				loc_res ='Data added';
			else
				update eventlist set signin = 'yes' where studid =parID and event = parevent;
				loc_res ='Data updated';

			end if;
				return loc_res;

		end;
	$$
	language 'plpgsql';

	select signinstud('2013-1364', 'GAKOP', '2017-10-10')
--old
create or replace function signoutstud(parID text, parevent text) returns text as
	$$
		declare
			loc_res text;
			loc_id text;
			
		begin
			
			loc_id := (select studid from eventlist where studid =parID and event= parevent);

			if loc_id isnull then
				loc_res ='Data not found';
			else
				update eventlist set signout = 'yes' where studid =parID and event = parevent;
				loc_res ='Data updated';

			end if;
				return loc_res;

		end;
	$$
	language 'plpgsql';

select signinstud('2013-1364','Palakasan', '2017-10-10')
create or replace function newadmin(paruname text, parpwd text) returns text as
	$$

		declare
			loc_id text;
			loc_res text;
			
			
		begin
			
			select into loc_id username from admin where username=paruname;
			if loc_id isnull then
				insert into admin(username, password) values (paruname, parpwd);
			
				loc_res = 'OK';

			else
				loc_res ='Data exists';		

			end if;
				return loc_res;

		end;
	$$
	language 'plpgsql'
-- select newadmin('aaspe', 'akolagini')

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
--select checkaccess('aaspe', 'akolagini');

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


create or replace function dropEvent(parEvent text) returns text as
	$$
		declare 
			loc_res text;
			loc_id text;
		begin
			select into loc_id event from events where event=parEvent;

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



create or replace function getstudentdata(in parID text, out text, out text, out text, out text) returns setof record as
	$$
		select studid, firstname, lastname, course from studentInfo where studid= parID;

	$$
	language 'sql'
--select getstudentdata('2013-1364')

create or replace function getevents(in parID text, out text, out text, out text, out text, out text, out text) returns setof record as
	$$
		select studentInfo.firstname, studentInfo.lastname, events.event, events.eventdate, eventlist.signin, eventlist.signout from studentInfo, eventlist, events where studentInfo.studid=parID and studentInfo.studid=eventlist.studid and eventlist.event=events.event;
	$$
	language 'sql'

--select getevents('2013-1364')
create or replace function getlistevents(out text, out text) returns setof record as
	$$
		select event, eventdate from events;
	$$
	language 'sql';

--select getlistevents()

create or replace function getliststudinevents(in parevent text, out text, out text, out text, out text) returns setof record as
	$$
		select studentInfo.studid, studentInfo.course, eventlist.signin, eventlist.signout from eventlist, studentInfo where eventlist.event=parevent and studentInfo.studid =eventlist.studid;
	$$
	language 'sql';
