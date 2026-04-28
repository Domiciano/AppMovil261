# Specifications Manifest (specs.md)

Este documento define las especificaciones técnicas y funcionales para las características clave de `appmovil261`. Sigue los principios de **Spec-Driven Development (SDD)** para asegurar que cada funcionalidad esté bien definida antes y durante su implementación.

---

## 1. Feature: Registro (Signup)

### Objetivo
Permitir a nuevos usuarios crear una cuenta en la aplicación utilizando su correo electrónico y una contraseña, integrándose con Supabase Auth.

### User Stories
- **Como** nuevo usuario, **quiero** registrarme con mi email y contraseña **para** poder acceder a las funcionalidades protegidas de la app.

### Requerimientos Funcionales
- **Entradas:** Correo electrónico (válido), Contraseña (mínimo 6 caracteres).
- **Acciones:** 
    - Validar formato de email.
    - Llamar al servicio de autenticación de Supabase.
    - Manejar estados de carga, éxito y error (ej. usuario ya existe).
- **Salidas:** Redirección a la pantalla de Inicio/Perfil en caso de éxito. Notificación (Snackbar) en caso de error.

### Acceptance Criteria
- [x] La UI tiene campos para Email y Password.
- [x] El botón "Registrar" dispara el `SignupBloc`.
- [x] Muestra un `CircularProgressIndicator` durante la carga.
- [x] Redirige a `/home` al completar con éxito.
- [ ] Validación de campos en tiempo real (formato email, longitud password).

---

## 2. Feature: Login

### Objetivo
Permitir a usuarios existentes acceder a su cuenta mediante sus credenciales previamente registradas.

### User Stories
- **Como** usuario registrado, **quiero** iniciar sesión **para** retomar mi actividad en la aplicación.

### Requerimientos Funcionales
- **Entradas:** Correo electrónico y Contraseña.
- **Acciones:**
    - Verificar credenciales contra Supabase Auth.
    - Persistir la sesión del usuario.
- **Salidas:** Acceso a la pantalla de Perfil. Mensaje de error si las credenciales son incorrectas.

### Acceptance Criteria
- [ ] Pantalla de Login dedicada.
- [ ] BLoC para manejar el estado de autenticación de login.
- [ ] Manejo de errores específicos (ej. "Invalid credentials").
- [ ] Opción para navegar a la pantalla de Registro desde el Login.

---

## 3. Feature: ProfileScreen

### Objetivo
Pantalla principal post-login con `BottomNavigationBar` de 3 tabs: Perfil, Home y Posts.

### Convención de nomenclatura
- `Screen` = página completa con scaffold/navegación propia.
- `Page` = sub-pantalla hosteada dentro de una Screen.

### Estructura de archivos
```
lib/features/profile/
  domain/models/post.dart          # Modelo Post
  ui/screens/profile_screen.dart   # Screen principal con BottomNavigationBar
  ui/pages/profile_page.dart       # Tab: resumen del usuario
  ui/pages/home_page.dart          # Tab: Home (vacío)
  ui/pages/posts_page.dart         # Tab: formulario nuevo Post
```

### User Stories
- **Como** usuario autenticado, **quiero** ver mis datos básicos (email) **para** confirmar que estoy en mi cuenta.
- **Como** usuario, **quiero** crear posts desde la app.

### Requerimientos Funcionales
- `ProfilePage`: muestra datos del usuario desde Supabase Auth.
- `HomePage`: pantalla vacía de placeholder.
- `PostsPage`: formulario con campos `title` y `content` mapeados al modelo `Post`.

### Acceptance Criteria
- [x] `ProfileScreen` con `BottomNavigationBar` (Perfil / Home / Posts).
- [x] `PostsPage` con formulario validado para el modelo `Post`.
- [ ] `ProfilePage` muestra el email del usuario actual (requiere lógica de sesión).
- [ ] Botón funcional de "Cerrar Sesión" en `ProfilePage`.

---

## 4. Feature: PostsPage — Crear Post

### Objetivo
Permitir al usuario autenticado crear un nuevo post desde `PostsPage`, persistiéndolo en la tabla `posts` de Supabase con el `profile_id` del usuario actual.

### Relación de modelos
- `profiles` 1 ↔ N `posts` (columna `profile_id` en `posts` referencia `profiles.id` con `ON DELETE CASCADE`).

### Esquema Supabase (`posts`) — fuente de verdad
```sql
create table posts (
  id         uuid primary key default gen_random_uuid(),
  title      text not null,
  content    text,
  created_at timestamp with time zone default now(),
  profile_id uuid references profiles(id) on delete cascade
);
```

### Modelo `Post` (dominio — sin nulleables)
```dart
class Post {
  final String id;          // UUID generado en el cliente
  final String title;
  final String content;
  final String profileId;   // FK → profiles.id
  final DateTime createdAt; // generado en el cliente con DateTime.now()
}
```

> **Regla:** el dominio no expone nulleables. El `id` y `createdAt` se generan en el cliente
> antes del insert, usando el paquete `uuid` y `DateTime.now()` respectivamente.
> `content` se valida como no vacío en el formulario aunque la columna DB admita null.

### Generación de valores antes del insert
```dart
import 'package:uuid/uuid.dart';

final post = Post(
  id: const Uuid().v4(),
  title: title,
  content: content,
  profileId: Supabase.instance.client.auth.currentUser!.id,
  createdAt: DateTime.now(),
);
```

### Estructura de archivos
```
lib/features/post/
  domain/models/post.dart
  domain/repository/post_repository.dart
  domain/usecases/create_post_usecase.dart
  data/sources/post_data_source.dart
  data/repository/post_repository_impl.dart
  ui/bloc/post_bloc.dart
  ui/pages/posts_page.dart           # formulario + BLoC
```

