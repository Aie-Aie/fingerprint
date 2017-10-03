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
			select into loc_id events.studid from events, studentInfo where events.studid=studentInfo.studid;

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
--select newevent('2013-1364', 'GAKOP 2017', 'yes', 'no' )

create or replace function getevents(in parID text, out text, out text, out timestamp, out text, out text) returns setof record as
	$$
		select studid, event, eventdate, signin, signout from events where studid = parID;
	$$
	language 'sql';

--select getevents('2013-1364')

create or replace function getstudentdata(in parID text, out text, out text, out text, out text) returns setof record as
	$$
		select studid, firstname, lastname, course from studentInfo where studid= parID;

	$$
	language 'sql'
--select getstudentdata('2013-1364')
	