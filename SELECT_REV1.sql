/*A) Crie uma consulta por meio do comando SELECT que exiba informações das categorias de produto e respectivos produtos de cada categoria. 
Exiba as seguintes informações: código e nome da categoria, código e descrição do produto, valor unitário, tipo de embalagem e percentual do 
lucro de cada produto. Caso exista alguma categoria sem produto, favor exibir a categoria e deixar os dados do produto em branco. 
Classifique a consulta em ordem de categoria e nome de produto de forma ascendente.*/

SELECT  C.CD_CATEGORIA   "CÓDIGO DA CATEGORIA",
        C.DS_CATEGORIA  "NOME DA CATEGORIA",
        P.CD_PRODUTO    "CÓDIGO DO PRODUTO",
        P.DS_PRODUTO    "DESCRIÇÃO DO PRODUTO",
        P.VL_UNITARIO   "VALOR UNITARIO DO PRODUTO",
        P.TP_EMBALAGEM  "TIPO DE EMBALAGEM",
        P.VL_PERC_LUCRO "VALOR PERCENTUAL DO LUCRO"
        
FROM T_MC_CATEGORIA_PROD C INNER JOIN T_MC_PRODUTO P
ON (C.CD_CATEGORIA = P.CD_CATEGORIA)
ORDER BY C.TP_CATEGORIA ASC,P.DS_PRODUTO ASC;

/*B) Crie uma consulta por meio do comando SELECT que exiba a quantidade de clientes agrupados por Estado, cidade e bairro. 
Classifique a consulta por nome do Estado, nome da cidade e nome do bairro. Caso não existam clientes cadastrados para algum 
bairro, exiba o valor zero para o bairro.*/

SELECT E.NM_ESTADO "NOME DO ESTADO",
        CI.NM_CIDADE "NOME DA CIDADE", 
        NVL(B.NM_BAIRRO,'0') "NOME DO BAIRRO", 
        COUNT (C.NR_CLIENTE) "NUMERO DO CLIENTE POR REGIÃO"
    FROM T_MC_ESTADO E INNER JOIN T_MC_CIDADE CI
        ON (E.SG_ESTADO = CI.SG_ESTADO)
      INNER JOIN T_MC_BAIRRO B
        ON (CI.CD_CIDADE = B.CD_CIDADE)
      INNER JOIN T_MC_LOGRADOURO L
        ON (B.CD_BAIRRO = L.CD_BAIRRO)
      INNER JOIN T_MC_CLIENTE C
        ON (C.NR_CLIENTE = L.CD_LOGRADOURO)
    GROUP BY E.NM_ESTADO, CI.NM_CIDADE, B.NM_BAIRRO;
	

/*C) Crie uma instrução SQL que exiba o TOP 10 vídeos de produtos assistidos pelo cliente. Exiba o código do produto, nome 
do produto, ano e mês de visualização e a quantidade total de visualizações que o produto teve durante o ano e mês.*/


SELECT ROWNUM AS RANK,
V.CD_PRODUTO "CÓDIGO DO PRODUTO",
P.DS_PRODUTO "NOME DO PRODUTO",
TO_DATE(V.DT_VISUALIZACAO,'YYYY/MM') "ANO E MÊS DE VISUALIZAÇÃO",
COUNT(V.CD_VISUALIZACAO_VIDEO) "QUANTIDADE DE VISUALIZAÇÃO"
FROM T_MC_PRODUTO P INNER JOIN T_MC_SGV_VISUALIZACAO_VIDEO V
ON (P.CD_PRODUTO = V.CD_PRODUTO)
WHERE ROWNUM <= 10
GROUP BY ROWNUM, V.CD_PRODUTO,P.DS_PRODUTO, V.DT_VISUALIZACAO, V.CD_VISUALIZACAO_VIDEO
ORDER BY CD_VISUALIZACAO_VIDEO DESC;



--CORETO 
 select 
 
v.cd_produto,
P.DS_PRODUTO "NOME DO PRODUTO",
to_char (v.dt_visualizacao, 'YYYY-MON'),
 count(v.cd_produto) "conta"
FROM T_MC_PRODUTO P INNER JOIN T_MC_SGV_VISUALIZACAO_VIDEO V
 ON (P.CD_PRODUTO = V.CD_PRODUTO)

 WHERE ROWNUM <= 10
 
group by v.cd_produto,P.DS_PRODUTO,V.DT_VISUALIZACAO
order by count(v.cd_produto) desc
  

	
	
	
/*D) Crie uma instrução SQL que exiba os dados dos clientes pessoa física. Exiba as seguintes informações: código e nome do 
cliente, e-mail, telefone, login, data de nascimento, sexo biológico e CPF.*/


SELECT F.NR_CLIENTE "CÓDIGO CLIENTE", 
        C.NM_CLIENTE "NOME CLIENTE", 
        C.DS_EMAIL "E-MAIL CLIENTE",
        C.NR_TELEFONE "TELEFONE CLIENTE", 
        C.NM_LOGIN "LOGIN CLIENTE", 
        F.DT_NASCIMENTO "DATA DE NASCIMENTO CLIENTE", 
        F.DS_GENERO "GENERO CLIENTE", 
        F.NR_CPF "CPF CLIENTE"
FROM T_MC_CLI_FISICA F INNER JOIN T_MC_CLIENTE C
ON ( C.NR_CLIENTE = F.NR_CLIENTE);




/*E)Crie uma instrução SQL que exiba os dados dos clientes pessoa jurídica. Exiba as seguintes informações: código e nome do cliente, 
e-mail, telefone, login, data de fundação e CNPJ.*/


