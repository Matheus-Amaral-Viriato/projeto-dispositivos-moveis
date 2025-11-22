Aplicativo de Tarefas Diárias com Flutter e Firebase

Este projeto foi desenvolvido como atividade acadêmica, utilizando **Flutter** integrado ao **Firebase** para autenticação de usuários e armazenamento de dados em nuvem.

O aplicativo possui:

- Tela de **cadastro**
- Tela de **login**
- Um **calendário interativo**
- Uma página de **lista de tarefas diárias**, onde o usuário pode adicionar, editar, completar e excluir tarefas

---

Funcionalidades

**Autenticação Firebase**

- Cadastro de novos usuários com email e senha
- Login usando FirebaseAuth
- Tratamento de erros de autenticação
- Mensagens de feedback (SnackBar)

---

**Calendário (TableCalendar)**

- Exibição de calendário mensal
- Seleção de um dia para visualizar tarefas
- Redirecionamento automático para a lista de tarefas do dia selecionado

---

**Lista de Tarefas (ToDoListPage)**
Para cada dia selecionado no calendário:

- Adicionar novas tarefas
- Editar o nome de tarefas existentes
- Marcar tarefa como **concluída** ou **pendente**
- Excluir tarefas individualmente
- Excluir todas as tarefas do dia
- Animações suaves de atualização da lista

As tarefas são salvas no **Firebase Realtime Database**, seguindo o formato:

calendar/
└── dia-mes-ano/
└── idFirebase/
name: "Nome da tarefa"
isCompleted: false/true

---

**Tecnologias Utilizadas**

- **Flutter**
- **Dart**
- **Firebase Core**
- **Firebase Authentication**
- **Firebase Realtime Database**
- **TableCalendar**
- **Material Design**

---

### Estrutura do Projeto

lib/
├── main.dart
├── login.dart
├── RegisterPage.dart
├── CalendarPage.dart
└── toDoListPage.dart

---

### Como Executar o Projeto

### 1)Clonar o repositório

git clone https://github.com/Matheus-Amaral-Viriato/projeto-dispositivos-moveis.git

### 2)Instalar dependências

flutter pub get

### 3)Configurar Firebase

No Firebase Console:

1. Criar um projeto Firebase
2. Ativar **Authentication (Email/Password)**
3. Ativar **Realtime Database**
4. Gerar `firebase_options.dart` com o **FlutterFire CLI**:

dart pub global activate flutterfire_cli
flutterfire configure

### 4)Rodar o aplicativo

flutter run

---

### Testando o App

1. Faça um novo cadastro
2. Faça login com o email criado
3. Selecione um dia no calendário
4. Adicione e gerencie suas tarefas
5. Observe que tudo é salvo automaticamente no Firebase

---

### Interface (Screenshots opcionais)

Os prints da interface do aplicativo estão na pasta print_projeto:
![Tela de login](./prints_projeto/tela%20de%20login.png)
![Tela de cadastro](./prints_projeto/tela%20de%20cadastro.png)
![Tela de calendario](./prints_projeto/tela%20de%20calendario.png)
![Tela de gerenciador](./prints_projeto/tela%20de%20gerenciador%20.png)

### Autor

**Matheus Amaral Viriato**
**RA:1177232**
Projeto desenvolvido como trabalho acadêmico utilizando Flutter + Firebase.

---

### Licença

Este projeto é apenas para fins educacionais.

---

Este projeto é um ponto de partida para um aplicativo Flutter.

Alguns recursos para você começar, caso este seja seu primeiro projeto Flutter:

- [Laboratório: Escreva seu primeiro aplicativo Flutter](https://docs.flutter.dev/get-started/codelab)
- [Guia Prático: Exemplos úteis de Flutter](https://docs.flutter.dev/cookbook)

Para obter ajuda para começar a desenvolver com Flutter, consulte a
[documentação online](https://docs.flutter.dev/), que oferece tutoriais,
exemplos, orientações sobre desenvolvimento mobile e uma referência completa da API.
