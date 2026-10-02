SGM — Sistema de Gestão de Manutenção

Dashboard web para monitoramento em tempo real do status de manutenção de equipamentos industriais, integrado a um sistema SCADA (Elipse E3) via webhook (n8n) e Supabase.

Projeto de portfólio que une automação industrial e desenvolvimento web: do chão de fábrica à nuvem.

Visão geral

Um sistema SCADA (Elipse E3) controla o bloqueio/desbloqueio de equipamentos para manutenção diretamente na tela de supervisão, exigindo um operador autorizado para cada ação. Cada evento é enviado via webhook (orquestrado pelo n8n) e persistido no Supabase, criando uma trilha auditável completa de cada ciclo de manutenção.

Este repositório contém o dashboard web que consome esses dados, permitindo acompanhar o status dos equipamentos e gerenciar operadores autorizados sem precisar estar na sala de controle.

Funcionalidades

Autenticação

Login com e-mail e senha via Supabase Auth
Proteção do dashboard sem sessão autenticada
Logout

Monitoramento de equipamentos

Identificação do status atual (Em manutenção / Operacional)
Equipamentos em manutenção ordenados no topo
Busca por equipamento_id
Filtro por status
Exibição do operador responsável e do tempo no status atual

Detalhamento do equipamento

Histórico completo de ciclos de manutenção
Motivo da manutenção e do desbloqueio
Datas de manutenção e desbloqueio
Tempo acumulado em manutenção nos últimos 7 e 30 dias

Gestão de operadores

Cadastro e busca de operadores por nome
Remoção de operadores, com bloqueio automático quando existem manutenções vinculadas e sugestão de desativação

Dados em tempo real

Atualização automática via Supabase Realtime
Atualização manual pelo botão "Atualizar"

Outros

Tratamento de erros de autenticação, RLS, conexão e Realtime
Layout responsivo (desktop, tablet, celular)
Tema monocromático: 
#252525 
#545454 
#7D7D7D 
#CFCFCF
Stack
Elipse E3 (SCADA/VBScript) — controle de bloqueio/desbloqueio na ponta industrial
n8n — orquestração do webhook que recebe os eventos do SCADA e grava no banco
HTML5 — estrutura das telas
CSS3 — layout, responsividade e tema visual
JavaScript (ES Modules) — lógica da aplicação
Vite — desenvolvimento local e build
Supabase Auth — login e sessão
Supabase Database — consulta e alteração de dados
Supabase Realtime — atualizações automáticas
Supabase RPC/PostgreSQL — busca do ciclo mais recente por equipamento
Row Level Security (RLS) — controle de acesso
npm / Node.js — gerenciamento de dependências e build
Git/GitHub — versionamento

Nota: a autenticação usa Supabase Auth, adequado ao escopo deste projeto de portfólio. Em um sistema corporativo de maior porte, o caminho natural seria integrar com SSO/Active Directory da empresa.

Estrutura do projeto
.
├── elipse e3/              # Scripts VBScript do sistema SCADA (Elipse E3)
├── index.html               # Estrutura visual
├── styles.css                # Estilos
├── app.js                     # Regras e interações
├── supabase-client.js    # Conexão centralizada com o Supabase
├── supabase-schema.sql  # RPC, policies e configuração de Realtime
├── SUPABASE-SETUP.md    # Guia de configuração do banco
├── .env.example             # Modelo das variáveis de ambiente
└── .gitignore
Banco de dados
Tabela manutencoes

Cada linha representa um ciclo de manutenção (abertura e eventual fechamento).

Coluna	Tipo	Descrição
id	serial	Chave primária
equipamento_id	varchar(50)	Identificador do equipamento
operador_id	varchar(20)	FK para operadores
motivo_manutencao	text	Motivo do bloqueio
motivo_desbloqueio	text	Motivo do desbloqueio (opcional)
status	varchar(10)	aberto (em manutenção) ou fechado (desbloqueado)
data_manutencao	timestamp	Data/hora do bloqueio
data_desbloqueio	timestamp	Data/hora do desbloqueio (opcional)
Tabela operadores
Coluna	Descrição
operador_id	Chave, referenciada pela FK de manutencoes
nome	Nome do operador
created_at	Data de cadastro
Como rodar localmente
Pré-requisitos
Node.js instalado
Um projeto Supabase criado
Passos
bash
# Clone o repositório
git clone <url-do-repositorio>
cd SGM

# Instale as dependências
npm install

# Configure as variáveis de ambiente
cp .env.example .env
# edite o .env com a URL e a chave do seu projeto Supabase

# Rode o schema SQL no seu projeto Supabase
# (veja SUPABASE-SETUP.md para o passo a passo completo)

# Inicie o servidor de desenvolvimento
npm run dev

Consulte SUPABASE-SETUP.md para o passo a passo completo de configuração do banco, policies de RLS e Realtime.

Integração com o SCADA

A pasta elipse e3/ contém os scripts VBScript usados na tela de supervisão do Elipse E3, responsáveis por:

Capturar a intenção do operador (bloquear/desbloquear) a partir do clique em um checkbox
Solicitar ID do operador e motivo via InputBox
Enviar os dados via WinHttpRequest para um webhook (n8n), que valida o operador e grava o evento no Supabase
Tratar erros de comunicação e reverter o estado visual em caso de falha ou cancelamento
Licença

Projeto de portfólio — uso livre como referência.
