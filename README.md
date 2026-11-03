# StudyTrack — Flutter

App de organização acadêmica (matérias, tarefas, prazos e progresso do semestre).
Trabalho do 4º bimestre de Desenvolvimento para Dispositivos Móveis — UNINGÁ.

**Acesse:** https://samuelstefano.github.io/studytrack/

**Conta de avaliação:** `professor@studytrack.app` / `uninga2026`
(ou toque em "Usar conta de avaliação" na tela de login, ou crie sua própria conta).

## Funcionalidades
- Cadastro e login (senha com hash SHA-256)
- CRUD de matérias (nome, professor, cor) e de tarefas (título, matéria, data de entrega)
- Validação de formulários
- Dashboard com contadores e próximos prazos
- Filtro e busca de tarefas; arrastar para excluir
- Progresso do semestre e por matéria, matérias com tarefa atrasada
- Persistência local por usuário (`shared_preferences`)

## Rodar
```
cd app
flutter pub get
flutter run            # Android / navegador
flutter build web      # versão web
```

Estrutura: `app/lib/models.dart` (modelos), `app/lib/store.dart` (estado + persistência),
`app/lib/screens/` (telas), `app/lib/widgets/` (componentes).
