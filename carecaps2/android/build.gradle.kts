// File: android/build.gradle.kts

buildscript {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal() // Add this line
    }
    dependencies {
        // Keep empty unless legacy plugin classpath is needed
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
