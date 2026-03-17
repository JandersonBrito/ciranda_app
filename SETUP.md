# Ciranda App — Guia de Setup

## Pré-requisitos

- Flutter 3.16+ com Dart 3.2+
- Node.js 18+ (para Firebase CLI)
- Android Studio ou Xcode (para builds)

## 1. Instalar dependências

```bash
flutter pub get
```

## 2. Configurar Firebase

### 2.1 Criar projeto no Firebase Console
1. Acesse [console.firebase.google.com](https://console.firebase.google.com)
2. Crie um novo projeto: `ciranda-app`
3. Habilite:
   - **Authentication** → E-mail/Senha + Google
   - **Cloud Firestore** → Modo de produção
   - **Firebase Storage**

### 2.2 Instalar FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 2.3 Configurar o app
```bash
flutterfire configure --project=SEU-PROJETO-FIREBASE
```
Isso atualiza `lib/firebase_options.dart` automaticamente.

## 3. Configurar Google Maps

### Android: `android/app/src/main/AndroidManifest.xml`
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="SUA_GOOGLE_MAPS_API_KEY"/>
```

### iOS: `ios/Runner/AppDelegate.swift`
```swift
import GoogleMaps
GMSServices.provideAPIKey("SUA_GOOGLE_MAPS_API_KEY")
```

Obtenha a chave em: [console.cloud.google.com/apis/library/maps-android-backend.googleapis.com](https://console.cloud.google.com/apis/library/maps-android-backend.googleapis.com)

## 4. Regras do Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Usuários: ler e editar apenas o próprio
    match /users/{uid} {
      allow read, write: if request.auth.uid == uid;
    }

    // Festivais: leitura pública, escrita apenas admin
    match /festivais/{festivalId} {
      allow read: if true;
      allow write: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';

      // Categorias
      match /categorias/{categoriaId} {
        allow read: if true;
        allow write: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
      }
    }

    // Quadrilhas: leitura pública
    match /quadrilhas/{quadrilhaId} {
      allow read: if true;
      allow write: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';

      match /integrantes/{integranteId} {
        allow read: if true;
        allow write: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
      }
    }

    // Jurados
    match /jurados/{juradoId} {
      allow read: if request.auth != null;
      allow write: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }

    // Votos: jurado vota apenas uma vez por categoria/quadrilha
    match /votos/{votoId} {
      allow read: if request.auth != null &&
        (resource.data.juradoId == request.auth.uid ||
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin');
      allow create: if request.auth != null &&
        get(/databases/$(database)/documents/jurados/{resource.data.juradoId}).data.uid == request.auth.uid;
      allow update: if request.auth != null &&
        resource.data.juradoId == request.auth.uid;
    }

    // Resultados: leitura pública (apenas publicados), escrita admin
    match /resultados/{resultadoId} {
      allow read: if resource.data.isPublicado == true ||
        get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
      allow write: if get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

## 5. Gerar código Riverpod (se necessário)

```bash
dart run build_runner build --delete-conflicting-outputs
```

## 6. Executar o app

```bash
# Android
flutter run

# iOS
flutter run -d iPhone

# Release
flutter build apk --release
flutter build ios --release
```

## 7. Estrutura de fontes (opcional)

Baixe as fontes Baloo 2 de [fonts.google.com/specimen/Baloo+2](https://fonts.google.com/specimen/Baloo+2)
e coloque em `assets/fonts/`:
- `Baloo2-Regular.ttf`
- `Baloo2-SemiBold.ttf`
- `Baloo2-Bold.ttf`
- `Baloo2-ExtraBold.ttf`

Se preferir usar via `google_fonts` (requer internet), remova a seção `fonts` do `pubspec.yaml`.

## Arquitetura

```
lib/
├── core/           # Tema, widgets base, constantes
├── features/       # Feature-first (auth, home, festivais, quadrilhas, jurados, resultados, perfil)
├── models/         # Models Firestore (Festival, Quadrilha, Jurado, Resultado, Usuario)
├── providers/      # Firebase providers globais
└── router/         # GoRouter com auth guard
```

## Paleta de cores

| Token | HEX | Uso |
|---|---|---|
| `primary` | `#E91E8C` | Rosa pink — cor principal da marca |
| `secondary` | `#FFD600` | Amarelo — destaques, pontuações |
| `accent` | `#FF6B00` | Laranja — botões secundários |
| `teal` | `#00BCD4` | Verde-azulado — ações neutras |
| `backgroundDark` | `#121212` | Fundo principal |
