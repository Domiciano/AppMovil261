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

---
*Última actualización: 27 de Abril, 2026*
