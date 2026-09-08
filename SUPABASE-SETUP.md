# Configuração do Supabase

## 1. Variáveis locais

No arquivo `.env`, use a URL do projeto e a chave pública atual copiada em **Project Settings > API**:

```env
VITE_SUPABASE_URL=https://seu-projeto.supabase.co
VITE_SUPABASE_PUBLISHABLE_KEY=sua-chave-publica
```

A chave `anon`/publishable pode aparecer no frontend. Nunca use `service_role` no `.env` do Vite ou em arquivos de `js/`.

## 2. Banco, RLS e Realtime

Execute [`supabase-schema.sql`](supabase-schema.sql) no SQL Editor. O script cria a RPC de status atual, policies para usuários autenticados e habilita a tabela `manutencoes` no Realtime. Ele pode ser executado novamente.

As policies incluídas permitem leitura autenticada e as operações necessárias ao dashboard. Ajuste as expressões `using (true)` caso exista uma regra de acesso por unidade, setor ou usuário.

## 3. Usuários

Crie os usuários manualmente em **Authentication > Users**. O cadastro público não é usado pelo dashboard.

## 4. Executar

```bash
npm install
npm run dev
```

O endereço local será exibido pelo Vite.

## Validação

Com uma conta autenticada, confirme:

1. A lista de equipamentos carrega e respeita as policies.
2. Um INSERT ou UPDATE em `manutencoes` atualiza a lista sem recarregar.
3. O detalhe mostra o histórico e os tempos acumulados.
4. Um operador com histórico não pode ser removido.

O cliente mostra erros de autenticação, RLS, RPC e Realtime no aviso da interface.
