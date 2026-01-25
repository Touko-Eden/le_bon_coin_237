plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.le_bon_coin_237"

    // 1. On force la compilation sur l'API 36 pour image_cropper et secure_storage
    compileSdk = 36

    // 2. On utilise la version du NDK demandée par tes plugins
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.le_bon_coin_237"

        // 3. On augmente le minSdk à 24 pour éviter l'erreur de "Manifest merger"
        minSdk = 24

        // 4. On s'aligne sur le SDK 35 ou 36 pour le ciblage
        targetSdk = 35

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
