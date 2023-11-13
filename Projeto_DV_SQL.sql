

-- Importar bases

-- Unir bases PP e já selecionar as colunas que vão ser utilizadas

drop table if exists PerfectPay
create table PerfectPay
(DataVenda nvarchar(255),
Status nvarchar(255), 
FormaPagamento nvarchar(255), 
Produto nvarchar(255), 
ValorVenda nvarchar(255), 
ValorComissão nvarchar(255)
)

insert into PerfectPay (DataVenda, Status, FormaPagamento, Produto, ValorVenda, ValorComissão)
select DataVenda, Status, FormaPagamento, Produto, ValorVenda, ValorComissão
from dbo.PP1

insert into PerfectPay (DataVenda, Status, FormaPagamento, Produto, ValorVenda, ValorComissão)
select DataVenda, Status, FormaPagamento, Produto, ValorVenda, ValorComissão
from dbo.PP2

------------------------------------------------------------------------------------------------------------------
-- Hotmart
	-- Preencher valores vazios da coluna de país (com Brasil)

select País,
case
when País = '' then 'Brasil'
else País
end
from dbo.Hotmart

update dbo.Hotmart
set País = case
when País = '' then 'Brasil'
else País
end

	-- Criar coluna de Valor da Venda (Preço total convertido * Câmbio)

alter table dbo.Hotmart
add ValordaVenda float

update dbo.Hotmart
set ValordaVenda = [Preço Total Convertido] * [Taxa de Câmbio da Comissão]

	-- Criar coluna de nome da plataforma (Hotmart)

alter table dbo.Hotmart
add Plataforma nvarchar(255)

update dbo.Hotmart
set Plataforma = 'Hotmart'

	-- Criar colunas de mês e ano

alter table dbo.Hotmart
add Mês int

update dbo.Hotmart
set Mês = cast(SUBSTRING([Data de Venda], 4, 2) as int)

alter table dbo.Hotmart
add Ano int

update dbo.Hotmart
set Ano = cast(SUBSTRING([Data de Venda], 7, 4) as int)

	-- Preencher valores vazios da coluna de Valor da Venda (usando valores da coluna Preço do produto)

update dbo.Hotmart
set ValordaVenda = isnull(ValordaVenda, [Preço do produto])

	-- Preencher valores vazios da coluna de Valor da Comissão Convertido (valor da comissão gerada)

update dbo.Hotmart
set [Valor da Comissão Convertido] = isnull([Valor da Comissão Convertido], [Valor da Comissão Gerada])

	-- Selecionando as colunas que vão ser utilizadas e colocando em ordem

drop table if exists HotmartAjustada
create table HotmartAjustada
(Plataforma nvarchar(255),
Produto nvarchar(255),
DataVenda nvarchar(255),
Mês int,
Ano int,
Status nvarchar(255), 
ValorVenda float,
ValorComissão float,
FormaPagamento nvarchar(255), 
País nvarchar(255)
)

insert into HotmartAjustada (Plataforma, Produto, DataVenda, Mês, Ano, Status, ValorVenda, ValorComissão, FormaPagamento, País)
select Plataforma, [Nome do Produto], [Data de Venda], Mês, Ano, Status, [ValordaVenda], [Valor da Comissão Convertido], [Tipo de Pagamento], País
from dbo.Hotmart

------------------------------------------------------------------------------------------------------------------
-- Kiwify
	-- Criar coluna de País (com Brasil)

alter table dbo.Kiwify
add País nvarchar(255)

update dbo.Kiwify
set País = 'Brasil'

	-- Criar coluna de nome da plataforma (Kiwify)

alter table dbo.Kiwify
add Plataforma nvarchar(255)

update dbo.Kiwify
set Plataforma = 'Kiwify'

	-- Criar colunas de mês e ano

alter table dbo.Kiwify
add Mês int

update dbo.Kiwify
set Mês = cast(SUBSTRING([Data de Criação], 4, 2) as int)

alter table dbo.Kiwify
add Ano int

update dbo.Kiwify
set Ano = cast(SUBSTRING([Data de Criação], 7, 4) as int)

	-- Selecionando as colunas que vão ser utilizadas e colocando em ordem

