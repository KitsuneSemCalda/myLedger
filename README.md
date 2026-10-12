# myLedger
A frontend to hledger using shellscript and gum

## Exemplo com Gum

O script em [examples/gum-frontend.sh](examples/gum-frontend.sh) abre um menu para
ver saldos, consultar o extrato da conta e registrar uma despesa. Sem argumento,
ele usa o diario ficticio em [examples/demo.journal](examples/demo.journal).

```sh
bash examples/gum-frontend.sh
```

Para experimentar sem alterar o arquivo de exemplo:

```sh
cp examples/demo.journal /tmp/myledger-demo.journal
bash examples/gum-frontend.sh /tmp/myledger-demo.journal
```

Requer `hledger` e `gum` instalados. Antes de gravar, o script mostra a entrada,
pede confirmacao e solicita ao hledger que valide o diario com a nova despesa.
As categorias e a conta bancaria sao fixas neste exemplo; ajuste-as para outro diario.
