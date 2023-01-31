drop table T_MC_SGV_OCORRENCIA_SAC;

create  table T_MC_SGV_OCORRENCIA_SAC(
    NR_OCORRENCIA_SAC NUMBER ,
    DT_ABERTURA_SAC DATE,
    HR_ABERTURA_SAC NUMBER(2,0),
    DS_TIPO_CLASSIFICACAO_SAC   VARCHAR2(30) NOT NULL,
    DS_INDICE_SATISFACAO_ATD_SAC    VARCHAR2(30),
    CD_CATEGORIA_PROD   NUMBER(10) NOT NULL,
    NM_TIPO_CATEGORIA_PROD  VARCHAR2(25),
    DS_CATEGORIA_PROD   VARCHAR2(500) NOT NULL,
    CD_PRODUTO  NUMBER(10),
    DS_PRODUTO  VARCHAR(80) NOT NULL,
    TS_EMBALAGEM    VARCHAR2(115),
    VL_PERC_LUCRO   NUMBER(8,2),
    VL_UNITARIO_PRODUTO NUMBER(10,2) NOT NULL,
    VL_UNITARIO_LUCRO_PRODUTO   NUMBER(8,2),
    SG_ESTADO   CHAR(2) NOT NULL,
    NM_ESTADO   VARCHAR2(30) NOT NULL,
    NM_CIDADE   VARCHAR(60) NOT NULL,
    NM_BAIRRO   VARCHAR(45) NOT NULL,
    NR_CLIENTE  NUMBER(10)  NOT NULL,
    NM_CLIENTE VARCHAR2(120) NOT NULL,
    QT_ESTRELAS_CLIENTE NUMBER(1),
    VL_ICMS_PRODUTO NUMBER(8,2),
        CONSTRAINT PK_MC_OCORRENCIA_SAC PRIMARY KEY (NR_OCORRENCIA_SAC)
    );
	/
commit;

CREATE OR REPLACE FUNCTION fn_indice_satisfacao  (
    v_nr_indice_satisfacao NUMBER DEFAULT 0
    )
    RETURN VARCHAR2 IS
begin
    IF v_nr_indice_satisfacao < 4 then RETURN 'PESSIMO';
   ELSIF  v_nr_indice_satisfacao < 6 then RETURN 'RUIM';
   ELSIF  v_nr_indice_satisfacao < 8 then RETURN 'BOM';
   ELSIF  v_nr_indice_satisfacao < 9 then RETURN 'SATISFATORIO';
   ELSIF  v_nr_indice_satisfacao < 11 then RETURN 'EXCELENTE';
   ELSE RETURN 'SEM AVALIACAO' ;
   END IF;
 end fn_indice_satisfacao;
 /
commit;

CREATE OR REPLACE FUNCTION fn_VL_UNITARIO_LUCRO_PRODUTO  (
    v_VL_UNITARIO_PRODUTO NUMBER DEFAULT 0,
    v_VL_PERC_LUCRO NUMBER DEFAULT 0
    )
    RETURN FLOAT IS
begin
    RETURN (v_VL_PERC_LUCRO / 100 ) * v_VL_UNITARIO_PRODUTO;

 end fn_VL_UNITARIO_LUCRO_PRODUTO;
 /
 commit;
 
 create or replace FUNCTION fn_mc_gera_aliquota_media_icms_estado  (
    v_SG_Estado VARCHAR2,
    v_vl_unitario Float
    
    )
    RETURN FLOAT IS