drop table if exists KiwifyAjustada
create table KiwifyAjustada
(Plataforma nvarchar(255),
Produto nvarchar(255),
DataVenda nvarchar(255),
Mês int,
Ano int,
Status nvarchar(255), 
ValorVenda float,
ValorComissão float,
FormaPagamento nvarchar(255), 
País nvarchar(255)
)

insert into KiwifyAjustada (Plataforma, Produto, DataVenda, Mês, Ano, Status, ValorVenda, ValorComissão, FormaPagamento, País)
select Plataforma, Produto, [Data de Criação], Mês, Ano, Status, [Preço base do produto], [Valor líquido], [Pagamento], País
from dbo.Kiwify

------------------------------------------------------------------------------------------------------------------
-- PerfectPay
	-- Criar coluna de País (com Brasil)

alter table dbo.PerfectPay
add País nvarchar(255)

update dbo.PerfectPay
set País = 'Brasil'

	-- Criar coluna de nome da plataforma (Perfect Pay)

alter table dbo.PerfectPay
add Plataforma nvarchar(255)

update dbo.PerfectPay
set Plataforma = 'Perfect Pay'

	-- Criar colunas de mês e ano

alter table dbo.PerfectPay
add Mês int

update dbo.PerfectPay
set Mês = cast(SUBSTRING([DataVenda], 4, 2) as int)

alter table dbo.PerfectPay
add Ano int

update dbo.PerfectPay
set Ano = cast(SUBSTRING([DataVenda], 7, 4) as int)

	-- Mudando tipos das colunas de Valor Venda e Valor Comissão

update dbo.PerfectPay
set ValorVenda = cast(replace(ValorVenda, ',', '.') as float)

update dbo.PerfectPay
set ValorComissão = cast(replace(ValorComissão, ',', '.') as float)

	-- Colocando as colunas em ordem

drop table if exists PerfectPayAjustada
create table PerfectPayAjustada
(Plataforma nvarchar(255),
Produto nvarchar(255),
DataVenda nvarchar(255),
Mês int,
Ano int,
Status nvarchar(255), 
ValorVenda float,
ValorComissão float,
FormaPagamento nvarchar(255), 
País nvarchar(255)
)

insert into PerfectPayAjustada (Plataforma, Produto, DataVenda, Mês, Ano, Status, ValorVenda, ValorComissão, FormaPagamento, País)
select Plataforma, Produto, DataVenda, Mês, Ano, Status, ValorVenda, ValorComissão, FormaPagamento, País
from dbo.PerfectPay

------------------------------------------------------------------------------------------------------------------
-- Stripe
	-- Criar coluna de País (com Exterior)

alter table dbo.Stripe
add País nvarchar(255)

update dbo.Stripe
set País = 'Exterior'

	-- Criar coluna de produto (EspiaYa)

alter table dbo.Stripe
add Produto nvarchar(255)

update dbo.Stripe
set Produto = 'EspiaYa'

	-- Criar colunas de forma de pagamento (Cartão de crédito)

alter table dbo.Stripe
add FormaPagamento nvarchar(255)

update dbo.Stripe
set FormaPagamento = 'Cartão de Credito'

	-- Criar coluna de Valor Líquido (Converted amount - Fee)

alter table dbo.Stripe
add ValorLíquido nvarchar(255)

update dbo.Stripe
set ValorLíquido = cast([Converted Amount] as float) - cast([Fee] as float)

	-- Criar coluna de nome da plataforma (Stripe)

alter table dbo.Stripe
add Plataforma nvarchar(255)

update dbo.Stripe
set Plataforma = 'Stripe'

	-- Criar colunas de mês e ano

alter table dbo.Stripe
add Mês int

update dbo.Stripe
set Mês = cast(SUBSTRING([Created (UTC)], 6, 2) as int)

alter table dbo.Stripe
add Ano int

update dbo.Stripe
set Ano = cast(SUBSTRING([Created (UTC)], 1, 4) as int)

	-- Selecionando as colunas que vão ser utilizadas e colocando em ordem

