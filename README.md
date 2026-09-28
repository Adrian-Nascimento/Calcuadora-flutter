# Calculadoras Financeiras em Flutter

Aplicativo mobile desenvolvido em Flutter e Dart durante o curso de Análise e Desenvolvimento de Sistemas na USCS. O app reúne três calculadoras financeiras acessadas por um menu inicial.

## Funcionalidades

- **Calculadora de Troco:** calcula o troco a devolver ao cliente e avisa quando o valor pago é insuficiente.
- **Parcelamento sem Juros:** mostra o valor de cada parcela a partir do valor total e do número de parcelas.
- **Meta de Poupança:** calcula quanto ainda falta poupar e quanto guardar por mês para atingir a meta.

## Conceitos aplicados

- Navegação entre telas com `Navigator.push` e `MaterialPageRoute`
- `StatefulWidget` com formulários validados (`Form`, `TextFormField` e `TextEditingController`)
- Classes de modelo separadas para os resultados
- Tema escuro único definido no `ThemeData` do `MaterialApp`
- Formatação de moeda em real com o pacote `intl`

## Tecnologias

Flutter, Dart, intl, Visual Studio Code, Git e GitHub

## Estrutura do projeto

```
lib/
├── main.dart
├── models/
│   ├── resultado_troco.dart
│   ├── resultado_parcelamento_sem_juros.dart
│   └── resultado_meta_de_poupanca.dart
└── screens/
    ├── home_screen.dart
    ├── troco_screen.dart
    ├── parcelamento_sem_juros_screen.dart
    └── meta_de_poupanca_screen.dart
```

## Como executar

1. Instale o [Flutter](https://docs.flutter.dev/get-started/install)
2. Clone o repositório:
```
   git clone https://github.com/Adrian-Nascimento/Calculadora-flutter.git
```
3. Entre na pasta do projeto e baixe as dependências:
```
   flutter pub get
```
4. Execute o app:
```
   flutter run
```

## Autor

Adrian Nascimento