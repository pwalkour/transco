INSERT INTO `transco`.`sla` (`inc_sla_UK`, `id_sla`, `sla_name_fr`, `sla_name_uk`, `is_used`) VALUES (NULL, 1, 'JOUR', 'DAY', 1);
INSERT INTO `transco`.`sla` (`inc_sla_UK`, `id_sla`, `sla_name_fr`, `sla_name_uk`, `is_used`) VALUES (NULL, 2, 'NUIT', 'NIGHT', 1);
INSERT INTO `transco`.`sla` (`inc_sla_UK`, `id_sla`, `sla_name_fr`, `sla_name_uk`, `is_used`) VALUES (NULL, 3, 'WE', 'WEEKEND', 1);
INSERT INTO `transco`.`sla` (`inc_sla_UK`, `id_sla`, `sla_name_fr`, `sla_name_uk`, `is_used`) VALUES (NULL, 4, 'FERIE', 'HOLIDAY', 1);
;
UPDATE sla set sla_name_uk="poufff" where id_sla=1;

delete from sla where id_sla=3;

call synchSlaHisto ('2013-01-04');

select 
    *
from
    test;
call p();

-- delete from sla where inc_sla_UK>2;
-- delete from sla_histo where inc_sla_UK>=1;
select 
    *
from
    sla;

select 
    *
from
    sla_histo;


DELIMITER $$
DROP PROCEDURE IF EXISTS getSlaHistoEffdtSerial $$
create procedure getSlaHistoEffdtSerial (IN i_Effdt date, IN i_Nav varchar(8), out o_Effdt date, out o_Serial INT)
begin
if (i_Nav="next") then
    select coalesce(min(slaH.effdt),'1900-01-01') into o_Effdt
      from sla_histo slaH
     where slaH.effdt>i_Effdt
    ;
end if;
if (i_Nav="current") then
    select coalesce(max(slaH.effdt),'1900-01-01') into o_Effdt
      from sla_histo slaH
     where slaH.effdt<=i_Effdt
    ;
end if;
if (i_Nav="previous") then
    select coalesce(max(slaH.effdt),'1900-01-01') into o_Effdt
      from sla_histo slaH
     where slaH.effdt<i_Effdt
    ;
end if;


select coalesce(max(slaH.serial),0) into o_Serial
  from sla_histo slaH
 where slaH.effdt=o_Effdt
;


end $$
DELIMITER ;

DELIMITER $$
DROP PROCEDURE IF EXISTS manageSla $$
create procedure manageSla (IN i_IdSla INT, IN i_NameFr varchar(45), IN i_NameUk varchar(45), IN i_IsUsed BOOL, IN i_Effdt date)
begin
    DECLARE v_NbrIdSla int;
    DECLARE v_Effdt date;
    DECLARE v_Serial int;

    call getSlaHistoEffdtSerial(i_Effdt, v_Effdt, v_Serial);
    if (v_effdt<= i_Effdt) then
        SET v_NbrIdSla=0;

        select coalesce(count(*),0) into v_NbrIdSla from sla where id_sla=i_IdSla;
        if (v_NbrIdSla=0) then 
            insert into sla (id_sla,sla_name_fr,sla_name_uk,is_used) values (i_IdSla, i_NameFr, i_NameUk, i_IsUsed);
            commit;
        else
            update sla set sla_name_fr=i_NameFr,sla_name_uk=i_NameUk,is_used=i_IsUsed where id_sla=i_IdSla;
            commit;
        end if;
    end if;
end $$
DELIMITER ;



DELIMITER $$
DROP PROCEDURE IF EXISTS synchSlaHisto $$
create procedure synchSlaHisto (IN i_Effdt date)
begin
    DECLARE v_Effdt date;
    DECLARE v_Serial int;

    call getSlaHistoEffdtSerial(i_Effdt, v_Effdt, v_Serial);
    if (v_Effdt= i_Effdt) then
        insert into sla_histo (id_sla, effdt,serial,is_used, sla_name_fr, sla_name_uk) select sr.id_sla, v_effdt, (v_Serial+1),sr.is_used, sr.sla_name_fr, sr.sla_name_uk from sla sr;
    else if (v_Effdt< i_Effdt) then
            insert into sla_histo (id_sla, effdt,serial,is_used, sla_name_fr, sla_name_uk) select sr.id_sla, i_Effdt, 1,sr.is_used, sr.sla_name_fr, sr.sla_name_uk from sla sr;
         end if;
    end if;
end $$
DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS getSlaHistoData $$
create procedure getSlaHistoData (IN i_Effdt date,IN i_Nav varchar(8))
begin

    call getSlaHistoEffdtSerial(i_Effdt, i_nav, @aEffdt, @aSerial);
    if (@aEffdt<>'1900-01-01') then
        select id_sla, effdt,serial,is_used, sla_name_fr, sla_name_uk from sla_histo where effdt=@aEffdt and serial=@aSerial;
    else
        select 0, @aEffdt,@aSerial,0, 'Pas de données', 'No data';
    end if;

    -- select id_sla, effdt,serial,is_used, sla_name_fr, sla_name_uk from sla_histo where effdt='2013-01-01' and serial=1;
end $$
DELIMITER ;

call getSlaHistoEffdtSerial('2013-02-02','next', @aEffdt, @aSerial);
select @aEffdt,@aSerial;
select id_sla, effdt,serial,is_used, sla_name_fr, sla_name_uk from sla_histo where effdt=@aEffdt and serial=@aSerial;
call synchSlaHisto ('2013-01-02');


call getSlaHistoData('2013-01-01',@aIdSla, @aEffdt, @aSerial, @aIsUsed, @aSlaNameFr, @aSlaNameUk);
select @aIdSla, @aEffdt, @aSerial, @aIsUsed, @aSlaNameFr, @aSlaNameUk;
-- delete from sla where inc_sla_UK>2;
-- delete from sla_histo where inc_sla_UK>=1;

-- commit;
call getSlaHistoData('2013-01-01');

call getSlaHistoData('2013-01-02');

call getSlaHistoData('2013-01-03');
call getSlaHistoData('2012-02-02');

UPDATE sla set sla_name_uk="tutu" where id_sla=4;