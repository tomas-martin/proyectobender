plugins {
    id("com.android.application")
    id("kotlin-android")

    // 🔥 Necesario para que Firebase lea google-services.json
    id("com.google.gms.google-services")

    // Flutter gradle plugin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.probando_app_bender_v0"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.probando_app_bender_v0"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
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

dependencies {
    // 🔥 BOM de Firebase – controla las versiones automáticamente
    implementation(platform("com.google.firebase:firebase-bom:34.5.0"))

    // ➕ Mínimo requerido por Firebase
    implementation("com.google.firebase:firebase-analytics")

    // ⏬ Cuando quieras usar Firestore, Auth, Storage, etc:
    // implementation("com.google.firebase:firebase-auth")
    // implementation("com.google.firebase:firebase-firestore")
}