SELECT J.NR_CLIENTE "CÓDIGO CLIENTE", 
        C.NM_CLIENTE "NOME CLIENTE", 
        C.DS_EMAIL "E-MAIL CLIENTE",
        C.NR_TELEFONE "TELEFONE CLIENTE", 
        C.NM_LOGIN "LOGIN CLIENTE", 
        J.DT_FUNDACAO "DATA DA FUNDAÇÃO", 
        J.NR_CNPJ "CNPJ CLIENTE"
FROM T_MC_CLI_JURIDICA J INNER JOIN T_MC_CLIENTE C
ON ( C.NR_CLIENTE = J.NR_CLIENTE);


/*F)Exiba qual é o dia da semana em que os vídeos são mais acessados. Exiba o dia da semana por extenso e a quantidade de vídeos acessados. 
Classifique a saída de dados por quantidade de vídeos mais acessados, ou seja, por ordem descendente.*/



SELECT TO_CHAR( V.DT_VISUALIZACAO,'fmDAY', 'NLS_DATE_LANGUAGE=PORTUGUESE') "DIA DA SEMANA", 
COUNT (V.CD_PRODUTO) "QUANTIDADE DE VISUALIZAÇÃO"
FROM T_MC_SGV_VISUALIZACAO_VIDEO V
GROUP BY V.CD_PRODUTO, TO_CHAR( V.DT_VISUALIZACAO,'fmDAY', 'NLS_DATE_LANGUAGE=PORTUGUESE')
ORDER BY COUNT (V.CD_PRODUTO) DESC;



/*G)Exiba por ano e por mês a quantidade de chamados abertos no SAC até o momento. Exiba o ano e mês da abertura do SAC e a quantidade de ocorrências 
abertas pelo cliente por ano e mês. Classifique a consulta em ordem de ano e mês.*/


SELECT TO_DATE(S.DT_ABERTURA_SAC,'YYYY/MM')"ANO/MÊS DA ABERTURA DOS CHAMADOS", 
COUNT ( S.NR_SAC )"QUANTIDADE DE OCORRÊNCIAS"
FROM T_MC_SGV_SAC S
GROUP BY S.DT_ABERTURA_SAC
ORDER BY S.DT_ABERTURA_SAC DESC;



/*H)Exiba o chamado no SAC que teve o maior tempo de atendimento total em número de horas (*utilize a técnica de subquery). Fica a seu 
critério informar as colunas que julgar necessárias. Não utilize *, selecione algumas colunas relevantes.*/


SELECT  ROWNUM as RANK, 
        NR_SAC "NUMERO DO SAC", 
        NR_TEMPO_TOTAL_SAC "TEMPO DE ATENDIMENTO"        
    FROM 
        ( SELECT    NR_SAC, 
                    NR_TEMPO_TOTAL_SAC 
        FROM T_MC_SGV_SAC 
        ORDER BY NR_TEMPO_TOTAL_SAC DESC
        )
 WHERE ROWNUM <= 1; 
 
 
/*I)Exiba a quantidade média do índice de satisfação informada pelo cliente para cada funcionário. Exiba o código e nome do 
funcionário, o nome do departamento onde ele trabalha, seu cargo e também exiba o valor do índice médio geral de satisfação 
aplicado em cada chamado pelo cliente. Os funcionários que não têm status A(tivo) não devem ser exibidos.*/

 
SELECT  S.CD_FUNCIONARIO "CÓDIGO DO FUNCIONARIO",
        F.NM_FUNCIONARIO "NOME DO FUNCIONARIO",
        D.NM_DEPTO "NOME DO DEPARTAMENTO",
        F.DS_CARGO "CARGO DO FUNCIONARIO",
        F.ST_FUNC "STATUS FUNCIONARIO",
        AVG (S.NR_INDICE_SATISFACAO) "MÉDIA DO INDICE DE SATISFAÇÃO"
FROM T_MC_DEPTO D INNER JOIN T_MC_FUNCIONARIO F
        ON (D.CD_DEPTO = F.CD_DEPTO)
      INNER JOIN T_MC_SGV_SAC S
        ON (F.CD_FUNCIONARIO = S.CD_FUNCIONARIO) 
        WHERE F.ST_FUNC = 'A'
GROUP BY S.CD_FUNCIONARIO, F.NM_FUNCIONARIO, D.NM_DEPTO, F.DS_CARGO, F.ST_FUNC, S.NR_INDICE_SATISFACAO;


/*J)Exiba a quantidade total de vídeos agrupados por produto. Exiba o código e nome do produto, o valor unitário e o status do produto. 
Exiba somente os produtos que estejam com status A(tivo) e, caso o produto esteja sem vídeo, exiba o valor zero para o agrupamento.*/


SELECT  P.CD_PRODUTO "CÓDIGO DO PRODUTO",
        P.DS_PRODUTO "NOME DO PRODUTO",
        P.VL_UNITARIO "VALOR UNITARIO DO PRODUTO",
        P.ST_PRODUTO "STATUS DO PRODUTO",
        COALESCE(to_char(COUNT(V.DS_PATH_VIDEO_PROD)),'0') "QUANTIDADE DE VIDEOS"
FROM T_MC_PRODUTO P LEFT JOIN T_MC_SGV_PRODUTO_VIDEO V
    ON (P.CD_PRODUTO = V.CD_PRODUTO)
    WHERE P.ST_PRODUTO = 'A' 
GROUP BY P.CD_PRODUTO, P.DS_PRODUTO, P.VL_UNITARIO, P.ST_PRODUTO
order by COALESCE(to_char(COUNT(V.DS_PATH_VIDEO_PROD)),'0')  desc;