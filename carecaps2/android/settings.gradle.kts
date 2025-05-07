// ✅ Add pluginManagement correctly
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }

    // ✅ Declare plugin versions here
    plugins {
        id("com.android.application") version "8.7.0"
        id("com.google.gms.google-services") version "4.4.2"
        id("com.google.firebase.crashlytics") version "2.11.1"
        id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    }
}
// ✅ Dependency resolution settings
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_SETTINGS)
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
rootProject.name = "carecaps2"
// ✅ Flutter SDK path setup
val flutterSdkPath = run {
    val properties = java.util.Properties()
    file("local.properties").inputStream().use { properties.load(it) }
    val flutterSdkPath = properties.getProperty("flutter.sdk")
    require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
    flutterSdkPath
}
includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
include(":app")