### User Stories
- **Como** usuario autenticado, **quiero** completar un formulario con título y contenido **para** publicar un nuevo post asociado a mi cuenta.

### Requerimientos Funcionales
- **Entradas:** `title` (no vacío), `content` (no vacío — validado en formulario).
- **Acciones:**
    - Generar `id` con `Uuid().v4()` en el cliente.
    - Obtener `profileId` desde `Supabase.instance.client.auth.currentUser!.id`.
    - Asignar `createdAt = DateTime.now()`.
    - Llamar a `PostDataSource.createPost(post)` que hace `insert` en la tabla `posts`.
    - Emitir estados: `PostInitial → PostLoading → PostSuccess | PostError`.
- **Salidas:** Snackbar de éxito y reset del formulario. Snackbar de error si falla Supabase.

### Acceptance Criteria
- [ ] Modelo `Post` sin campos nulleables, con `toJson` / `fromJson`.
- [ ] `toJson` serializa `createdAt` como ISO 8601 string para Supabase.
- [ ] `PostDataSource.createPost` inserta con `id`, `profile_id` y `created_at` generados en cliente.
- [ ] `PostBloc` gestiona estados `PostLoading`, `PostSuccess`, `PostError`.
- [ ] `PostsPage` despacha evento al BLoC y muestra feedback visual.
- [ ] El formulario se limpia tras un `PostSuccess`.

---

## 5. Feature: HomePage — Feed de Posts

### Objetivo
Mostrar en `HomePage` una lista sin paginación de todos los posts de todos los usuarios, ordenados del más reciente al más antiguo.

### User Stories
- **Como** usuario autenticado, **quiero** ver un feed con todos los posts publicados **para** enterarme de la actividad de la comunidad.

### Requerimientos Funcionales
- **Acciones:**
    - Llamar a `PostDataSource.fetchAllPosts()` que ejecuta:
      ```sql
      SELECT * FROM posts ORDER BY created_at DESC
      ```
    - Emitir estados: `PostsLoading → PostsLoaded(List<Post>) | PostsError`.
- **Salidas:** Lista de tarjetas (`Card`) con `title`, `content` y `created_at` formateado. Indicador de carga mientras se obtienen datos.

### Estructura de archivos (adiciones a la feature `post`)
```
lib/features/post/
  domain/usecases/fetch_posts_usecase.dart
  ui/bloc/posts_list_bloc.dart       # o estados adicionales en PostBloc
  ui/widgets/post_card.dart
lib/features/home/
  ui/pages/home_page.dart            # usa PostsListBloc
```

### Acceptance Criteria
- [ ] `PostDataSource.fetchAllPosts()` retorna `List<Post>` ordenada por `created_at DESC`.
- [ ] `PostsListBloc` (o estados nuevos en `PostBloc`) gestiona `PostsLoading`, `PostsLoaded`, `PostsError`.
- [ ] `HomePage` muestra un `ListView` de `PostCard` widgets.
- [ ] Cada `PostCard` muestra: título, contenido y fecha de creación.
- [ ] Si la lista está vacía se muestra un mensaje "No hay posts aún".
- [ ] Sin paginación en esta iteración.

---

## Manifest de Implementación

Este manifiesto rastrea el progreso actual del desarrollo basado en las especificaciones anteriores.

| Feature | Sub-tarea | Estado | Notas |
| :--- | :--- | :---: | :--- |
| **Registro** | UI (SignupScreen) | ✅ | Funcional con campos básicos. |
| | Lógica (SignupBloc) | ✅ | Integrado con Usecase. |
| | Integración Supabase | ✅ | `AuthRepoImpl` usa `AuthDataSource`. |
| | Validaciones de Formulario | ❌ | Pendiente implementar `FormKey` y validadores. |
| **Login** | UI (LoginScreen) | ✅ | Pantalla creada con navegación a Signup. |
| | Lógica (LoginBloc) | ✅ | Implementada con manejo de estados. |
| | Usecase (LoginUsecase) | ✅ | Implementado y conectado al Repo. |
| **ProfileScreen** | ProfileScreen + BottomNavigationBar | ✅ | 3 tabs: Perfil, Home, Posts. |
| | PostsPage (formulario) | ✅ | Campos title/content con validación. |
| | Modelo Post | ✅ | toJson/fromJson para Supabase. |
| | ProfilePage (datos sesión) | ❌ | Pendiente lógica de sesión. |
| | Logout | ❌ | No iniciada. |
| **PostsPage — Crear Post** | Modelo Post | ✅ | Sin nulleables; id y createdAt generados en cliente. |
| | PostDataSource.createPost | ✅ | Insert con id/createdAt del cliente y profile_id. |
| | PostRepository + Impl | ✅ | Implementado. |
| | CreatePostUsecase | ✅ | Implementado. |
| | PostBloc (create) | ✅ | Estados: Loading/Success/Error. |
| | PostsPage integrada con BLoC | ✅ | Despacha evento, snackbar, reset de formulario. |
| **HomePage — Feed** | PostDataSource.fetchAllPosts | ✅ | SELECT * ORDER BY created_at DESC. |
| | FetchPostsUsecase | ✅ | Implementado. |
| | PostsListBloc | ✅ | Estados: Loading/Loaded/Error. |
| | PostCard widget | ✅ | Muestra title, content, fecha local. |
| | HomePage con ListView | ✅ | Lista sin paginación, mensaje si vacío. |

---
*Última actualización: 27 de Abril, 2026*
