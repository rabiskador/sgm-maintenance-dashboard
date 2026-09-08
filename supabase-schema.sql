-- Execute uma vez no SQL Editor do Supabase.
-- A RPC aplica DISTINCT ON no Postgres e anexa o nome do operador.
create or replace function public.equipamentos_status_atual()
returns table (
    equipamento_id varchar(50),
    operador_id varchar(20),
    operador_nome text,
    status varchar(10),
    data_manutencao timestamp,
    data_desbloqueio timestamp,
    motivo_manutencao text,
    motivo_desbloqueio text,
    id integer
)
language sql
stable
security invoker
as $$
    select distinct on (m.equipamento_id)
        m.equipamento_id,
        m.operador_id,
        o.nome as operador_nome,
        m.status,
        m.data_manutencao,
        m.data_desbloqueio,
        m.motivo_manutencao,
        m.motivo_desbloqueio,
        m.id
    from public.manutencoes m
    left join public.operadores o on o.operador_id = m.operador_id
    order by m.equipamento_id, m.data_manutencao desc, m.id desc;
$$;

-- Realtime: habilite a tabela na publicação caso ainda não esteja habilitada.
do $$
begin
    if not exists (
        select 1
        from pg_publication_tables
        where pubname = 'supabase_realtime'
          and schemaname = 'public'
          and tablename = 'manutencoes'
    ) then
        alter publication supabase_realtime add table public.manutencoes;
    end if;
end
$$;

-- Com RLS habilitado, estas policies permitem o dashboard autenticado operar.
-- Revise os comandos caso o seu modelo de permissões seja mais restritivo.
drop policy if exists "authenticated can read manutencoes" on public.manutencoes;
drop policy if exists "authenticated can insert manutencoes" on public.manutencoes;
drop policy if exists "authenticated can update manutencoes" on public.manutencoes;
drop policy if exists "authenticated can read operadores" on public.operadores;
drop policy if exists "authenticated can insert operadores" on public.operadores;
drop policy if exists "authenticated can update operadores" on public.operadores;
drop policy if exists "authenticated can delete operadores" on public.operadores;
create policy "authenticated can read manutencoes" on public.manutencoes for select to authenticated using (true);
create policy "authenticated can insert manutencoes" on public.manutencoes for insert to authenticated with check (true);
create policy "authenticated can update manutencoes" on public.manutencoes for update to authenticated using (true) with check (true);
create policy "authenticated can read operadores" on public.operadores for select to authenticated using (true);
create policy "authenticated can insert operadores" on public.operadores for insert to authenticated with check (true);
create policy "authenticated can update operadores" on public.operadores for update to authenticated using (true) with check (true);
create policy "authenticated can delete operadores" on public.operadores for delete to authenticated using (true);
