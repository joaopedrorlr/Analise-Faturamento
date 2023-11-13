

-- Importar bases

-- Unir bases PP e j� selecionar as colunas que v�o ser utilizadas

drop table if exists PerfectPay
create table PerfectPay
(DataVenda nvarchar(255),
Status nvarchar(255), 
FormaPagamento nvarchar(255), 
Produto nvarchar(255), 
ValorVenda nvarchar(255), 
ValorComiss�o nvarchar(255)
)

insert into PerfectPay (DataVenda, Status, FormaPagamento, Produto, ValorVenda, ValorComiss�o)
select DataVenda, Status, FormaPagamento, Produto, ValorVenda, ValorComiss�o
from dbo.PP1

insert into PerfectPay (DataVenda, Status, FormaPagamento, Produto, ValorVenda, ValorComiss�o)
select DataVenda, Status, FormaPagamento, Produto, ValorVenda, ValorComiss�o
from dbo.PP2

------------------------------------------------------------------------------------------------------------------
-- Hotmart
	-- Preencher valores vazios da coluna de pa�s (com Brasil)

select Pa�s,
case
when Pa�s = '' then 'Brasil'
else Pa�s
end
from dbo.Hotmart

update dbo.Hotmart
set Pa�s = case
when Pa�s = '' then 'Brasil'
else Pa�s
end

	-- Criar coluna de Valor da Venda (Pre�o total convertido * C�mbio)

alter table dbo.Hotmart
add ValordaVenda float

update dbo.Hotmart
set ValordaVenda = [Pre�o Total Convertido] * [Taxa de C�mbio da Comiss�o]

	-- Criar coluna de nome da plataforma (Hotmart)

alter table dbo.Hotmart
add Plataforma nvarchar(255)

update dbo.Hotmart
set Plataforma = 'Hotmart'

	-- Criar colunas de m�s e ano

alter table dbo.Hotmart
add M�s int

update dbo.Hotmart
set M�s = cast(SUBSTRING([Data de Venda], 4, 2) as int)

alter table dbo.Hotmart
add Ano int

update dbo.Hotmart
set Ano = cast(SUBSTRING([Data de Venda], 7, 4) as int)

	-- Preencher valores vazios da coluna de Valor da Venda (usando valores da coluna Pre�o do produto)

update dbo.Hotmart
set ValordaVenda = isnull(ValordaVenda, [Pre�o do produto])

	-- Preencher valores vazios da coluna de Valor da Comiss�o Convertido (valor da comiss�o gerada)

update dbo.Hotmart
set [Valor da Comiss�o Convertido] = isnull([Valor da Comiss�o Convertido], [Valor da Comiss�o Gerada])

	-- Selecionando as colunas que v�o ser utilizadas e colocando em ordem

drop table if exists HotmartAjustada
create table HotmartAjustada
(Plataforma nvarchar(255),
Produto nvarchar(255),
DataVenda nvarchar(255),
M�s int,
Ano int,
Status nvarchar(255), 
ValorVenda float,
ValorComiss�o float,
FormaPagamento nvarchar(255), 
Pa�s nvarchar(255)
)

insert into HotmartAjustada (Plataforma, Produto, DataVenda, M�s, Ano, Status, ValorVenda, ValorComiss�o, FormaPagamento, Pa�s)
select Plataforma, [Nome do Produto], [Data de Venda], M�s, Ano, Status, [ValordaVenda], [Valor da Comiss�o Convertido], [Tipo de Pagamento], Pa�s
from dbo.Hotmart

------------------------------------------------------------------------------------------------------------------
-- Kiwify
	-- Criar coluna de Pa�s (com Brasil)

alter table dbo.Kiwify
add Pa�s nvarchar(255)

update dbo.Kiwify
set Pa�s = 'Brasil'

	-- Criar coluna de nome da plataforma (Kiwify)

alter table dbo.Kiwify
add Plataforma nvarchar(255)

update dbo.Kiwify
set Plataforma = 'Kiwify'

	-- Criar colunas de m�s e ano

alter table dbo.Kiwify
add M�s int

update dbo.Kiwify
set M�s = cast(SUBSTRING([Data de Cria��o], 4, 2) as int)

alter table dbo.Kiwify
add Ano int

update dbo.Kiwify
set Ano = cast(SUBSTRING([Data de Cria��o], 7, 4) as int)

	-- Selecionando as colunas que v�o ser utilizadas e colocando em ordem

drop table if exists KiwifyAjustada
create table KiwifyAjustada
(Plataforma nvarchar(255),
Produto nvarchar(255),
DataVenda nvarchar(255),
M�s int,
Ano int,
Status nvarchar(255), 
ValorVenda float,
ValorComiss�o float,
FormaPagamento nvarchar(255), 
Pa�s nvarchar(255)
)

insert into KiwifyAjustada (Plataforma, Produto, DataVenda, M�s, Ano, Status, ValorVenda, ValorComiss�o, FormaPagamento, Pa�s)
select Plataforma, Produto, [Data de Cria��o], M�s, Ano, Status, [Pre�o base do produto], [Valor l�quido], [Pagamento], Pa�s
from dbo.Kiwify

