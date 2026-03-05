import java.io.File
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.auri_sign"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.auri_sign"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

fun locateAdbExecutable(rootDir: File): String {
    val sdkFromLocalProperties = run {
        val localPropertiesFile = rootDir.resolve("local.properties")
        if (!localPropertiesFile.exists()) {
            null
        } else {
            val props = Properties()
            localPropertiesFile.inputStream().use { props.load(it) }
            props.getProperty("sdk.dir")
        }
    }

    val sdkDir = sdkFromLocalProperties
        ?: System.getenv("ANDROID_SDK_ROOT")
        ?: System.getenv("ANDROID_HOME")

    if (!sdkDir.isNullOrBlank()) {
        val adbName = if (System.getProperty("os.name").startsWith("Windows", ignoreCase = true)) "adb.exe" else "adb"
        val adbPath = File(sdkDir).resolve("platform-tools").resolve(adbName)
        if (adbPath.exists()) {
            return adbPath.absolutePath
        }
    }

    return "adb"
}

val setupAdbReverse by tasks.registering {
    group = "flutter"
    description = "Configures adb reverse for local mobile webview and API connectivity"

    doLast {
        val adbExecutable = locateAdbExecutable(rootDir)
        val serial = findProperty("android.injected.device.serial")?.toString()?.trim().orEmpty()
        val serialArgs = if (serial.isNotEmpty()) listOf("-s", serial) else emptyList()
        val ports = listOf(5173, 5000)

        logger.lifecycle("[adb] Preparing reverse tunnels for ports: ${ports.joinToString()}")

        exec {
            commandLine(listOf(adbExecutable) + serialArgs + "start-server")
            isIgnoreExitValue = true
        }

        ports.forEach { port ->
            exec {
                commandLine(listOf(adbExecutable) + serialArgs + listOf("reverse", "tcp:$port", "tcp:$port"))
                isIgnoreExitValue = true
            }
        }
    }
}

tasks.matching { task -> task.name == "preDebugBuild" }
    .configureEach {
        dependsOn(setupAdbReverse)
    }
