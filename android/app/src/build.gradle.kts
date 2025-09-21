plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.krishi_saathi"
    compileSdk = 36  // Updated to 36 (highest required)
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.krishi_saathi"
        minSdk = flutter.minSdkVersion
        targetSdk = 36  // Also update targetSdk to 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Additional configurations for Krishi Saathi
        multiDexEnabled = true
        vectorDrawables.useSupportLibrary = true
        
        // ProGuard configurations for release builds
        proguardFiles(
            getDefaultProguardFile("proguard-android-optimize.txt"),
            "proguard-rules.pro"
        )
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            minifyEnabled = false
            shrinkResources = false
        }
        debug {
            applicationIdSuffix = ".debug"
            debuggable = true
        }
    }
    
    // Build features
    buildFeatures {
        buildConfig = true
    }
    
    // Packaging options
    packagingOptions {
        resources {
            excludes += [
                '/META-INF/{AL2.0,LGPL2.1}',
                '/META-INF/gradle/incremental.annotation.processors'
            ]
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Existing dependency
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    
    // Firebase BOM (Bill of Materials) - manages all Firebase library versions
    implementation(platform("com.google.firebase:firebase-bom:32.7.4"))
    
    // Firebase dependencies (versions managed by BOM)
    implementation("com.google.firebase:firebase-analytics-ktx")
    implementation("com.google.firebase:firebase-auth-ktx")
    implementation("com.google.firebase:firebase-firestore-ktx")
    implementation("com.google.firebase:firebase-storage-ktx")
    implementation("com.google.firebase:firebase-messaging-ktx")
    implementation("com.google.firebase:firebase-crashlytics-ktx")
    implementation("com.google.firebase:firebase-perf-ktx")
    
    // Google services
    implementation("com.google.android.gms:play-services-auth:20.7.0")
    implementation("com.google.android.gms:play-services-maps:18.2.0")
    implementation("com.google.android.gms:play-services-location:21.0.1")
    
    // AndroidX dependencies for modern Android development
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.7.0")
    implementation("androidx.activity:activity-compose:1.8.2")
    implementation("androidx.work:work-runtime-ktx:2.9.0")
    
    // Multidex support for large apps
    implementation("androidx.multidex:multidex:2.0.1")
    
    // Image loading and caching
    implementation("com.github.bumptech.glide:glide:4.16.0")
    
    // Networking (for API calls if needed)
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    
    // Local database (if needed for offline storage)
    implementation("androidx.room:room-runtime:2.6.1")
    implementation("androidx.room:room-ktx:2.6.1")
    
    // Camera and image processing
    implementation("androidx.camera:camera-core:1.3.1")
    implementation("androidx.camera:camera-camera2:1.3.1")
    implementation("androidx.camera:camera-lifecycle:1.3.1")
    implementation("androidx.camera:camera-view:1.3.1")
    
    // Permissions handling
    implementation("com.karumi:dexter:6.2.3")
    
    // Material Design components
    implementation("com.google.android.material:material:1.11.0")
    
    // Notification support
    implementation("androidx.core:core-splashscreen:1.0.1")
    
    // Security and encryption
    implementation("androidx.security:security-crypto:1.1.0-alpha06")
    
    // Performance monitoring
    implementation("androidx.benchmark:benchmark-junit4:1.2.2")
}