------------------------------------------------------------------------------------------------------------------
-- PerfectPay
	-- Criar coluna de Pa�s (com Brasil)

alter table dbo.PerfectPay
add Pa�s nvarchar(255)

update dbo.PerfectPay
set Pa�s = 'Brasil'

	-- Criar coluna de nome da plataforma (Perfect Pay)

alter table dbo.PerfectPay
add Plataforma nvarchar(255)

update dbo.PerfectPay
set Plataforma = 'Perfect Pay'

	-- Criar colunas de m�s e ano

alter table dbo.PerfectPay
add M�s int

update dbo.PerfectPay
set M�s = cast(SUBSTRING([DataVenda], 4, 2) as int)

alter table dbo.PerfectPay
add Ano int

update dbo.PerfectPay
set Ano = cast(SUBSTRING([DataVenda], 7, 4) as int)

	-- Mudando tipos das colunas de Valor Venda e Valor Comiss�o

update dbo.PerfectPay
set ValorVenda = cast(replace(ValorVenda, ',', '.') as float)

update dbo.PerfectPay
set ValorComiss�o = cast(replace(ValorComiss�o, ',', '.') as float)

	-- Colocando as colunas em ordem

drop table if exists PerfectPayAjustada
create table PerfectPayAjustada
(Plataforma nvarchar(255),
Produto nvarchar(255),
DataVenda nvarchar(255),
M�s int,
Ano int,
Status nvarchar(255), 
ValorVenda float,
ValorComiss�o float,
FormaPagamento nvarchar(255), 
Pa�s nvarchar(255)
)

insert into PerfectPayAjustada (Plataforma, Produto, DataVenda, M�s, Ano, Status, ValorVenda, ValorComiss�o, FormaPagamento, Pa�s)
select Plataforma, Produto, DataVenda, M�s, Ano, Status, ValorVenda, ValorComiss�o, FormaPagamento, Pa�s
from dbo.PerfectPay

------------------------------------------------------------------------------------------------------------------
-- Stripe
	-- Criar coluna de Pa�s (com Exterior)

alter table dbo.Stripe
add Pa�s nvarchar(255)

update dbo.Stripe
set Pa�s = 'Exterior'

	-- Criar coluna de produto (EspiaYa)

alter table dbo.Stripe
add Produto nvarchar(255)

update dbo.Stripe
set Produto = 'EspiaYa'

	-- Criar colunas de forma de pagamento (Cart�o de cr�dito)

alter table dbo.Stripe
add FormaPagamento nvarchar(255)

update dbo.Stripe
set FormaPagamento = 'Cart�o de Credito'

	-- Criar coluna de Valor L�quido (Converted amount - Fee)

alter table dbo.Stripe
add ValorL�quido nvarchar(255)

update dbo.Stripe
set ValorL�quido = cast([Converted Amount] as float) - cast([Fee] as float)

	-- Criar coluna de nome da plataforma (Stripe)

alter table dbo.Stripe
add Plataforma nvarchar(255)

update dbo.Stripe
set Plataforma = 'Stripe'

	-- Criar colunas de m�s e ano

alter table dbo.Stripe
add M�s int

update dbo.Stripe
set M�s = cast(SUBSTRING([Created (UTC)], 6, 2) as int)

alter table dbo.Stripe
add Ano int

update dbo.Stripe
set Ano = cast(SUBSTRING([Created (UTC)], 1, 4) as int)

	-- Selecionando as colunas que v�o ser utilizadas e colocando em ordem

drop table if exists StripeAjustada
create table StripeAjustada
(Plataforma nvarchar(255),
Produto nvarchar(255),
DataVenda nvarchar(255),
M�s int,
Ano int,
Status nvarchar(255), 
ValorVenda float,
ValorComiss�o float,
FormaPagamento nvarchar(255), 
Pa�s nvarchar(255)
)

insert into StripeAjustada (Plataforma, Produto, DataVenda, M�s, Ano, Status, ValorVenda, ValorComiss�o, FormaPagamento, Pa�s)
select Plataforma, Produto, [Created (UTC)], M�s, Ano, Status, [Converted Amount], ValorL�quido, FormaPagamento, Pa�s
from dbo.Stripe

------------------------------------------------------------------------------------------------------------------

-- Unir bases

drop table if exists BaseConsolidada
create table BaseConsolidada
(Plataforma nvarchar(255),
Produto nvarchar(255),
DataVenda nvarchar(255),
M�s int,
Ano int,
Status nvarchar(255), 
ValorVenda float,
ValorComiss�o float,
FormaPagamento nvarchar(255), 
Pa�s nvarchar(255)
)

insert into BaseConsolidada (Plataforma, Produto, DataVenda, M�s, Ano, Status, ValorVenda, ValorComiss�o, FormaPagamento, Pa�s)
select *
from dbo.HotmartAjustada

