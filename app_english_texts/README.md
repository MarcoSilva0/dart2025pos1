# English Learning App

Aplicativo Flutter para aprender inglês através de artigos da Wikipedia e dicionário de definições.

## Funcionalidades

### 1. Página Principal (Home)
- Campo de entrada para URL da Wikipedia em inglês
- Validação de URL (deve ser en.wikipedia.org)
- Busca e extração do primeiro parágrafo do artigo

### 2. Página de Texto
- Exibe o primeiro parágrafo extraído da Wikipedia
- Cada palavra é um botão clicável (exceto palavras já compreendidas)
- Palavras compreendidas aparecem como texto normal
- Botão para acessar lista de palavras compreendidas

### 3. Página de Definição
- Exibe definições da palavra em inglês (via Dictionary API)
- Mostra fonética e múltiplos significados
- Reprodutor de áudio para pronúncia
- Botão para marcar/desmarcar palavra como compreendida
- Exemplos de uso quando disponíveis

### 4. Página de Palavras Compreendidas
- Lista todas as palavras marcadas como compreendidas
- Permite remover palavras da lista
- Persistência local usando SharedPreferences

## APIs Utilizadas

- **Wikipedia API**: Para extrair conteúdo de artigos
- **Dictionary API**: https://dictionaryapi.dev para definições e áudio

## Dependências

```yaml
http: ^1.2.2           # Requisições HTTP
audioplayers: ^6.1.0   # Reprodução de áudio
shared_preferences: ^2.3.3  # Persistência local
```

## Estrutura do Projeto

```
lib/
├── main.dart
├── models/
│   └── word_definition.dart
├── services/
│   ├── wikipedia_service.dart
│   ├── dictionary_service.dart
│   └── understood_words_manager.dart
└── pages/
    ├── home_page.dart
    ├── text_page.dart
    ├── definition_page.dart
    └── understood_words_page.dart
```

## Como Usar

1. Cole um link da Wikipedia em inglês (ex: https://en.wikipedia.org/wiki/Chole_bhature)
2. Clique em "Buscar Texto"
3. Toque em qualquer palavra para ver sua definição
4. Ouça a pronúncia tocando no ícone de volume
5. Marque palavras como compreendidas usando o ícone de check
6. Acesse suas palavras compreendidas através do botão de lista

## Executar o Projeto

```bash
flutter pub get
flutter run
```
