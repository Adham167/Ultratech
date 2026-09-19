import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppStyle {
// =========================
// Splash
// =========================

static const splashTitle = TextStyle(
color: Colors.white,
fontSize: 36,
fontWeight: FontWeight.bold,
letterSpacing: 1.5,
);

static const splashSubtitle = TextStyle(
color: Colors.white,
fontSize: 14,
);

// =========================
// Headings
// =========================

static const headingLarge = TextStyle(
color: AppColors.textHeading,
fontSize: 22,
fontWeight: FontWeight.bold,
);

static const headingMedium = TextStyle(
color: AppColors.textHeading,
fontSize: 20,
fontWeight: FontWeight.bold,
);

static const headingSmall = TextStyle(
color: AppColors.textHeading,
fontSize: 16,
fontWeight: FontWeight.bold,
);

// =========================
// Body
// =========================

static const bodyMedium = TextStyle(
color: AppColors.textMuted,
fontSize: 14,
);

static const bodySmall = TextStyle(
color: AppColors.textMuted,
fontSize: 13,
);

// =========================
// Labels
// =========================

static const labelMedium = TextStyle(
color: AppColors.textBody,
fontSize: 13,
fontWeight: FontWeight.w600,
);

static const labelSmall = TextStyle(
color: AppColors.textBody,
fontSize: 12,
);

// =========================
// Hint
// =========================

static const hint = TextStyle(
color: AppColors.textHint,
fontSize: 13,
);

// =========================
// Buttons
// =========================

static const button = TextStyle(
color: Colors.white,
fontSize: 15,
fontWeight: FontWeight.bold,
);

static const buttonSmall = TextStyle(
color: Colors.white,
fontSize: 14,
fontWeight: FontWeight.bold,
);
}
