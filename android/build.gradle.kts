plugins {
    // Add the dependency for the Google services Gradle plugin
    id("com.google.gms.google-services") version "4.4.0" apply false
    
    // Firebase plugins for Krishi Saathi features
    id("com.google.firebase.crashlytics") version "2.9.9" apply false
    id("com.google.firebase.firebase-perf") version "1.4.2" apply false
    
    // Note: Android and Kotlin plugin versions are managed by Flutter
}

allprojects {
    repositories {
        google()
        mavenCentral()
        
        // Additional repositories for enhanced functionality
        maven { url = uri("https://jitpack.io") }
    }
    
    // Global configurations for all subprojects
    configurations.all {
        resolutionStrategy {
            // Force specific versions to avoid Firebase conflicts
            force("com.google.android.gms:play-services-basement:18.4.0")
            force("com.google.firebase:firebase-common:20.4.3")
            force("androidx.lifecycle:lifecycle-common:2.8.7")
            
            // Exclude problematic transitive dependencies
            exclude(group = "com.google.guava", module = "listenablefuture")
        }
        
        // Cache dynamic versions for better build performance
        resolutionStrategy.cacheDynamicVersionsFor(24, "hours")
        resolutionStrategy.cacheChangingModulesFor(4, "hours")
    }
}

// Build directory configuration - Kotlin DSL syntax
rootProject.layout.buildDirectory.set(file("../build"))
subprojects {
    layout.buildDirectory.set(file("${rootProject.layout.buildDirectory.get()}/${project.name}"))
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Clean task - Kotlin DSL syntax
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory.get())
}