begin
	case 
		when upper(v_sg_estado)='AC' then  return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='AL'then return ((7/ 100 ) * v_vl_unitario) ;
        when upper(v_sg_estado)='AM' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='AP' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='BA' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='CE' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='DF' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='ES' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='GO' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='MA' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='MT' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='MS' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='MG' then return ((12/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='PA' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='PB' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='PR' then return ((12/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='PE' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='PI' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='RN' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='RS' then return ((12/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='RJ' then return ((12/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='RO' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='RO' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='RR' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='SC' then return ((12/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='SP' then return ((18/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='SE' then return ((7/ 100 ) * v_vl_unitario);
        when upper(v_sg_estado)='TO' then return ((7/ 100 ) * v_vl_unitario);
        else return ((4/ 100 ) * v_vl_unitario);
        end case;
 end fn_mc_gera_aliquota_media_icms_estado;
 /
 commit;
 
  CREATE OR REPLACE VIEW "VW_T_MC_SGV_OCORRENCIA_SAC" ("NR_SAC", "DT_ABERTURA_SAC", "HR_ABERTURA_SAC", "TP_SAC", "NR_INDICE_SATISFACAO", "CD_CATEGORIA", "TP_CATEGORIA", "DS_CATEGORIA", "CD_PRODUTO", "DS_PRODUTO", "TP_EMBALAGEM", "VL_PERC_LUCRO","VL_UNITARIO","VL_UNITARIO_LUCRO_PRODUTO","SG_ESTADO", "NM_ESTADO", "NM_CIDADE", "NM_BAIRRO", "NR_CLIENTE", "NM_CLIENTE", "QT_ESTRELAS", "VL_ICMS_PRODUTO") AS 
select 
sac.nr_sac
,sac.dt_abertura_sac
,sac.hr_abertura_sac
,case   when upper(sac.tp_sac) = 'R' then 'RECLAMACAO'  
        when upper(sac.tp_sac) = 'S' then 'SUGESTAO'
        when upper(sac.tp_sac) = 'E' then 'ELOGIO'
        when upper(sac.tp_sac) = 'D' then 'DUVIDA'
        ELSE 'CLASSIFICAÇÃO INVÁLIDA.'  END as TP_SAC
,fn_indice_satisfacao(TO_CHAR(sac.nr_indice_satisfacao)) as "NR_INDICE_SATISFACAO"
,cat.cd_categoria
,case when UPPER(cat.tp_categoria ) = 'P' then 'PRODUTO'
	 when UPPER(cat.tp_categoria ) = 'V' then 'VIDEO'
	 ELSE 'CATEGORIA INVÁLIDA.'   END AS TP_CATEGORIA
,cat.ds_categoria 
,prod.cd_produto 
,prod.ds_produto
,prod.tp_embalagem 
,prod.vl_perc_lucro
,prod.vl_unitario 
, fn_VL_UNITARIO_LUCRO_PRODUTO(prod.vl_unitario,prod.vl_perc_lucro) AS VL_UNITARIO_LUCRO_PRODUTO
,est.sg_estado
,est.nm_estado 
,cid.nm_cidade 
,bairro.nm_bairro 
,cli.nr_cliente
,cli.nm_cliente 
,cli.qt_estrelas 
,fn_mc_gera_aliquota_media_icms_estado (est.sg_estado,to_binary_float(prod.vl_unitario)) AS VL_ICMS_PRODUTO
from t_mc_sgv_sac sac
inner join t_mc_produto prod
on sac.cd_produto = prod.cd_produto
inner join t_mc_categoria_prod cat
on cat.cd_categoria = prod.cd_categoria
inner join t_mc_cliente cli
on cli.nr_cliente = sac.nr_cliente
inner join t_mc_end_cli end_cli
on cli.nr_cliente = end_cli.nr_cliente
and upper(end_cli.st_end) = 'A'
inner join t_mc_logradouro logra
on end_cli.cd_logradouro_cli = logra.cd_logradouro
inner join t_mc_bairro bairro
on bairro.cd_bairro = logra.cd_bairro
inner join t_mc_cidade cid
on cid.cd_cidade = bairro.cd_cidade
inner join t_mc_estado est 
on est.sg_estado = cid.sg_estado

group by 
sac.nr_sac
,sac.dt_abertura_sac
,sac.hr_abertura_sac
,sac.tp_sac
,sac.nr_indice_satisfacao
,cat.cd_categoria
,cat.tp_categoria 
,cat.ds_categoria 
,prod.cd_produto 
,prod.ds_produto
,prod.vl_unitario 
,prod.tp_embalagem 
,prod.vl_perc_lucro
,est.sg_estado
,est.nm_estado 
,cid.nm_cidade 
,bairro.nm_bairro 
,cli.nr_cliente
,cli.nm_cliente 
,cli.qt_estrelas  
order by sac.nr_sac
;
/
commit;

CREATE OR REPLACE PROCEDURE sp_update_T_MC_SGV_OCORRENCIA_SAC (atualizacao in date) is
begin
    delete  from T_MC_SGV_OCORRENCIA_SAC;
    dbms_output.put_line('Dados que serão inseridos na T_MC_SGV_OCORRENCIA_SAC ');
    for linha in (select * from VW_T_MC_SGV_OCORRENCIA_SAC) loop
            
	dbms_output.put_line('nr_sac: '||linha.nr_sac);
    dbms_output.put_line('dt_abertura_sac: '||to_date(linha.dt_abertura_sac,'DD/MM/YYYY'));
    dbms_output.put_line('hr_abertura_sac: '||linha.hr_abertura_sac);
    dbms_output.put_line('tp_sac: '||linha.tp_sac);
    dbms_output.put_line('nr_indice_satisfacao: '||linha.nr_indice_satisfacao);
    dbms_output.put_line('cd_categoria: '||linha.cd_categoria);
    dbms_output.put_line('tp_categoria: '||linha.tp_categoria);
    dbms_output.put_line('ds_categoria: '||linha.ds_categoria);
    dbms_output.put_line('cd_produto: '||linha.cd_produto);
    dbms_output.put_line('ds_produto: '||linha.ds_produto);
    dbms_output.put_line('tp_embalagem: '||linha.tp_embalagem);
    dbms_output.put_line('vl_perc_lucro: '||linha.vl_perc_lucro);
    dbms_output.put_line('vl_unitario: '||linha.vl_unitario);
	dbms_output.put_line('VL_UNITARIO_LUCRO_PRODUTO: '||linha.VL_UNITARIO_LUCRO_PRODUTO);
    dbms_output.put_line('sg_estado: '||linha.sg_estado);
    dbms_output.put_line('nm_estado: '||linha.nm_estado);
    dbms_output.put_line('nm_cidade: '||linha.nm_cidade);
    dbms_output.put_line('nm_bairro: '||linha.nm_bairro);
    dbms_output.put_line('nr_cliente: '||linha.nr_cliente);
    dbms_output.put_line('nm_cliente: '||linha.nm_cliente);
    dbms_output.put_line('qt_estrelas: '||linha.qt_estrelas);
	dbms_output.put_line('vl_icms_produto: '||linha.vl_icms_produto);
    dbms_output.put_line('');   
    end loop;
	
	
    for linha in (select * from VW_T_MC_SGV_OCORRENCIA_SAC) loop
       insert into T_MC_SGV_OCORRENCIA_SAC 
        values
        (
        linha.nr_sac,
        to_date(linha.dt_abertura_sac,'DD/MM/YYYY'),
        linha.hr_abertura_sac,
        linha.tp_sac,
        linha.nr_indice_satisfacao,
        linha.cd_categoria,
        linha.tp_categoria,
        linha.ds_categoria,
        linha.cd_produto,
        linha.ds_produto,
        linha.tp_embalagem,
        linha.vl_perc_lucro,
        linha.vl_unitario,
		linha.VL_UNITARIO_LUCRO_PRODUTO,
        linha.sg_estado,
        linha.nm_estado,
        linha.nm_cidade,
        linha.nm_bairro,
        linha.nr_cliente,
        linha.nm_cliente,
        linha.qt_estrelas,
		linha.vl_icms_produto
        );
    end loop;

    dbms_output.put_line ('Os dados foram atualizados na tabela T_MC_SGV_OCORRENCIA_SAC. Data de atualizacao: '||atualizacao);
end;
/


commit;

set serveroutput on
exec sp_update_T_MC_SGV_OCORRENCIA_SAC (SYSDATE)
commit;