insert into BaseConsolidada (Plataforma, Produto, DataVenda, M�s, Ano, Status, ValorVenda, ValorComiss�o, FormaPagamento, Pa�s)
select *
from dbo.KiwifyAjustada

insert into BaseConsolidada (Plataforma, Produto, DataVenda, M�s, Ano, Status, ValorVenda, ValorComiss�o, FormaPagamento, Pa�s)
select *
from dbo.PerfectPayAjustada

insert into BaseConsolidada (Plataforma, Produto, DataVenda, M�s, Ano, Status, ValorVenda, ValorComiss�o, FormaPagamento, Pa�s)
select *
from dbo.StripeAjustada

-- Agrupar produtos com mesmo nome na coluna de produtos

select Produto, count(
case
when Produto = 'MonitoreAgora' then 'EspiaJ�'
when Produto = 'Sue�o Profundo 2.0' then 'EspiaYa'
when Produto = 'EspiaYa - R' then 'EspiaYa'
when Produto = 'Alma G�mea' then 'Sua Alma G�mea'
when Produto = 'Hydra Gloss Lips - Academy Class' then 'Hydra Gloss Lips'
when Produto = 'Emagrecimento Desbloqueado - T�nicos Japoneses' then 'Emagrecimento Desbloqueado'
else Produto
end) as QuantidadeVendida
from dbo.BaseConsolidada
group by Produto
order by QuantidadeVendida desc

update dbo.BaseConsolidada
set Produto = case
when Produto = 'MonitoreAgora' then 'EspiaJ�'
when Produto = 'Sue�o Profundo 2.0' then 'EspiaYa'
when Produto = 'EspiaYa - R' then 'EspiaYa'
when Produto = 'Alma G�mea' then 'Sua Alma G�mea'
when Produto = 'Hydra Gloss Lips - Academy Class' then 'Hydra Gloss Lips'
when Produto = 'Emagrecimento Desbloqueado - T�nicos Japoneses' then 'Emagrecimento Desbloqueado'
else Produto
end

-- Agrupar produtos com menos de 30 vendas em 'outros'

alter table dbo.BaseConsolidada
add QuantidadeVendasProd nvarchar(255)

with CTE as(
select Produto, count(Produto) over (partition by Produto) as QtdeTempProd
from dbo.BaseConsolidada
)
update dbo.BaseConsolidada
set QuantidadeVendasProd = QtdeTempProd
from CTE 
join dbo.BaseConsolidada
on dbo.BaseConsolidada.Produto = CTE.Produto

update dbo.BaseConsolidada
set Produto = case
when QuantidadeVendasProd < 30 then 'Outros'
else Produto
end

alter table dbo.BaseConsolidada
drop column QuantidadeVendasProd

-- Agrupar status que se referem � mesma coisa na coluna de status

update dbo.BaseConsolidada
set Status = case
when Status = 'Completo' then 'Aprovado'
when Status = 'Paid' then 'Aprovado'
when Status = 'paid' then 'Aprovado'
when Status = 'Charge Back' then 'Chargeback'
when Status = 'chargedback' then 'Chargeback'
when Status = 'Devolvida' then 'Reembolsado'
when Status = 'refunded' then 'Reembolsado'
else Status
end

-- Arredondar valor da venda e valor da comiss�o para 1 casa decimal

update dbo.BaseConsolidada
set ValorVenda = round(ValorVenda, 1)

update dbo.BaseConsolidada
set ValorComiss�o = round(ValorComiss�o, 1)

-- Agrupar formas de pagamento que se referem � mesma coisa na coluna de forma de pagamento

update dbo.BaseConsolidada
set FormaPagamento = case
when FormaPagamento = 'Cart�o de Credito' then 'Cart�o de Cr�dito'
when FormaPagamento = 'mastercard' then 'Cart�o de Cr�dito'
when FormaPagamento = 'visa' then 'Cart�o de Cr�dito'
when FormaPagamento = 'pix' then 'Pix'
else FormaPagamento
end

-- Agrupar formas de pagamento com menos de 20 vendas em 'outros'

alter table dbo.BaseConsolidada
add QuantidadeVendasPag nvarchar(255)

with CTE as(
select FormaPagamento, count(FormaPagamento) over (partition by FormaPagamento) as QtdeTempPag
from dbo.BaseConsolidada
)
update dbo.BaseConsolidada
set QuantidadeVendasPag = QtdeTempPag
from CTE 
join dbo.BaseConsolidada
on dbo.BaseConsolidada.FormaPagamento = CTE.FormaPagamento

update dbo.BaseConsolidada
set FormaPagamento = case
when QuantidadeVendasPag < 20 then 'Outros'
else FormaPagamento
end

alter table dbo.BaseConsolidada
drop column QuantidadeVendasPag

-- Transformar todos pa�ses fora o Brasil em 'Exterior'

update dbo.BaseConsolidada
set Pa�s = case
when Pa�s <> 'Brasil' then 'Exterior'
else Pa�s
end

-- Vers�o Final

select *
from dbo.BaseConsolidada
