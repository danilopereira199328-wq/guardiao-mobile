rootProject.name = "GuardiaoMobile"

// Repositórios para resolver os plugins (AGP, Kotlin)
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

// Repositórios para resolver as dependências (androidx, etc.)
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}

include(":app")