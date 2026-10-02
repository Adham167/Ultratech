# Auth Password Management & UI Dynamic Focus Enhancements - Implementation Plan

This plan outlines the implementation of Forgot Password navigation, Reset Password screen (with 6-digit OTP, countdown timer, password fields), In-App Change Password feature for Sales and Technician profiles, and dynamic keyboard navigation across all auth forms.

## User Review Required

> [!IMPORTANT]
> - **Reset Password Endpoint:** `POST /api/Auth/reset-password` taking `{ "emailOrPhone": "string", "code": "string", "newPassword": "string" }`.
> - **Change Password Endpoint:** `PUT /api/Auth/change-password` taking `{ "currentPassword": "string", "newPassword": "string" }`.
> - **OTP UI:** Custom 6-digit square box input with auto-focus, paste support, and active highlighting.
> - **Profile Integration:** "Change Password" tile added to both Sales Profile and Technician Profile screens.

## Proposed Changes

### Core & Data Layer
#### [MODIFY] [auth_remote_data_source.dart](file:///F:/StudioProjects/ultra_tech/lib/feature/Auth/data/datasources/auth_remote_data_source.dart)
- Add `resetPassword` and `changePassword` remote data source methods.

#### [MODIFY] [auth_repository.dart](file:///F:/StudioProjects/ultra_tech/lib/feature/Auth/domain/repositories/auth_repository.dart) & [auth_repository_impl.dart](file:///F:/StudioProjects/ultra_tech/lib/feature/Auth/data/repositories/auth_repository_impl.dart)
- Add repository contract and implementation for `resetPassword` and `changePassword`.

#### [NEW] Use Cases (`reset_password_usecase.dart`, `change_password_usecase.dart`)
- Create domain use cases for reset password and change password.

#### [MODIFY] [auth_cubit.dart](file:///F:/StudioProjects/ultra_tech/lib/feature/Auth/presentaion/manager/auth_cubit.dart) & [auth_state.dart](file:///F:/StudioProjects/ultra_tech/lib/feature/Auth/presentaion/manager/auth_state.dart)
- Add cubit methods and states for reset password and change password.
- Register dependencies in `service_locator.dart`.

### Presentation & UI Layer
#### [MODIFY] [forgot_password_view.dart](file:///F:/StudioProjects/ultra_tech/lib/feature/Auth/presentaion/views/forgot_password_view.dart)
- Wire up navigation upon successful OTP request to `ResetPasswordView` passing `emailOrPhone`.

#### [NEW] [reset_password_view.dart](file:///F:/StudioProjects/ultra_tech/lib/feature/Auth/presentaion/views/reset_password_view.dart)
- Implement 6-digit OTP square box UI with paste support and auto-focus.
- New password & Confirm password fields with show/hide toggle and local validation.
- 15-minute countdown timer with "Resend Code" option.
- Navigation back to login upon success (`200`).

#### [NEW] [change_password_bottom_sheet.dart](file:///F:/StudioProjects/ultra_tech/lib/feature/Auth/presentaion/views/widgets/change_password_bottom_sheet.dart)
- Implement modal bottom sheet for changing password in-app.
- Current password, new password, confirm new password fields with validation and loading indicator.

#### [MODIFY] Profile Screens (`sales_profile_view.dart`, `technician_earnings_view_body.dart`, logout buttons)
- Add "Change Password" action tile/button to both Sales and Technician profiles.

### UX & Keyboard Navigation Enhancements
#### [MODIFY] [custom_text_field.dart](file:///F:/StudioProjects/ultra_tech/lib/feature/Auth/presentaion/views/widgets/custom_text_field.dart)
- Add `textInputAction`, `onFieldSubmitted`, and `focusNode` parameters.

#### [MODIFY] Forms (`login_form.dart`, `sign_up_form.dart`, `forgot_password_view.dart`, `reset_password_view.dart`, `change_password_bottom_sheet.dart`)
- Configure `TextInputAction.next` / `TextInputAction.done` and focus traversal.

## Verification Plan

### Automated Tests
- Run project build check (`flutter analyze` / compilation test).

### Manual Verification
- Test Forgot Password -> Reset Password flow with OTP boxes and timer.
- Test Change Password from Sales Profile and Technician Profile.
- Test keyboard focus navigation (`Next` / `Done`) across all forms.
