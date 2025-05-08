buildscript {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://storage.googleapis.com/download.flutter.io")
        }
        gradlePluginPortal()
    }
    dependencies {
        // Keep empty unless legacy plugin classpath is needed
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://storage.googleapis.com/download.flutter.io")
        }
        gradlePluginPortal()
    }
}