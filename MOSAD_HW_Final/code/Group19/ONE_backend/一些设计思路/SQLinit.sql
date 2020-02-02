grant all privileges on test.* to 'www'@'%' identified by 'www';

create database one_ios;

use one_ios;

create table papers (
    ID_vol 		INTEGER not null,
    motto       text not null,
    motto_auth 	TinyText not null,
    release_year 		INTEGER(4) not null,
    release_month 		INTEGER(2) not null,
    release_day 		INTEGER(2) not null,
    release_data 	    INTEGER(8) not null,
    photo_url   text not null,
    photo_auth  TinyText not null,
    articles_count      INTEGER not null,
    primary key (ID_vol)
) engine=innodb;

create table articles (
    ID_vol          INTEGER not null,
    content_type    TinyText not null,
    title           TinyText not null,
    auth            TinyText not null default '不详',
    photo_url       text not null,
    foreword        text not null,
    content         MEDIUMTEXT not null,
    primary key (ID_vol)
) engine = innodb;
