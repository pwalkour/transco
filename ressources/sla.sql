-- ***********************
-- ***********************
DELIMITER $$
DROP PROCEDURE IF EXISTS slaGetHistoEffdtSerial $$
CREATE PROCEDURE slaGetHistoEffdtSerial (IN i_Effdt date, IN i_Nav varchar(8), out o_Effdt date, out o_Serial INT)
begin
-- ******** IN ***********
-- 
-- ******** OUT **********
-- 
-- ******** AIM **********
-- 
-- ******** REM **********
--
-- ***********************
    Declare v_NbrRecords int; 
if (i_Nav="next") then
    select count(*) into v_NbrRecords from slaHisto slaH
     where slaH.effdt>i_Effdt;
    if ( v_NbrRecords<>0) then
        select coalesce(min(slaH.effdt),'1900-01-01') into o_Effdt
        from slaHisto slaH
        where slaH.effdt>i_Effdt;
    else
        select coalesce(min(slaH.effdt),'1900-01-01') into o_Effdt
        from slaHisto slaH
        where slaH.effdt=i_Effdt;
    end if;
end if;
if (i_Nav="current") then
    select coalesce(max(slaH.effdt),'1900-01-01') into o_Effdt
      from slaHisto slaH
     where slaH.effdt<=i_Effdt
    ;
end if;
if (i_Nav="previous") then
    select count(*) into v_NbrRecords from slaHisto slaH
     where slaH.effdt<i_Effdt;
    if ( v_NbrRecords<>0) then
        select coalesce(max(slaH.effdt),'1900-01-01') into o_Effdt
        from slaHisto slaH
        where slaH.effdt<i_Effdt;
    else
        select coalesce(max(slaH.effdt),'1900-01-01') into o_Effdt
        from slaHisto slaH
        where slaH.effdt=i_Effdt;
    end if;
end if;


select coalesce(max(slaH.serial),0) into o_Serial
  from slaHisto slaH
 where slaH.effdt=o_Effdt
;


end $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS slaAddUpdate $$
create procedure slaAddUpdate (IN i_IdSla INT, IN i_NameFr varchar(45), IN i_NameUk varchar(45), IN i_IsUsed BOOL, IN i_Effdt date)
begin
-- ******** IN ***********
-- 
-- ******** OUT **********
-- 
-- ******** AIM **********
-- 
-- ******** REM **********
--
-- ***********************
    DECLARE v_NbrIdSla int;
    DECLARE v_Effdt date;
    DECLARE v_Serial int;

    call slaGetHistoEffdtSerial(i_Effdt, 'current',v_Effdt, v_Serial);
    if (v_effdt<= i_Effdt) then
        SET v_NbrIdSla=0;

        select coalesce(count(*),0) into v_NbrIdSla from sla where idSla=i_IdSla;
        if (v_NbrIdSla=0) then 
            insert into sla (idSla,slaNameFR,slaNameUK,isUsed) values (i_IdSla, i_NameFr, i_NameUk, i_IsUsed);
            commit;
        else
            update sla set slaNameFR=i_NameFr,slaNameUK=i_NameUk,isUsed=i_IsUsed where idSla=i_IdSla;
            commit;
        end if;
    end if;
end $$
DELIMITER ;



DELIMITER $$
DROP PROCEDURE IF EXISTS slaSynchHisto $$
CREATE PROCEDURE slaSynchHisto()
begin
-- ******** IN ***********
-- 
-- ******** OUT **********
-- 
-- ******** AIM **********
-- 
-- ******** REM **********
--
-- ***********************
    DECLARE i_Effdt date;
    DECLARE v_Effdt date;
    DECLARE v_Serial int;    
    select min(effdt) into i_Effdt from slaIns;
    call slaGetHistoEffdtSerial(i_Effdt, 'current',v_Effdt, v_Serial);
    if (v_Effdt= i_Effdt) then
        insert into slaHisto (idSla, effdt,serial,isUsed, slaNameFR, slaNameUK) select sr.idSla, v_effdt, (v_Serial+1),sr.isUsed, sr.slaNameFR, sr.slaNameUK from slaIns sr;
    else if (v_Effdt< i_Effdt) then
            insert into slaHisto (idSla, effdt,serial,isUsed, slaNameFR, slaNameUK) select sr.idSla, i_Effdt, 1,sr.isUsed, sr.slaNameFR, sr.slaNameUK from slaIns sr;
         end if;
    end if;