drop table if exists StripeAjustada
create table StripeAjustada
(Plataforma nvarchar(255),
Produto nvarchar(255),
DataVenda nvarchar(255),
Mês int,
Ano int,
Status nvarchar(255), 
ValorVenda float,
ValorComissão float,
FormaPagamento nvarchar(255), 
País nvarchar(255)
)

insert into StripeAjustada (Plataforma, Produto, DataVenda, Mês, Ano, Status, ValorVenda, ValorComissão, FormaPagamento, País)
select Plataforma, Produto, [Created (UTC)], Mês, Ano, Status, [Converted Amount], ValorLíquido, FormaPagamento, País
from dbo.Stripe

------------------------------------------------------------------------------------------------------------------

-- Unir bases

drop table if exists BaseConsolidada
create table BaseConsolidada
(Plataforma nvarchar(255),
Produto nvarchar(255),
DataVenda nvarchar(255),
Mês int,
Ano int,
Status nvarchar(255), 
ValorVenda float,
ValorComissão float,
FormaPagamento nvarchar(255), 
País nvarchar(255)
)

insert into BaseConsolidada (Plataforma, Produto, DataVenda, Mês, Ano, Status, ValorVenda, ValorComissão, FormaPagamento, País)
select *
from dbo.HotmartAjustada

insert into BaseConsolidada (Plataforma, Produto, DataVenda, Mês, Ano, Status, ValorVenda, ValorComissão, FormaPagamento, País)
select *
from dbo.KiwifyAjustada

insert into BaseConsolidada (Plataforma, Produto, DataVenda, Mês, Ano, Status, ValorVenda, ValorComissão, FormaPagamento, País)
select *
from dbo.PerfectPayAjustada

insert into BaseConsolidada (Plataforma, Produto, DataVenda, Mês, Ano, Status, ValorVenda, ValorComissão, FormaPagamento, País)
select *
from dbo.StripeAjustada

-- Agrupar produtos com mesmo nome na coluna de produtos

select Produto, count(
case
when Produto = 'MonitoreAgora' then 'EspiaJá'
when Produto = 'Sueño Profundo 2.0' then 'EspiaYa'
when Produto = 'EspiaYa - R' then 'EspiaYa'
when Produto = 'Alma Gêmea' then 'Sua Alma Gêmea'
when Produto = 'Hydra Gloss Lips - Academy Class' then 'Hydra Gloss Lips'
when Produto = 'Emagrecimento Desbloqueado - Tônicos Japoneses' then 'Emagrecimento Desbloqueado'
else Produto
end) as QuantidadeVendida
from dbo.BaseConsolidada
group by Produto
order by QuantidadeVendida desc

update dbo.BaseConsolidada
set Produto = case
when Produto = 'MonitoreAgora' then 'EspiaJá'
when Produto = 'Sueño Profundo 2.0' then 'EspiaYa'
when Produto = 'EspiaYa - R' then 'EspiaYa'
when Produto = 'Alma Gêmea' then 'Sua Alma Gêmea'
when Produto = 'Hydra Gloss Lips - Academy Class' then 'Hydra Gloss Lips'
when Produto = 'Emagrecimento Desbloqueado - Tônicos Japoneses' then 'Emagrecimento Desbloqueado'
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

-- Agrupar status que se referem à mesma coisa na coluna de status

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

-- Arredondar valor da venda e valor da comissão para 1 casa decimal

update dbo.BaseConsolidada
set ValorVenda = round(ValorVenda, 1)

update dbo.BaseConsolidada
set ValorComissão = round(ValorComissão, 1)

-- Agrupar formas de pagamento que se referem à mesma coisa na coluna de forma de pagamento

update dbo.BaseConsolidada
set FormaPagamento = case
when FormaPagamento = 'Cartão de Credito' then 'Cartão de Crédito'
when FormaPagamento = 'mastercard' then 'Cartão de Crédito'
when FormaPagamento = 'visa' then 'Cartão de Crédito'
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

-- Transformar todos países fora o Brasil em 'Exterior'

update dbo.BaseConsolidada
set País = case
when País <> 'Brasil' then 'Exterior'
else País
end

-- Versão Final

select *
from dbo.BaseConsolidada
