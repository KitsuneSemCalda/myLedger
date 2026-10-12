#!/usr/bin/env bash
set -uo pipefail

# Exemplo pequeno: um diario hledger, um menu Gum e uma escrita validada.
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
journal=${1:-"$script_dir/demo.journal"}

if [[ ${1:-} == --help ]]; then
    printf 'Uso: %s [caminho/do/diario.journal]\n' "$0"
    printf 'Sem argumento, usa o diario ficticio examples/demo.journal.\n'
    exit 0
fi

for program in hledger gum; do
    if ! command -v "$program" >/dev/null 2>&1; then
        printf 'Dependencia ausente: %s\n' "$program" >&2
        exit 1
    fi
done

if [[ ! -f $journal || ! -w $journal ]]; then
    printf 'O diario precisa existir e ser gravavel: %s\n' "$journal" >&2
    exit 1
fi

if ! hledger -f "$journal" check >/dev/null; then
    printf 'O diario tem erros. Corrija-os antes de abrir o menu.\n' >&2
    exit 1
fi

show_balance() {
    hledger -f "$journal" balance --depth 2 | gum pager
}

show_register() {
    hledger -f "$journal" register assets:bank:checking | gum pager
}

add_expense() {
    local description amount category today entry
    today=$(date +%F)

    if ! description=$(gum input --placeholder 'Descricao da despesa'); then return; fi
    if [[ -z $description || $description == *';'* || $description == *$'\n'* || $description == *$'\r'* ]]; then
        printf 'Use uma descricao simples, sem ponto e virgula.\n' >&2
        return
    fi

    if ! amount=$(gum input --placeholder 'Valor em BRL, ex: 12,50'); then return; fi
    amount=${amount/,/.}
    if [[ ! $amount =~ ^[0-9]+(\.[0-9]{1,2})?$ || $amount =~ ^0+(\.0{1,2})?$ ]]; then
        printf 'Informe um valor positivo com ate duas casas decimais.\n' >&2
        return
    fi

    if ! category=$(gum choose 'expenses:food' 'expenses:transport' 'expenses:other'); then return; fi

    entry=$(printf '%s %s\n    %s  BRL %s\n    assets:bank:checking' \
        "$today" "$description" "$category" "$amount")
    printf '\n%s\n' "$entry"
    if ! gum confirm 'Gravar esta despesa?'; then return; fi

    # A entrada e verificada junto com o diario existente antes do append.
    if ! printf '\n%s\n' "$entry" | hledger -f "$journal" -f - check; then
        printf 'O hledger rejeitou a entrada; nada foi gravado.\n' >&2
        return
    fi

    if ! printf '\n%s\n' "$entry" >> "$journal"; then
        printf 'Falha ao gravar no diario.\n' >&2
        return
    fi
    printf 'Despesa gravada em %s.\n' "$journal"
}

while true; do
    printf '\nmyLedger (exemplo) — %s\n' "$journal"
    if ! option=$(gum choose 'Ver saldos' 'Ver extrato da conta' 'Registrar despesa' 'Sair'); then
        break
    fi
    case $option in
        'Ver saldos') show_balance ;;
        'Ver extrato da conta') show_register ;;
        'Registrar despesa') add_expense ;;
        'Sair') break ;;
    esac
done