end$$
DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS slaGetHistoData $$
create procedure slaGetHistoData (IN i_Effdt date,IN i_Nav varchar(8))
begin
-- ******** IN ***********
-- 
-- ******** OUT **********
-- 
-- ******** AIM **********
-- 
-- ******** REM **********
--
-- ***********************
    call slaGetHistoEffdtSerial(i_Effdt, i_nav, @aEffdt, @aSerial);
    if (@aEffdt<>'1900-01-01') then
        select idSla, effdt,serial,isUsed, slaNameFR, slaNameUK from slaHisto where effdt=@aEffdt and serial=@aSerial;
    else
        select 0, @aEffdt,@aSerial,0, 'Pas de données', 'No data';
    end if;
end $$
DELIMITER ;

call slaGetHistoEffdtSerial('2013-02-02','next', @aEffdt, @aSerial);
select @aEffdt,@aSerial;
select id_sla, effdt,serial,is_used, sla_name_fr, sla_name_uk from sla_histo where effdt=@aEffdt and serial=@aSerial;
call slaSynchHisto ('2013-01-02');


call slaGetHistoData('2013-01-01',@aIdSla, @aEffdt, @aSerial, @aIsUsed, @aSlaNameFr, @aSlaNameUk);
select @aIdSla, @aEffdt, @aSerial, @aIsUsed, @aSlaNameFr, @aSlaNameUk;
-- delete from sla where inc_sla_UK>2;
-- delete from sla_histo where inc_sla_UK>=1;

-- commit;
call slaGetHistoData('2013-01-01');

call slaGetHistoData('2013-01-02');

call slaGetHistoData('2013-01-03');
call slaGetHistoData('2012-02-02');

UPDATE sla set sla_name_uk="tutu" where id_sla=4;
-- ***********************
-- Simulate data entries
-- ***********************
delete from fieldsTitles
where idTitle=20;
insert into fieldsTitles (tableName,filedName,titleName,selectType,insertType) values('sla','idSla', 'SLA Code' ,'text','text');
insert into fieldsTitles (tableName,filedName,titleName,selectType,insertType) values('sla','effdt','Effective Date','text','date');
insert into fieldsTitles (tableName,filedName,titleName,selectType,insertType) values('sla','serial','Serial','text','text');
insert into fieldsTitles (tableName,filedName,titleName,selectType,insertType) values('sla','isUsed','Est Actif','text','radio');
insert into fieldsTitles (tableName,filedName,titleName,selectType,insertType) values('sla','slaNameFR','Nom Français','text','text');
insert into fieldsTitles (tableName,filedName,titleName,selectType,insertType) values('sla','slaNameUK','Nom Anglais','text','text');

select * from fieldsTitles;

call getColumnsTitles ('sla');

-- ***********************
-- Simulate data entries
-- ***********************
delete from slaIns;
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (1,'2013-01-01',1, 'JOUR', 'DAY');
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (2,'2013-01-01',1, 'NUIT', 'NIGHT');
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (3,'2013-01-01',1, 'WE', 'WEEKEND');
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (4,'2013-01-01',1, 'FERIE', 'HOLIDAY');
;
call slaSynchHisto;
select * from sla;

delete from slaIns;
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (1,'2013-01-01',1, 'JOUR', 'DAY');
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (2,'2013-01-01',1, 'NUIT', 'NIGHT');
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (3,'2013-01-01',0, 'WE', 'WEEKEND');
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (4,'2013-01-01',1, 'FERIEEEE', 'HOLIDAY');
;
call slaSynchHisto;
select * from sla;

