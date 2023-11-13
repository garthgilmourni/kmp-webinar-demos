import org.jetbrains.kotlin.gradle.utils.loadPropertyFromResources

plugins {
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.androidLibrary)
    kotlin("plugin.serialization") version "1.9.0"

    //TODO - find out why "0.13.3" will not work
    id("com.codingfeline.buildkonfig") version "0.15.0"
}

kotlin {
    listOf(
        iosX64(),
        iosArm64(),
        iosSimulatorArm64()
    ).forEach { iosTarget ->
        iosTarget.binaries.framework {
            baseName = "Shared"
            isStatic = true
        }
    }
    
    androidTarget {
        compilations.all {
            kotlinOptions {
                jvmTarget = "1.8"
            }
        }
    }
    
    sourceSets {
        commonMain.dependencies {
            // put your Multiplatform dependencies here
            implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.7.3")
            implementation("io.ktor:ktor-client-core:2.3.3")
            implementation("io.ktor:ktor-client-content-negotiation:2.3.3")
            implementation("io.ktor:ktor-serialization-kotlinx-json:2.3.3")
            implementation("io.github.xxfast:kstore:0.6.0")
            implementation("io.github.xxfast:kstore-file:0.6.0")
            implementation("org.jetbrains.kotlinx:kotlinx-datetime:0.4.0")
        }

        androidMain.dependencies {
            implementation("androidx.startup:startup-runtime:1.2.0-alpha02")
        }
        
        iosMain.dependencies {
            implementation("io.ktor:ktor-client-darwin:2.3.3")
        }
    }
}

android {
    namespace = "com.kmp.webinar.shared"
    compileSdk = libs.versions.android.compileSdk.get().toInt()
    defaultConfig {
        minSdk = libs.versions.android.minSdk.get().toInt()
    }
}
dependencies {
    implementation("androidx.core:core-ktx:+")
    implementation("androidx.core:core-ktx:+")
}

buildkonfig {
    //TODO - Maybe change this to match project package name?
    packageName = "com.myapplication"
    objectName = "ApiKeyConfig"
    exposeObjectWithName = "Config"

    defaultConfigs {
        buildConfigField(
            //TODO - maybe import this?
            com.codingfeline.buildkonfig.compiler.FieldSpec.Type.STRING,
            "WeatherApiKey",
            "12345"

            //TODO - this function does not exist
            //getLocalProperty("WEATHER_API_KEY").toString()
        )
    }
}


