# R8 / ProGuard rules for the release build.
#
# The Flutter Gradle plugin already injects the rules required by the engine and
# by plugins that ship generated registrants. The rules below cover the plugins
# used by this app that rely on reflection, annotations or native lookups.

# Flutter embedding, engine and plugin registrants.
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# AndroidX / Kotlin metadata used by plugins at runtime.
-keepattributes *Annotation*, InnerClasses, Signature, Exceptions

# Plugins with Java/Kotlin entry points referenced only by name.
-keep class com.dexterous.** { *; }          # file_picker
-keep class androidx.core.content.FileProvider { *; }  # share_plus

# sqlite3_flutter_libs loads native libraries by name.
-keep class com.tekartik.sqflite.** { *; }
-keep class org.sqlite.** { *; }
-dontwarn org.sqlite.**

# Intl / date symbols are looked up reflectively.
-keep class com.tekartik.** { *; }
-dontwarn com.tekartik.**

# Silence warnings for optional dependencies that are never used at runtime.
-dontwarn javax.annotation.**
-dontwarn sun.misc.**
-dontwarn org.conscrypt.**