delete from slaIns;
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (1,'2013-01-02',1, 'JOUR', 'DAY');
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (2,'2013-01-02',1, 'NUIT', 'NIGHT');
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (3,'2013-01-02',0, 'WE', 'WEEKEND');
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (4,'2013-01-02',1, 'FERIE', 'HOLIDAY');
;
call slaSynchHisto;
select * from sla;

delete from slaIns;
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (1,'2013-04-05',1, 'JOUR', 'DAY');
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (2,'2013-04-05',1, 'NUIT', 'NIGHT');
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (3,'2013-04-05',0, 'WE', 'WEEKEND');
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (4,'2013-04-05',1, 'FERIES', 'HOLIDAY');
;
call slaSynchHisto;
select * from sla;

delete from slaIns;
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (1,'2013-04-15',1, 'JOUR', 'DAY');
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (2,'2013-04-15',1, 'NUIT', 'NIGHT');
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (3,'2013-04-15',0, 'WEA', 'WEEKEND');
INSERT INTO `transco`.`slaIns` (`idSla`, `effdt`, `isUsed`, `slaNameFR`, `slaNameUK`) VALUES (4,'2013-04-15',1, 'FERIES', 'HOLIDAY');
;
call slaSynchHisto;
select * from sla;


-- simulate an update
UPDATE sla set sla_name_uk="poufff" where id_sla=1;

-- simulate a delete
delete from sla where id_sla=3;

-- REMARK about delete do not delete the row, change the field "is_used" to 0, so it can be re-used later

-- simulate a global commit on date of 4 January 2013
call slaSynchHisto;
select * from slaIns;
-- ('2013-01-01');

select * from sla;
call p();

-- delete from sla where inc_sla_UK>2;
-- delete from sla_histo where inc_sla_UK>=1;
select * from sla;
INSERT INTO `transco`.`sla` (`inc_sla_UK`, `id_sla`, `sla_name_fr`, `sla_name_uk`, `is_used`) VALUES (NULL, 3, 'WE', 'WEEKEND', 0);
insert into sla_histo (id_sla, effdt,serial,is_used, sla_name_fr, sla_name_uk) values( 3, '2013-01-04', 2,0, 'WE', 'WEEKEND') ;
select 
    *
from
    sla_histo;


call slaGetHistoData ('2013-04-05','previous');
call slaGetHistoData (CURDATE(),'current');
call slaGetHistoData (CURDATE(),'next');
select coalesce(max(slaH.effdt),'1900-01-01') into o_Effdt
      from sla_histo slaH
     where slaH.effdt<=i_Effdt
;
select 
      sla.id_sla
    , sla.effdt
    , sla.serial
    , sla.is_used
    , sla.sla_name_fr
    , sla.sla_name_uk
from Sla_histo sla 
where sla.effdt=( select coalesce(max(slaE.effdt),'1900-01-01') from sla_histo slaE where slaE.effdt<=curdate())
  and sla.serial=( select coalesce(max(slaS.serial),0) from Sla_histo slaS where slaS.effdt=(select coalesce(max(slaE.effdt),'1900-01-01') from sla_histo slaE where slaE.effdt<=curdate()))

order by id_sla
;
select 
      id_sla
    , effdt
    , serial
    , is_used
    , sla_name_fr
    , sla_name_uk
from Sla_histo Sla
   , ( select SlaEffdt.o_effdt, coalesce(max(slaS.serial),0) as o_Serial
         from sla_histo slaS
             , ( select coalesce(max(slaE.effdt),'1900-01-01') as o_Effdt
                 from sla_histo slaE
                where slaE.effdt<=curdate()
               ) SlaEffdt
        where slaS.effdt = SlaEffdt.o_Effdt
      ) SlaCur
where Sla.effdt=SlaCur.o_Effdt
  and Sla.serial=SlaCur.o_Serial
order by id_sla
;


desc slaHisto;